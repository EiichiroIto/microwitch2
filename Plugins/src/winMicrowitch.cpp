/*
 * winMicrowitchOps.cpp
 * Copyright 2022 Eiichiro Ito (ghc02331@nifty.com)
 */

#define UNICODE 1  // use WCHAR API's

#include <windows.h>
#include <objbase.h>
#include <shlobj.h>
#include <shellapi.h>
#include <winuser.h>
#include <stdio.h>

#define _T(a)  L ## a
#ifdef MAIN
#define LineDelimiter '\n'
#else /* MAIN */
#define LineDelimiter '\r'
#endif /* MAIN */

#define MICROBIT_VID "0D28"
#define MICROBIT_PID "0204"

extern "C" {
  int MicrobitDriveLetters(char *dst, int max);
  int MicrobitComPorts(char *dst, int max);
};

static int GetDriveInfo(const char *drive, char *dst, int max);

int
MicrobitDriveLetters(char *dst, int max)
{
  DWORD drives;
  DWORD mask;
  char drive_letter[4];
  char buf[256];
  int ret;
  int num;

  drive_letter[0] = 'X';
  drive_letter[1] = ':';
  drive_letter[2] = '\\';
  drive_letter[3] = '\0';

  drives = GetLogicalDrives();
  for (int c = 'A', mask = 1; c <= 'Z'; c ++, mask <<= 1) {
    if (!(drives & mask)) {
      continue;
    }
    drive_letter[0] = c;
    ret = GetDriveInfo(drive_letter, buf, sizeof buf);
    if ( ret ) {
      if (!strcmp(buf, "MICROBIT")) {
	if (num < max) {
	  *dst ++ = c;
	  num ++;
	} else {
	  break;
	}
      }
    }
  }
  *dst = '\0';
  return num;
}

static int
GetDriveInfo(const char *drive, char *dst, int max)
{
  char volume_name[256];
  char volume_system[256];
  DWORD serial, length, flags;

  if (!GetVolumeInformationA(drive, volume_name, sizeof volume_name, &serial, &length, &flags, volume_system, sizeof volume_system)) {
    return 0;
  }
  strncpy(dst, volume_name, max);
  return 1;
}

#define INITGUID
#include <setupapi.h>
#include <guiddef.h>

DEFINE_GUID(GUID_DEVINTERFACE_COMPORT, 0x86e0d1e0, 0x8089, 0x11d0, 0x9c, 0xe4, 0x08, 0x00, 0x3e, 0x30, 0x1f, 0x73);

int
MicrobitComPorts(char *dst, int max)
{
  int i, count;
  TCHAR tmpbuf[256];
  char portname[256], hardwareid[256];
  DWORD type, portname_size, size;

  count = 0;
  *dst = 0;
  SP_DEVINFO_DATA DeviceInfoData = {sizeof(SP_DEVINFO_DATA)};
  HDEVINFO hDevInfo = SetupDiGetClassDevs(&GUID_DEVINTERFACE_COMPORT, NULL, NULL, (DIGCF_PRESENT|DIGCF_DEVICEINTERFACE));
  for (i=0; SetupDiEnumDeviceInfo(hDevInfo, i, &DeviceInfoData); i++) {
    HKEY key = SetupDiOpenDevRegKey(hDevInfo, &DeviceInfoData,  DICS_FLAG_GLOBAL, 0, DIREG_DEV, KEY_QUERY_VALUE);
    if ( key ) {
      // get port name
      type = 0;
      size = sizeof tmpbuf;
      RegQueryValueEx(key, _T("PortName"), NULL, &type , (LPBYTE) tmpbuf, &size);
      portname_size = WideCharToMultiByte(CP_ACP, 0, tmpbuf, wcslen(tmpbuf), portname, sizeof portname, NULL, NULL);
      portname[portname_size] = 0;
#ifdef MAIN
      printf(" checking %s\n", portname);
#endif /* MAIN */
      // check if micro:bit
      type = 0;
      size = sizeof tmpbuf;
      if (SetupDiGetDeviceRegistryProperty(hDevInfo, &DeviceInfoData, SPDRP_HARDWAREID, &type, (PBYTE) tmpbuf, size, &size)) {
	size = WideCharToMultiByte(CP_ACP, 0, tmpbuf, wcslen(tmpbuf), hardwareid, sizeof hardwareid, NULL, NULL);
	hardwareid[size] = 0;
	if (!memcmp(MICROBIT_VID, &hardwareid[8], 4) && !memcmp(MICROBIT_PID, &hardwareid[17], 4)) {
	  count ++;
	  if (max > portname_size + 1) {
	    strcpy(dst, portname);
	    dst += portname_size;
	    *dst++ = LineDelimiter;
	    max -= portname_size + 1;
	  }
	}
      }
    }
  }
  SetupDiDestroyDeviceInfoList(hDevInfo);
  *dst = 0;
  return count;
}

#ifdef MAIN
#include <stdio.h>
char buffer[1024];

int
main(int argc, char *argv[])
{
  int ret;

  memset(buffer, 0, sizeof buffer);
  ret = MicrobitDriveLetters(buffer, sizeof buffer);
  printf("MicrobitDriveLetters\n");
  printf("  %d bytes received\n", ret);
  printf("  drive letters='%s'\n", buffer);
  printf("\n");

  ret = MicrobitComPorts(buffer, sizeof buffer);
  printf("MicrobitComPorts = %d\n", ret);
  printf("VVV\n%s\n^^^\n", buffer);
}

#endif /* MAIN */

/*
 * unixMicrowitchOps.cpp
 * Copyright 2022 Eiichiro Ito (ghc02331@nifty.com)
 */

extern "C" {
  int MicrobitDriveLetters(char *dst, int max);
  int MicrobitComPorts(char *dst, int max);
};

int
MicrobitDriveLetters(char *dst, int max)
{
  *dst = '\0';
  return 0;
}

int
MicrobitComPorts(char *dst, int max)
{
  *dst = '\0';
  return 0;
}

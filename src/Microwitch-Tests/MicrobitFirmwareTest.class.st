"
A MicrobitFirmwareTest is a test class for testing the behavior of MicrobitFirmware
"
Class {
	#name : #MicrobitFirmwareTest,
	#superclass : #TestCase,
	#category : #'Microwitch-Tests'
}

{ #category : #private }
MicrobitFirmwareTest >> detailsTxtOfV22 [

	^ '# DAPLink Firmware - see https://daplink.io
Build ID: v0257-gc782a5ba (gcc)
Unique ID: 9906360200052820dcf63df39c4913ce000000006e052820
HIC ID: 6e052820
Auto Reset: 1
Automation allowed: 0
Overflow detection: 0
Incompatible image detection: 1
Page erasing: 0
Daplink Mode: Interface
Interface Version: 0257
Bootloader Version: 0257
Git SHA: c782a5ba907377658bc28aa8d132a0fa44543687
Local Mods: 0
USB Interfaces: MSD, CDC, HID, WebUSB
Bootloader CRC: 0x725bea7d
Interface CRC: 0xe561f1de
Remount count: 0
URL: https://microbit.org/device/?id=9906&v=0257
'
]

{ #category : #private }
MicrobitFirmwareTest >> newObj [
	^ MicrobitFirmware new
]

{ #category : #test }
MicrobitFirmwareTest >> testFirmwareVersionForUniqueID [

	| o |
	o := self newObj.
	self assert: (o firmwareVersionForUniqueID: '9900') equals: #v10.
	self assert: (o firmwareVersionForUniqueID: '9901') equals: #v10.
	self assert: (o firmwareVersionForUniqueID: '9903') equals: #v20.
	self assert: (o firmwareVersionForUniqueID: '9904') equals: #v20.
	self assert: (o firmwareVersionForUniqueID: '9905') equals: #v20.
	self assert: (o firmwareVersionForUniqueID: '9906') equals: #v20
]

{ #category : #test }
MicrobitFirmwareTest >> testUniqueIDFrom [

	| o |
	o := self newObj.
	self assert: (o uniqueIDFrom: self detailsTxtOfV22) equals: '9906'
]

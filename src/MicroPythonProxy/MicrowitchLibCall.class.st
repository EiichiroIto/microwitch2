Class {
	#name : 'MicrowitchLibCall',
	#superclass : 'Object',
	#category : 'MicroPythonProxy-Plugins',
	#package : 'MicroPythonProxy',
	#tag : 'Plugins'
}

{ #category : 'resources' }
MicrowitchLibCall class >> ffiLibrary [
	^ MicrowitchLibrary
]

{ #category : 'api' }
MicrowitchLibCall >> closePort: portNum [
	^ self ffiCall: #(void SerialPortClose(int portNum))
]

{ #category : 'resources' }
MicrowitchLibCall >> ffiLibrary [
	^ self class ffiLibrary
]

{ #category : 'api' }
MicrowitchLibCall >> isPortOpen: portNum [
	^ (self primSerialPortIsOpen: portNum) ~= 0
]

{ #category : 'api' }
MicrowitchLibCall >> microbitComPorts [
	| size str i |
	size := 1024.
	str := ByteArray new: size.
	self primMicrobitComPorts: str max: size.
	i := str indexOf: 0.
	i > 0
		ifTrue: [ str := str copyFrom: 1 to: i - 1 ].
	^ str asString lines
]

{ #category : 'api' }
MicrowitchLibCall >> microbitDriveLetters [
	| size str i |
	size := 256.
	str := ByteArray new: size.
	self primMicrobitDriveLetters: str max: size.
	i := str indexOf: 0.
	i > 0
		ifTrue: [ str := str copyFrom: 1 to: i - 1 ].
	^ str asArray collect: [ :each | each asCharacter asString , ':\' ]
]

{ #category : 'api' }
MicrowitchLibCall >> openPortNamed: portName baud: baudRate [
	^ self ffiCall: #(int SerialPortOpenPortNamed(String portName, int baudRate))
]

{ #category : 'api' }
MicrowitchLibCall >> port: portNum getOption: optionNum [
	^ self ffiCall: #(int SerialPortGetOption(int portNum, int optionNum))
]

{ #category : 'api' }
MicrowitchLibCall >> port: portNum setOption: optionNum to: newValue [
	^ self ffiCall: #(int SerialPortSetOption(int portNum, int optionNum, int newValue))
]

{ #category : 'api' }
MicrowitchLibCall >> portCount [
	^ self ffiCall: #(int SerialPortCount(void))
]

{ #category : 'api' }
MicrowitchLibCall >> portName: portIndex [
	| ext size str i |
	size := 256.
	str := ByteArray new: size.
	ext := FFIExternalArray externalNewType: 'byte' size: size.
	[ self primSerialPortName: portIndex string: ext size: size.
	1 to: size do: [ :index | str at: index put: (ext at: index) ] ]
		ensure: [ ext free ].
	i := str indexOf: 0.
	i > 0
		ifTrue: [ str := str copyFrom: 1 to: i - 1 ].
	^ str asString
]

{ #category : 'private' }
MicrowitchLibCall >> primMicrobitComPorts: bufPtr max: bufSize [
	^ self ffiCall: #(int MicrobitComPorts(String bufPtr, int bufSize))
]

{ #category : 'private' }
MicrowitchLibCall >> primMicrobitDriveLetters: bufPtr max: bufSize [
	^ self ffiCall: #(int MicrobitDriveLetters(String bufPtr, int bufSize))
]

{ #category : 'private' }
MicrowitchLibCall >> primSerialPortIsOpen: anInteger [
	^ self ffiCall: #(int SerialPortIsOpen(int anInteger))
]

{ #category : 'private' }
MicrowitchLibCall >> primSerialPortName: anInteger string: aString size: anInteger2 [
	^ self ffiCall: #(void SerialPortName(int anInteger, FFIExternalArray aString, int anInteger2))
]

{ #category : 'private' }
MicrowitchLibCall >> primSerialPortRead: anInteger buffer: aPtr size: anInteger2 [
	^ self
		ffiCall:
			#(int SerialPortRead (int anInteger , FFIExternalArray aPtr , int anInteger2))
]

{ #category : 'private' }
MicrowitchLibCall >> primSerialPortWrite: portNum buffer: bufPtr size: bufSize [
	^ self ffiCall: #(int SerialPortWrite(int portNum, FFIExternalArray bufPtr, int bufSize))
]

{ #category : 'api' }
MicrowitchLibCall >> readPort: portNum into: buffer [

	| ext count |
	count := 0.
	ext := FFIExternalArray externalNewType: 'byte' size: buffer size.
	[ 
	count := self
		         primSerialPortRead: portNum
		         buffer: ext
		         size: buffer size.
	1 to: count do: [ :index | buffer at: index put: (ext at: index) ] ] 
		ensure: [ ext free ].
	^ count
]

{ #category : 'api' }
MicrowitchLibCall >> serialPortOpsAvailable [
	self shouldBeImplemented
]

{ #category : 'api' }
MicrowitchLibCall >> writePort: portNum data: buffer [
	| ext |
	ext := FFIExternalArray externalNewType: 'byte' size: buffer size.
	^ [ buffer withIndexDo: [ :each :index | ext at: index put: each ].
	self primSerialPortWrite: portNum buffer: ext size: buffer size ]
		ensure: [ ext free.
			0 ]
]

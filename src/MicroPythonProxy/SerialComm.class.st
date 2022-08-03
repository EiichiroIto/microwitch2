Class {
	#name : #SerialComm,
	#superclass : #MWComm,
	#instVars : [
		'port',
		'portName',
		'baudRate'
	],
	#category : #'MicroPythonProxy-Comm'
}

{ #category : #private }
SerialComm class >> enumerateComPort: dst max: size [
	^ self ffiCall: #(int EnumerateComPort(FFIExternalArray dst, int size)) module: 'MicroWiz.dll'
]

{ #category : #accessing }
SerialComm >> baudRate [
	^ baudRate ifNil: [ baudRate := self defaultBaudRate ]
]

{ #category : #accessing }
SerialComm >> baudRate: anInteger [
	baudRate := anInteger
]

{ #category : #api }
SerialComm >> close [
	self isConnected
		ifFalse: [ ^ self ].
	port close.
	port := nil
]

{ #category : #private }
SerialComm >> defaultBaudRate [
	^ 115200
]

{ #category : #api }
SerialComm >> get [
	| ret |
	self isConnected
		ifFalse: [ ^ nil ].
	ret := port readByteArray.
	ret isEmpty
		ifTrue: [ ^ nil ].
	^ ret
]

{ #category : #api }
SerialComm >> isConnected [
	^ port notNil and: [ port isOpen ]
]

{ #category : #testing }
SerialComm >> isWebRepl [
	^ false
]

{ #category : #api }
SerialComm >> open [
	self isConnected
		ifTrue: [ ^ true ].
	portName ifNil: [ ^ false ].
	port := SerialPort2 new.
	[ port openPortNamed: portName baud: self baudRate ]
		on: Error
		do: [ :err | 
			self inform: err asString.
			port := nil.
			^ false ].
	^ true
]

{ #category : #private }
SerialComm >> port [
	^ port
]

{ #category : #accessing }
SerialComm >> portName [
	^ portName
]

{ #category : #accessing }
SerialComm >> portName: aString [
	portName := aString
]

{ #category : #private }
SerialComm >> portNames [

	Smalltalk os isWindows ifTrue: [ 
		^ MicrowitchLibCall new microbitComPorts ].
	^ SerialPort2 portNames
]

{ #category : #printing }
SerialComm >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		nextPut: $(.
	self isConnected
		ifTrue: [ aStream nextPut: $* ].
	aStream
		nextPutAll: self portName asString;
		nextPut: $,;
		nextPutAll: self baudRate asString;
		nextPut: $)
]

{ #category : #api }
SerialComm >> put: aByteArray [
	self isConnected
		ifFalse: [ ^ 0 ].
	^ port nextPutAll: aByteArray
]

Class {
	#name : 'SerialCommTest',
	#superclass : 'TestCase',
	#category : 'MicroPythonProxy-Tests',
	#package : 'MicroPythonProxy',
	#tag : 'Tests'
}

{ #category : 'private' }
SerialCommTest >> newComm [
	^ SerialComm new
]

{ #category : 'test' }
SerialCommTest >> testBaudRate [
	| c |
	c := self newComm.
	self assert: c baudRate equals: c defaultBaudRate.
	c baudRate: 9600.
	self assert: c baudRate equals: 9600
]

{ #category : 'test' }
SerialCommTest >> testDefaultBaudRate [
	| c |
	c := self newComm.
	self assert: c defaultBaudRate equals: 115200
]

{ #category : 'test' }
SerialCommTest >> testIsConnected [
	| c |
	c := self newComm.
	self deny: c isConnected
]

{ #category : 'test' }
SerialCommTest >> testPort [
	| c |
	c := self newComm.
	self assert: c port isNil.
]

{ #category : 'test' }
SerialCommTest >> testPortName [
	| c |
	c := self newComm.
	self assert: c portName isNil.
	c portName: 'abc'.
	self assert: c portName equals: 'abc'.
	c portName: 'def'.
	self assert: c portName equals: 'def'
]

{ #category : 'test' }
SerialCommTest >> testPrintOn [
	| c s |
	c := self newComm.
	c baudRate: 9600.
	c portName: 'abc'.
	s := WriteStream on: String new.
	c printOn: s.
	self assert: s contents equals: 'SerialComm(abc,9600)'
]

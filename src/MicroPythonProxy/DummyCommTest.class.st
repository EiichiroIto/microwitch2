"
A DummyComm22Test is a test class for testing the behavior of DummyComm22
"
Class {
	#name : 'DummyCommTest',
	#superclass : 'TestCase',
	#category : 'MicroPythonProxy-Tests',
	#package : 'MicroPythonProxy',
	#tag : 'Tests'
}

{ #category : 'private' }
DummyCommTest >> newComm [
	^ DummyComm new
]

{ #category : 'test' }
DummyCommTest >> testBaudRate [
	| c |
	c := self newComm.
	self assert: c baudRate isNil.
	c baudRate: 9600.
	self assert: c baudRate equals: 9600
]

{ #category : 'test' }
DummyCommTest >> testClose [

	| c |
	c := self newComm.
	c isConnected: true.
	c close.
	self deny: c isConnected
]

{ #category : 'test' }
DummyCommTest >> testGet [

	| c |
	c := self newComm.
	c gets: #(a b c).
	self assert: c get equals: 'a'.
	self assert: c get equals: 'b'.
	self assert: c get equals: 'c'.
	self assert: c get isNil
]

{ #category : 'test' }
DummyCommTest >> testGetSize [

	| c |
	c := self newComm.
	self assert: c getSize equals: 0.
	c gets: #(a b c).
	self assert: c getSize equals: 3
]

{ #category : 'test' }
DummyCommTest >> testGets [

	| c a |
	c := self newComm.
	self assert: c gets isCollection.
	self assert: c gets isEmpty.
	a := #(a b c).
	c gets: a.
	self assert: c gets isCollection.
	self assertCollection: c gets equals: a asOrderedCollection
]

{ #category : 'test' }
DummyCommTest >> testIsConnected [

	| c |
	c := self newComm.
	self deny: c isConnected.
	c isConnected: true.
	self assert: c isConnected.
	c isConnected: false.
	self deny: c isConnected
]

{ #category : 'test' }
DummyCommTest >> testMode [

	| c |
	c := self newComm.
	self assert: c mode isNil.
	c mode: #abc.
	self assert: c mode equals: #abc
]

{ #category : 'test' }
DummyCommTest >> testOpen [

	| c |
	c := self newComm.
	self deny: c isConnected.
	c mode: #cannotOpen.
	self deny: c open.
	self deny: c isConnected.
	c mode: nil.
	self assert: c open.
	self assert: c isConnected
]

{ #category : 'test' }
DummyCommTest >> testPortName [

	| c |
	c := self newComm.
	self assert: c portName isNil.
	c portName: 'abc'.
	self assert: c portName equals: 'abc'
]

{ #category : 'test' }
DummyCommTest >> testPortNames [

	self assertCollection: self newComm portNames equals: #(abc def)
]

{ #category : 'test' }
DummyCommTest >> testPut [

	| c |
	c := self newComm.
	c put: 'a'.
	c put: 'b'.
	c put: 'c'.
	self assertCollection: c puts equals: #(a b c) asOrderedCollection
]

{ #category : 'test' }
DummyCommTest >> testPutSize [

	| c |
	c := self newComm.
	self assert: c putSize equals: 0.
	c puts: #(a b c).
	self assert: c putSize equals: 3
]

{ #category : 'test' }
DummyCommTest >> testPuts [

	| c a |
	c := self newComm.
	self assert: c puts isCollection.
	self assert: c puts isEmpty.
	a := #(a b c).
	c puts: a.
	self assert: c puts identicalTo: a
]

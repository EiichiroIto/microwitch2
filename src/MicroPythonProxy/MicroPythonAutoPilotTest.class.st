"
A MicroPythonAutoPilotTest is a test class for testing the behavior of MicroPythonAutoPilot
"
Class {
	#name : #MicroPythonAutoPilotTest,
	#superclass : #TestCase,
	#category : #'MicroPythonProxy-Tests'
}

{ #category : #private }
MicroPythonAutoPilotTest >> newComm [
	^ DummyComm new
]

{ #category : #private }
MicroPythonAutoPilotTest >> newObj [
	^ MicroPythonAutoPilot new
]

{ #category : #private }
MicroPythonAutoPilotTest >> newProxy [
	^ MicroPythonProxy new
]

{ #category : #test }
MicroPythonAutoPilotTest >> testClear [

	| o |
	o := self newObj.
	self assert: o sendLines isNil.
	self assert: o selector isNil.
	o sendLines: #(1 2 3).
	o selector: #abc.
	self deny: o sendLines isNil.
	self deny: o selector isNil.
	o clear.
	self assert: o sendLines isNil.
	self assert: o selector isNil
]

{ #category : #test }
MicroPythonAutoPilotTest >> testDoRestart [

	| o p c |
	o := self newObj.
	p := self newProxy.
	c := self newComm.
	c isConnected: true.
	p comm: c.
	p state beReady.
	o proxy: p.
	self assert: c putSize equals: 0.
	o doRestart.
	self assert: c putSize equals: 1.
	self assert: c puts first equals: #[4].
	self deny: c isConnected
]

{ #category : #test }
MicroPythonAutoPilotTest >> testIsEmpty [

	| o |
	o := self newObj.
	self assert: o isEmpty.
	o sendLines: #( 1 2 3 ).
	self deny: o isEmpty.
	o sendLines: #(  ).
	self assert: o isEmpty.
	o clear.
	self assert: o isEmpty
]

{ #category : #test }
MicroPythonAutoPilotTest >> testMode [

	| o |
	o := self newObj.
	self assert: o mode isNil.
	o mode: #stepPaste.
	self assert: o mode equals: #stepPaste.
	o mode: #stepNormal.
	self assert: o mode equals: #stepNormal
]

{ #category : #test }
MicroPythonAutoPilotTest >> testProxy [

	| o p |
	o := self newObj.
	self assert: o proxy isNil.
	p := self newProxy.
	o proxy: p.
	self assert: o proxy identicalTo: p
]

{ #category : #test }
MicroPythonAutoPilotTest >> testSelector [

	| o |
	o := self newObj.
	self assert: o selector isNil.
	o selector: #abc.
	self assert: o selector equals: #abc
]

{ #category : #test }
MicroPythonAutoPilotTest >> testSendLines [

	| o a |
	o := self newObj.
	self assert: o sendLines isNil.
	a := #(1 2 3).
	o sendLines: a.
	self assert: o sendLines equals: a asOrderedCollection
]

{ #category : #test }
MicroPythonAutoPilotTest >> testSendNormal [

	| o |
	o := self newObj.
	self assert: o mode isNil.
	o sendNormal.
	self assert: o mode equals: #stepNormal
]

{ #category : #test }
MicroPythonAutoPilotTest >> testSendPaste [

	| o |
	o := self newObj.
	self assert: o mode isNil.
	o sendPaste.
	self assert: o mode equals: #stepPaste
]

{ #category : #test }
MicroPythonAutoPilotTest >> testThenRestart [

	| o |
	o := self newObj.
	self assert: o selector isNil.
	o thenRestart.
	self assert: o selector equals: #doRestart
]

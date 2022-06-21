"
A MicroPythonAutoPilotTest is a test class for testing the behavior of MicroPythonAutoPilot
"
Class {
	#name : #MicroPythonAutoPilotTest,
	#superclass : #TestCase,
	#category : #'Microwitch-Tests'
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
	self assert: o pasteLines isNil.
	self assert: o selector isNil.
	o pasteLines: #(1 2 3).
	o selector: #abc.
	self deny: o pasteLines isNil.
	self deny: o selector isNil.
	o clear.
	self assert: o pasteLines isNil.
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
	o pasteLines: #( 1 2 3 ).
	self deny: o isEmpty.
	o pasteLines: #(  ).
	self assert: o isEmpty.
	o clear.
	self assert: o isEmpty
]

{ #category : #test }
MicroPythonAutoPilotTest >> testPasteLines [

	| o a |
	o := self newObj.
	self assert: o pasteLines isNil.
	a := #(1 2 3).
	o pasteLines: a.
	self assert: o pasteLines equals: a asOrderedCollection
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
MicroPythonAutoPilotTest >> testThenRestart [

	| o |
	o := self newObj.
	self assert: o selector isNil.
	o thenRestart.
	self assert: o selector equals: #doRestart
]

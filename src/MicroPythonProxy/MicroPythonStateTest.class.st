"
A MicroPythonStatusTest is a test class for testing the behavior of MicroPythonStatus
"
Class {
	#name : 'MicroPythonStateTest',
	#superclass : 'TestCase',
	#category : 'MicroPythonProxy-Tests',
	#package : 'MicroPythonProxy',
	#tag : 'Tests'
}

{ #category : 'private' }
MicroPythonStateTest >> newObj [
	^ MicroPythonState new
]

{ #category : 'test' }
MicroPythonStateTest >> testBeConnected [
	| obj |
	obj := self newObj.
	self deny: obj isConnected.
	obj beConnected.
	self assert: obj isConnected
]

{ #category : 'test' }
MicroPythonStateTest >> testBeIdle [
	| obj |
	obj := self newObj.
	obj state: nil.
	self deny: obj isIdle.
	obj beIdle.
	self assert: obj isIdle
]

{ #category : 'test' }
MicroPythonStateTest >> testBeNotConnected [
	| obj |
	obj := self newObj.
	self deny: obj isNotConnected.
	obj beNotConnected.
	self assert: obj isNotConnected
]

{ #category : 'test' }
MicroPythonStateTest >> testBePasteReady [
	| obj |
	obj := self newObj.
	self deny: obj isPasteReady.
	obj bePasteReady.
	self assert: obj isPasteReady
]

{ #category : 'test' }
MicroPythonStateTest >> testBeReady [
	| obj |
	obj := self newObj.
	self deny: obj isReady.
	obj beReady.
	self assert: obj isReady
]

{ #category : 'test' }
MicroPythonStateTest >> testBeRunning [
	| obj |
	obj := self newObj.
	self deny: obj isRunning.
	obj beRunning.
	self assert: obj isRunning
]

{ #category : 'test' }
MicroPythonStateTest >> testBeWaiting [
	| obj |
	obj := self newObj.
	self deny: obj isWaiting.
	obj beWaiting.
	self assert: obj isWaiting
]

{ #category : 'test' }
MicroPythonStateTest >> testBeWaitingEnterPaste [
	| obj |
	obj := self newObj.
	self deny: obj isWaitingEnterPaste.
	obj beWaitingEnterPaste.
	self assert: obj isWaitingEnterPaste
]

{ #category : 'test' }
MicroPythonStateTest >> testBeWaitingPaste [
	| obj |
	obj := self newObj.
	self deny: obj isWaitingPaste.
	obj beWaitingPaste.
	self assert: obj isWaitingPaste
]

{ #category : 'test' }
MicroPythonStateTest >> testInitialize [
	self assert: self newObj isIdle
]

{ #category : 'test' }
MicroPythonStateTest >> testIsConnected [
	| obj |
	obj := self newObj.
	self deny: obj isConnected.
	obj state: #connected.
	self assert: obj isConnected
]

{ #category : 'test' }
MicroPythonStateTest >> testIsIdle [
	| obj |
	obj := self newObj.
	obj state: nil.
	self deny: obj isIdle.
	obj state: #idle.
	self assert: obj isIdle
]

{ #category : 'test' }
MicroPythonStateTest >> testIsNotConnected [
	| obj |
	obj := self newObj.
	self deny: obj isNotConnected.
	obj state: #notConnected.
	self assert: obj isNotConnected
]

{ #category : 'test' }
MicroPythonStateTest >> testIsPasteReady [

	| obj |
	obj := self newObj.
	self deny: obj isPasteReady.
	obj state: #pasteReady.
	self assert: obj isPasteReady
]

{ #category : 'test' }
MicroPythonStateTest >> testIsReady [
	| obj |
	obj := self newObj.
	self deny: obj isReady.
	obj state: #ready.
	self assert: obj isReady
]

{ #category : 'test' }
MicroPythonStateTest >> testIsRunning [
	| obj |
	obj := self newObj.
	self deny: obj isRunning.
	obj state: #running.
	self assert: obj isRunning
]

{ #category : 'test' }
MicroPythonStateTest >> testIsWaiting [
	| obj |
	obj := self newObj.
	self deny: obj isWaiting.
	obj state: #waiting.
	self assert: obj isWaiting
]

{ #category : 'test' }
MicroPythonStateTest >> testIsWaitingEnterPaste [
	| obj |
	obj := self newObj.
	self deny: obj isWaitingEnterPaste.
	obj state: #waitingEnterPaste.
	self assert: obj isWaitingEnterPaste
]

{ #category : 'test' }
MicroPythonStateTest >> testIsWaitingPaste [
	| obj |
	obj := self newObj.
	self deny: obj isWaitingPaste.
	obj state: #waitingPaste.
	self assert: obj isWaitingPaste
]

{ #category : 'test' }
MicroPythonStateTest >> testPrintOn [

	| s st |
	s := self newObj.
	st := WriteStream on: String new.
	s printOn: st.
	self assert: st contents equals: '[idle]'
]

{ #category : 'test' }
MicroPythonStateTest >> testState [
	| obj |
	obj := self newObj.
	self assert: obj state equals: #idle.
	obj state: #abc.
	self assert: obj state equals: #abc
]

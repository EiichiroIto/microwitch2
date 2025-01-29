Class {
	#name : 'MicroPythonState',
	#superclass : 'Object',
	#instVars : [
		'state'
	],
	#category : 'MicroPythonProxy-Core',
	#package : 'MicroPythonProxy',
	#tag : 'Core'
}

{ #category : 'api' }
MicroPythonState >> beConnected [
	state := #connected
]

{ #category : 'api' }
MicroPythonState >> beIdle [
	state := #idle
]

{ #category : 'api' }
MicroPythonState >> beNotConnected [
	state := #notConnected
]

{ #category : 'api' }
MicroPythonState >> bePasteReady [
	state := #pasteReady
]

{ #category : 'api' }
MicroPythonState >> beReady [
	state := #ready
]

{ #category : 'api' }
MicroPythonState >> beRunning [
	state := #running
]

{ #category : 'api' }
MicroPythonState >> beWaiting [
	state := #waiting
]

{ #category : 'api' }
MicroPythonState >> beWaitingEnterPaste [
	state := #waitingEnterPaste
]

{ #category : 'api' }
MicroPythonState >> beWaitingPaste [
	state := #waitingPaste
]

{ #category : 'initialization' }
MicroPythonState >> initialize [
	self beIdle
]

{ #category : 'testing' }
MicroPythonState >> isConnected [
	^ state = #connected
]

{ #category : 'testing' }
MicroPythonState >> isIdle [
	^ state = #idle
]

{ #category : 'testing' }
MicroPythonState >> isNotConnected [
	^ state = #notConnected
]

{ #category : 'testing' }
MicroPythonState >> isPasteReady [
	^ state = #pasteReady
]

{ #category : 'testing' }
MicroPythonState >> isReady [
	^ state = #ready
]

{ #category : 'testing' }
MicroPythonState >> isRunning [
	^ state = #running
]

{ #category : 'testing' }
MicroPythonState >> isWaiting [
	^ state = #waiting
]

{ #category : 'testing' }
MicroPythonState >> isWaitingEnterPaste [
	^ state = #waitingEnterPaste
]

{ #category : 'testing' }
MicroPythonState >> isWaitingPaste [
	^ state = #waitingPaste
]

{ #category : 'printing' }
MicroPythonState >> printOn: aStream [

	aStream
		nextPut: $[;
		nextPutAll: state;
		nextPut: $]
]

{ #category : 'accessing' }
MicroPythonState >> state [

	^ state
]

{ #category : 'accessing' }
MicroPythonState >> state: anObject [

	state := anObject
]

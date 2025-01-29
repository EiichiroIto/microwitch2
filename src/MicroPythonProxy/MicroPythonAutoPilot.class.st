Class {
	#name : 'MicroPythonAutoPilot',
	#superclass : 'Object',
	#instVars : [
		'proxy',
		'selector',
		'sendLines',
		'mode'
	],
	#category : 'MicroPythonProxy-Core',
	#package : 'MicroPythonProxy',
	#tag : 'Core'
}

{ #category : 'api' }
MicroPythonAutoPilot >> clear [
	sendLines := nil.
	selector := nil
]

{ #category : 'private' }
MicroPythonAutoPilot >> doRestart [
	proxy restart
]

{ #category : 'api' }
MicroPythonAutoPilot >> execute: aCollection [

	| lines |
	lines := aCollection collect: #asByteArray.
	lines := lines asOrderedCollection.
	sendLines
		ifNil: [ sendLines := lines ]
		ifNotNil: [ sendLines addAll: lines ]
]

{ #category : 'testing' }
MicroPythonAutoPilot >> isEmpty [
	sendLines ifNil: [ ^ true ].
	^ sendLines isEmpty
]

{ #category : 'accessing' }
MicroPythonAutoPilot >> mode [

	^ mode
]

{ #category : 'accessing' }
MicroPythonAutoPilot >> mode: anObject [

	mode := anObject
]

{ #category : 'accessing' }
MicroPythonAutoPilot >> proxy [

	^ proxy
]

{ #category : 'accessing' }
MicroPythonAutoPilot >> proxy: anObject [

	proxy := anObject
]

{ #category : 'accessing' }
MicroPythonAutoPilot >> selector [

	^ selector
]

{ #category : 'accessing' }
MicroPythonAutoPilot >> selector: anObject [

	selector := anObject
]

{ #category : 'accessing' }
MicroPythonAutoPilot >> sendLines [

	^ sendLines
]

{ #category : 'accessing' }
MicroPythonAutoPilot >> sendLines: anObject [

	sendLines := anObject asOrderedCollection
]

{ #category : 'api' }
MicroPythonAutoPilot >> sendNormal [

	mode := #stepNormal
]

{ #category : 'api' }
MicroPythonAutoPilot >> sendPaste [

	mode := #stepPaste
]

{ #category : 'api' }
MicroPythonAutoPilot >> step [

	mode ifNil: [ ^ self ].
	self perform: mode
]

{ #category : 'private' }
MicroPythonAutoPilot >> stepNormal [

	proxy isReady ifTrue: [ 
		self isEmpty
			ifTrue: [ 
				sendLines := nil.
				selector ifNotNil: [ 
					self perform: selector.
					selector := nil ] ]
			ifFalse: [ proxy sendLine: sendLines removeFirst ] ]
]

{ #category : 'private' }
MicroPythonAutoPilot >> stepPaste [

	proxy isReady ifTrue: [ 
		self isEmpty ifTrue: [ 
			selector ifNotNil: [ 
				self perform: selector.
				selector := nil ].
			^ self ].
		^ proxy enterPasteMode ].
	proxy isPasteReady ifFalse: [ ^ self ].
	self isEmpty
		ifTrue: [ 
			sendLines := nil.
			proxy exitPasteMode ]
		ifFalse: [ proxy sendPasteLine: sendLines removeFirst ]
]

{ #category : 'api' }
MicroPythonAutoPilot >> thenRestart [
	selector := #doRestart
]

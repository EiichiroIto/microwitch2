Class {
	#name : #MicroPythonAutoPilot,
	#superclass : #Object,
	#instVars : [
		'proxy',
		'pasteLines',
		'selector'
	],
	#category : #'Microwitch-MPython'
}

{ #category : #api }
MicroPythonAutoPilot >> clear [
	pasteLines := nil.
	selector := nil
]

{ #category : #private }
MicroPythonAutoPilot >> doRestart [
	proxy restart
]

{ #category : #api }
MicroPythonAutoPilot >> execute: aCollection [

	| lines |
	lines := aCollection collect: #asByteArray.
	lines := lines asOrderedCollection.
	pasteLines
		ifNil: [ pasteLines := lines ]
		ifNotNil: [ pasteLines addAll: lines ]
]

{ #category : #testing }
MicroPythonAutoPilot >> isEmpty [
	pasteLines ifNil: [ ^ true ].
	^ pasteLines isEmpty
]

{ #category : #accessing }
MicroPythonAutoPilot >> pasteLines [

	^ pasteLines
]

{ #category : #accessing }
MicroPythonAutoPilot >> pasteLines: anObject [

	pasteLines := anObject asOrderedCollection
]

{ #category : #accessing }
MicroPythonAutoPilot >> proxy [

	^ proxy
]

{ #category : #accessing }
MicroPythonAutoPilot >> proxy: anObject [

	proxy := anObject
]

{ #category : #accessing }
MicroPythonAutoPilot >> selector [

	^ selector
]

{ #category : #accessing }
MicroPythonAutoPilot >> selector: anObject [

	selector := anObject
]

{ #category : #api }
MicroPythonAutoPilot >> step [

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
			pasteLines := nil.
			proxy exitPasteMode ]
		ifFalse: [ proxy sendPasteLine: pasteLines removeFirst ]
]

{ #category : #api }
MicroPythonAutoPilot >> thenRestart [
	selector := #doRestart
]

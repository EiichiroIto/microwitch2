Class {
	#name : #MicroPythonProcess,
	#superclass : #Object,
	#instVars : [
		'topBlock',
		'proxy'
	],
	#category : #'Microwitch-MPython'
}

{ #category : #testing }
MicroPythonProcess >> errorFlag [
	^ false
]

{ #category : #testing }
MicroPythonProcess >> isRunning [
	^ proxy isRunning or: [ proxy isWaiting ]
]

{ #category : #accessing }
MicroPythonProcess >> proxy [
	^ proxy
]

{ #category : #accessing }
MicroPythonProcess >> proxy: anObject [
	proxy := anObject.
]

{ #category : #api }
MicroPythonProcess >> step [
	"do nothing"
]

{ #category : #accessing }
MicroPythonProcess >> stop [

	proxy isReady ifFalse: [ proxy break ].
	topBlock ifNotNil: [ topBlock scratchProc: nil ]
]

{ #category : #accessing }
MicroPythonProcess >> topBlock [
	^ topBlock
]

{ #category : #accessing }
MicroPythonProcess >> topBlock: aBlock [ 
	topBlock := aBlock.
]

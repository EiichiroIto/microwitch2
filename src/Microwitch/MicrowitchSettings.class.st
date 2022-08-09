Class {
	#name : #MicrowitchSettings,
	#superclass : #ScratchSettings,
	#category : #'Microwitch-Spec2'
}

{ #category : #settings }
MicrowitchSettings >> defaultModules [

	^ dictionary at: #defaultModules ifAbsentPut: [ '' ]
]

{ #category : #settings }
MicrowitchSettings >> defaultModules: aString [

	dictionary at: #defaultModules put: aString
]

{ #category : #initialization }
MicrowitchSettings >> initialize [

	super initialize.
	self inputFlowControlType: 0.
	self outputFlowControlType: 0.
	self defaultModules: ''
]

{ #category : #settings }
MicrowitchSettings >> inputFlowControlType [

	^ dictionary at: #inputFlowControlType ifAbsentPut: [ 0 ]
]

{ #category : #settings }
MicrowitchSettings >> inputFlowControlType: aNumber [

	dictionary at: #inputFlowControlType put: aNumber
]

{ #category : #settings }
MicrowitchSettings >> optionsFor: aSymbol [

	aSymbol = #inputFlowControlType ifTrue: [ ^ #( 0 1 2 ) ].
	aSymbol = #outputFlowControlType ifTrue: [ ^ #( 0 1 2 ) ].
	aSymbol = #defaultModules ifTrue: [ ^ #string ].
	^ super optionsFor: aSymbol
]

{ #category : #settings }
MicrowitchSettings >> outputFlowControlType [

	^ dictionary at: #outputFlowControlType ifAbsentPut: [ 0 ]
]

{ #category : #settings }
MicrowitchSettings >> outputFlowControlType: aNumber [

	dictionary at: #outputFlowControlType put: aNumber
]

Class {
	#name : #MicrobitLedColorMorph,
	#superclass : #Morph,
	#instVars : [
		'buttons',
		'whenValueChangedDo'
	],
	#category : #'MicroPythonBlocks-Microbit'
}

{ #category : #private }
MicrobitLedColorMorph >> buttonExtent [
	^ 20 @ 20
]

{ #category : #private }
MicrobitLedColorMorph >> buttonPosition [
	^ self topLeft
]

{ #category : #private }
MicrobitLedColorMorph >> buttonSkip [
	^ 22 @ 22
]

{ #category : #accessing }
MicrobitLedColorMorph >> buttons [

	^ buttons
]

{ #category : #accessing }
MicrobitLedColorMorph >> buttons: anObject [

	buttons := anObject
]

{ #category : #private }
MicrobitLedColorMorph >> createButtonMorph [
	^ Morph new
		extent: self buttonExtent;
		on: #mouseDown send: #mouseDown:button: to: self;
		borderWidth: 2;
		borderColor: Color transparent;
		yourself
]

{ #category : #private }
MicrobitLedColorMorph >> fixButtonsLayout [

	buttons withIndexDo: [ :each :index | 
		each
			position: self buttonPosition + (index - 1 @ 0 * self buttonSkip);
			color: Color red * (index - 1 / 9) ].
	buttons last borderColor: Color black
]

{ #category : #'event handling' }
MicrobitLedColorMorph >> handlesMouseDown: evt [
	^ true
]

{ #category : #initialization }
MicrobitLedColorMorph >> initialize [

	super initialize.
	self color: Color darkGray.
	self extent: self buttonSkip * (10 @ 1).
	buttons := Array new: 10.
	1 to: 10 do: [ :each | 
		| m |
		m := self createButtonMorph.
		self addMorph: m.
		buttons at: each put: m ].
	self fixButtonsLayout
]

{ #category : #'event handling' }
MicrobitLedColorMorph >> mouseDown: evt button: aMorph [

	buttons do: [ :each | each borderColor: Color transparent ].
	aMorph borderColor: Color black.
	whenValueChangedDo ifNil: [ ^ self ].
	whenValueChangedDo cull: (aMorph color red * 9) asInteger
]

{ #category : #accessing }
MicrobitLedColorMorph >> whenValueChangedDo [

	^ whenValueChangedDo
]

{ #category : #accessing }
MicrobitLedColorMorph >> whenValueChangedDo: anObject [

	whenValueChangedDo := anObject
]

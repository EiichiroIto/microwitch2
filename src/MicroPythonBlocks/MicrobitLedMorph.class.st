Class {
	#name : #MicrobitLedMorph,
	#superclass : #Morph,
	#instVars : [
		'intensity',
		'form',
		'buttons'
	],
	#category : #'MicroPythonBlocks-Microbit'
}

{ #category : #private }
MicrobitLedMorph >> buttonExtent [
	^ 8 @ 10
]

{ #category : #private }
MicrobitLedMorph >> buttonPosition [
	^ self topLeft + (65 @ 49)
]

{ #category : #private }
MicrobitLedMorph >> buttonSkip [
	^ 16 @ 16
]

{ #category : #accessing }
MicrobitLedMorph >> buttons [

	^ buttons
]

{ #category : #accessing }
MicrobitLedMorph >> buttons: anObject [

	buttons := anObject
]

{ #category : #private }
MicrobitLedMorph >> createButtonMorph [
	^ Morph new
		color: Color black;
		on: #mouseDown send: #mouseDown:button: to: self;
		yourself
]

{ #category : #drawing }
MicrobitLedMorph >> drawOn: aCanvas [
	super drawOn: aCanvas.
	aCanvas drawImage: form at: self topLeft
]

{ #category : #private }
MicrobitLedMorph >> fixButtonsLayout [

	buttons withIndexDo: [ :each :index | 
		each
			extent: self buttonExtent;
			position: self buttonPosition
				+ (index - 1 \\ 5 @ (index - 1 // 5) * self buttonSkip) ]
]

{ #category : #accessing }
MicrobitLedMorph >> form [

	^ form
]

{ #category : #accessing }
MicrobitLedMorph >> form: anObject [

	form := anObject
]

{ #category : #'event handling' }
MicrobitLedMorph >> handlesMouseDown: evt [
	^ true
]

{ #category : #accessing }
MicrobitLedMorph >> imageString [

	| s |
	s := WriteStream on: String new.
	buttons withIndexDo: [ :each :index | 
		s nextPutAll: (each color red * 9) asInteger asString.
		(index \\ 5 = 0 and: [ index ~= 25 ]) ifTrue: [ s nextPut: $: ] ].
	^ s contents
]

{ #category : #accessing }
MicrobitLedMorph >> imageString: aString [

	| x y s c |
	x := y := 0.
	s := ReadStream on: aString.
	[ s atEnd ] whileFalse: [ 
		c := s next.
		c = $:
			ifTrue: [ 
				y := y + 1.
				x := 0 ]
			ifFalse: [ 
				(c between: $0 and: $9) ifFalse: [ self error ].
				(buttons at: y * 5 + x + 1) color:
					Color red * ((c asciiValue - $0 asciiValue) / 9).
				x := x + 1 ] ]
]

{ #category : #initialization }
MicrobitLedMorph >> initialize [

	super initialize.
	self color: Color darkGray.
	form := ScratchTheme formAt: #largeMicrobit.
	self extent: form extent.
	buttons := Array new: 25.
	1 to: 25 do: [ :each | 
		| m |
		m := self createButtonMorph.
		self addMorph: m.
		buttons at: each put: m ].
	self fixButtonsLayout.
	intensity := 9
]

{ #category : #accessing }
MicrobitLedMorph >> intensity [
	^ intensity asInteger
]

{ #category : #accessing }
MicrobitLedMorph >> intensity: anInteger [
	(anInteger < 0 or: [anInteger > 9])
		ifTrue: [^ self].
	intensity := anInteger
]

{ #category : #'event handling' }
MicrobitLedMorph >> mouseDown: evt button: aMorph [

	| c |
	c := Color red * (intensity / 9).
	aMorph color = c ifTrue: [ ^ aMorph color: Color black ].
	aMorph color: c
]

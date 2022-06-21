Class {
	#name : #MicrobitLedArgMorph,
	#superclass : #ArgMorph,
	#instVars : [
		'image'
	],
	#category : #'Microwitch-Microbit'
}

{ #category : #accessing }
MicrobitLedArgMorph >> defaultValue: anObject [
	self image: anObject
]

{ #category : #drawing }
MicrobitLedArgMorph >> drawOn: aCanvas [ 
	| w h x y r |
	super drawOn: aCanvas.
	w := 3.
	h := 3.
	x := self left + 3.
	1 to: 5 do: 
		[:xx | 
		y := self top + 2.
		1 to: 5 do: 
			[:yy | 
			(self valueAt: (xx - 1) @ (yy - 1))
				> 0
				ifTrue: 
					[r := x @ y extent: 2 @ 2.
					aCanvas fillRectangle: r color: Color red].
			y := y + h].
		x := x + w]
]

{ #category : #accessing }
MicrobitLedArgMorph >> evaluate [
	^ image
]

{ #category : #'event handling' }
MicrobitLedArgMorph >> handlesMouseDown: evt [
	^ true
]

{ #category : #accessing }
MicrobitLedArgMorph >> image [
	^ image
]

{ #category : #accessing }
MicrobitLedArgMorph >> image: aString [
	image := aString.
	self updateCache
]

{ #category : #initialization }
MicrobitLedArgMorph >> initialize [
	super initialize.
	self extent: 20 @ 20.
	self color: Color white.
	image := '00000:00000:00900:00000:00000:'.
]

{ #category : #other }
MicrobitLedArgMorph >> labelMorph [
	^ ''
]

{ #category : #'event handling' }
MicrobitLedArgMorph >> mouseUp: evt [ 
	self showLedEditorAt: evt cursorPoint.
]

{ #category : #private }
MicrobitLedArgMorph >> showLedEditorAt: aPoint [

	| editor dialog |
	editor := MicrobitLedEditor new.
	editor imageString: self image.
	dialog := editor openModal.
	dialog cancelled ifTrue: [ ^ self ].
	self image: editor imageString
]

{ #category : #private }
MicrobitLedArgMorph >> updateCache [
	| m |
	m := self outermostMorphThat: [ :v | v isKindOf: BlockMorph ].
	m ifNil: [ ^ self ].
	self changed.
	m updateCachedForm
]

{ #category : #private }
MicrobitLedArgMorph >> valueAt: aPoint [ 
	| index v |
	index := aPoint y * (5 + 1) + aPoint x + 1.
	index > image size ifTrue: [^ 0].
	v := image at: index.
	^ v asciiValue - $0 asciiValue
]

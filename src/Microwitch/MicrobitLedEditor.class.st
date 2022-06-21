Class {
	#name : #MicrobitLedEditor,
	#superclass : #SpPresenter,
	#instVars : [
		'intensitySlider',
		'ledMorph'
	],
	#category : #'Microwitch-Microbit'
}

{ #category : #specs }
MicrobitLedEditor class >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #intensitySlider withConstraints: [ :c | c height: 30 ];
		  add: #ledMorph;
		  yourself
]

{ #category : #initialization }
MicrobitLedEditor >> connectPresenters [
	intensitySlider morph whenValueChangedDo: [ :v | ledMorph morph intensity: v ]
]

{ #category : #private }
MicrobitLedEditor >> createLedColorMorph [
	^ MicrobitLedColorMorph new
]

{ #category : #private }
MicrobitLedEditor >> createLedMorph [
	^ MicrobitLedMorph new
]

{ #category : #accessing }
MicrobitLedEditor >> imageString [

	^ ledMorph morph imageString
]

{ #category : #accessing }
MicrobitLedEditor >> imageString: aString [

	ledMorph morph imageString: aString
]

{ #category : #initialization }
MicrobitLedEditor >> initializePresenters [

	intensitySlider := self newMorph
		                   morph: self createLedColorMorph;
		                   yourself.
	ledMorph := self newMorph
		            morph: self createLedMorph;
		            yourself
]

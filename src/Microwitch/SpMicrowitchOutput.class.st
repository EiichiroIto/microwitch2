Class {
	#name : #SpMicrowitchOutput,
	#superclass : #SpPresenter,
	#instVars : [
		'plotter',
		'textOutput',
		'notebook',
		'buttonClear'
	],
	#category : #'Microwitch-Spec2'
}

{ #category : #specs }
SpMicrowitchOutput class >> defaultLayout [
	^ SpBoxLayout newVertical
		add: #buttonClear withConstraints: [ :c | c height: self buttonHeight ];
		add: #notebook;
		yourself
]

{ #category : #accessing }
SpMicrowitchOutput >> addPlots: aCollection [

	plotter morph addPlots: aCollection
]

{ #category : #accessing }
SpMicrowitchOutput >> addText: aString [

	textOutput morph
		put: aString;
		changed
]

{ #category : #accessing }
SpMicrowitchOutput >> clearPlots [

	plotter morph clearPlots
]

{ #category : #accessing }
SpMicrowitchOutput >> clearText [
	textOutput morph clearScreen
]

{ #category : #initialization }
SpMicrowitchOutput >> connectPresenters [

	buttonClear action: [ 
		self
			clearText;
			clearPlots.
		textOutput morph changed.
		plotter morph changed ]
]

{ #category : #private }
SpMicrowitchOutput >> createConsoleMorph [
	^ ScratchConsoleMorph new
]

{ #category : #private }
SpMicrowitchOutput >> createPlotterMorph [
	^ ScratchPlotterMorph new
		maxSize: 100;
		updatePeriod: 100;
		acceptPlots: true;
		max: 100;
		min: -100;
		yourself
]

{ #category : #private }
SpMicrowitchOutput >> createPlotterPage [
	plotter := self newMorph.
	plotter morph: self createPlotterMorph.
	^ SpNotebookPage
		title: self plotterLabel
		icon: (self iconNamed: #morph)
		provider: [ plotter ]
]

{ #category : #private }
SpMicrowitchOutput >> createTextPage [

	textOutput := self newMorph.
	textOutput morph: self createConsoleMorph.
	^ SpNotebookPage
		  title: self textLabel
		  icon: (self iconNamed: #morph)
		  provider: [ textOutput ]
]

{ #category : #initialization }
SpMicrowitchOutput >> initializePresenters [
	buttonClear := self newButton
		label: 'Clear';
		icon: (self iconNamed: #glamorousClose);
		yourself.
	notebook := self newNotebook
		addPage: self createTextPage;
		addPage: self createPlotterPage;
		yourself
]

{ #category : #accessing }
SpMicrowitchOutput >> plotter [
	^ plotter morph
]

{ #category : #private }
SpMicrowitchOutput >> plotterLabel [
	^ 'Plotter'
]

{ #category : #private }
SpMicrowitchOutput >> textLabel [
	^ 'Output'
]

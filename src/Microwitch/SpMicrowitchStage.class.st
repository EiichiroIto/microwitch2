Class {
	#name : #SpMicrowitchStage,
	#superclass : #SpPresenter,
	#instVars : [
		'morphTimer',
		'labelStatus',
		'labelMessage',
		'plotter',
		'textOutput',
		'notebook',
		'buttonClear',
		'buttonInput'
	],
	#category : #'Microwitch-Spec2'
}

{ #category : #specs }
SpMicrowitchStage class >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #morphTimer withConstraints: [ :c | c height: 5 ];
		  add: #labelStatus
		  withConstraints: [ :c | c height: self buttonHeight ];
		  add: #labelMessage
		  withConstraints: [ :c | c height: self buttonHeight ];
		  add: (SpBoxLayout newVertical
				   add: (SpBoxLayout newHorizontal
						    add: #buttonInput;
						    add: #buttonClear;
						    yourself)
				   withConstraints: [ :c | c height: self buttonHeight ];
				   add: #notebook;
				   yourself);
		  yourself
]

{ #category : #private }
SpMicrowitchStage >> addPlots: aCollection [

	| data |
	aCollection do: [ :each | 
		each asString lines do: [ :each2 | 
			data := self plotDataFromString: each2.
			data notEmpty ifTrue: [ plotter morph addPlots: data ] ] ]
]

{ #category : #api }
SpMicrowitchStage >> addText: aString [

	textOutput morph
		put: aString;
		changed
]

{ #category : #'button actions' }
SpMicrowitchStage >> clear [

	textOutput morph
		clearScreen;
		changed.
	plotter morph
		clearPlots;
		changed
]

{ #category : #initialization }
SpMicrowitchStage >> connectPresenters [

	buttonClear action: [ self clear ]
]

{ #category : #private }
SpMicrowitchStage >> createConsoleMorph [
	^ ScratchConsoleMorph new
]

{ #category : #private }
SpMicrowitchStage >> createPlotterMorph [
	^ ScratchPlotterMorph new
		maxSize: 100;
		updatePeriod: 100;
		acceptPlots: true;
		max: 100;
		min: -100;
		yourself
]

{ #category : #private }
SpMicrowitchStage >> createPlotterPage [
	plotter := self newMorph.
	plotter morph: self createPlotterMorph.
	^ SpNotebookPage
		title: self plotterLabel
		icon: (self iconNamed: #morph)
		provider: [ plotter ]
]

{ #category : #private }
SpMicrowitchStage >> createTextPage [

	textOutput := self newMorph.
	textOutput morph: self createConsoleMorph.
	^ SpNotebookPage
		  title: self textLabel
		  icon: (self iconNamed: #morph)
		  provider: [ textOutput ]
]

{ #category : #private }
SpMicrowitchStage >> createTimerMorph [
	^ ScratchStepperMorph new
		stepTime: self defaultStepTime;
		yourself
]

{ #category : #private }
SpMicrowitchStage >> defaultStepTime [
	^ 100
]

{ #category : #initialization }
SpMicrowitchStage >> initializePresenters [

	buttonInput := self newButton
		               label: 'input' localized;
		               icon: (self iconNamed: #edit);
		               yourself.
	buttonClear := self newButton
		               label: 'clear' localized;
		               icon: (self iconNamed: #glamorousClose);
		               yourself.
	notebook := self newNotebook
		            addPage: self createTextPage;
		            addPage: self createPlotterPage;
		            yourself.
	morphTimer := self newMorph
		              morph: self createTimerMorph;
		              yourself.
	labelStatus := self newLabel
		               label: '';
		               yourself.
	labelMessage := self newLabel
		                label: '';
		                yourself
]

{ #category : #api }
SpMicrowitchStage >> message: aString [
	labelMessage label: aString
]

{ #category : #private }
SpMicrowitchStage >> plotDataFromString: aString [
	| str tokens |
	str := aString trimBoth.
	((str beginsWith: '[') and: [ str endsWith: ']' ])
		ifTrue: [ str := str copyFrom: 2 to: str size - 1 ].
	tokens := ([ :c | c isSeparator or: [ c = $, ] ] split: str)
		select: [ :each | each notEmpty ].
	(tokens allSatisfy: [ :each | each isNumberString ])
		ifFalse: [ ^ #() ].
	^ tokens
		withIndexCollect:
			[ :each :index | ScratchPlot channel: index data: each asNumberNoError ]
]

{ #category : #accessing }
SpMicrowitchStage >> plotter [
	^ plotter morph
]

{ #category : #private }
SpMicrowitchStage >> plotterLabel [
	^ 'Plotter' localized
]

{ #category : #accessing }
SpMicrowitchStage >> startStepping [
	morphTimer morph startStepping
]

{ #category : #api }
SpMicrowitchStage >> status: aString [
	labelStatus label: aString localized
]

{ #category : #private }
SpMicrowitchStage >> textLabel [
	^ 'Output' localized
]

{ #category : #accessing }
SpMicrowitchStage >> whenInputClicked: aBlock [

	buttonInput action: aBlock
]

{ #category : #accessing }
SpMicrowitchStage >> whenStepsDo: aBlock [
	morphTimer morph whenStepsDo: aBlock
]

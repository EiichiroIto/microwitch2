Class {
	#name : #SpMicrowitchStage,
	#superclass : #SpPresenter,
	#instVars : [
		'output',
		'proxy',
		'morphTimer',
		'labelStatus',
		'labelMessage',
		'showOutput'
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
		  add: #output;
		  yourself
]

{ #category : #private }
SpMicrowitchStage >> addPlots: aCollection [

	| data |
	aCollection do: [ :each | 
		each asString lines do: [ :each2 | 
			data := self plotDataFromString: each2.
			data notEmpty ifTrue: [ output addPlots: data ] ] ]
]

{ #category : #api }
SpMicrowitchStage >> autoConnect [

	self autoConnectIfFail: [ :msg | 
		self message: msg.
		^ false ].
	^ true
]

{ #category : #private }
SpMicrowitchStage >> autoConnectIfFail: aBlock [

	proxy isReady ifTrue: [ ^ self ]. 
	self connectIfFail: aBlock.
	proxy break.
	proxy waitPromptIfError: aBlock
]

{ #category : #private }
SpMicrowitchStage >> autoSelectPortName [

	| list ret |
	list := proxy portNames sorted.
	list isEmpty ifTrue: [ ^ self ].
	ret := list first.
	list size > 1 ifTrue: [ 
		ret := SpScratchApp
			       select: 'Select port' localized
			       chooseFrom: list.
		ret ifNil: [ ^ self ] ].
	proxy portName: ret
]

{ #category : #'button actions' }
SpMicrowitchStage >> break [

	self application stopAllProcesses.
	proxy isIdle ifTrue: [ ^ self ].
	proxy isNotConnected ifTrue: [ 
		proxy open ifFalse: [ 
			owner enableConnect.
			^ self message: 'cannot open:' localized , proxy comm portName ] ].
	proxy break.
	owner disableConnect.
	self message: 'stopped' localized
]

{ #category : #'button actions' }
SpMicrowitchStage >> connect [

	self connectIfFail: [ :msg | ^ self message: msg ].
	proxy break
]

{ #category : #private }
SpMicrowitchStage >> connectIfFail: aBlock [

	proxy isIdle ifTrue: [ 
		self autoSelectPortName.
		proxy isIdle ifTrue: [ 
			^ aBlock cull: 'cannot select port' localized ] ].
	proxy isNotConnected ifTrue: [ 
		proxy open ifFalse: [ 
			^ aBlock cull: 'cannot open:' localized , proxy comm portName ] ].
	owner disableConnect
]

{ #category : #initialization }
SpMicrowitchStage >> connectPresenters [

	output whenInputClicked: [ self input ]
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

{ #category : #api }
SpMicrowitchStage >> deleteFileNamed: aString [

	proxy isReady ifFalse: [ 
		self message: 'device is not ready' localized.
		^ self ].
	proxy deleteFileNamed: aString.
	showOutput := false.
	self message: 'done' localized
]

{ #category : #'button actions' }
SpMicrowitchStage >> disconnect [

	owner enableConnect.
	proxy disconnect.
	self message: 'port closed' localized
]

{ #category : #api }
SpMicrowitchStage >> downloadFileNamed: aString [

	| ret |
	proxy isReady ifFalse: [ 
		self message: 'device is not ready' localized.
		^ nil ].
	ret := proxy downloadFileNamed: aString ifError: [ :msg | 
		       self message: msg.
		       ^ nil ].
	showOutput := false.
	^ ret
]

{ #category : #api }
SpMicrowitchStage >> evaluate: aString [

	| ret |
	self autoConnectIfFail: [ :msg | 
		self message: msg.
		^ 'Error!' ].
	ret := proxy evaluate: aString ifError: [ :msg | 
		       self message: msg.
		       ^ 'Error!' ].
	self message: 'done' localized.
	^ ret
]

{ #category : #api }
SpMicrowitchStage >> execute: aString [

	self autoConnectIfFail: [ :msg | ^ self message: msg ].

	proxy execute: aString.
	self message: 'done' localized
]

{ #category : #api }
SpMicrowitchStage >> getDirectory [

	| cmd ret |
	self autoConnectIfFail: [ :msg | 
		self message: msg.
		^ nil ].

	cmd := 'import os' , String lf , 'os.listdir()'.
	ret := proxy evaluate: cmd ifError: [ :msg | 
		       self message: msg.
		       ^ nil ].

	ret ifNil: [ ^ nil ].
	^ MicroPythonParser new parse: ret
]

{ #category : #initialization }
SpMicrowitchStage >> initialize [
	super initialize.
	showOutput := true
]

{ #category : #initialization }
SpMicrowitchStage >> initializePresenters [
	output := self instantiate: SpMicrowitchOutput.
	morphTimer := self newMorph
		morph: self createTimerMorph;
		yourself.
	labelStatus := self newLabel
		label: '';
		yourself.
	labelMessage := self newLabel
		label: '';
		yourself.
	self focusOrder
		add: output
]

{ #category : #'button actions' }
SpMicrowitchStage >> input [

	| ret |
	self autoConnectIfFail: [ :msg | ^ self message: msg ].
	ret := Microwitch
		       multiLineRequest: 'Enter expression' localized
		       initialAnswer: ''.
	ret ifNil: [ ^ self ].
	proxy isReady ifFalse: [ ^ self ].
	proxy execute: ret
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
	^ output plotter
]

{ #category : #accessing }
SpMicrowitchStage >> proxy [
	^ proxy
]

{ #category : #accessing }
SpMicrowitchStage >> proxy: aProxy [
	| comm |
	comm := nil.
	proxy
		ifNotNil: [ proxy close.
			comm := proxy comm ].
	proxy := aProxy.
	comm ifNotNil: [ proxy comm: comm ]
]

{ #category : #'button actions' }
SpMicrowitchStage >> restart [

	owner enableConnect.
	proxy restart.
	self message: 'restarted' localized
]

{ #category : #api }
SpMicrowitchStage >> restartAfterUpload [
	owner enableConnect.
	proxy thenRestart
]

{ #category : #accessing }
SpMicrowitchStage >> startStepping [
	morphTimer morph startStepping
]

{ #category : #api }
SpMicrowitchStage >> status: aString [
	labelStatus label: aString localized
]

{ #category : #stepping }
SpMicrowitchStage >> step [

	| out |
	proxy step.
	self status: proxy state asString.
	proxy isReady ifTrue: [ 
		showOutput := true.
		owner application stopAllProcesses ].
	out := proxy receiveQueue getAll.
	showOutput ifTrue: [ 
		out do: [ :each | output addText: each asString ] ].
	self addPlots: out.
	proxy ifTimeoutDo: [ self message: 'timeout' localized ]
]

{ #category : #api }
SpMicrowitchStage >> upload: aString fileNamed: aString2 [

	proxy isReady ifFalse: [ 
		self message: 'device is not ready' localized.
		^ nil ].
	proxy upload: aString fileNamed: aString2.
	showOutput := false
]

{ #category : #accessing }
SpMicrowitchStage >> whenStepsDo: aBlock [
	morphTimer morph whenStepsDo: aBlock
]

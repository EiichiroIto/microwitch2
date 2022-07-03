Class {
	#name : #Microwitch,
	#superclass : #SpScratchApp,
	#instVars : [
		'process'
	],
	#category : #'Microwitch-Spec2'
}

{ #category : #constants }
Microwitch class >> aboutAppString [

	^ self appName , ' ' , self appVersion , '
Copyright © 2022 Eiichiro Ito (ghc02331@nifty.com)
All rights reserved.

Based on Scratch from the MIT Media Lab, v' , self basedVersion , '
Copyright © 2009 Massachusetts Institute of Technology.
All rights reserved.
'
]

{ #category : #utilities }
Microwitch class >> allBlockDefs [

	"MicroPythonProject initialize.
	FileSystem workingDirectory / 'blocks.txt' writeStreamDo: [ :s | 
		s nextPutAll:
			(Microwitch allBlockDefs sorted joinUsing: Character cr) ]."

	^ (({ MicrobitBlockSpecs new intModuleDef }
	    , MicroPythonProject availableModules values collect: #blockDict) 
		   collect: #values) flattened collect: #block
]

{ #category : #constants }
Microwitch class >> appFolderName [
	^ 'microwitch2'
]

{ #category : #constants }
Microwitch class >> appName [
	^ 'Microwitch'
]

{ #category : #constants }
Microwitch class >> appVersion [
	^ '2.0.2'
]

{ #category : #settings }
Microwitch class >> defaultModules [

	^ self settings at: #defaultModules ifAbsentPut: [ '' ]
]

{ #category : #settings }
Microwitch class >> defaultModules: aString [

	self settings at: #defaultModules put: aString
]

{ #category : #constants }
Microwitch class >> extension [
	^ 'mw2'
]

{ #category : #'class initialization' }
Microwitch class >> initialize [

	"self initialize"

	ScratchTheme
		themesURL: self themesURL;
		setupThemeNamed: self appFolderName.
	self setupOptions.
	"workaround for travis test errors"
	ObjStream setupVariables
]

{ #category : #settings }
Microwitch class >> inputFlowControlType [
	^ self settings at: #inputFlowControlType ifAbsentPut: [ 0 ]
]

{ #category : #settings }
Microwitch class >> inputFlowControlType: aNumber [
	self settings at: #inputFlowControlType put: aNumber
]

{ #category : #'world menu' }
Microwitch class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: self appName asSymbol)
		order: 0.5;
		target: self;
		action: [self new open]; 
		"parent: #Tools;"
		icon: self icon
]

{ #category : #settings }
Microwitch class >> optionsFor: aSymbol [
	aSymbol = #inputFlowControlType
		ifTrue: [ ^ #(0 1 2) ].
	aSymbol = #outputFlowControlType
		ifTrue: [ ^ #(0 1 2) ].
	aSymbol = #defaultModules
		ifTrue: [ ^ #string ].
	^ super optionsFor: aSymbol
]

{ #category : #settings }
Microwitch class >> outputFlowControlType [
	^ self settings at: #outputFlowControlType ifAbsentPut: [ 0 ]
]

{ #category : #settings }
Microwitch class >> outputFlowControlType: aNumber [
	self settings at: #outputFlowControlType put: aNumber
]

{ #category : #constants }
Microwitch class >> presentationClass [
	^ SpMicrowitchFrame
]

{ #category : #constants }
Microwitch class >> projectClass [
	^ MicroPythonProject
]

{ #category : #settings }
Microwitch class >> setupOptions [

	super setupOptions.
	self inputFlowControlType: 0.
	self outputFlowControlType: 0.
	self defaultModules: ''
]

{ #category : #constants }
Microwitch class >> sexpExtension [
	^ 'mws'
]

{ #category : #utilities }
Microwitch class >> sourceCodeUsingLocalize [

	"FileSystem workingDirectory / 'localized.txt' writeStreamDo: [ :s | 
		s nextPutAll: (self sourceCodeUsingLocalize joinUsing: Character cr) ]"

	^ #localized senders collect: #sourceCode
]

{ #category : #constants }
Microwitch class >> themesURL [
	^ 'https://github.com/EiichiroIto/microwitch2/raw/main/misc/Themes.zip'
]

{ #category : #accessing }
Microwitch >> availableModuleNames [
	^ MicroPythonProject availableModuleNames
]

{ #category : #private }
Microwitch >> checkValidScript: aScript [
	aScript eventBlocks size = 1
		ifFalse: [ self alert: 'Start script only needs one' localized.
			^ false ].
	^ true
]

{ #category : #private }
Microwitch >> checkValidScripts [
	^ project scripts allSatisfy: [ :each | self checkValidScript: each ]
]

{ #category : #private }
Microwitch >> confirmCode: aString title: aTitleString [
	^ UIManager default
		multiLineRequest: aTitleString
		initialAnswer: aString
		answerHeight: 450
]

{ #category : #private }
Microwitch >> createBlockSpecs [
	^ MicrobitBlockSpecs new
]

{ #category : #private }
Microwitch >> createComm [
	^ SerialComm new
]

{ #category : #private }
Microwitch >> createProcess [
	^ MicroPythonProcess new
]

{ #category : #private }
Microwitch >> createProject [

	| proj modules |
	proj := super createProject.
	proj blockSpecs: self createBlockSpecs.
	modules := self class defaultModules splitOn: Character space.
	modules := modules intersection: self availableModuleNames.
	modules do: [ :each | proj addModule: each ].
	^ proj
]

{ #category : #private }
Microwitch >> createProxy [
	^ MicroPythonProxy new
]

{ #category : #'menu actions' }
Microwitch >> deleteFile [

	| file |
	presenter autoConnect ifFalse: [ ^ self ].
	file := self selectRemoteFile.
	file ifNil: [ ^ self ].
	presenter deleteFileNamed: file
]

{ #category : #'menu actions' }
Microwitch >> downloadFile [

	| file code |
	presenter autoConnect ifFalse: [ ^ self ].
	file := self selectRemoteFile.
	file ifNil: [ ^ self ].
	code := presenter downloadFileNamed: file.
	(code isNil or: [ code isEmpty ]) ifTrue: [ ^ self ].
	code := MicroPythonParser new parse: code.
	code := self confirmCode: code title: 'OK to save, or cancel'.
	code ifNil: [ ^ self ].
	self exportString: code extension: self pyExtension isBinary: false
]

{ #category : #accessing }
Microwitch >> enabledModuleNames [
	^ project modules
]

{ #category : #processes }
Microwitch >> evaluateFor: aTopBlock [

	| code |
	self stopAllProcesses.
	code := self newCode parse: aTopBlock withHeader: true.
	code isEmpty ifTrue: [ ^ nil ].
	^ presenter evaluate: code
]

{ #category : #'menu actions' }
Microwitch >> exportMicroPython [
	self export: MicroPythonExporter new extension: self pyExtension
]

{ #category : #'menu actions' }
Microwitch >> exportSexpCode [
	self export: (MicroPythonSexpExporter appName: self appName) extension: self class sexpExtension
]

{ #category : #'menu actions' }
Microwitch >> importSexpCode [
	self import: (MicroPythonSexpImporter appName: self appName) extension: self class sexpExtension
]

{ #category : #private }
Microwitch >> installNewProject: aProject [

	| proxy comm |
	self stopAllProcesses.
	project := aProject.
	project application: self.
	proxy := self createProxy.
	comm := self createComm.
	comm baudRate: proxy defaultBaudRate.
	proxy comm: comm.
	presenter proxy: proxy.
	project
		blockSpecs: self createBlockSpecs;
		updateBlockDefs.
	"project fixVars.
	project updateLabels."
	self setupView.
	Smalltalk garbageCollect.
	project modified: false
]

{ #category : #processes }
Microwitch >> isProcessRunning [
	^ process notNil and: [ process isRunning ]
]

{ #category : #testing }
Microwitch >> moduleInUse: aString [
	^ project ifNil: [ false ] ifNotNil: [ project moduleInUse: aString ]
]

{ #category : #micropython }
Microwitch >> modulesNeedToUpload [
	| existings |
	existings := presenter getDirectory.
	existings ifNil: [ ^ nil ].
	^ project moduleFiles
		reject: [ :each | existings includes: each basename ]
]

{ #category : #private }
Microwitch >> newCode [
	^ MicroPythonCode new
		generator: MicrobitGenerator new;
		yourself
]

{ #category : #private }
Microwitch >> normalizeModuleName: aString [

	| ret |
	aString ifNil: [ ^ aString ].
	ret := aString select: [ :each | each isAlphaNumeric ].
	ret isEmpty ifTrue: [ ^ ret ].
	ret first isUppercase ifTrue: [ 
		ret := ret first asLowercase asString , ret copyWithoutFirst ].
	ret first isDigit ifTrue: [ ret := 'v' , ret ].
	ret size > 16 ifTrue: [ ret := ret copyFrom: 1 to: 16 ].
	^ ret
]

{ #category : #private }
Microwitch >> normalizeVariableName: aString [

	^ self normalizeModuleName: aString
]

{ #category : #private }
Microwitch >> prepareForOpening [
	MicroPythonProject loadIntModules.
	MicroPythonProject loadAvailableModules
]

{ #category : #accessing }
Microwitch >> proxy [
	^ presenter proxy
]

{ #category : #accessing }
Microwitch >> proxyClass [
	^ presenter proxy class name
]

{ #category : #micropython }
Microwitch >> pyExtension [
	^ 'py'
]

{ #category : #'menu actions' }
Microwitch >> quit [
	(self confirm: 'Quit Application?' translated)
		ifFalse: [ ^ self ].
	Smalltalk snapshot: false andQuit: true
]

{ #category : #private }
Microwitch >> restoreProject [
	"do nothing"
]

{ #category : #micropython }
Microwitch >> selectRemoteFile [

	| choices |
	choices := presenter getDirectory.
	(choices isNil or: [ choices isEmpty ]) ifTrue: [ ^ nil ].
	^ self select: 'Select file' localized chooseFrom: choices
]

{ #category : #private }
Microwitch >> showCode: aString title: aTitleString [

	self closeMediaEditorsAndDialogs.
	UIManager default longMessage: aString title: aTitleString
]

{ #category : #'menu actions' }
Microwitch >> showCodeOf: aBlockMorph [
	| code |
	code := self newCode parse: aBlockMorph withHeader: true.
	self showCode: code title: 'show code' localized
]

{ #category : #processes }
Microwitch >> startProcessFor: aTopBlock [

	| code |
	self stopAllProcesses.
	code := self newCode parse: aTopBlock withHeader: true.
	code isEmpty ifTrue: [ ^ nil ].
	process := self createProcess
		           proxy: self proxy;
		           topBlock: aTopBlock;
		           yourself.
	aTopBlock scratchProc: process.
	presenter execute: code.
	^ process
]

{ #category : #'menu actions' }
Microwitch >> startProgram [
	self checkValidScripts
		ifFalse: [ ^ self ].
	presenter autoConnect ifFalse: [ ^ self ].
	self uploadModuleFiles.
	self uploadProgram.
	presenter restartAfterUpload
]

{ #category : #processes }
Microwitch >> stepProcesses [

	process ifNotNil: #step.
	presenter step
]

{ #category : #processes }
Microwitch >> stopAllProcesses [

	process ifNotNil: [ 
		process stop.
		process := nil ].
	project ifNotNil: [ project stopAllProcesses ]
]

{ #category : #'menu actions' }
Microwitch >> toggleModule: aString [
	project toggleModule: aString.
	presenter updateViewer
]

{ #category : #'menu actions' }
Microwitch >> uploadFile [

	| pair filename |
	pair := self
		        importFileWithExtension: self pyExtension
		        isBinary: false.
	pair ifNil: [ ^ self ].
	filename := self
		            request: 'Upload file name?' localized
		            initialAnswer: pair second basename.
	(filename isNil or: [ filename isEmpty ]) ifTrue: [ ^ self ].
	presenter autoConnect.
	presenter upload: pair first fileNamed: filename
]

{ #category : #'menu actions' }
Microwitch >> uploadFirmware [

	| dir file firmware |
	dir := MicrobitFirmware default firmwarePathIfFail: [ :msg | 
		       ^ self alert: msg ].
	dir ifNil: [ 
		dir := UIManager default chooseDirectory:
			       'select micro:bit device' localized ].
	dir ifNil: [ ^ self ].
	file := dir / 'DETAILS.TXT'.
	file isFile ifFalse: [ 
		^ self alert: 'details.txt is not found' localized ].
	firmware := MicrobitFirmware default firmwareFor: file.
	firmware ifNil: [ 
		^ self alert: 'unable to find the appropriate firmware' localized ].
	(self confirm: 'initialize micro:bit?' localized) ifFalse: [ ^ self ].
	(dir / 'firmware.hex') writeStreamDo: [ :stream | 
		stream nextPutAll: firmware ]
]

{ #category : #micropython }
Microwitch >> uploadModuleFiles [

	| list |
	list := self modulesNeedToUpload.
	list ifNil: [ ^ self ].
	list do: [ :each | 
		presenter upload: each contents fileNamed: each basename ]
]

{ #category : #micropython }
Microwitch >> uploadProgram [

	project scripts do: [ :each | 
		| code |
		code := self newCode parseHats: each hatBlocks.
		code isEmpty ifFalse: [ 
			presenter
				upload: code
				fileNamed: each objName , '.' , self pyExtension ] ]
]

{ #category : #private }
Microwitch >> windowClosing [
	self proxy close
]

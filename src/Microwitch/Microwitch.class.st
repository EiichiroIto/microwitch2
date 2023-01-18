Class {
	#name : #Microwitch,
	#superclass : #SpScratchApp,
	#instVars : [
		'process',
		'proxy',
		'showOutput',
		'lastInput'
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

{ #category : #utilities }
Microwitch class >> allProxyStates [

	| obj |
	obj := MicroPythonState new.
	^ (MicroPythonState organization protocolOrganizer 
		   methodsInProtocolNamed: 'api') collect: [ :each | 
		  obj perform: each.
		  obj asString ]
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
	^ '2.0.4'
]

{ #category : #constants }
Microwitch class >> extension [
	^ 'mw2'
]

{ #category : #utilities }
Microwitch class >> generatePOTFile [

	"Microwitch generatePOTFile."

	| project list strings |
	MicroPythonProject initialize.
	project := MicroPythonProject new blockSpecs: MicrobitBlockSpecs new.
	list := ScratchScript allSubclasses collect: [ :each | each new ].
	list do: [ :each | each project: project ].
	strings := Set new.
	ScratchTranslator addBlockDefs: list to: strings.
	ScratchTranslator addLocalizedTextsTo: strings.
	strings addAll: MicroPythonProject availableModuleNames.
	strings addAll: self allBlockDefs.
	strings addAll: self allProxyStates.
	ScratchTranslator writePOT: strings fileNamed: 'microwitch2.pot'
]

{ #category : #accessing }
Microwitch class >> icon [

	^ Form
		  extent: 16 @ 16
		  depth: 32
		  fromArray:
			  #( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 134217728
			     1076363859 1161036649 16777216 0 0 0 0 0 0 0 0 0 0 0 723583304
			     3244032695 4219011565 4117955298 1933574785 421921105
			     320799553 67108864 0 0 0 0 0 0 0 1211499375 3932881875
			     4286710014 4286710015 4286579194 4269081573 4083484357
			     3376351612 520093696 0 0 0 0 0 0 1211368299 4033872605
			     4286710015 4286710015 4286710015 4286448375 2655127426
			     889192448 167772160 0 0 721879315 805699858 16777217 0 942408028
			     3882615508 4286710015 4286710015 4286710015 4286710015
			     4286317043 1548027018 0 0 0 469828096 4029154378 4163568719
			     2098463527 522322176 3697607574 4286448121 4286710015
			     4286710015 4286710015 4286710015 4285989610 892143192
			     0 0 0 536871424 4197122640 4281401436 4247519826 3847095654
			     4291299086 4289725556 4286579913 4285924074 4286710015
			     4286710015 4050387670 570425344 0 0 0 167772160 3189900096
			     4281336155 4281401436 4282451839 4286121682 4288611721
			     4291167015 4291429952 4289005190 4289201531 4221044046
			     2789803412 3294430392 2420966552 337117744 0 369295369
			     2971731006 4163699284 4281401947 4282647686 4286055147
			     4286382831 4285596116 4285793475 4286645690 4285924317
			     4286644477 4286710015 4235395810 775095398 0 0 33554432
			     1209205796 3122856770 3895001932 3576825186 3512992453
			     4218618339 4286513657 4286711038 4286579450 4286054891
			     4100915931 2253324957 83886080 0 0 0 0 83886080 352321536
			     218103808 184549376 724435551 1816265094 2017854603 1816396425
			     1111294587 522191427 33554432 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
			     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 )
		  offset: 0 @ 0
]

{ #category : #'class initialization' }
Microwitch class >> initialize [

	"self initialize"

	ScratchTheme
		themesURL: self themesURL;
		setupThemeNamed: self appFolderName.
	"workaround for travis test errors"
	ObjStream setupVariables
]

{ #category : #'world menu' }
Microwitch class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: self appName asSymbol)
		order: 0.5;
		target: self;
		action: [self open]; 
		"parent: #Tools;"
		icon: self icon
]

{ #category : #constants }
Microwitch class >> presentationClass [
	^ SpMicrowitchFrame
]

{ #category : #constants }
Microwitch class >> projectClass [
	^ MicroPythonProject
]

{ #category : #constants }
Microwitch class >> settingsClass [

	^ MicrowitchSettings
]

{ #category : #constants }
Microwitch class >> sexpExtension [
	^ 'mws'
]

{ #category : #constants }
Microwitch class >> themesURL [
	^ 'https://github.com/EiichiroIto/microwitch2/raw/main/misc/Themes.zip'
]

{ #category : #proxy }
Microwitch >> autoConnect [

	self autoConnectIfFail: [ :msg | 
		presenter message: msg.
		^ false ].
	^ true
]

{ #category : #proxy }
Microwitch >> autoConnectIfFail: aBlock [

	proxy isReady ifTrue: [ ^ self ]. 
	self connectIfFail: aBlock.
	proxy break.
	proxy waitPromptIfError: aBlock
]

{ #category : #proxy }
Microwitch >> autoSelectPortName [

	| list ret |
	list := proxy portNames sorted.
	list isEmpty ifTrue: [ ^ self ].
	ret := list first.
	list size > 1 ifTrue: [ 
		ret := self
			       select: 'Select port' localized
			       chooseFrom: list.
		ret ifNil: [ ^ self ] ].
	proxy portName: ret
]

{ #category : #accessing }
Microwitch >> availableModuleNames [
	^ MicroPythonProject availableModuleNames
]

{ #category : #proxy }
Microwitch >> break [

	self stopAllProcesses.
	proxy isIdle ifTrue: [ ^ self ].
	proxy isNotConnected ifTrue: [ 
		proxy open ifFalse: [ 
			presenter enableConnect.
			^ presenter message: 'cannot open:' localized , proxy comm portName ] ].
	proxy break.
	presenter disableConnect.
	presenter message: 'stopped' localized
]

{ #category : #private }
Microwitch >> confirmCode: aString title: aTitleString [
	^ UIManager default
		multiLineRequest: aTitleString
		initialAnswer: aString
		answerHeight: 450
]

{ #category : #proxy }
Microwitch >> connect [

	self connectIfFail: [ :msg | ^ presenter message: msg ].
	proxy break
]

{ #category : #proxy }
Microwitch >> connectIfFail: aBlock [

	proxy isIdle ifTrue: [ 
		self autoSelectPortName.
		proxy isIdle ifTrue: [ 
			^ aBlock cull: 'cannot select port' localized ] ].
	proxy isNotConnected ifTrue: [ 
		proxy open ifFalse: [ 
			^ aBlock cull: 'cannot open:' localized , proxy comm portName ] ].
	presenter disableConnect
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
	modules := settings defaultModules splitOn: Character space.
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
	self autoConnect ifFalse: [ ^ self ].
	file := self selectRemoteFile.
	file ifNil: [ ^ self ].
	self deleteFileNamed: file
]

{ #category : #proxy }
Microwitch >> deleteFileNamed: aString [

	proxy isReady ifFalse: [ 
		presenter message: 'device is not ready' localized.
		^ self ].
	proxy deleteFileNamed: aString.
	showOutput := false.
	presenter message: 'done' localized
]

{ #category : #proxy }
Microwitch >> disconnect [

	presenter enableConnect.
	proxy disconnect.
	presenter message: 'port closed' localized
]

{ #category : #'menu actions' }
Microwitch >> downloadFile [

	| file code |
	self autoConnect ifFalse: [ ^ self ].
	file := self selectRemoteFile.
	file ifNil: [ ^ self ].
	code := self downloadFileNamed: file.
	(code isNil or: [ code isEmpty ]) ifTrue: [ ^ self ].
	code := MicroPythonParser new parse: code.
	code := self confirmCode: code title: 'OK to save, or cancel' localized.
	code ifNil: [ ^ self ].
	self exportString: code extension: self pyExtension isBinary: false
]

{ #category : #proxy }
Microwitch >> downloadFileNamed: aString [

	| ret |
	proxy isReady ifFalse: [ 
		presenter message: 'device is not ready' localized.
		^ nil ].
	ret := proxy downloadFileNamed: aString ifError: [ :msg | 
		       presenter message: msg.
		       ^ nil ].
	showOutput := false.
	^ ret
]

{ #category : #accessing }
Microwitch >> enabledModuleNames [
	^ project modules
]

{ #category : #proxy }
Microwitch >> evaluate: aString [

	| ret |
	self autoConnectIfFail: [ :msg | 
		presenter message: msg.
		^ 'Error!' ].
	ret := proxy evaluate: aString ifError: [ :msg | 
		       presenter message: msg.
		       ^ 'Error!' ].
	presenter message: 'done' localized.
	^ ret
]

{ #category : #processes }
Microwitch >> evaluateFor: aTopBlock [

	| code |
	self stopAllProcesses.
	code := self newCode parse: aTopBlock withHeader: true.
	code isEmpty ifTrue: [ ^ nil ].
	^ self evaluate: code
]

{ #category : #proxy }
Microwitch >> execute: aString [

	self autoConnectIfFail: [ :msg | ^ presenter message: msg ].

	proxy execute: aString.
	presenter message: 'done' localized
]

{ #category : #'menu actions' }
Microwitch >> exportMicroPython [
	self export: MicroPythonExporter new extension: self pyExtension
]

{ #category : #'menu actions' }
Microwitch >> exportSexpCode [
	self export: (MicroPythonSexpExporter appName: self appName) extension: self class sexpExtension
]

{ #category : #proxy }
Microwitch >> getDirectory [

	| cmd ret |
	self autoConnectIfFail: [ :msg | 
		presenter message: msg.
		^ nil ].
	cmd := 'import os' , String lf , 'os.listdir()'.
	ret := proxy evaluate: cmd ifError: [ :msg | 
		       presenter message: msg.
		       ^ nil ].
	ret ifNil: [ ^ nil ].
	^ MicroPythonParser new parse: ret
]

{ #category : #'menu actions' }
Microwitch >> importSexpCode [
	self import: (MicroPythonSexpImporter appName: self appName) extension: self class sexpExtension
]

{ #category : #initialization }
Microwitch >> initialize [

	super initialize.
	showOutput := true.
	lastInput := ''
]

{ #category : #proxy }
Microwitch >> input [

	| ret |
	self autoConnectIfFail: [ :msg | ^ presenter message: msg ].
	ret := self
		       multiLineRequest: 'Enter expression' localized
		       initialAnswer: lastInput.
	ret ifNil: [ ^ self ].
	lastInput := ret.
	proxy isReady ifFalse: [ ^ self ].
	proxy execute: ret
]

{ #category : #private }
Microwitch >> installNewProject: aProject [

	| proxy2 comm |
	self stopAllProcesses.
	project := aProject.
	project application: self.
	proxy2 := self createProxy.
	comm := self createComm.
	comm baudRate: proxy2 defaultBaudRate.
	proxy2 comm: comm.
	self proxy: proxy2.
	project updateBlockDefs.
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

{ #category : #accessing }
Microwitch >> lastInput [

	^ lastInput
]

{ #category : #accessing }
Microwitch >> lastInput: anObject [

	lastInput := anObject
]

{ #category : #accessing }
Microwitch >> modifiedChanged [

	presenter modifiedText: (project modified
			 ifTrue: [ '[modified]' localized ]
			 ifFalse: [ '' ])
]

{ #category : #testing }
Microwitch >> moduleInUse: aString [
	^ project ifNil: [ false ] ifNotNil: [ project moduleInUse: aString ]
]

{ #category : #micropython }
Microwitch >> modulesNeedToUpload [
	| existings |
	existings := self getDirectory.
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
Microwitch >> projectName: aString [

	presenter projectName: aString.
	super projectName: aString
]

{ #category : #accessing }
Microwitch >> proxy [

	^ proxy
]

{ #category : #accessing }
Microwitch >> proxy: aProxy [

	| comm |
	comm := nil.
	proxy ifNotNil: [ 
		proxy close.
		comm := proxy comm ].
	proxy := aProxy.
	comm ifNotNil: [ proxy comm: comm ].
	presenter updateViewer
]

{ #category : #accessing }
Microwitch >> proxyClass [

	^ proxy class name
]

{ #category : #micropython }
Microwitch >> pyExtension [
	^ 'py'
]

{ #category : #proxy }
Microwitch >> restart [

	presenter enableConnect.
	proxy restart.
	presenter message: 'restarted' localized
]

{ #category : #proxy }
Microwitch >> restartAfterUpload [

	presenter enableConnect.
	proxy thenRestart
]

{ #category : #private }
Microwitch >> restoreProject [
	"do nothing"
]

{ #category : #micropython }
Microwitch >> selectRemoteFile [

	| choices |
	choices := self getDirectory.
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

{ #category : #'menu actions' }
Microwitch >> showMicroPythonCode [

	| str lines |
	str := MicroPythonExporter new exportFrom: self isBinary: false.
	lines := self proxy linesWithoutComments: str.
	lines := self proxy lines: lines withDelimiterEvery: 10.
	str := lines joinUsing: Character cr.
	str isEmpty ifTrue: [ ^ self ].
	self showCode: str title: 'show code' localized
]

{ #category : #accessing }
Microwitch >> showOutput [

	^ showOutput
]

{ #category : #accessing }
Microwitch >> showOutput: anObject [

	showOutput := anObject
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
	self execute: code.
	^ process
]

{ #category : #'menu actions' }
Microwitch >> startProgram [

	project scripts do: [ :each | 
		each eventBlocks size = 1 ifFalse: [ 
			self alert: 'Start script only needs one' localized.
			^ self ] ].
	self autoConnect ifFalse: [ ^ self ].
	self uploadModuleFiles.
	self uploadProgram.
	self restartAfterUpload
]

{ #category : #processes }
Microwitch >> stepProcesses [

	process ifNotNil: #step.
	self stepProxy
]

{ #category : #proxy }
Microwitch >> stepProxy [

	| out |
	proxy step.
	presenter status: proxy state asString.
	proxy isReady ifTrue: [ 
		showOutput := true.
		self stopAllProcesses ].
	out := proxy receiveQueue getAll.
	showOutput ifTrue: [ 
		out do: [ :each | presenter addText: each asString ] ].
	presenter addPlots: out.
	proxy ifTimeoutDo: [ presenter message: 'timeout' localized ]
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

{ #category : #proxy }
Microwitch >> upload: aString fileNamed: aString2 [

	proxy isReady ifFalse: [ 
		presenter message: 'device is not ready' localized.
		^ nil ].
	proxy upload: aString fileNamed: aString2.
	showOutput := false
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
	self autoConnect.
	self upload: pair first fileNamed: filename
]

{ #category : #'menu actions' }
Microwitch >> uploadFirmware [

	| dir file firmware |
	MicrobitFirmware default readFirmwares.
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
		self upload: each contents fileNamed: each basename ]
]

{ #category : #micropython }
Microwitch >> uploadProgram [

	project scripts do: [ :each | 
		| code |
		code := self newCode parseHats: each hatBlocks.
		code isEmpty ifFalse: [ 
			self
				upload: code
				fileNamed: each objName , '.' , self pyExtension ] ]
]

{ #category : #private }
Microwitch >> windowClosing [
	self proxy close
]

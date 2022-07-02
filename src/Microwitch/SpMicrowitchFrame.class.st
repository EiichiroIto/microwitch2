Class {
	#name : #SpMicrowitchFrame,
	#superclass : #SpScratchFrame,
	#instVars : [
		'logo',
		'menu',
		'buttonSave',
		'buttonOpen',
		'buttonConnect',
		'buttonDisconnect',
		'buttonRestart',
		'buttonBreak',
		'buttonSend'
	],
	#category : #'Microwitch-Spec2'
}

{ #category : #specs }
SpMicrowitchFrame class >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: (SpBoxLayout newHorizontal
				   spacing: 4;
				   add: #logo withConstraints: [ :c | c width: 200 ];
				   add: #buttonOpen
				   withConstraints: [ :c | c width: self iconWidth ];
				   add: #buttonSave
				   withConstraints: [ :c | c width: self iconWidth ];
				   add: #menu;
				   yourself)
		  withConstraints: [ :c | c height: self toolbarHeight ];
		  add: (SpBoxLayout newHorizontal
				   add: #viewerPane
				   withConstraints: [ :c | c width: self viewerPaneWidth ];
				   add: (SpPanedLayout newHorizontal
						    positionOfSlider: 0.7;
						    add: (SpBoxLayout newVertical
								     add: (SpBoxLayout newHorizontal
										      add: #buttonSend;
										      add: #buttonConnect;
										      add: #buttonDisconnect;
										      add: #buttonBreak;
										      add: #buttonRestart;
										      yourself)
								     withConstraints: [ :c | c height: self buttonHeight ];
								     add: #editorPane;
								     yourself);
						    add: #stageFrame;
						    yourself);
				   yourself);
		  yourself
]

{ #category : #private }
SpMicrowitchFrame class >> libraryPaneHeight [
	^ self buttonHeight + 10
]

{ #category : #private }
SpMicrowitchFrame class >> viewerPaneWidth [
	^ 250
]

{ #category : #accessing }
SpMicrowitchFrame >> addPlots: aCollection [
	stageFrame addPlots: aCollection
]

{ #category : #api }
SpMicrowitchFrame >> autoConnect [

	^ stageFrame autoConnect
]

{ #category : #'menu building' }
SpMicrowitchFrame >> blockMenuFor: aBlockMorph inScriptEditor: aBoolean [
	| m |
	m := self newMenu.
	m
		addGroup: [ :grp | 
			grp
				addItem: [ :item | 
					item
						name: 'show code' localized;
						action: [ application showCodeOf: aBlockMorph topBlock ] ];
				addItem: [ :item | 
					item
						name: 'start' localized;
						action: [ aBlockMorph topBlock toggleProcess ] ] ].
	aBoolean
		ifTrue: [ self addBlockMenu: m for: aBlockMorph ].
	^ m
]

{ #category : #initialization }
SpMicrowitchFrame >> connectPresenters [
	buttonOpen action: [ application openProject ].
	buttonSave action: [ application saveProject ].
	buttonConnect action: [ stageFrame connect ].
	buttonDisconnect action: [ stageFrame disconnect ].
	buttonRestart action: [ stageFrame restart ].
	buttonBreak action: [ stageFrame break ].
	buttonSend action: [ application startProgram ]
]

{ #category : #private }
SpMicrowitchFrame >> createEditor [

	^ ScrollFrameMorph2 new
		  growthFraction: 0.1;
		  color: ScratchTheme scriptsPaneColor;
		  yourself
]

{ #category : #private }
SpMicrowitchFrame >> defaultExtent [
	^ 1024 @ 768
]

{ #category : #api }
SpMicrowitchFrame >> deleteFileNamed: aString [

	stageFrame deleteFileNamed: aString
]

{ #category : #private }
SpMicrowitchFrame >> disableConnect [
	buttonConnect disable.
	buttonDisconnect enable
]

{ #category : #api }
SpMicrowitchFrame >> downloadFileNamed: aString [

	^ stageFrame downloadFileNamed: aString
]

{ #category : #private }
SpMicrowitchFrame >> enableConnect [
	buttonConnect enable.
	buttonDisconnect disable
]

{ #category : #api }
SpMicrowitchFrame >> evaluate: aString [
	^ stageFrame evaluate: aString
]

{ #category : #api }
SpMicrowitchFrame >> execute: aString [
	stageFrame execute: aString
]

{ #category : #'menu building' }
SpMicrowitchFrame >> exportMenu [
	^ self newMenu
		addItem: [ :item | 
			item
				name: 'Export S-expression' localized;
				action: [ application exportSexpCode ] ];
		addItem: [ :item | 
			item
				name: 'Export MicroPython' localized;
				action: [ application exportMicroPython ] ];
		yourself
]

{ #category : #'menu building' }
SpMicrowitchFrame >> fileMenu [

	| m |
	m := self newMenu.
	m addGroup: [ :grp | 
		grp
			addItem: [ :item | 
				item
					name: 'New' localized;
					action: [ 
						application newProject.
						self plotter clearPlots ] ];
			addItem: [ :item | 
				item
					name: 'Open' localized;
					action: [ 
						application openProject.
						self plotter clearPlots ] ] ].
	application examplesDirectory isDirectory ifTrue: [ 
		m addGroup: [ :grp | 
			grp addItem: [ :item | 
				item
					name: 'Examples' localized;
					subMenu: self examplesMenu ] ] ].
	m
		addGroup: [ :grp | 
			grp
				addItem: [ :item | 
					item
						name: 'Project Notes' localized;
						action: [ application editNotes ] ];
				addItem: [ :item | 
					item
						name: 'Save' localized;
						action: [ application saveProjectNoDialog ] ];
				addItem: [ :item | 
					item
						name: 'Save As' localized;
						action: [ application saveProject ] ] ];
		addGroup: [ :grp | 
			grp
				addItem: [ :item | 
					item
						name: 'Import' localized;
						subMenu: self importMenu ];
				addItem: [ :item | 
					item
						name: 'Export' localized;
						subMenu: self exportMenu ] ];
		addGroup: [ :grp | 
			grp
				addItem: [ :item | 
					item
						name: 'Close' localized;
						action: [ application closeAllWindows ];
						enabled: [ application class dontClose not ] ];
				addItem: [ :item | 
					item
						name: 'Quit' localized;
						action: [ application quit ] ] ].
	^ m
]

{ #category : #api }
SpMicrowitchFrame >> getDirectory [
	^ stageFrame getDirectory
]

{ #category : #'menu building' }
SpMicrowitchFrame >> importMenu [
	^ self newMenu
		addItem: [ :item | 
			item
				name: 'Import S-expression' localized;
				action: [ application importSexpCode ] ];
		yourself
]

{ #category : #initialization }
SpMicrowitchFrame >> initializePresenters [

	logo := self newImage
		        image: (ScratchTheme formAt: #logo);
		        yourself.
	buttonOpen := self newButton
		              icon: (ScratchTheme formAt: #openButton);
		              help: 'Open project';
		              yourself.
	buttonSave := self newButton
		              icon: (ScratchTheme formAt: #saveButton);
		              help: 'Save this project';
		              yourself.
	buttonConnect := self newButton
		                 help: 'Connect to micro:bit';
		                 label: 'Connect' localized;
		                 icon: (ScratchTheme formAt: #connect);
		                 yourself.
	buttonDisconnect := self newButton
		                    help: 'Disconnect from micro:bit';
		                    label: 'Disconnect' localized;
		                    icon: (ScratchTheme formAt: #disconnect);
		                    disable;
		                    yourself.
	buttonRestart := self newButton
		                 help: 'Restart micro:bit';
		                 label: 'Restart' localized;
		                 icon: (self iconNamed: #refresh).
	buttonBreak := self newButton
		               help: 'Stop';
		               label: 'Stop' localized;
		               icon: (ScratchTheme formAt: #stopButton).
	buttonSend := self newButton
		              help: 'Start program';
		              label: 'Start' localized;
		              icon: (ScratchTheme formAt: #goButton).
	menu := self newMenuBar.
	self setupMenu.
	viewerPane := self instantiate: SpScratchListViewer.
	editorPane := self newMorph
		              morph: self createEditor;
		              yourself.
	titlePane := self instantiate: SpScratchTitle.
	stageFrame := self instantiate: SpMicrowitchStage.
	self focusOrder
		add: buttonSend;
		add: buttonConnect;
		add: buttonDisconnect;
		add: buttonBreak;
		add: buttonRestart;
		add: editorPane
]

{ #category : #accessing }
SpMicrowitchFrame >> plotter [
	^ stageFrame plotter
]

{ #category : #accessing }
SpMicrowitchFrame >> proxy [
	^ stageFrame proxy
]

{ #category : #accessing }
SpMicrowitchFrame >> proxy: aProxy [
	stageFrame proxy: aProxy.
	"editorPane proxy: aProxy."
	self updateViewer
]

{ #category : #api }
SpMicrowitchFrame >> restartAfterUpload [

	stageFrame restartAfterUpload
]

{ #category : #'menu actions' }
SpMicrowitchFrame >> selectModules [

	| choices selectedItems result toBeRemoved toBeAdded |
	choices := application availableModuleNames.
	selectedItems := application enabledModuleNames asSet.
	result := SpScratchApp
		          multiSelect: 'Select Modules' localized
		          chooseFrom: choices
		          selectedItems: selectedItems.
	result ifNil: [ ^ self ].
	toBeRemoved := selectedItems \ result.
	toBeAdded := result \ selectedItems.
	toBeRemoved do: [ :each | application toggleModule: each ].
	toBeAdded do: [ :each | application toggleModule: each ]
]

{ #category : #'menu building' }
SpMicrowitchFrame >> setupMenu [
	menu
		addItem: [ :item | 
			item
				name: 'File' localized;
				subMenu: self fileMenu ];
		addItem: [ :item | 
			item
				name: 'Tools' localized;
				subMenu: self toolsMenu ];
		addItem: [ :item | 
			item
				name: 'Help' localized;
				subMenu: self helpMenu ]
]

{ #category : #private }
SpMicrowitchFrame >> stageShotExtent: size [
	^ nil
]

{ #category : #accessing }
SpMicrowitchFrame >> status: aString [
	editorPane status: aString
]

{ #category : #api }
SpMicrowitchFrame >> step [
	stageFrame step
]

{ #category : #accessing }
SpMicrowitchFrame >> target: aScript [

	viewerPane target: aScript.
	editorPane morph contents: aScript blocksBin.
	editorPane morph contents color: ScratchTheme scriptsPaneColor
]

{ #category : #'menu building' }
SpMicrowitchFrame >> toolsMenu [

	^ self newMenu
		  addGroup: [ :grp | 
			  grp
				  addItem: [ :item | 
					  item
						  name: 'Select Modules' localized;
						  action: [ self selectModules ] ];
				  addItem: [ :item | 
					  item
						  name: 'Upload Modules' localized;
						  action: [ application uploadModuleFiles ] ] ];
		  addGroup: [ :grp | 
			  grp
				  addItem: [ :item | 
					  item
						  name: 'Upload file' localized;
						  icon: (self iconNamed: #up);
						  action: [ application uploadFile ] ];
				  addItem: [ :item | 
					  item
						  name: 'Download file' localized;
						  icon: (self iconNamed: #down);
						  action: [ application downloadFile ] ];
				  addItem: [ :item | 
					  item
						  name: 'Delete file' localized;
						  icon: (self iconNamed: #delete);
						  action: [ application deleteFile ] ] ];
		  addGroup: [ :grp | 
			  grp addItem: [ :item | 
				  item
					  name: 'Initialize micro:bit' localized;
					  icon: (self iconNamed: #glamorousOver);
					  action: [ application uploadFirmware ] ] ];
		  yourself
]

{ #category : #accessing }
SpMicrowitchFrame >> updateDisplay [
	"do nothing"
]

{ #category : #accessing }
SpMicrowitchFrame >> updateViewer [
	viewerPane target: viewerPane target
]

{ #category : #api }
SpMicrowitchFrame >> upload: aString fileNamed: aString2 [

	stageFrame upload: aString fileNamed: aString2
]

{ #category : #enumerating }
SpMicrowitchFrame >> whenStepsDo: aBlock [
	stageFrame whenStepsDo: aBlock
]

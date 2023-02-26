Class {
	#name : #SpMicrowitchPresenter,
	#superclass : #SpScratchPresenter,
	#instVars : [
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
SpMicrowitchPresenter class >> defaultLayout [

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
										      add: #modifiedProjectLabel
										      withConstraints: [ :c | c expand: false ];
										      add: #projectNameLabel;
										      yourself)
								     withConstraints: [ :c | c expand: false ];
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
SpMicrowitchPresenter class >> libraryPaneHeight [
	^ self buttonHeight + 10
]

{ #category : #private }
SpMicrowitchPresenter class >> viewerPaneWidth [
	^ 250
]

{ #category : #accessing }
SpMicrowitchPresenter >> addPlots: aCollection [

	stageFrame addPlots: aCollection
]

{ #category : #api }
SpMicrowitchPresenter >> addText: aString [

	stageFrame addText: aString
]

{ #category : #'menu building' }
SpMicrowitchPresenter >> blockMenuFor: aBlockMorph inScriptEditor: aBoolean [
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
SpMicrowitchPresenter >> connectPresenters [
	buttonOpen action: [ application openProject ].
	buttonSave action: [ application saveProject ].
	buttonConnect action: [ application connect ].
	buttonDisconnect action: [ application disconnect ].
	buttonRestart action: [ application restart ].
	buttonBreak action: [ application break ].
	buttonSend action: [ application startProgram ].
	stageFrame whenInputClicked: [ application input ]
]

{ #category : #private }
SpMicrowitchPresenter >> defaultExtent [
	^ 1024 @ 768
]

{ #category : #private }
SpMicrowitchPresenter >> disableConnect [
	buttonConnect disable.
	buttonDisconnect enable
]

{ #category : #private }
SpMicrowitchPresenter >> enableConnect [
	buttonConnect enable.
	buttonDisconnect disable
]

{ #category : #'menu building' }
SpMicrowitchPresenter >> exportMenu [
	^ self newMenu
		addItem: [ :item | 
			item
				name: 'Export S-expression' localized;
				action: [ application exportSexpCode ] ];
		addItem: [ :item | 
			item
				name: 'Export MicroPython' localized;
				action: [ application exportMicroPython ] ];
		addItem: [ :item | 
			item
				name: 'Export Script image' localized;
				action: [ application exportScriptImage ] ];
		yourself
]

{ #category : #'menu building' }
SpMicrowitchPresenter >> fileMenu [

	| m |
	m := self newMenu.
	m addGroup: [ :grp | 
		grp
			addItem: [ :item | 
				item
					name: 'New' localized;
				  icon: (self iconNamed: #smallNew);
					action: [ 
						application newProject.
						self plotter clearPlots ] ];
			addItem: [ :item | 
				item
					name: 'Open' localized;
				  icon: (self iconNamed: #smallOpen);
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
					  icon: (self iconNamed: #smallWindow);
						action: [ application editNotes ] ];
				addItem: [ :item | 
					item
						name: 'Save' localized;
					  icon: (self iconNamed: #smallSave);
						action: [ application saveProjectNoDialog ] ];
				addItem: [ :item | 
					item
						name: 'Save As' localized;
					  icon: (self iconNamed: #smallSaveAs);
						action: [ application saveProject ] ] ];
		addGroup: [ :grp | 
			grp
				addItem: [ :item | 
					item
						name: 'Import' localized;
					  icon: (self iconNamed: #smallLoadProject);
						subMenu: self importMenu ];
				addItem: [ :item | 
					item
						name: 'Export' localized;
					  icon: (self iconNamed: #smallExport);
						subMenu: self exportMenu ] ];
		addGroup: [ :grp | 
			grp
				addItem: [ :item | 
					item
						name: 'Close' localized;
						action: [ application closeAllWindows ];
						enabled: [ self settings dontClose not ] ];
				addItem: [ :item | 
					item
						name: 'Quit' localized;
					  icon: (self iconNamed: #smallQuit);
						action: [ application class quit ] ] ].
	^ m
]

{ #category : #'menu building' }
SpMicrowitchPresenter >> importMenu [
	^ self newMenu
		addItem: [ :item | 
			item
				name: 'Import S-expression' localized;
				action: [ application importSexpCode ] ];
		yourself
]

{ #category : #initialization }
SpMicrowitchPresenter >> initializePresenters [

	super initializePresenters.
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
	self focusOrder
		add: buttonSend;
		add: buttonConnect;
		add: buttonDisconnect;
		add: buttonBreak;
		add: buttonRestart;
		add: editorPane
]

{ #category : #api }
SpMicrowitchPresenter >> message: aString [

	stageFrame message: aString
]

{ #category : #initialization }
SpMicrowitchPresenter >> newStage [

	^ self instantiate: SpMicrowitchStage
]

{ #category : #accessing }
SpMicrowitchPresenter >> plotter [
	^ stageFrame plotter
]

{ #category : #accessing }
SpMicrowitchPresenter >> scriptForm [

	^ editorPane morph contents screenshot
]

{ #category : #'menu actions' }
SpMicrowitchPresenter >> selectModules [

	| choices selectedItems result toBeRemoved toBeAdded |
	choices := Microwitch availableModuleNames sorted.
	selectedItems := application enabledModuleNames asSet.
	result := self
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
SpMicrowitchPresenter >> setupMenu [
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
SpMicrowitchPresenter >> stageShotExtent: size [
	^ nil
]

{ #category : #api }
SpMicrowitchPresenter >> status: aString [

	stageFrame status: aString
]

{ #category : #accessing }
SpMicrowitchPresenter >> target: aScript [

	viewerPane target: aScript.
	editorPane morph contents: aScript blocksBin.
	editorPane morph contents color: ScratchTheme scriptsPaneColor
]

{ #category : #'menu building' }
SpMicrowitchPresenter >> toolsMenu [

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
					  name: 'Show MicroPython code' localized;
					  icon: (self iconNamed: #smallWindow);
					  action: [ application showMicroPythonCode ] ] ];
		  addGroup: [ :grp | 
			  grp addItem: [ :item | 
				  item
					  name: 'Initialize micro:bit' localized;
					  icon: (self iconNamed: #glamorousOver);
					  action: [ application uploadFirmware ] ] ];
		  yourself
]

{ #category : #accessing }
SpMicrowitchPresenter >> updateDisplay [
	"do nothing"
]

{ #category : #accessing }
SpMicrowitchPresenter >> updateViewer [
	viewerPane target: viewerPane target
]

{ #category : #accessing }
SpMicrowitchPresenter >> whenStepsDo: aBlock [
	stageFrame whenStepsDo: aBlock
]

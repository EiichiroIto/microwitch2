Class {
	#name : #MicroPythonProject,
	#superclass : #ScratchProject,
	#instVars : [
		'modules'
	],
	#category : #'Microwitch-Project'
}

{ #category : #constants }
MicroPythonProject class >> fileVersion [
	^ 1
]

{ #category : #constants }
MicroPythonProject class >> fileVersionTag [
	^ 'MicrowitchV'
]

{ #category : #constants }
MicroPythonProject class >> objStreamClass [
	^ STONObjStream
]

{ #category : #'ston-core' }
MicroPythonProject class >> stonAllInstVarNames [
	^ super stonAllInstVarNames , #(modules)
]

{ #category : #'block specs' }
MicroPythonProject >> addBlockSpecsTo: aBlockMorphBuilder [

	Microwitch mainModuleNames , modules do: [ :name | 
		(Microwitch blockSpecsFor: name) blockSpecs do: [ :each | 
			aBlockMorphBuilder addBlockSpec: each ] ]
]

{ #category : #accessing }
MicroPythonProject >> addModule: aSymbol [
	modules := modules copyWith: aSymbol.
	self setupBlockSpecs
]

{ #category : #private }
MicroPythonProject >> addScriptNamed: aString [
	| script |
	script := MicroPythonScript new
		project: self;
		objName: aString;
		yourself.
	self addScript: script.
	^ script
]

{ #category : #accessing }
MicroPythonProject >> assureExistsBreed: each [
	((self scripts collect: #objName) includes: each)
		ifTrue: [ ^ self ].
	self addScriptNamed: each
]

{ #category : #accessing }
MicroPythonProject >> assureImportModules: aCollection [

	| list |
	list := aCollection \ Microwitch availableModuleNames.
	list isEmpty ifFalse: [ 
		self error: 'not available modules: ' localized , list asString ].
	modules := aCollection copy asArray.
	self setupBlockSpecs
]

{ #category : #accessing }
MicroPythonProject >> deleteModule: aSymbol [
	modules := modules copyWithout: aSymbol.
	self setupBlockSpecs
]

{ #category : #evaluation }
MicroPythonProject >> evaluateBlock: aTopBlock [
	^ application evaluateBlock: aTopBlock
]

{ #category : #'object i/o' }
MicroPythonProject >> fieldsVersion [
	^ 1
]

{ #category : #'file read/write' }
MicroPythonProject >> getScratchInfoFrom: aFileReference [
	| dict icon |
	dict := super getScratchInfoFrom: aFileReference.
	dict ifNil: [ ^ nil ].
	icon := (Smalltalk at: (dict at: 'proxy')) new icon.
	dict at: 'thumbnail' put: icon.
	^ dict
]

{ #category : #'object i/o' }
MicroPythonProject >> initFieldsFrom: anObjStream version: classVersion [
	self
		initFieldsNamed: #(modules)
		from: anObjStream.
	super initFieldsFrom: anObjStream version: classVersion
]

{ #category : #initialization }
MicroPythonProject >> initialize [

	super initialize.
	modules := Array new
]

{ #category : #accessing }
MicroPythonProject >> moduleFileFor: aString [
	| file |
	file := Microwitch moduleDirectory / (aString , '.' , application pyExtension).
	file isFile
		ifFalse: [ ^ nil ].
	^ file
]

{ #category : #accessing }
MicroPythonProject >> moduleFiles [
	| list |
	list := modules collect: [ :each | self moduleFileFor: each ].
	^ list reject: #isNil
]

{ #category : #testing }
MicroPythonProject >> moduleInUse: aString [
	^ modules includes: aString
]

{ #category : #accessing }
MicroPythonProject >> modules [
	^ modules
]

{ #category : #accessing }
MicroPythonProject >> modules: anObject [

	modules := anObject
]

{ #category : #accessing }
MicroPythonProject >> startHatBlock [
	self scripts
		do: [ :each | 
			| l |
			l := each startHatBlocks.
			l ifNotEmpty: [ ^ l first ] ].
	^ nil
]

{ #category : #processes }
MicroPythonProject >> stopAllProcesses [
	scripts do: #stopAllProcesses
]

{ #category : #'object i/o' }
MicroPythonProject >> storeFieldsOn: anObjStream [
	self storeFieldsNamed: #(modules) on: anObjStream.
	super storeFieldsOn: anObjStream
]

{ #category : #accessing }
MicroPythonProject >> thumbnailForm: aForm [

	"do nothing"
]

{ #category : #accessing }
MicroPythonProject >> toggleModule: aString [
	(self moduleInUse: aString)
		ifTrue: [ self deleteModule: aString ]
		ifFalse: [ self addModule: aString ]
]

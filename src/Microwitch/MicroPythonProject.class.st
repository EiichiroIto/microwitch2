Class {
	#name : #MicroPythonProject,
	#superclass : #ScratchProject,
	#instVars : [
		'blockSpecs',
		'modules'
	],
	#classVars : [
		'AvailableModules',
		'IntModules'
	],
	#category : #'Microwitch-Project'
}

{ #category : #accessing }
MicroPythonProject class >> availableModuleNames [
	^ self availableModules keys
]

{ #category : #accessing }
MicroPythonProject class >> availableModules [
	^ AvailableModules ifNil: [ #() ]
]

{ #category : #accessing }
MicroPythonProject class >> availableModules: aDictionary [
	AvailableModules := aDictionary
]

{ #category : #constants }
MicroPythonProject class >> extModExtension [
	^ 'mwm'
]

{ #category : #constants }
MicroPythonProject class >> fileVersion [
	^ 1
]

{ #category : #constants }
MicroPythonProject class >> fileVersionTag [
	^ 'MicrowitchV'
]

{ #category : #initialization }
MicroPythonProject class >> initialize [

	"self initialize"

	self loadIntModules.
	self loadAvailableModules
]

{ #category : #constants }
MicroPythonProject class >> intModExtension [
	^ 'mwi'
]

{ #category : #accessing }
MicroPythonProject class >> intModuleAt: aString [
	^ self intModules at: aString ifAbsent: [ nil ]
]

{ #category : #accessing }
MicroPythonProject class >> intModules [
	^ IntModules ifNil: [ Dictionary new ]
]

{ #category : #accessing }
MicroPythonProject class >> intModules: aDictionary [
	IntModules := aDictionary
]

{ #category : #testing }
MicroPythonProject class >> isAvailableModule: aString [
	^ self availableModuleNames includes: aString
]

{ #category : #private }
MicroPythonProject class >> loadAvailableModules [
	| dict |
	dict := Dictionary new.
	self loadModuleExtension: self extModExtension into: dict.
	self availableModules: dict
]

{ #category : #private }
MicroPythonProject class >> loadIntModules [
	"self loadIntModules"
	| dict |
	dict := Dictionary new.
	self loadModuleExtension: self intModExtension into: dict.
	self intModules: dict
]

{ #category : #private }
MicroPythonProject class >> loadModuleExtension: ext into: aDictionary [
	(self moduleDirectory filesMatching: '*.' , ext)
		do: [ :each | 
			each
				readStreamDo: [ :stream | 
					aDictionary
						at: each base
						put: (ModuleImporter new import: stream contents) setup ] ]
]

{ #category : #private }
MicroPythonProject class >> moduleDirectory [
	| dir |
	dir := FileSystem workingDirectory / 'Modules'.
	dir isDirectory
		ifFalse: [ dir createDirectory ].
	^ dir
]

{ #category : #constants }
MicroPythonProject class >> objStreamClass [
	^ STONObjStream
]

{ #category : #'ston-core' }
MicroPythonProject class >> stonAllInstVarNames [
	^ super stonAllInstVarNames , #(modules)
]

{ #category : #accessing }
MicroPythonProject >> addModule: aSymbol [
	modules := modules copyWith: aSymbol.
	self updateBlockDefs
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
MicroPythonProject >> application: anApplication [
	super application: anApplication.
	scripts isEmpty ifTrue: [ self addScriptNamed: 'main' ]
]

{ #category : #accessing }
MicroPythonProject >> assureExistsBreed: each [
	((self scripts collect: #objName) includes: each)
		ifTrue: [ ^ self ].
	self addScriptNamed: each
]

{ #category : #accessing }
MicroPythonProject >> assureImportModule: aString [
	(self class isAvailableModule: aString)
		ifFalse: [ self error: 'not available module: ' localized, aString ].
	(self moduleInUse: aString)
		ifTrue: [ ^ self ].
	self addModule: aString
]

{ #category : #'block specs' }
MicroPythonProject >> blockSpecs [
	^ blockSpecs
]

{ #category : #accessing }
MicroPythonProject >> blockSpecs: anObject [

	blockSpecs := anObject
]

{ #category : #'block specs' }
MicroPythonProject >> blocks [
	^ self blockSpecs blocks, self extBlockTuples
]

{ #category : #accessing }
MicroPythonProject >> deleteModule: aSymbol [
	modules := modules copyWithout: aSymbol.
	self updateBlockDefs
]

{ #category : #private }
MicroPythonProject >> evaluateFor: aTopBlock [
	^ application evaluateFor: aTopBlock
]

{ #category : #'block specs' }
MicroPythonProject >> extBlockTuples [

	| st |
	st := WriteStream on: Array new.
	st nextPut: 'modules'.
	modules
		do: [ :each | 
			st nextPutAll: (self class availableModules at: each ifAbsent: [ 
					 self error:
						 'The following modules are not installed:' localized , each ])
					blockTuples ]
		separatedBy: [ st nextPut: '-' ].
	^ st contents
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
	modules := Array new.
	blockSpecs := MicrobitBlockSpecs new
]

{ #category : #'block specs' }
MicroPythonProject >> intBlockDefOf: aSymbol [
	^ blockSpecs intBlockDefOf: aSymbol
]

{ #category : #'block specs' }
MicroPythonProject >> isInternalBlock: aSymbol [
	^ blockSpecs isInternalBlock: aSymbol
]

{ #category : #accessing }
MicroPythonProject >> moduleFileFor: aString [
	| file |
	file := self class moduleDirectory / (aString , '.' , application pyExtension).
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
MicroPythonProject >> startHatBlock [
	self scripts
		do: [ :each | 
			| l |
			l := each eventBlocks.
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

{ #category : #'file read/write' }
MicroPythonProject >> storeProjectInfoOn: aBinaryStream [
	info removeKey: 'thumbnail'.
	info at: 'proxy' put: application proxyClass.
	super storeProjectInfoOn: aBinaryStream
]

{ #category : #accessing }
MicroPythonProject >> toggleModule: aString [
	(self moduleInUse: aString)
		ifTrue: [ self deleteModule: aString ]
		ifFalse: [ self addModule: aString ]
]

{ #category : #accessing }
MicroPythonProject >> updateBlockDefs [
	scripts do: #setupBlockDef
]

Class {
	#name : #MicroPythonScript,
	#superclass : #ScratchScript,
	#instVars : [
		'objName',
		'varNames'
	],
	#category : #'Microwitch-Project'
}

{ #category : #'ston-core' }
MicroPythonScript class >> stonAllInstVarNames [
	^ super stonAllInstVarNames , #(objName varNames)
]

{ #category : #'argument menus' }
MicroPythonScript >> addArgBuilder [
	super addArgBuilder.
	project blockSpecs addArgBuilderTo: argBuilder
]

{ #category : #variables }
MicroPythonScript >> addVariable: aString [
	varNames add: aString
]

{ #category : #'argument menus' }
MicroPythonScript >> allSubNames [
	^ project allSubNames
]

{ #category : #accessing }
MicroPythonScript >> application [
	^ self project application
]

{ #category : #'block specs' }
MicroPythonScript >> blocks [
	^ project blocks
]

{ #category : #accessing }
MicroPythonScript >> breedNo [
	^ objName
]

{ #category : #blocks }
MicroPythonScript >> compareHatBlock: a and: b [
	| aIsSubHat bIsSubHat |
	aIsSubHat := a isKindOf: SubHatMorph.
	bIsSubHat := b isKindOf: SubHatMorph.
	(aIsSubHat and: [ bIsSubHat ])
		ifTrue: [ ^ a subName < b subName ].
	aIsSubHat
		ifTrue: [ ^ true ].
	bIsSubHat
		ifTrue: [ ^ false ].
	^ a eventName < b eventName
]

{ #category : #variables }
MicroPythonScript >> deleteVariable: aString [
	varNames remove: aString ifAbsent: [  ]
]

{ #category : #private }
MicroPythonScript >> evaluateFor: aTopBlock [
	^ project evaluateFor: aTopBlock
]

{ #category : #'block specs' }
MicroPythonScript >> extBlockDefOf: aSymbol [
	project class availableModules
		do: [ :each | (each blockDefAt: aSymbol) ifNotNil: [ :def | ^ def ] ].
	^ nil
]

{ #category : #'object i/o' }
MicroPythonScript >> fieldsVersion [
	^ 1
]

{ #category : #blocks }
MicroPythonScript >> hatBlocks [
	| list |
	list := super hatBlocks.
	list := list sort: [ :a :b | self compareHatBlock: a and: b ].
	^ list
]

{ #category : #private }
MicroPythonScript >> identifierInUse: aString [

	^ (varNames includes: aString) or: [ super subNameInUse: aString ]
]

{ #category : #'object i/o' }
MicroPythonScript >> initFieldsFrom: anObjStream version: classVersion [
	super initFieldsFrom: anObjStream version: classVersion.
	self
		initFieldsNamed: #(objName varNames)
		from: anObjStream
]

{ #category : #initialization }
MicroPythonScript >> initialize [
	super initialize.
	varNames := OrderedCollection new
]

{ #category : #'block specs' }
MicroPythonScript >> intBlockDefOf: aSymbol [
	^ project intBlockDefOf: aSymbol
]

{ #category : #'block specs' }
MicroPythonScript >> isExternalBlock: aSymbol [
	project class availableModules
		do: [ :each | (each blockDefAt: aSymbol) ifNotNil: [ ^ true ] ].
	^ false
]

{ #category : #testing }
MicroPythonScript >> isInternalBlock: aString [ 
	^ self project isInternalBlock: aString
]

{ #category : #testing }
MicroPythonScript >> isValidSubName: aString [
	aString isEmpty
		ifTrue: [ ^ false ].
	aString first isDigit
		ifTrue: [ ^ false ].
	^ aString allSatisfy: [ :each | each isAlphaNumeric ]
]

{ #category : #'argument menus' }
MicroPythonScript >> listVarNames [
	^ #()
]

{ #category : #'control ops' }
MicroPythonScript >> mwait: duration elapsed: elapsed from: ignored [
	^ nil
]

{ #category : #accessing }
MicroPythonScript >> objName [
	^ objName
]

{ #category : #accessing }
MicroPythonScript >> objName: aString [
	objName := aString
]

{ #category : #'block specs' }
MicroPythonScript >> setupBlockCategory [

	super setupBlockCategory.
	project blockSpecs addBlockCategoryTo: blockDef
]

{ #category : #processes }
MicroPythonScript >> stopAllProcesses [
	blocksBin isArray
		ifTrue: [ ^ self ].
	blocksBin
		submorphsDo: [ :each | 
			each isBlockMorph
				ifTrue: [ each clearProcess.
					each litUp: false ] ]
]

{ #category : #'block specs' }
MicroPythonScript >> stopBlocks [

	^ super stopBlocks , #(panic: reset)
]

{ #category : #'object i/o' }
MicroPythonScript >> storeFieldsOn: anObjStream [
	super storeFieldsOn: anObjStream.
	self storeFieldsNamed: #(objName varNames) on: anObjStream.
]

{ #category : #testing }
MicroPythonScript >> subNameInUse: aString [

	^ self identifierInUse: aString
]

{ #category : #testing }
MicroPythonScript >> useList [
	^ false
]

{ #category : #testing }
MicroPythonScript >> useVariableWatcher [
	^ false
]

{ #category : #'argument menus' }
MicroPythonScript >> varNames [
	^ varNames
]

{ #category : #variables }
MicroPythonScript >> variableNameInUse: aString [

	^ self identifierInUse: aString
]

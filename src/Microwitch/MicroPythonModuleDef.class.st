Class {
	#name : #MicroPythonModuleDef,
	#superclass : #Object,
	#instVars : [
		'blockDefs',
		'blockDict'
	],
	#category : #'Microwitch-Modules'
}

{ #category : #accessing }
MicroPythonModuleDef >> blockDefAt: aSymbol [
	^ self blockDict at: aSymbol ifAbsent: [ nil ]
]

{ #category : #accessing }
MicroPythonModuleDef >> blockDefs [
	^ blockDefs
]

{ #category : #accessing }
MicroPythonModuleDef >> blockDefs: aCollection [
	blockDefs := aCollection
]

{ #category : #accessing }
MicroPythonModuleDef >> blockDict [
	^ blockDict
]

{ #category : #accessing }
MicroPythonModuleDef >> blockDict: anObject [
	blockDict := anObject
]

{ #category : #api }
MicroPythonModuleDef >> blockTuples [
	blockDict
		ifNil: [ self error: 'need to setup' ].
	^ blockDefs collect: #blockTuple
]

{ #category : #api }
MicroPythonModuleDef >> blocks [
	^ (blockDefs collect: #block) joinUsing: String lf
]

{ #category : #testing }
MicroPythonModuleDef >> includes: aSymbol [
	^ self blockDict includesKey: aSymbol
]

{ #category : #printing }
MicroPythonModuleDef >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		nextPut: $(;
		nextPutAll: (blockDefs ifNil: [ 0 ] ifNotNil: [ blockDefs size ]) asString;
		nextPut: $)
]

{ #category : #api }
MicroPythonModuleDef >> setup [
	self
		setupBlockDefs;
		setupBlockDict
]

{ #category : #private }
MicroPythonModuleDef >> setupBlockDefs [
	"do nothing"
]

{ #category : #private }
MicroPythonModuleDef >> setupBlockDict [
	blockDict := OrderedDictionary new.
	blockDefs
		do: [ :each | 
			each isBlockDef
				ifTrue: [ blockDict at: each selector put: each ] ]
]

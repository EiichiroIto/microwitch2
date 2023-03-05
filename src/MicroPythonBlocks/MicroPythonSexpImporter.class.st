Class {
	#name : #MicroPythonSexpImporter,
	#superclass : #ScratchSexpImporter,
	#category : #'MicroPythonBlocks-Converter'
}

{ #category : #private }
MicroPythonSexpImporter >> importWorld: aCollection [
	aCollection first = appName
		ifFalse: [ self error ].
	aCollection second do: [ :each | project assureExistsScriptNamed: each ].
	project assureImportModules: aCollection third.
	self importScripts: aCollection fourth
]

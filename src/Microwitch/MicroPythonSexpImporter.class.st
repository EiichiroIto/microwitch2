Class {
	#name : #MicroPythonSexpImporter,
	#superclass : #ScratchSexpImporter,
	#category : #'Microwitch-Converter'
}

{ #category : #private }
MicroPythonSexpImporter >> importWorld: aCollection [
	aCollection first = appName
		ifFalse: [ self error ].
	aCollection second do: [ :each | project assureExistsBreed: each ].
	aCollection third do: [ :each | project assureImportModule: each ].
	self importScripts: aCollection fourth
]

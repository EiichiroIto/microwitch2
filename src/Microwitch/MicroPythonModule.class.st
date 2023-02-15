Class {
	#name : #MicroPythonModule,
	#superclass : #Object,
	#instVars : [
		'name',
		'blockSpecs'
	],
	#category : #'Microwitch-Project'
}

{ #category : #accessing }
MicroPythonModule >> blockSpecs [

	^ blockSpecs
]

{ #category : #accessing }
MicroPythonModule >> blockSpecs: anObject [

	blockSpecs := anObject
]

{ #category : #accessing }
MicroPythonModule >> name [

	^ name
]

{ #category : #accessing }
MicroPythonModule >> name: anObject [

	name := anObject
]

{ #category : #printing }
MicroPythonModule >> printOn: aStream [

	aStream
		nextPutAll: self class name;
		nextPut: $(;
		nextPutAll: name asString.
	blockSpecs ifNotNil: [ 
		aStream
			nextPutAll: ', ';
			nextPutAll: blockSpecs size asString;
			nextPutAll: ' blockSpecs' ].
	aStream nextPut: $)
]

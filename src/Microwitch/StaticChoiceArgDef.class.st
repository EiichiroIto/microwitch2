Class {
	#name : #StaticChoiceArgDef,
	#superclass : #MicroPythonBlockDef,
	#instVars : [
		'arg',
		'options'
	],
	#category : #'Microwitch-Modules'
}

{ #category : #api }
StaticChoiceArgDef >> addTo: argBuilder [

	argBuilder addChoiceArg: arg options: options initialChoice: ''
]

{ #category : #accessing }
StaticChoiceArgDef >> arg [

	^ arg
]

{ #category : #accessing }
StaticChoiceArgDef >> arg: anObject [

	arg := anObject
]

{ #category : #accessing }
StaticChoiceArgDef >> block [

	^ ''
]

{ #category : #testing }
StaticChoiceArgDef >> isChoiceArg [

	^ true
]

{ #category : #accessing }
StaticChoiceArgDef >> options [

	^ options
]

{ #category : #accessing }
StaticChoiceArgDef >> options: anObject [

	options := anObject
]

{ #category : #printing }
StaticChoiceArgDef >> printOn: aStream [

	aStream
		nextPutAll: self class name;
		nextPut: $(.
	arg ifNotNil: [ 
		aStream
			nextPut: $%;
			nextPut: arg.
		options ifNotNil: [ 
			aStream
				nextPut: $,;
				nextPutAll: options size asString ] ].
	aStream nextPut: $)
]

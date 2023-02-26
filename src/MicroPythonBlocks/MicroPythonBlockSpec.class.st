Class {
	#name : #MicroPythonBlockSpec,
	#superclass : #ScratchBlockSpec,
	#instVars : [
		'code',
		'imports',
		'var',
		'moduleName'
	],
	#category : #'MicroPythonBlocks-Module'
}

{ #category : #private }
MicroPythonBlockSpec >> argPermutation [

	| parsedSpec parsedTranslatedSpec parsedSpecArgs parsedTranslatedSpecArgs |
	parsedSpec := self parseCommandSpec: label.
	parsedSpecArgs := parsedSpec select: [ :s | self isArgSpec: s ].
	parsedTranslatedSpec := self parseCommandSpec: code.
	parsedTranslatedSpecArgs := parsedTranslatedSpec select: [ :s | 
		                            self isArgSpec: s ].
	parsedSpecArgs = parsedTranslatedSpecArgs ifTrue: [ 
		^ (1 to: parsedSpecArgs size) asArray ].
	^ parsedTranslatedSpecArgs collect: [ :each | 
		  self findPos: each in: parsedSpecArgs ]
]

{ #category : #accessing }
MicroPythonBlockSpec >> code [

	^ code
]

{ #category : #accessing }
MicroPythonBlockSpec >> code: anObject [

	code := anObject
]

{ #category : #api }
MicroPythonBlockSpec >> codeWithArgs: aCollection [

	| args r w c i |
	args := self evaluatedArgs: aCollection.
	r := ReadStream on: self code.
	w := WriteStream on: String new.
	i := 1.
	[ r atEnd ] whileFalse: [ 
		c := r next.
		c = $%
			ifTrue: [ 
				(r atEnd not and: [ r peek isSpaceSeparator ])
					ifTrue: [ w nextPut: c ]
					ifFalse: [ 
						w nextPutAll: (args at: i).
						i := i + 1.
						(r atEnd not and: [ r peek = $' ]) ifTrue: [ r next ].
						r next.
						[ r atEnd or: [ r peek isDigit not ] ] whileFalse: [ r next ] ] ]
			ifFalse: [ w nextPut: c ] ].
	^ w contents
]

{ #category : #private }
MicroPythonBlockSpec >> evaluatedArgs: aCollection [

	| args argPermutation result |
	args := aCollection collect: [ :each | self valueOf: each ].
	argPermutation := self argPermutation.
	result := argPermutation collect: [ :each | args at: each ].
	((self parseCommandSpec: code) select: [ :s | self isArgSpec: s ]) 
		withIndexDo: [ :each :index | 
			(self isUnquoteArg: each) ifTrue: [ 
				result at: index put: (self unquoteString: (result at: index)) ] ].
	^ result
]

{ #category : #private }
MicroPythonBlockSpec >> findPos: aString in: aCollection [

	| pos arg count |
	arg := aString copyWithout: $'.
	pos := aCollection indexOf: arg.
	pos > 0 ifTrue: [ ^ pos ].
	arg last isDigit ifFalse: [ self error: 'permutation failed' ].
	count := arg last asString asNumber.
	arg := arg copyFrom: 1 to: arg size - 1.
	aCollection withIndexDo: [ :each :index | 
		each = arg ifTrue: [ 
			count = 1
				ifTrue: [ ^ index ]
				ifFalse: [ count := count - 1 ] ] ].
	self error: 'permutation failed'
]

{ #category : #accessing }
MicroPythonBlockSpec >> imports [

	^ imports
]

{ #category : #accessing }
MicroPythonBlockSpec >> imports: anObject [

	imports := anObject
]

{ #category : #private }
MicroPythonBlockSpec >> isArgSpec: aString [

	"Answer true if the given string is an argument specification."

	^ aString size > 1 and: [ aString first = $% ]
]

{ #category : #testing }
MicroPythonBlockSpec >> isNativeBlock [

	^ false
]

{ #category : #testing }
MicroPythonBlockSpec >> isUnquoteArg: aString [

	"Answer true if the given string is an argument specification."

	^ aString size > 2 and: [ 
		  aString first = $% and: [ aString second = $' ] ]
]

{ #category : #accessing }
MicroPythonBlockSpec >> moduleName [

	^ moduleName
]

{ #category : #accessing }
MicroPythonBlockSpec >> moduleName: anObject [

	moduleName := anObject
]

{ #category : #private }
MicroPythonBlockSpec >> parseCommandSpec: aString [

	| tokens str i in out pair |
	tokens := ([ :c | c isSeparator ] split: aString) select: [ :e | 
		          e notEmpty ].
	in := ReadStream on: tokens.
	out := WriteStream on: Array new.
	[ in atEnd ] whileFalse: [ 
		str := in next.
		[ 
		i := str indexOf: $%.
		i = 0 ] whileFalse: [ 
			i > 1 ifTrue: [ out nextPut: (str copyFrom: 1 to: i - 1) ].
			pair := self splitArg: (str copyFrom: i to: str size).
			out nextPut: pair first.
			str := pair second ].
		str ifNotEmpty: [ out nextPut: str ] ].
	^ out contents
]

{ #category : #private }
MicroPythonBlockSpec >> splitArg: aString [

	| in c arg rest |
	in := ReadStream on: aString.
	arg := WriteStream on: String new.
	c := in next.
	c = $% ifFalse: [ self error: 'invalid arg' ].
	arg nextPut: c.
	in peek = $' ifTrue: [ arg nextPut: in next ].
	(in atEnd not and: [ in peek isLetter ]) ifTrue: [ 
		arg nextPut: in next ].
	[ 
	in atEnd not and: [ 
		c := in peek.
		c isDigit ] ] whileTrue: [ arg nextPut: in next ].
	rest := in upToEnd.
	^ { 
		  arg contents.
		  rest }
]

{ #category : #private }
MicroPythonBlockSpec >> unquoteString: aString [

	(aString first = $' and: [ aString last = $' ]) ifFalse: [ ^ aString ].
	^ aString copyFrom: 2 to: aString size - 1
]

{ #category : #private }
MicroPythonBlockSpec >> valueOf: anObject [

	"to be integrated with Generator"

	anObject isBlock ifTrue: [ ^ anObject value asString ].
	^ anObject asString
]

{ #category : #accessing }
MicroPythonBlockSpec >> var [

	^ var
]

{ #category : #accessing }
MicroPythonBlockSpec >> var: anObject [

	var := anObject
]

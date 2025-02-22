Class {
	#name : 'MicroPythonParser',
	#superclass : 'Object',
	#category : 'MicroPythonProxy-Core',
	#package : 'MicroPythonProxy',
	#tag : 'Core'
}

{ #category : 'parsing' }
MicroPythonParser >> parse: aString [
	| stream |
	stream := ReadStream on: aString.
	^ self parseItem: stream
]

{ #category : 'private' }
MicroPythonParser >> parseIdentifier: aStream [
	| out c |
	out := WriteStream on: String new.
	[ aStream atEnd ]
		whileFalse: [ c := aStream next.
			c isLetter
				ifTrue: [ out nextPut: c ]
				ifFalse: [ aStream back.
					^ out contents ifEmpty: [ nil ] ifNotEmpty: [ :o | o asSymbol ] ] ].
	^ out contents ifEmpty: [ nil ] ifNotEmpty: [ :o | o asSymbol ]
]

{ #category : 'private' }
MicroPythonParser >> parseItem: aStream [

	| token |
	aStream atEnd ifTrue: [ ^ nil ].
	aStream skipSeparators.
	token := aStream next.
	token = $( ifTrue: [ 
		^ (self parseItems: aStream delimiter: $)) asArray ].
	token = $[ ifTrue: [ ^ self parseItems: aStream delimiter: $] ].
	('"''' includes: token) ifTrue: [ 
		^ self parseString: aStream delimiter: token ].
	token isDigit ifTrue: [ 
		aStream back.
		^ self parseNumber: aStream ].
	token isLetter ifTrue: [ 
		aStream back.
		^ self parseIdentifier: aStream ].
	self error
]

{ #category : 'private' }
MicroPythonParser >> parseItems: aStream delimiter: aCharacter [

	| list item c |
	list := OrderedCollection new.
	aStream skipSeparators.
	aStream next = aCharacter ifTrue: [ ^ list ].
	aStream back.
	[ 
	item := self parseItem: aStream.
	list add: item.
	aStream skipSeparators.
	c := aStream next.
	c = aCharacter ifTrue: [ ^ list ].
	c = $, ] whileTrue.
	self error
]

{ #category : 'private' }
MicroPythonParser >> parseNumber: aStream [
	| out c |
	out := WriteStream on: String new.
	[ aStream atEnd ]
		whileFalse: [ c := aStream next.
			(c isDigit or: [ c = $. ])
				ifTrue: [ out nextPut: c ]
				ifFalse: [ aStream back.
					^ out contents asNumber ] ].
	^ out contents asNumber
]

{ #category : 'private' }
MicroPythonParser >> parseString: aStream delimiter: aCharacter [
	| out c |
	out := WriteStream on: String new.
	[ aStream atEnd ]
		whileFalse: [ c := aStream next.
			c = aCharacter
				ifTrue: [ ^ out contents ].
			c = $\
				ifTrue: [ c := aStream next.
					c = $t
						ifTrue: [ c := Character tab ].
					c = $n
						ifTrue: [ c := Character lf ].
					c = $r
						ifTrue: [ c := Character cr ] ].
			out nextPut: c ].
	self error
]

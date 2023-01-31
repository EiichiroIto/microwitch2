"
A StaticChoiceArgDefTest is a test class for testing the behavior of StaticChoiceArgDef
"
Class {
	#name : #StaticChoiceArgDefTest,
	#superclass : #TestCase,
	#category : #'Microwitch-Tests'
}

{ #category : #private }
StaticChoiceArgDefTest >> newObj [

	^ StaticChoiceArgDef new
]

{ #category : #test }
StaticChoiceArgDefTest >> testArg [

	| obj |
	obj := self newObj.
	self assert: obj arg isNil.
	obj arg: $a.
	self assert: obj arg equals: $a.
	obj arg: $b.
	self assert: obj arg equals: $b
]

{ #category : #test }
StaticChoiceArgDefTest >> testIsChoiceArg [

	self assert: self newObj isChoiceArg
]

{ #category : #test }
StaticChoiceArgDefTest >> testOptions [

	| obj a |
	obj := self newObj.
	self assert: obj options isNil.
	a := #( a b c ).
	obj options: a.
	self assert: obj options identicalTo: a
]

{ #category : #test }
StaticChoiceArgDefTest >> testPrintOn [

	| obj s |
	obj := self newObj.
	s := WriteStream on: String new.
	obj printOn: s.
	self assert: s contents equals: 'StaticChoiceArgDef()'.
	obj arg: $a.
	s := WriteStream on: String new.
	obj printOn: s.
	self assert: s contents equals: 'StaticChoiceArgDef(%a)'.
	obj options: #( a b c ).
	s := WriteStream on: String new.
	obj printOn: s.
	self assert: s contents equals: 'StaticChoiceArgDef(%a,3)'
]

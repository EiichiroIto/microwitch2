Class {
	#name : #MicroPythonGenerator,
	#superclass : #Object,
	#instVars : [
		'newlineString',
		'imports',
		'modules',
		'varNo',
		'indent',
		'listVars',
		'stream',
		'vars'
	],
	#category : #'Microwitch-MPython'
}

{ #category : #private }
MicroPythonGenerator >> appendWithNewline: aString [
	self generateIndent: indent.
	stream
		nextPutAll: aString;
		nextPutAll: self newlineString
]

{ #category : #private }
MicroPythonGenerator >> binaryFunction: aSymbol arg1: anObject1 arg2: anObject2 [
	| a b |
	a := self valueOf: anObject1.
	b := self valueOf: anObject2.
	^ aSymbol, '(', a, ',', b, ')'
]

{ #category : #private }
MicroPythonGenerator >> binaryOperator: aSymbol arg1: anObject1 arg2: anObject2 [
	| a b |
	a := self valueOf: anObject1.
	b := self valueOf: anObject2.
	^ '(' , a asString , aSymbol , b asString , ')'
]

{ #category : #'variable ops' }
MicroPythonGenerator >> changeVar: var by: val [
	self useVar: var.
	self appendWithNewline: var , ' = ' , var , ' + ' , (self valueOf: val)
]

{ #category : #accessing }
MicroPythonGenerator >> code [
	^ stream contents
]

{ #category : #'operators ops' }
MicroPythonGenerator >> computeFunction: aSymbol of: aNumber [
	| v f |
	v := self valueOf: aNumber.
	aSymbol = 'abs'
		ifTrue: [ ^ aSymbol , '(' , v , ')' ].
	aSymbol = '10 ^'
		ifTrue: [ ^ self math , 'pow(10,' , v , ')' ].
	f := aSymbol.
	f = 'log'
		ifTrue: [ f := 'log10' ].
	f = 'ln'
		ifTrue: [ f := 'log' ].
	f = 'e ^'
		ifTrue: [ f := 'exp' ].
	^ self math , f , '(' , v , ')'
]

{ #category : #'control ops' }
MicroPythonGenerator >> def: aString [
	self appendWithNewline: 'def ' , aString , '():'
]

{ #category : #'control ops' }
MicroPythonGenerator >> doForeverBegin [
	self appendWithNewline: 'while True:'
]

{ #category : #'control ops' }
MicroPythonGenerator >> doForeverEnd [
	"do nothing"
]

{ #category : #'control ops' }
MicroPythonGenerator >> doIfBegin: cond [
	self appendWithNewline: 'if ' , (self valueOf: cond) , ':'
]

{ #category : #'control ops' }
MicroPythonGenerator >> doIfElse [
	self appendWithNewline: 'else:'
]

{ #category : #'control ops' }
MicroPythonGenerator >> doIfEnd [
	"do nothing"
]

{ #category : #'control ops' }
MicroPythonGenerator >> doIterateBegin: list var: var [
	self
		appendWithNewline: 'for ' , (self valueOf: var) , ' in ' , (self valueOf: list) , ':'
]

{ #category : #'control ops' }
MicroPythonGenerator >> doIterateEnd [
	"do nothing"
]

{ #category : #'control ops' }
MicroPythonGenerator >> doRepeatBegin: aNumber var: aString [
	self
		appendWithNewline: 'for ' , aString , ' in range(' , aNumber asString , '):'
]

{ #category : #'control ops' }
MicroPythonGenerator >> doRepeatEnd [
	"do nothing"
]

{ #category : #'control ops' }
MicroPythonGenerator >> doUntilBegin: cond [
	self appendWithNewline: 'while not(' , (self valueOf: cond) , '):'
]

{ #category : #'control ops' }
MicroPythonGenerator >> doUntilEnd [
	"do nothing"
]

{ #category : #'control ops' }
MicroPythonGenerator >> doWhileBegin: cond [
	self appendWithNewline: 'while ' , (self valueOf: cond) , ':'
]

{ #category : #'control ops' }
MicroPythonGenerator >> doWhileEnd [
	"do nothing"
]

{ #category : #private }
MicroPythonGenerator >> falseString [

	^ 'False'
]

{ #category : #private }
MicroPythonGenerator >> from: aSymbol1 import: aSymbol2 [ 
	| set |
	set := modules at: aSymbol1 ifAbsentPut: [Set new].
	set add: aSymbol2
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateCode: aSymbol arguments: aCollection for: aScript [

	| blockSpec code |
	blockSpec := aScript blockSpecAt: aSymbol.
	code := blockSpec codeWithArgs: aCollection.
	blockSpec imports ifNotNil: [ :list | 
		list do: [ :each | self import: each ] ].
	blockSpec isReporterBlock ifTrue: [ ^ code ].
	code linesDo: [ :each | self appendWithNewline: each ]
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateFrom: aString imports: aCollection [

	| list |
	aCollection isEmpty ifTrue: [ ^ self ].
	self generateIndent: indent.
	stream
		nextPutAll: 'from ';
		nextPutAll: aString;
		nextPutAll: ' import '.
	list := aCollection asSet.
	(list includes: '*')
		ifTrue: [ stream nextPut: $* ]
		ifFalse: [ 
			list asArray sorted
				do: [ :each | stream nextPutAll: each ]
				separatedBy: [ stream nextPut: $, ] ].
	stream nextPutAll: self newlineString
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateHeader [
	self
		indent: 0;
		generateInitModules
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateImports: aCollection [

	aCollection isEmpty ifTrue: [ ^ self ].
	self generateIndent: indent.
	stream nextPutAll: 'import '.
	aCollection asSet asArray sorted
		do: [ :each | stream nextPutAll: each ]
		separatedBy: [ stream nextPut: $, ].
	stream nextPutAll: self newlineString
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateIndent: anInteger [
	anInteger timesRepeat: [ stream nextPutAll: '    ' ]
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateInitModules [

	self generateImports: imports.
	modules keysDo: [ :each | 
		self generateFrom: each imports: (modules at: each) ]
]

{ #category : #'code generator' }
MicroPythonGenerator >> generatePass [
	self appendWithNewline: 'pass'
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateSubVars: aCollection [
	| st |
	aCollection isEmpty
		ifTrue: [ ^ self ].
	st := WriteStream on: String new.
	st nextPutAll: 'global '.
	aCollection
		do: [ :each | st nextPutAll: each ]
		separatedBy: [ st nextPut: $, ].
	self appendWithNewline: st contents
]

{ #category : #accessing }
MicroPythonGenerator >> header [
	stream := WriteStream on: String new.
	self generateHeader.
	^ stream contents
]

{ #category : #private }
MicroPythonGenerator >> import: anObject [
	anObject isString
		ifTrue: [ imports add: anObject.
			^ self ].
	anObject isArray
		ifTrue: [ ^ self from: anObject first import: anObject second ].
	self error: 'invalid import'
]

{ #category : #private }
MicroPythonGenerator >> imports [
	^ imports
]

{ #category : #accessing }
MicroPythonGenerator >> indent [
	^ indent
]

{ #category : #accessing }
MicroPythonGenerator >> indent: anInteger [
	indent := anInteger
]

{ #category : #initialization }
MicroPythonGenerator >> initialize [
	super initialize.
	stream := WriteStream on: String new.
	listVars := Set new.
	vars := Set new.
	indent := 0.
	varNo := 0.
	imports := Set new.
	modules := Dictionary new.
	self newlineLF
]

{ #category : #private }
MicroPythonGenerator >> listVars [
	^ listVars
]

{ #category : #'code generator' }
MicroPythonGenerator >> literalStringFrom: anObject [ 
	((anObject isString)
		and: [anObject isNumberString not])
		ifTrue: [^ self quotedString: anObject].
	^ anObject asString
]

{ #category : #private }
MicroPythonGenerator >> localVarArgString: aString [
	^ aString
]

{ #category : #private }
MicroPythonGenerator >> math [
	self import: 'math'.
	^ 'math.'
]

{ #category : #private }
MicroPythonGenerator >> modules [
	^ modules
]

{ #category : #private }
MicroPythonGenerator >> newVariable [
	varNo := varNo + 1.
	^ '_v', varNo asString
]

{ #category : #accessing }
MicroPythonGenerator >> newlineCR [
	newlineString := String cr
]

{ #category : #accessing }
MicroPythonGenerator >> newlineCRLF [
	newlineString := String crlf
]

{ #category : #accessing }
MicroPythonGenerator >> newlineLF [
	newlineString := String lf
]

{ #category : #accessing }
MicroPythonGenerator >> newlineString [
	^ newlineString
]

{ #category : #private }
MicroPythonGenerator >> nullaryFunction: aSymbol [
	^ aSymbol, '()'
]

{ #category : #private }
MicroPythonGenerator >> quotedString: aString [ 
	| in out c |
	in := ReadStream on: aString.
	out := WriteStream on: String new.
	out nextPut: $'.
	[in atEnd]
		whileFalse: 
			[c := in next.
			('''' includes: c)
				ifTrue: [out nextPut: $\].
			out nextPut: c].
	out nextPut: $'.
	^ out contents
]

{ #category : #private }
MicroPythonGenerator >> random [
	self import: 'random'.
	^ 'random.'
]

{ #category : #'variable ops' }
MicroPythonGenerator >> setVar: var to: val [
	self useVar: var.
	self appendWithNewline: var , ' = ' , (self valueOf: val)
]

{ #category : #'code generator' }
MicroPythonGenerator >> stopThread [
	"do nothing"
]

{ #category : #private }
MicroPythonGenerator >> ternaryFunction: aSymbol arg1: anObject1 arg2: anObject2 arg3: anObject3 [
	| a b c |
	a := self valueOf: anObject1.
	b := self valueOf: anObject2.
	c := self valueOf: anObject3.
	^ aSymbol, '(', a, ',', b, ',', c, ')'
]

{ #category : #private }
MicroPythonGenerator >> unaryFunction: aString arg: anObject [
	| arg |
	arg := self valueOf: anObject.
	^ aString, '(', arg, ')'
]

{ #category : #private }
MicroPythonGenerator >> useListVar: aString [
	listVars add: aString
]

{ #category : #private }
MicroPythonGenerator >> useVar: aString [
	vars add: aString.
]

{ #category : #private }
MicroPythonGenerator >> valueOf: anObject [
	anObject isBlock ifTrue: [ ^ anObject value asString ].
	^ anObject asString
]

{ #category : #private }
MicroPythonGenerator >> varNo [
	^ varNo
]

{ #category : #private }
MicroPythonGenerator >> variableArgString: aString [
	self useVar: aString.
	^ aString
]

{ #category : #private }
MicroPythonGenerator >> vars [
	^ vars
]

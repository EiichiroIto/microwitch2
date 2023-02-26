Class {
	#name : #MicroPythonGenerator,
	#superclass : #ScratchGenerator,
	#instVars : [
		'imports',
		'modules',
		'varNo',
		'indent',
		'listVars',
		'stream',
		'vars',
		'options'
	],
	#category : #'MicroPythonBlocks-Process'
}

{ #category : #private }
MicroPythonGenerator >> appendWithNewline: aString [

	self printIndent.
	stream
		nextPutAll: aString;
		nextPutAll: self newlineString
]

{ #category : #private }
MicroPythonGenerator >> argsOf: aMorph [

	^ aMorph blockArgs collect: [ :each | each argOf: parser ]
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

{ #category : #private }
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

{ #category : #'arg generator' }
MicroPythonGenerator >> eventTitleString: aString [

	self shouldBeImplemented
]

{ #category : #'arg generator' }
MicroPythonGenerator >> expressionArgWithMenuString: aMorph [

	| v |
	v := aMorph specialValue.
	v ifNil: [ ^ self argString: aMorph ].
	(#( #append:toList: #deleteLine:ofList: #insert:at:ofList:
	    #setLine:ofList:to: #getLine:ofList: ) includes:
		 aMorph ownerSelector) ifTrue: [ 
		v = #all ifTrue: [ ^ ':' ].
		v = #last ifTrue: [ ^ '-1' ] ].
	^ v
]

{ #category : #'arg generator' }
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
MicroPythonGenerator >> generateCode: aSymbol morph: aMorph [

	SpScratchApp
		try: [ self rawGenerateCode: aSymbol morph: aMorph ]
		onFailure: [ aMorph showBalloon: 'error' ]
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateDoForeverBegin: aMorph [

	self doForeverBegin
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateDoForeverEnd: aMorph [

	self doForeverEnd
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateDoIfBegin: aMorph [

	| cond |
	cond := aMorph blockArgs first argString: parser.
	self doIfBegin: cond
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateDoIfElseBegin: aMorph [

	self generateDoIfBegin: aMorph
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateDoIfElseCenter: aMorph [

	self doIfElse
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateDoIfElseEnd: aMorph [

	self generateDoIfEnd: aMorph
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateDoIfEnd: aMorph [

	"do nothing"
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateDoIterateBegin: aMorph [

	| list var |
	list := aMorph blockArgs first argString: parser.
	var := aMorph blockArgs second varName.
	self doIterateBegin: list var: var
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateDoIterateEnd: aMorph [

	self doIterateEnd
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateDoRepeatBegin: aMorph [

	| num var |
	num := aMorph blockArgs first argString: parser.
	var := aMorph blockArgs second varName.
	self doRepeatBegin: num var: var
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateDoRepeatEnd: aMorph [

	self doRepeatEnd
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateDoUntilBegin: aMorph [

	| cond |
	cond := aMorph blockArgs first argString: parser.
	self doUntilBegin: cond
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateDoUntilEnd: aMorph [

	self doUntilEnd
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateDoWhileBegin: aMorph [

	| cond |
	cond := aMorph blockArgs first argString: parser.
	self doWhileBegin: cond
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateDoWhileEnd: aMorph [

	self doWhileEnd
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateEmptySubBody [

	self generatePass
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateEventFooter: aString [ 

	self stopThread
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateEventHeader: aString [

	"do nothing"
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateFrom: aString imports: aCollection [

	| list |
	aCollection isEmpty ifTrue: [ ^ self ].
	self printIndent.
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
	self printIndent.
	stream nextPutAll: 'import '.
	aCollection asSet asArray sorted
		do: [ :each | stream nextPutAll: each ]
		separatedBy: [ stream nextPut: $, ].
	stream nextPutAll: self newlineString
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateIndent: anInteger [

	self indent: anInteger
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
MicroPythonGenerator >> generateReporter: aString [

	self appendWithNewline: aString
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateReporter: aSymbol morph: aMorph [

	| ret |
	ret := 0.
	SpScratchApp
		try: [ ret := self rawGenerateCode: aSymbol morph: aMorph ]
		onFailure: [ aMorph showBalloon: 'error' ].
	^ ret
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateSubFooter: aString [

	"do nothing"
]

{ #category : #'code generator' }
MicroPythonGenerator >> generateSubHeader: aString [

	self
		indent: 0;
		def: aString
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

{ #category : #private }
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

{ #category : #private }
MicroPythonGenerator >> indentLevelFor: aMorph [

	^ aMorph isSubHatMorph
		  ifTrue: [ 1 ]
		  ifFalse: [ 0 ]
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
	options := Dictionary new.
	self newlineLF.
	self withHeader: false.
	self withDef: true
]

{ #category : #private }
MicroPythonGenerator >> listVars [
	^ listVars
]

{ #category : #private }
MicroPythonGenerator >> literalStringFrom: anObject [

	(anObject isString and: [ anObject isNumberString not ]) ifTrue: [ 
		^ self quotedString: anObject ].
	^ anObject asString
]

{ #category : #'arg generator' }
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

	options at: #newlineString put: String cr
]

{ #category : #accessing }
MicroPythonGenerator >> newlineCRLF [

	options at: #newlineString put: String crlf
]

{ #category : #accessing }
MicroPythonGenerator >> newlineLF [

	options at: #newlineString put: String lf
]

{ #category : #accessing }
MicroPythonGenerator >> newlineString [

	^ options at: #newlineString
]

{ #category : #private }
MicroPythonGenerator >> nullaryFunction: aSymbol [
	^ aSymbol, '()'
]

{ #category : #api }
MicroPythonGenerator >> parseBlock: aBlock [

	| code |
	code := super parseBlock: aBlock.
	(code isEmpty or: [ self withHeader not ])
		ifTrue: [ ^ code ].
	^ self header , code
]

{ #category : #api }
MicroPythonGenerator >> parseScript: aScript [

	^ self parseHats: aScript hatBlocks
]

{ #category : #private }
MicroPythonGenerator >> printIndent [

	indent timesRepeat: [ stream nextPutAll: '    ' ]
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

{ #category : #'code generator' }
MicroPythonGenerator >> rawGenerateCode: aSymbol morph: aMorph [

	| args script blockSpec |
	script := aMorph receiver.
	args := self argsOf: aMorph.
	blockSpec := script blockSpecAt: aSymbol.
	blockSpec isNativeBlock ifTrue: [ 
		aSymbol = #getVar: ifTrue: [ ^ aMorph variable ].
		^ self perform: aSymbol asSymbol withArguments: args ].
	^ self
		  generateCode: aSymbol asSymbol
		  arguments: args
		  for: script
]

{ #category : #'variable ops' }
MicroPythonGenerator >> setVar: var to: val [
	self useVar: var.
	self appendWithNewline: var , ' = ' , (self valueOf: val)
]

{ #category : #'arg generator' }
MicroPythonGenerator >> spriteArgString: aMorph [

	self shouldNotImplement
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

{ #category : #'code generator' }
MicroPythonGenerator >> varNamesUsedIn: aMorph [

	| varNames blocks block blockSpec |
	varNames := Set new.
	blocks := OrderedCollection new.
	blocks add: aMorph.
	[ blocks notEmpty ] whileTrue: [ 
		block := blocks removeFirst.
		block isSetterBlock ifTrue: [ varNames add: block variable ].
		block isCommandBlock ifTrue: [ 
			blockSpec := block blockSpec.
			(blockSpec isBlockSpec and: [ blockSpec isNativeBlock not ]) 
				ifTrue: [ blockSpec var ifNotNil: [ :v | varNames add: v ] ] ].
		blocks addAll: block nextOrInnerBlocks ].
	^ varNames asArray sorted
]

{ #category : #private }
MicroPythonGenerator >> varNo [
	^ varNo
]

{ #category : #'arg generator' }
MicroPythonGenerator >> variableArgString: aString [
	self useVar: aString.
	^ aString
]

{ #category : #private }
MicroPythonGenerator >> vars [
	^ vars
]

{ #category : #accessing }
MicroPythonGenerator >> withDef [

	^ options at: #withDef
]

{ #category : #accessing }
MicroPythonGenerator >> withDef: aBoolean [

	options at: #withDef put: aBoolean
]

{ #category : #accessing }
MicroPythonGenerator >> withHeader [

	^ options at: #withHeader
]

{ #category : #accessing }
MicroPythonGenerator >> withHeader: aBoolean [

	options at: #withHeader put: aBoolean
]

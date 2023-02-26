"
A MicroPythonGeneratorTest is a test class for testing the behavior of MicroPythonGenerator
"
Class {
	#name : #MicroPythonGeneratorTest,
	#superclass : #TestCase,
	#category : #'MicroPythonBlocks-Tests'
}

{ #category : #private }
MicroPythonGeneratorTest >> newGenerator [
	^ MicroPythonGenerator new
]

{ #category : #test }
MicroPythonGeneratorTest >> testAppendWithNewline [
	| g |
	g := self newGenerator.
	g indent: 2.
	g appendWithNewline: 'abc'.
	self assert: g code equals: '        abc' , String lf
]

{ #category : #test }
MicroPythonGeneratorTest >> testAppendWithNewline2 [
	| g |
	g := self newGenerator.
	g appendWithNewline: 'abc'.
	g appendWithNewline: 'def'.
	self assert: g code equals: 'abc' , String lf , 'def' , String lf
]

{ #category : #test }
MicroPythonGeneratorTest >> testBinaryFunctionArg1Arg2 [
	| g |
	g := self newGenerator.
	self
		assert: (g binaryFunction: 'abc' arg1: [ 10 ] arg2: [ 1 + 2 ])
		equals: 'abc(10,3)'
]

{ #category : #test }
MicroPythonGeneratorTest >> testBinaryOperatorArg1Arg2 [
	| g |
	g := self newGenerator.
	self
		assert: (g binaryOperator: '+' arg1: [ 10 ] arg2: [ 1 + 2 ])
		equals: '(10+3)'
]

{ #category : #test }
MicroPythonGeneratorTest >> testChangeVarBy [
	| g |
	g := self newGenerator.
	g changeVar: 'x' by: '2'.
	self assert: g code equals: 'x = x + 2' , String lf
]

{ #category : #test }
MicroPythonGeneratorTest >> testCode [
	| g |
	g := self newGenerator.
	self assert: g code isEmpty.
	g appendWithNewline: 'abc'.
	g appendWithNewline: 'def'.
	self assert: g code equals: 'abc' , String lf , 'def' , String lf
]

{ #category : #test }
MicroPythonGeneratorTest >> testComputeFunctionOf [
	| g |
	g := self newGenerator.
	self assert: (g computeFunction: 'abs' of: 'x') equals: 'abs(x)'.
	self assert: (g computeFunction: 'sin' of: 'x') equals: 'math.sin(x)'.
	self assert: (g computeFunction: 'ln' of: 'x') equals: 'math.log(x)'.
	self
		assert: (g computeFunction: 'log' of: 'x')
		equals: 'math.log10(x)'.
	self
		assert: (g computeFunction: '10 ^' of: 'x')
		equals: 'math.pow(10,x)'.
	self assert: (g computeFunction: 'e ^' of: 'x') equals: 'math.exp(x)'
]

{ #category : #test }
MicroPythonGeneratorTest >> testDef [
	| g |
	g := self newGenerator.
	g def: 'abc'.
	self assert: g code equals: 'def abc():' , String lf
]

{ #category : #test }
MicroPythonGeneratorTest >> testDoForeverBegin [
	| g |
	g := self newGenerator.
	g doForeverBegin.
	self assert: g code equals: 'while True:' , String lf
]

{ #category : #test }
MicroPythonGeneratorTest >> testDoForeverEnd [
	| g |
	g := self newGenerator.
	g doForeverEnd.
	self assert: g code equals: ''
]

{ #category : #test }
MicroPythonGeneratorTest >> testDoIfBegin [
	| g |
	g := self newGenerator.
	g doIfBegin: 'a'.
	self assert: g code equals: 'if a:' , String lf
]

{ #category : #test }
MicroPythonGeneratorTest >> testDoIfElse [
	| g |
	g := self newGenerator.
	g doIfElse.
	self assert: g code equals: 'else:' , String lf
]

{ #category : #test }
MicroPythonGeneratorTest >> testDoIterateBeginVar [
	| g |
	g := self newGenerator.
	g doIterateBegin: 'x' var: 'y'.
	self assert: g code equals: 'for y in x:' , String lf
]

{ #category : #test }
MicroPythonGeneratorTest >> testDoIterateEnd [
	| g |
	g := self newGenerator.
	g doIterateEnd.
	self assert: g code equals: ''
]

{ #category : #test }
MicroPythonGeneratorTest >> testDoRepeatBeginVar [
	| g |
	g := self newGenerator.
	g doRepeatBegin: '10' var: 'x'.
	self assert: g code equals: 'for x in range(10):' , String lf
]

{ #category : #test }
MicroPythonGeneratorTest >> testDoRepeatEnd [
	| g |
	g := self newGenerator.
	g doRepeatEnd.
	self assert: g code equals: ''
]

{ #category : #test }
MicroPythonGeneratorTest >> testDoUntilBegin [
	| g |
	g := self newGenerator.
	g doUntilBegin: '1=2'.
	self assert: g code equals: 'while not(1=2):' , String lf
]

{ #category : #test }
MicroPythonGeneratorTest >> testDoUntilEnd [
	| g |
	g := self newGenerator.
	g doUntilEnd.
	self assert: g code equals: ''
]

{ #category : #test }
MicroPythonGeneratorTest >> testDoWhileBegin [
	| g |
	g := self newGenerator.
	g doWhileBegin: '1=2'.
	self assert: g code equals: 'while 1=2:' , String lf
]

{ #category : #test }
MicroPythonGeneratorTest >> testDoWhileEnd [
	| g |
	g := self newGenerator.
	g doWhileEnd.
	self assert: g code equals: ''
]

{ #category : #test }
MicroPythonGeneratorTest >> testFalseString [
	| g |
	g := self newGenerator.
	self assert: g falseString equals: 'False'
]

{ #category : #test }
MicroPythonGeneratorTest >> testFromImport [
	| g |
	g := self newGenerator.
	self assert: g modules isEmpty.
	g from: 'machine' import: 'abc'.
	self assert: ((g modules at: 'machine') includes: 'abc')
]

{ #category : #test }
MicroPythonGeneratorTest >> testGenerateFromImports [

	| g |
	g := self newGenerator.
	g generateFrom: 'abc' imports: #(  ).
	self assert: g code isEmpty.
	g := self newGenerator.
	g generateFrom: 'abc' imports: #( def ).
	self assert: g code equals: 'from abc import def' , String lf.
	g := self newGenerator.
	g generateFrom: 'abc' imports: #( def ghi ).
	self assert: g code equals: 'from abc import def,ghi' , String lf.
	g := self newGenerator.
	g generateFrom: 'abc' imports: #( def ghi '*' ).
	self assert: g code equals: 'from abc import *' , String lf.
	g := self newGenerator.
	g indent: 1.
	g generateFrom: 'abc' imports: #( def ghi ).
	self assert: g code equals: '    from abc import def,ghi' , String lf
]

{ #category : #test }
MicroPythonGeneratorTest >> testGenerateHeader [
	| g |
	g := self newGenerator.
	g generateHeader.
	self assert: g header isEmpty.
	g import: 'abc'.
	g from: 'def' import: 'ghi'.
	g useVar: 'a'.
	g useListVar: 'b'.
	g generateHeader.
	self
		assert: g header
		equals:
			'import abc' , String lf , 'from def import ghi' , String lf
]

{ #category : #test }
MicroPythonGeneratorTest >> testGenerateImports [

	| g |
	g := self newGenerator.
	g generateImports: #(  ).
	self assert: g code isEmpty.
	g := self newGenerator.
	g generateImports: #( abc ).
	self assert: g code equals: 'import abc' , String lf.
	g := self newGenerator.
	g generateImports: #( abc def ).
	self assert: g code equals: 'import abc,def' , String lf.
	g := self newGenerator.
	g indent: 1.
	g generateImports: #( abc def ).
	self assert: g code equals: '    import abc,def' , String lf
]

{ #category : #test }
MicroPythonGeneratorTest >> testGenerateIndent [

	self testIndent
]

{ #category : #test }
MicroPythonGeneratorTest >> testGenerateInitModules [

	| g |
	g := self newGenerator.
	g import: 'abc'.
	g import: 'def'.
	g from: 'a' import: 'b'.
	g from: 'c' import: 'd'.
	g from: 'a' import: 'e'.
	g generateInitModules.
	self
		assert: g code
		equals:
			'import abc,def' , String lf , 'from a import b,e' , String lf
			, 'from c import d' , String lf
]

{ #category : #test }
MicroPythonGeneratorTest >> testGeneratePass [
	| g |
	g := self newGenerator.
	g generatePass.
	self assert: g code equals: 'pass' , String lf
]

{ #category : #test }
MicroPythonGeneratorTest >> testGenerateSubVars [
	| g |
	g := self newGenerator.
	g generateSubVars: #(a b c).
	self assert: g code equals: 'global a,b,c' , String lf.
	g := self newGenerator.
	g generateSubVars: #().
	self assert: g code isEmpty
]

{ #category : #test }
MicroPythonGeneratorTest >> testHeader [
	| g |
	g := self newGenerator.
	self assert: g header isEmpty.
	g import: 'abc'.
	self assert: g header equals: 'import abc' , String lf
]

{ #category : #test }
MicroPythonGeneratorTest >> testImport [
	| g |
	g := self newGenerator.
	self assert: g imports isEmpty.
	g import: 'abc'.
	self assert: (g imports includes: 'abc').
	g import: 'def'.
	self assert: (g imports includes: 'abc').
	self assert: (g imports includes: 'def')
]

{ #category : #test }
MicroPythonGeneratorTest >> testImports [
	| g |
	g := self newGenerator.
	self assert: g imports isCollection.
	self assert: g imports isEmpty
]

{ #category : #test }
MicroPythonGeneratorTest >> testIndent [
	| g |
	g := self newGenerator.
	self assert: g indent equals: 0.
	g indent: 1.
	self assert: g indent equals: 1.
	g indent: 2.
	self assert: g indent equals: 2
]

{ #category : #test }
MicroPythonGeneratorTest >> testInitialize [
	| g |
	g := self newGenerator.
	self assert: g listVars isCollection.
	self assert: g vars isCollection.
	self assert: g varNo equals: 0.
	self assert: g imports isCollection.
	self assert: g listVars isCollection.
	self assert: g vars isCollection.
	self assert: g modules isDictionary
]

{ #category : #test }
MicroPythonGeneratorTest >> testListVars [
	| g |
	g := self newGenerator.
	self assert: g listVars isCollection.
	self assert: g listVars isEmpty
]

{ #category : #test }
MicroPythonGeneratorTest >> testLiteralStringFrom [
	| g |
	g := self newGenerator.
	self assert: (g literalStringFrom: 'a') equals: '''a'''.
	self assert: (g literalStringFrom: '10') equals: '10'.
	self assert: (g literalStringFrom: 10) equals: '10'
]

{ #category : #test }
MicroPythonGeneratorTest >> testLocalVarArgString [
	| g |
	g := self newGenerator.
	self assert: (g localVarArgString: 'abc') equals: 'abc'.
	self assert: (g localVarArgString: 'def') equals: 'def'
]

{ #category : #test }
MicroPythonGeneratorTest >> testMath [
	| g |
	g := self newGenerator.
	self assert: g math equals: 'math.'.
	self assert: (g imports includes: 'math')
]

{ #category : #test }
MicroPythonGeneratorTest >> testModules [
	| g |
	g := self newGenerator.
	self assert: g modules isDictionary.
	self assert: g modules isEmpty
]

{ #category : #test }
MicroPythonGeneratorTest >> testNewVariable [
	| g |
	g := self newGenerator.
	self assert: g newVariable equals: '_v1'.
	self assert: g newVariable equals: '_v2'.
	self assert: g varNo equals: 2
]

{ #category : #test }
MicroPythonGeneratorTest >> testNewlineCR [
	| g |
	g := self newGenerator.
	self assert: g newlineString equals: String lf.
	g newlineCR.
	self assert: g newlineString equals: String cr
]

{ #category : #test }
MicroPythonGeneratorTest >> testNewlineCRLF [
	| g |
	g := self newGenerator.
	self assert: g newlineString equals: String lf.
	g newlineCRLF.
	self assert: g newlineString equals: String crlf
]

{ #category : #test }
MicroPythonGeneratorTest >> testNewlineLF [
	| g |
	g := self newGenerator.
	self assert: g newlineString equals: String lf.
	g newlineCRLF.
	self assert: g newlineString equals: String crlf.
	g newlineLF.
	self assert: g newlineString equals: String lf
]

{ #category : #test }
MicroPythonGeneratorTest >> testNewlineString [
	self testNewlineLF
]

{ #category : #test }
MicroPythonGeneratorTest >> testNullaryFunction [
	| g |
	g := self newGenerator.
	self
		assert: (g nullaryFunction: 'abc')
		equals: 'abc()'
]

{ #category : #test }
MicroPythonGeneratorTest >> testPrintIndent [

	| g |
	g := self newGenerator.
	g indent: 2.
	g printIndent.
	self assert: g code equals: '        '
]

{ #category : #test }
MicroPythonGeneratorTest >> testQuotedString [
	| g |
	g := self newGenerator.
	self assert: (g quotedString: 'abc') equals: '''abc'''.
	self assert: (g quotedString: 'ab''c') equals: '''ab\''c'''.
	self assert: (g quotedString: 'ab\n') equals: '''ab\n'''
]

{ #category : #test }
MicroPythonGeneratorTest >> testRandom [
	| g |
	g := self newGenerator.
	self assert: g random equals: 'random.'.
	self assert: (g imports includes: 'random')
]

{ #category : #test }
MicroPythonGeneratorTest >> testSetVarTo [
	| g |
	g := self newGenerator.
	g setVar: 'x' to: '1+2'.
	self assert: g code equals: 'x = 1+2' , String lf
]

{ #category : #test }
MicroPythonGeneratorTest >> testStopThread [
	| g |
	g := self newGenerator.
	g stopThread.
	self assert: g code equals: ''
]

{ #category : #test }
MicroPythonGeneratorTest >> testTernaryFunctionArg1Arg2Arg3 [
	| g |
	g := self newGenerator.
	self
		assert: (g ternaryFunction: 'abc' arg1: [ 10 ] arg2: [ 1 + 2 ] arg3: [ 4 ])
		equals: 'abc(10,3,4)'
]

{ #category : #test }
MicroPythonGeneratorTest >> testUnaryFunctionArg [
	| g |
	g := self newGenerator.
	self
		assert: (g unaryFunction: 'abc' arg: [ 10 ])
		equals: 'abc(10)'
]

{ #category : #test }
MicroPythonGeneratorTest >> testUseListVar [
	| g |
	g := self newGenerator.
	self assert: g listVars isEmpty.
	g useListVar: 'a'.
	self assert: (g listVars includes: 'a').
	self deny: (g listVars includes: 'b')
]

{ #category : #test }
MicroPythonGeneratorTest >> testUseVar [
	| g |
	g := self newGenerator.
	self assert: g vars isEmpty.
	g useVar: 'a'.
	self assert: (g vars includes: 'a').
	self deny: (g vars includes: 'b')
]

{ #category : #test }
MicroPythonGeneratorTest >> testValueOf [
	| g |
	g := self newGenerator.
	self assert: (g valueOf: 'a') equals: 'a'.
	self assert: (g valueOf: 10) equals: '10'.
	self assert: (g valueOf: [10]) equals: '10'
]

{ #category : #test }
MicroPythonGeneratorTest >> testVarNo [
	| g |
	g := self newGenerator.
	self assert: g varNo equals: 0
]

{ #category : #test }
MicroPythonGeneratorTest >> testVariableArgString [
	| g |
	g := self newGenerator.
	self assert: (g variableArgString: 'a') equals: 'a'.
	self assert: (g vars includes: 'a')
]

{ #category : #test }
MicroPythonGeneratorTest >> testVars [
	| g |
	g := self newGenerator.
	self assert: g vars isCollection.
	self assert: g vars isEmpty
]

{ #category : #test }
MicroPythonGeneratorTest >> testWithDef [

	| gen |
	gen := self newGenerator.
	self assert: gen withDef.
	gen withDef: false.
	self deny: gen withDef.
	gen withDef: true.
	self assert: gen withDef
]

{ #category : #test }
MicroPythonGeneratorTest >> testWithHeader [

	| gen |
	gen := self newGenerator.
	self deny: gen withHeader.
	gen withHeader: true.
	self assert: gen withHeader.
	gen withHeader: false.
	self deny: gen withHeader
]

"
A MicroPythonParser2Test is a test class for testing the behavior of MicroPythonParser
"
Class {
	#name : #MicroPythonParserTest,
	#superclass : #TestCase,
	#category : #'MicroPythonProxy-Tests'
}

{ #category : #private }
MicroPythonParserTest >> newParser [
	^ MicroPythonParser new
]

{ #category : #test }
MicroPythonParserTest >> testParse [
	| p |
	p := self newParser.
	self
		assertCollection: (p parse: '[''main.py'',''boot.py'']')
		equals: {'main.py' . 'boot.py'}
]

{ #category : #test }
MicroPythonParserTest >> testParseData [
	| p |
	p := self newParser.
	self assert: (p parseData: '123') equals: 123.
	p := self newParser.
	self assert: (p parseData: '''abc''') equals: 'abc'.
	p := self newParser.
	self assert: (p parseData: '') equals: nil
]

{ #category : #test }
MicroPythonParserTest >> testParseIdentifier [
	| p s |
	p := self newParser.
	s := ReadStream on: '123'.
	self assert: (p parseIdentifier: s) isNil.
	s := ReadStream on: 'abc'.
	self assert: (p parseIdentifier: s) equals: #abc.
	s := ReadStream on: 'abc123'.
	self assert: (p parseIdentifier: s) equals: #abc.
	self assert: s next equals: $1
]

{ #category : #test }
MicroPythonParserTest >> testParseItem [
	| p in list |
	p := self newParser.
	in := ReadStream on: '[]'.
	list := p parseItem: in.
	self assert: list isEmpty.
	in := ReadStream on: '[123,456]'.
	list := p parseItem: in.
	self assertCollection: list equals: #(123 456).
	in := ReadStream on: '[''main.py'']'.
	list := p parseItem: in.
	self assertCollection: list equals: #('main.py')
]

{ #category : #test }
MicroPythonParserTest >> testParseItemsDelimiter [
	| p in list |
	p := self newParser.
	in := ReadStream on: '123,456 , 789]'.
	list := p parseItems: in delimiter: $].
	self assertCollection: list equals: #(123 456 789).
	self assert: in atEnd.
	in := ReadStream on: '    ]'.
	list := p parseItems: in delimiter: $].
	self assert: list isEmpty.
]

{ #category : #test }
MicroPythonParserTest >> testParseList [
	| p s r |
	s := ReadStream on: '[]'.
	p := self newParser.
	p stream: s.
	r := p parseList.
	self assert: r isCollection.
	self assert: r isEmpty.
	s := ReadStream on: '[1 , 2,3 ]'.
	p := self newParser.
	p stream: s.
	r := p parseList.
	self assertCollection: r equals: #(1 2 3) asOrderedCollection
]

{ #category : #test }
MicroPythonParserTest >> testParseNumber [
	| p s |
	p := self newParser.
	s := ReadStream on: '123'.
	self assert: (p parseNumber: s) equals: 123.
	s := ReadStream on: '12.3'.
	self assert: (p parseNumber: s) equals: 12.3.
	s := ReadStream on: '123abc'.
	self assert: (p parseNumber: s) equals: 123.
	self assert: s next equals: $a
]

{ #category : #test }
MicroPythonParserTest >> testParseSequentialUpTo [
	| p s r |
	s := ReadStream on: '<>'.
	p := self newParser.
	p stream: s.
	r := p parseSequential: Array new upTo: $>.
	self assert: r isArray.
	self assert: r isEmpty.
	s := ReadStream on: '<1 , 2,3 >'.
	p := self newParser.
	p stream: s.
	r := p parseSequential: Array new upTo: $>.
	self assertCollection: r equals: #(1 2 3)
]

{ #category : #test }
MicroPythonParserTest >> testParseString [
	| p s |
	s := ReadStream on: '''123''X'.
	p := self newParser.
	p stream: s.
	self assert: p parseString equals: '123'.
	self assert: p stream next equals: $X.
	s := ReadStream on: '''12"34'''.
	p := self newParser.
	p stream: s.
	self assert: p parseString equals: '12"34'.
	s := ReadStream on: '"12''34"'.
	p := self newParser.
	p stream: s.
	self assert: p parseString equals: '12''34'.
	s := ReadStream on: '''12\''34'''.
	p := self newParser.
	p stream: s.
	self assert: p parseString equals: '12''34'.
	s := ReadStream on: '"12\"34"'.
	p := self newParser.
	p stream: s.
	self assert: p parseString equals: '12"34'.
	s := ReadStream on: '"12\\34"'.
	p := self newParser.
	p stream: s.
	self assert: p parseString equals: '12\34'
]

{ #category : #test }
MicroPythonParserTest >> testParseStringDelimiter [
	| p s |
	p := self newParser.
	s := ReadStream on: 'abc"'.
	self assert: (p parseString: s delimiter: $") equals: 'abc'.
	s := ReadStream on: 'abc def'''.
	self assert: (p parseString: s delimiter: $') equals: 'abc def'.
	s := ReadStream on: 'abc\ndef"'.
	self
		assert: (p parseString: s delimiter: $")
		equals: 'abc' , String lf , 'def'
]

{ #category : #test }
MicroPythonParserTest >> testParseTuple [
	| p s r |
	s := ReadStream on: '()'.
	p := self newParser.
	p stream: s.
	r := p parseTuple.
	self assert: r isArray.
	self assert: r isEmpty.
	s := ReadStream on: '(1 , 2,3 )'.
	p := self newParser.
	p stream: s.
	r := p parseTuple.
	self assertCollection: r equals: #(1 2 3)
]

{ #category : #test }
MicroPythonParserTest >> testStream [
	| p s |
	p := self newParser.
	self assert: p stream isNil.
	s := ReadStream on: 'abc'.
	p stream: s.
	self assert: p stream identicalTo: s
]

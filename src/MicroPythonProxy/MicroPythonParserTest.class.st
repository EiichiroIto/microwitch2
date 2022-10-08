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

	| p r |
	p := self newParser.
	r := p parse: '[''main.py'',''boot.py'']'.
	self assertCollection: r equals: { 'main.py'. 'boot.py' } asOrderedCollection.
	r := p parse: '123'.
	self assert: r equals: 123.
	r := p parse: '''abc'''.
	self assert: r equals: 'abc'.
	r := p parse: ''.
	self assert: r isNil.
	r := p parse: '[]'.
	self assert: r isCollection.
	self assert: r isEmpty.
	r := p parse: '[1 , 2,3 ]'.
	self assertCollection: r equals: #( 1 2 3 ) asOrderedCollection
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
	self assert: list isCollection.
	self assert: list isEmpty.
	in := ReadStream on: '[123,456]'.
	list := p parseItem: in.
	self assertCollection: list equals: #( 123 456 ) asOrderedCollection.
	in := ReadStream on: '[''main.py'']'.
	list := p parseItem: in.
	self
		assertCollection: list
		equals: #( 'main.py' ) asOrderedCollection.
	in := ReadStream on: '()'.
	list := p parseItem: in.
	self assert: list isArray.
	self assert: list isEmpty.
	in := ReadStream on: '(123,456)'.
	list := p parseItem: in.
	self assertCollection: list equals: #( 123 456 ).
	in := ReadStream on: '(''main.py'')'.
	list := p parseItem: in.
	self assertCollection: list equals: #( 'main.py' )
]

{ #category : #test }
MicroPythonParserTest >> testParseItemsDelimiter [

	| p in list |
	p := self newParser.
	in := ReadStream on: '123,456 , 789]'.
	list := p parseItems: in delimiter: $].
	self
		assertCollection: list
		equals: #( 123 456 789 ) asOrderedCollection.
	self assert: in atEnd.
	in := ReadStream on: '    ]'.
	list := p parseItems: in delimiter: $].
	self assert: list isCollection.
	self assert: list isEmpty.
	p := self newParser.
	in := ReadStream on: '123,456 , 789)'.
	list := p parseItems: in delimiter: $).
	self
		assertCollection: list
		equals: #( 123 456 789 ) asOrderedCollection.
	self assert: in atEnd.
	in := ReadStream on: '    )'.
	list := p parseItems: in delimiter: $).
	self assert: list isCollection.
	self assert: list isEmpty
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
		equals: 'abc' , String lf , 'def'.
	s := ReadStream on: 'abc\tdef"'.
	self
		assert: (p parseString: s delimiter: $")
		equals: 'abc' , String tab , 'def'
]

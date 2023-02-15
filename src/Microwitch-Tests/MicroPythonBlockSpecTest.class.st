"
A MicroPythonBlockSpecTest is a test class for testing the behavior of MicroPythonBlockSpec
"
Class {
	#name : #MicroPythonBlockSpecTest,
	#superclass : #TestCase,
	#category : #'Microwitch-Tests'
}

{ #category : #private }
MicroPythonBlockSpecTest >> newObj [

	^ MicroPythonBlockSpec new
]

{ #category : #test }
MicroPythonBlockSpecTest >> testArgPermutation [

	| d |
	d := self newObj.
	d
		label: '%a of %b of %c of %d';
		code: '%a de %b de %c de %d'.
	self assertCollection: d argPermutation equals: #( 1 2 3 4 ).
	d code: '%d de %c de %b de %a'.
	self assertCollection: d argPermutation equals: #( 4 3 2 1 ).

	d
		label: '%a of %m of %m of %t';
		code: '%a de %m de %m de %t'.
	self assertCollection: d argPermutation equals: #( 1 2 3 4 ).
	d code: '%t de %m2 de %m1 de %a'.
	self assertCollection: d argPermutation equals: #( 4 3 2 1 ).
	d code: '%t1 de %m2 %t1 de %m1 de %a'.
	self assertCollection: d argPermutation equals: #( 4 3 4 2 1 )
]

{ #category : #test }
MicroPythonBlockSpecTest >> testCode [

	| obj |
	obj := self newObj.
	self assert: obj code isNil.
	obj code: 'init %s'.
	self assert: obj code equals: 'init %s'.
	obj code: 'return'.
	self assert: obj code equals: 'return'
]

{ #category : #test }
MicroPythonBlockSpecTest >> testCodeWithArgs [

	| d ret |
	d := self newObj.
	d label: 'a %n b %n'.
	d code: '%n2=%n1'.
	ret := d codeWithArgs: { 3. 4 }.
	self assert: ret equals: '4=3'.
	d := self newObj.
	d label: 'a %n b %n'.
	d code: '%n2=%n1'.
	ret := d codeWithArgs: { 'abc'. 'def' }.
	self assert: ret equals: 'def=abc'.
	d label: 'set digital pin %n for %P'.
	d code: '_pin%n1=Pin(%n1,Pin.%P)'.
	ret := d codeWithArgs: { '5'. 'OUTPUT' }.
	self assert: ret equals: '_pin5=Pin(5,Pin.OUTPUT)'.
	d label: 'set pwm pin %n freq %n duty %n'.
	d code: '_pwm%n1=PWM(Pin(%n1),freq=%n2,duty=%n3)'.
	ret := d codeWithArgs: { '3'. '123'. '456' }.
	self assert: ret equals: '_pwm3=PWM(Pin(3),freq=123,duty=456)'.
	d label: 'i2c write %s to %n'.
	d code: 'i2c.write(%n,bytes(%''s))'.
	ret := d codeWithArgs: { 
			       [ '''[1,2,3]''' ].
			       [ 5 ] }.
	self assert: ret equals: 'i2c.write(5,bytes([1,2,3]))'.
	d label: '%n mod %n'.
	d code: '(%n % %n)'.
	ret := d codeWithArgs: { 1. 2 }.
	self assert: ret equals: '(1 % 2)'
]

{ #category : #test }
MicroPythonBlockSpecTest >> testEvaluatedArgs [

	| d ret |
	d := self newObj.
	d label: 'lcd text %s at %n , %n fg %c bg %c'.
	d code: 'lcd.draw_string(%n1,%n2,%s,lcd.%c1,lcd.%c2)'.
	ret := d evaluatedArgs: { 
			       [ 'hello' ].
			       [ '101' ].
			       [ '102' ].
			       [ 'RED' ].
			       [ 'BLACK' ] }.
	self
		assertCollection: ret
		equals: #( '101' '102' 'hello' 'RED' 'BLACK' ).
	d label: 'set digital pin %n for %P'.
	d code: '_pin%n1=Pin(%n1,Pin.%P)'.
	ret := d evaluatedArgs: { 
			       [ 5 ].
			       [ 'OUTPUT' ] }.
	self assertCollection: ret equals: #( '5' '5' 'OUTPUT' ).
	d label: 'abc %s def %n'.
	d code: 'x%''sy%n'.
	ret := d evaluatedArgs: { 
			       [ '''OUTPUT''' ].
			       [ 5 ] }.
	self assertCollection: ret equals: #( 'OUTPUT' '5' ).
	d label: 'i2c write %s to %n'.
	d code: 'i2c.write(%n,bytes(%''s))'.
	ret := d evaluatedArgs: { 
			       [ '''[1,2,3]''' ].
			       [ 0 ] }.
	self assertCollection: ret equals: #( '0' '[1,2,3]' )
]

{ #category : #test }
MicroPythonBlockSpecTest >> testFindPosIn [

	| d |
	d := self newObj.
	self assert: (d findPos: '%a' in: #('%a' '%b' '%c' '%d')) equals: 1.
	self assert: (d findPos: '%b' in: #('%a' '%b' '%c' '%d')) equals: 2.
	self assert: (d findPos: '%c' in: #('%a' '%b' '%c' '%d')) equals: 3.
	self assert: (d findPos: '%d' in: #('%a' '%b' '%c' '%d')) equals: 4.
	self assert: (d findPos: '%a1' in: #('%a' '%a' '%a' '%a')) equals: 1.
	self assert: (d findPos: '%a2' in: #('%a' '%a' '%a' '%a')) equals: 2.
	self assert: (d findPos: '%a3' in: #('%a' '%a' '%a' '%a')) equals: 3.
	self assert: (d findPos: '%a4' in: #('%a' '%a' '%a' '%a')) equals: 4.
	self assert: (d findPos: '%b1' in: #('%a' '%b' '%b' '%a')) equals: 2.
	self assert: (d findPos: '%b2' in: #('%a' '%b' '%b' '%a')) equals: 3
]

{ #category : #test }
MicroPythonBlockSpecTest >> testImports [

	| obj |
	obj := self newObj.
	self assert: obj imports isNil.
	obj imports: #( microbit ).
	self assertCollection: obj imports equals: #( microbit ).
	obj imports: #( #( microbit I2C ) ).
	self assertCollection: obj imports equals: #( #( microbit I2C ) )
]

{ #category : #test }
MicroPythonBlockSpecTest >> testIsArgSpec [

	| d |
	d := self newObj.
	self assert: (d isArgSpec: '%a').
	self assert: (d isArgSpec: '%b').
	self deny: (d isArgSpec: '%').
	self deny: (d isArgSpec: 'x')
]

{ #category : #test }
MicroPythonBlockSpecTest >> testIsUnquoteArg [

	| d |
	d := self newObj.
	self deny: (d isUnquoteArg: '%a').
	self deny: (d isUnquoteArg: '%b').
	self deny: (d isUnquoteArg: '%').
	self deny: (d isUnquoteArg: '%''').
	self deny: (d isUnquoteArg: 'x').
	self assert: (d isUnquoteArg: '%''a').
	self assert: (d isUnquoteArg: '%''b')
]

{ #category : #test }
MicroPythonBlockSpecTest >> testModuleName [

	| obj |
	obj := self newObj.
	self assert: obj moduleName isNil.
	obj moduleName: 'micropython'.
	self assert: obj moduleName equals: 'micropython'.
	obj moduleName: 'microbit'.
	self assert: obj moduleName equals: 'microbit'
]

{ #category : #test }
MicroPythonBlockSpecTest >> testParseCommandSpec [

	| d |
	d := self newObj.
	self
		assertCollection: (d parseCommandSpec: 'abc %n')
		equals: #(abc '%n').
	self
		assertCollection: (d parseCommandSpec: 'abc %n    def %s')
		equals: #(abc '%n' def '%s').
	self
		assertCollection: (d parseCommandSpec: 'abc%n1def%s23gh')
		equals: #(abc '%n1' def '%s23' gh).
	self
		assertCollection: (d parseCommandSpec: 'abc% def%')
		equals: #(abc '%' def '%').
	self
		assertCollection: (d parseCommandSpec: 'abc%''a def%')
		equals: #(abc '%''a' def '%')
]

{ #category : #test }
MicroPythonBlockSpecTest >> testSplitArg [

	| d |
	d := self newObj.
	self assert: (d splitArg: '%') equals: #('%' '').
	self assert: (d splitArg: '%a') equals: #('%a' '').
	self assert: (d splitArg: '%a1') equals: #('%a1' '').
	self assert: (d splitArg: '%''a1') equals: #('%''a1' '').
	self assert: (d splitArg: '%ab') equals: #('%a' 'b').
	self assert: (d splitArg: '%%') equals: #('%' '%').
	self assert: (d splitArg: '%$') equals: #('%' '$')
]

{ #category : #test }
MicroPythonBlockSpecTest >> testUnquoteString [

	| g |
	g := self newObj.
	self assert: (g unquoteString: 'abc') equals: 'abc'.
	self assert: (g unquoteString: '''abc') equals: '''abc'.
	self assert: (g unquoteString: 'abc''') equals: 'abc'''.
	self assert: (g unquoteString: '''abc''') equals: 'abc'
]

{ #category : #test }
MicroPythonBlockSpecTest >> testValueOf [

	| obj |
	obj := self newObj.
	self assert: (obj valueOf: 1) equals: '1'.
	self assert: (obj valueOf: [ 1 + 2 ]) equals: '3'
]

{ #category : #test }
MicroPythonBlockSpecTest >> testVar [

	| obj |
	obj := self newObj.
	self assert: obj var isNil.
	obj var: '_var'.
	self assert: obj var equals: '_var'.
	obj var: '_abc'.
	self assert: obj var equals: '_abc'
]

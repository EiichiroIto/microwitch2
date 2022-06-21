Class {
	#name : #MicroPythonBlockSpecs,
	#superclass : #Object,
	#instVars : [
		'intModuleDef'
	],
	#category : #'Microwitch-MPython'
}

{ #category : #'argument menus' }
MicroPythonBlockSpecs >> addArgBuilderTo: anArgBuilder [
	anArgBuilder
		addChoiceArg: $a selector: #allSubNames;
		addChoiceArg: $d
			selector: #digits
			target: self
			initialChoice: '0';
		addNumberExpressArg: $i
			selector: #listIndexNames
			target: self
			initialExpression: '0';
		addNumberExpressArg: $y
			selector: #listIndexForDeleteNames
			target: self
			initialExpression: '0';
		add: $C builder: [ MicrobitLedArgMorph new ]
]

{ #category : #'block specs' }
MicroPythonBlockSpecs >> addBlockCategoryTo: aBlockDef [
	aBlockDef
		addCategory: 'lists' color: ScratchTheme listBlockColor;
		addCategory: 'misc' color: (Color h: 165 s: 1 v: 0.63)
]

{ #category : #private }
MicroPythonBlockSpecs >> addIntModuleDefNamed: aString [
	| m |
	m := MicroPythonProject intModuleAt: aString.
	m ifNil: [ ^ self ].
	intModuleDef := intModuleDef
		ifNil: [ m ]
		ifNotNil: [ intModuleDef + m ]
]

{ #category : #'block specs' }
MicroPythonBlockSpecs >> blocks [
	^ self ioBlocks , self displayBlocks
		, self controlBlocks , self operatorsBlocks
		, self sensingBlocks , self intModuleBlocks
]

{ #category : #'block specs' }
MicroPythonBlockSpecs >> controlBlocks [
	^ #(
		'control'
			('when %m clicked'		G	-)
			-
			('forever'					c	doForever)
			('repeat %n each %l'	c	doRepeat 10 'i')
			('while %b'					c	doWhile)
			('repeat until %b'		c	doUntil)
			('do %s each %l'			c	doIterate 'list')
			-
			('if %b'						c	doIf)
			('if %b'						c	doIfElse)
	)
]

{ #category : #'argument menus' }
MicroPythonBlockSpecs >> digits [
	^ (0 to: 9) collect: [ :each | each asString ]
]

{ #category : #'block specs' }
MicroPythonBlockSpecs >> displayBlocks [
	^ #()
]

{ #category : #initialization }
MicroPythonBlockSpecs >> initialize [
	self setupIntModuleDef
]

{ #category : #'block specs' }
MicroPythonBlockSpecs >> intBlockDefOf: aSymbol [
	^ intModuleDef
		ifNil: [ nil ]
		ifNotNil: [ :m | m blockDefAt: aSymbol ]
]

{ #category : #'block specs' }
MicroPythonBlockSpecs >> intModuleBlocks [
	^ intModuleDef
		ifNil: [ #() ]
		ifNotNil: [ :def | def blockTuples asArray ]
]

{ #category : #'block specs' }
MicroPythonBlockSpecs >> ioBlocks [
	^ #()
]

{ #category : #'block specs' }
MicroPythonBlockSpecs >> isInternalBlock: aSymbol [
	^ intModuleDef
		ifNil: [ false ]
		ifNotNil: [ :m | m includes: aSymbol ]
]

{ #category : #'argument menus' }
MicroPythonBlockSpecs >> listIndexForDeleteNames [
	^ #('0' last all)
		collect: [ :s | 
			{s localized.
			s} ]
]

{ #category : #'argument menus' }
MicroPythonBlockSpecs >> listIndexNames [
	^ #('0' last) collect: [ :s | {s localized. s} ]
]

{ #category : #'block specs' }
MicroPythonBlockSpecs >> modulesBlocks [
	^ #(
		'modules'
			('execute %a of %m'		-		execute:of: '' '')
			('evaluate %a of %m'		r 		evaluate:of: '' '')
			-
		)
]

{ #category : #'block specs' }
MicroPythonBlockSpecs >> operatorsBlocks [
	^ #(
		'operators'
			('%n + %n'							r	+ - -)
			('%n - %n'							r	- - -)
			('%n * %n'							r	* - -)
			('%n / %n'							r	/ - -)
			('%n div %n'							r	// - -)
			('%n mod %n'							r	\\ - -)
			('- %n'									r	negated: 1)
			-
			('pick random %n to %n'		r	randomFrom:to: 1 10)
			('set random seed to %n'	-	setRandomSeed: 1234)
			-
			('%s < %s'							b	< '' '')
			('%s = %s'							b	= '' '')
			('%s > %s'							b	> '' '')
			('%n between %n and %n'		b 	is:between:and: 20 10 30)
			('%s is None'						b	isNone:)
			-
			('%b and %b'						b	&)
			('%b or %b'							b	|)
			('not %b'								b	not:)
			('true'									b	getTrue)
			('false'								b	getFalse)
			-
			('%n bitand %n'					r	bit:and:	2	6)
			('%n bitor %n'						r	bit:or:		2	6)
			('%n bitxor %n'					r	bit:xor:	2	6)
			('%n bit shift left %n'		r	bit:shiftLeft:		1	5)
			('%n bit shift right %n'	r	bit:shiftRight:	256	6)
			-
			('string of %n'				r	stringOf:	0)
			('number of %s'				r	numberOf: '123')
			('join %s %s'					r	concatenate:with: 'hello ' 'world')
			('item %n of %s'				r	letter:of: 0 'world')
			('length of %s'				r	stringLength: 'world')
			('any of %s'					r	anyOf: 'hello')
			-
			('round %n'							r	rounded: -)
			('truncate %n'						r	truncated: -)
			('abs %n'								r	abs: -)
			('abs %n sign %n'			r	abs:sign:	- -)
			('%f of %n'							r	computeFunction:of: 'sqrt' 10)
			-
			('string from %s encoding %s'
													r	stringFrom:encoding: '' 'utf8')
			('bytes from %s encoding %s'
													r	bytesFrom:encoding: 'abc' 'utf8')
	)
]

{ #category : #'block specs' }
MicroPythonBlockSpecs >> sensingBlocks [
	^ #()
]

{ #category : #private }
MicroPythonBlockSpecs >> setupIntModuleDef [
	intModuleDef := nil.
	self addIntModuleDefNamed: 'micropython'
]

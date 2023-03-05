Class {
	#name : #MicroPythonScript,
	#superclass : #ScratchScript,
	#instVars : [
		'varNames'
	],
	#category : #'Microwitch-Project'
}

{ #category : #'ston-core' }
MicroPythonScript class >> stonAllInstVarNames [
	^ super stonAllInstVarNames , #(objName varNames)
]

{ #category : #'argument menus' }
MicroPythonScript >> addArgBuilder [

	argMorphBuilder
		addBooleanArg: $b;
		addEventTitleArg: $e;
		addChoiceArg: $f
		options:
			#( 'abs' 'sqrt' 'sin' 'cos' 'tan' 'asin' 'acos' 'atan' 'ln' 'log'
			   'e ^' '10 ^' )
		initialChoice: 'sqrt';
		addLocalVarArg: $l;
		addChoiceArg: $L selector: #listVarNames;
		addSpriteArg: $m;
		addNumberExpressArg: $n initialExpression: '10';
		addChoiceArg: $S selector: #subNames;
		addStringExpressArg: $s;
		addChoiceArg: $v selector: #varNames;
		addChoiceArg: $a selector: #allSubNames;
		addNumberExpressArg: $i
		selector: #listIndexNames
		target: self
		initialExpression: '0';

		addChoiceArg: $B options: #( a b ) initialChoice: 'a';

		add: $C builder: [ MicrobitLedArgMorph new ];

		addNumberExpressArg: $y
		selector: #listIndexForDeleteNames
		target: self
		initialExpression: '0';

		addChoiceArg: $T
		options: #( pin_logo pin0 pin1 pin2 )
		initialChoice: 'pin_logo'.
	project addBlockSpecsTo: argMorphBuilder
]

{ #category : #'block specs' }
MicroPythonScript >> addBlockSpecs [

	self
		addControlBlockSpecs;
		addIoBlockSpecs;
		addVariableBlockSpecs.
	project addBlockSpecsTo: blockMorphBuilder.
	self addOperatorsBlockSpecs
]

{ #category : #'block specs' }
MicroPythonScript >> addControlBlockSpecs [

	blockMorphBuilder
		addCategory: 'control';
		addStartHatBlock: 'when start' selector: #start;
		addSeparator;
		addCBlock: 'forever' selector: #doForever arguments: #(  );
		addCBlock: 'repeat %n each %l'
		selector: #doRepeat
		arguments: #( 10 'i' );
		addCBlock: 'while %b' selector: #doWhile arguments: #(  );
		addCBlock: 'repeat until %b' selector: #doUntil arguments: #(  );
		addCBlock: 'do %s each %l'
		selector: #doIterate
		arguments: #( 'list' );
		addSeparator;
		addCBlock: 'if %b' selector: #doIf arguments: #(  );
		addCBlock: 'if %b' selector: #doIfElse arguments: #(  )
]

{ #category : #'block specs' }
MicroPythonScript >> addIoBlockSpecs [

	blockMorphBuilder
		addCategory: 'io';
		addBooleanReporter: 'button %B is pressed' selector: #buttonIsPressed:;
		addBooleanReporter: 'button %B was pressed' selector: #buttonWasPressed:;
		addBooleanReporter: '%T is touched' selector: #pinIsTouched: arguments: #( pin_logo );
		addReporter: 'count of button %B pressed' selector: #countOfButtonPressed:;
		addSeparator;
		addCommand: 'servo set pin %G %n msec %n to %n' selector: #setServo:msec:min:max: arguments: #( 0 5 100 500 );
		addCommand: 'servo write pin %G to %n degrees' selector: #writeServo:to: arguments: #( 0 180 )
]

{ #category : #variables }
MicroPythonScript >> addList: aString [

	self shouldNotImplement
]

{ #category : #'block specs' }
MicroPythonScript >> addOperatorsBlockSpecs [

	blockMorphBuilder
		addCategory: 'operators';
		addReporter: '%f of %n'
		selector: #computeFunction:of:
		arguments: #( 'sqrt' 10 )
]

{ #category : #variables }
MicroPythonScript >> addVariable: aString [
	varNames add: aString
]

{ #category : #'block specs' }
MicroPythonScript >> addVariableBlockSpecs [

	blockMorphBuilder
		addCategory: nil;
		addReporter: 'dummy' selector: #getVar: arguments: #( 0 );
		addCommand: 'dummy' selector: #setVar:to: arguments: #( 0 0 );
		addCommand: 'dummy' selector: #changeVar:by: arguments: #( 0 0 )
]

{ #category : #'argument menus' }
MicroPythonScript >> allSubNames [
	^ project allSubNames
]

{ #category : #blocks }
MicroPythonScript >> compareHatBlock: a and: b [
	| aIsSubHat bIsSubHat |
	aIsSubHat := a isKindOf: SubHatMorph.
	bIsSubHat := b isKindOf: SubHatMorph.
	(aIsSubHat and: [ bIsSubHat ])
		ifTrue: [ ^ a subName < b subName ].
	aIsSubHat
		ifTrue: [ ^ true ].
	bIsSubHat
		ifTrue: [ ^ false ].
	^ a eventName < b eventName
]

{ #category : #'block building' }
MicroPythonScript >> convertEventHatTuple: anArray [

	anArray first = #EventHatMorph ifTrue: [ ^ Array with: #start ].
	anArray first = #SubHatMorph ifTrue: [ 
		^ Array with: #sub: with: anArray second ].
	^ anArray
]

{ #category : #variables }
MicroPythonScript >> deleteList: aString [

	self shouldNotImplement
]

{ #category : #variables }
MicroPythonScript >> deleteVariable: aString [
	varNames remove: aString ifAbsent: [  ]
]

{ #category : #evaluation }
MicroPythonScript >> evaluateBlock: aTopBlock [
	^ project evaluateBlock: aTopBlock
]

{ #category : #'object i/o' }
MicroPythonScript >> fieldsVersion [
	^ 1
]

{ #category : #blocks }
MicroPythonScript >> hatBlocks [
	| list |
	list := super hatBlocks.
	list := list sort: [ :a :b | self compareHatBlock: a and: b ].
	^ list
]

{ #category : #testing }
MicroPythonScript >> identifierInUse: aString [

	^ (varNames includes: aString) or: [ super subNameInUse: aString ]
]

{ #category : #'object i/o' }
MicroPythonScript >> initFieldsFrom: anObjStream version: classVersion [
	super initFieldsFrom: anObjStream version: classVersion.
	self
		initFieldsNamed: #(objName varNames)
		from: anObjStream
]

{ #category : #initialization }
MicroPythonScript >> initialize [
	super initialize.
	varNames := OrderedCollection new
]

{ #category : #introspection }
MicroPythonScript >> instVarNamed: aString put: aValue [

	[ super instVarNamed: aString put: aValue ]
		on: InstanceVariableNotFound
		do: [ :err | self inform: err instVarName ]
]

{ #category : #testing }
MicroPythonScript >> isValidSubName: aString [
	aString isEmpty
		ifTrue: [ ^ false ].
	aString first isDigit
		ifTrue: [ ^ false ].
	^ aString allSatisfy: [ :each | each isAlphaNumeric ]
]

{ #category : #'argument menus' }
MicroPythonScript >> listIndexForDeleteNames [

	^ #( '0' last all ) collect: [ :s | 
		  { 
			  s localized.
			  s } ]
]

{ #category : #'argument menus' }
MicroPythonScript >> listIndexNames [

	^ #( '0' last ) collect: [ :s | 
		  { 
			  s localized.
			  s } ]
]

{ #category : #'argument menus' }
MicroPythonScript >> listVarNames [
	^ #()
]

{ #category : #'control ops' }
MicroPythonScript >> mwait: duration elapsed: elapsed from: ignored [
	^ nil
]

{ #category : #accessing }
MicroPythonScript >> objName [

	^ 'main'
]

{ #category : #'block specs' }
MicroPythonScript >> setupBlockCategory [

	blockMorphBuilder
		setCategory: 'control' color: (Color h: 41 s: 0.85 v: 0.9);
		setCategory: 'operators' color: (Color h: 93 s: 0.9 v: 0.76);
		setCategory: 'sensing' color: (Color h: 200 s: 0.98 v: 0.86);
		setCategory: 'variables' color: ScratchTheme variableBlockColor;
		setCategory: 'lists' color: ScratchTheme listBlockColor;
		setCategory: 'misc' color: (Color h: 165 s: 1 v: 0.63);
		setCategory: 'io' color: (Color h: 225 s: 0.65 v: 0.83);
		setCategory: 'accelerometer' color: (Color h: 200 s: 0.98 v: 0.86);
		setCategory: 'compass' color: (Color h: 200 s: 0.98 v: 0.86);
		setCategory: 'radio' color: (Color h: 165 s: 1 v: 0.63);
		setCategory: 'uart' color: (Color h: 165 s: 1 v: 0.63);
		setCategory: 'i2c' color: (Color h: 165 s: 1 v: 0.63);
		setCategory: 'music' color: (Color h: 264 s: 0.62 v: 0.89);
		setCategory: 'display' color: (Color h: 264 s: 0.62 v: 0.89);
		setCategory: 'neopixel' color: (Color h: 264 s: 0.62 v: 0.89)
]

{ #category : #'block specs' }
MicroPythonScript >> startHatBlockNames [

	^ #( start )
]

{ #category : #processes }
MicroPythonScript >> stopAllProcesses [
	blocksBin isArray
		ifTrue: [ ^ self ].
	blocksBin
		submorphsDo: [ :each | 
			each isBlockMorph
				ifTrue: [ each clearProcess.
					each litUp: false ] ]
]

{ #category : #'block specs' }
MicroPythonScript >> stopBlockSelectors [

	^ super stopBlockSelectors , #(panic: reset)
]

{ #category : #'object i/o' }
MicroPythonScript >> storeFieldsOn: anObjStream [
	super storeFieldsOn: anObjStream.
	self storeFieldsNamed: #(objName varNames) on: anObjStream.
]

{ #category : #testing }
MicroPythonScript >> subNameInUse: aString [

	^ self identifierInUse: aString
]

{ #category : #accessing }
MicroPythonScript >> toggleWatcher: aToggleButton for: aBlockMorph [

	self shouldNotImplement
]

{ #category : #accessing }
MicroPythonScript >> updateWatcher: aToggleButton for: aBlockMorph [

	self shouldNotImplement
]

{ #category : #testing }
MicroPythonScript >> useList [
	^ false
]

{ #category : #testing }
MicroPythonScript >> useVariableWatcher [
	^ false
]

{ #category : #'argument menus' }
MicroPythonScript >> varNames [
	^ varNames
]

{ #category : #variables }
MicroPythonScript >> variableNameInUse: aString [

	^ self identifierInUse: aString
]

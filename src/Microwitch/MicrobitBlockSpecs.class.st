Class {
	#name : #MicrobitBlockSpecs,
	#superclass : #MicroPythonBlockSpecs,
	#category : #'Microwitch-Microbit'
}

{ #category : #'argument menus' }
MicrobitBlockSpecs >> addArgBuilderTo: anArgBuilder [

	super addArgBuilderTo: anArgBuilder.
	anArgBuilder
		addChoiceArg: $B options: #( a b ) initialChoice: 'a';
		addChoiceArg: $T
		options: #( pin_logo pin0 pin1 pin2 )
		initialChoice: 'pin_logo'
]

{ #category : #'block specs' }
MicrobitBlockSpecs >> addBlockCategoryTo: aBlockDef [
	super addBlockCategoryTo: aBlockDef.
	aBlockDef
		addCategory: 'io' color: (Color h: 225 s: 0.65 v: 0.83);
		addCategory: 'accelerometer' color: (Color h: 200 s: 0.98 v: 0.86);
		addCategory: 'compass' color: (Color h: 200 s: 0.98 v: 0.86);
		addCategory: 'radio' color: (Color h: 165 s: 1 v: 0.63);
		addCategory: 'uart' color: (Color h: 165 s: 1 v: 0.63);
		addCategory: 'i2c' color: (Color h: 165 s: 1 v: 0.63);
		addCategory: 'music' color: (Color h: 264 s: 0.62 v: 0.89);
		addCategory: 'display' color: (Color h: 264 s: 0.62 v: 0.89);
		addCategory: 'neopixel' color: (Color h: 264 s: 0.62 v: 0.89)
]

{ #category : #'block specs' }
MicrobitBlockSpecs >> ioBlocks [
	^ super ioBlocks , #(
		'io'
			('button %B is pressed'				b		buttonIsPressed:)
			('button %B was pressed'				b		buttonWasPressed:)
			('%T is touched'							b		pinIsTouched: pin_logo)
			('count of button %B pressed'		r		countOfButtonPressed:)
			-
			('servo set pin %G %n msec %n to %n'
																	-		setServo:msec:min:max:	0	5	100	500)
			('servo write pin %G to %n degrees'
																	-		writeServo:to: 0 180)
		)
]

{ #category : #private }
MicrobitBlockSpecs >> setupIntModuleDef [
	super setupIntModuleDef.
	self addIntModuleDefNamed: 'microbit'
]

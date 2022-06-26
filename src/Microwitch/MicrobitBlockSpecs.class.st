Class {
	#name : #MicrobitBlockSpecs,
	#superclass : #MicroPythonBlockSpecs,
	#category : #'Microwitch-Microbit'
}

{ #category : #'argument menus' }
MicrobitBlockSpecs >> addArgBuilderTo: anArgBuilder [
	super addArgBuilderTo: anArgBuilder.
	anArgBuilder
		addChoiceArg: $A
			selector: #ledArrowNames
			target: self
			initialChoice: '';
		addChoiceArg: $B
			selector: #buttonNames
			target: self
			initialChoice: 'a';
		addChoiceArg: $c
			selector: #ledClockNames
			target: self
			initialChoice: '';
		addChoiceArg: $g
			selector: #gestureNames
			target: self
			initialChoice: '';
		addChoiceArg: $G
			selector: #ioPinNames
			target: self
			initialChoice: '';
		addChoiceArg: $F
			selector: #analogPinNames
			target: self
			initialChoice: '';
		addChoiceArg: $H
			selector: #ledShapeNames
			target: self
			initialChoice: '';
		addChoiceArg: $I
			selector: #ledCharacterNames
			target: self
			initialChoice: '';
		addChoiceArg: $M
			selector: #ledSymbolNames
			target: self
			initialChoice: '';
		addChoiceArg: $T
			selector: #touchPinNames
			target: self
			initialChoice: '';
		addChoiceArg: $U
			selector: #microphoneNames
			target: self
			initialChoice: '';
		addChoiceArg: $P
			selector: #musicNames
			target: self
			initialChoice: ''
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

{ #category : #'argument menus' }
MicrobitBlockSpecs >> analogPinNames [
	^ #(0 1 2 3 4 10)
]

{ #category : #'argument menus' }
MicrobitBlockSpecs >> buttonNames [
	^ #(a b)
]

{ #category : #'argument menus' }
MicrobitBlockSpecs >> gestureNames [
	^ #(up down left right 'face up' 'face down' freefall '3g' '6g' '8g' shake)
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

{ #category : #'argument menus' }
MicrobitBlockSpecs >> ioPinNames [
	^ (0 to: 16) , #(19 20)
]

{ #category : #'argument menus' }
MicrobitBlockSpecs >> ledArrowNames [

	^ #( ARROW_N ARROW_NE ARROW_E ARROW_SE ARROW_S ARROW_SW ARROW_W
	     ARROW_NW )
]

{ #category : #'argument menus' }
MicrobitBlockSpecs >> ledCharacterNames [

	^ #( RABBIT COW MUSIC_CROTCHET MUSIC_QUAVER MUSIC_QUAVERS
	     PITCHFORK XMAS PACMAN TARGET TSHIRT ROLLERSKATE DUCK HOUSE TORTOISE
	     BUTTERFLY STICKFIGURE GHOST SWORD GIRAFFE SKULL UMBRELLA
	     SNAKE )
]

{ #category : #'argument menus' }
MicrobitBlockSpecs >> ledClockNames [

	^ #( CLOCK12 CLOCK1 CLOCK2 CLOCK3 CLOCK4 CLOCK5 CLOCK6 CLOCK7 CLOCK8
	     CLOCK9 CLOCK10 CLOCK11 )
]

{ #category : #'argument menus' }
MicrobitBlockSpecs >> ledShapeNames [

	^ #( TRIANGLE TRIANGLE_LEFT CHESSBOARD DIAMOND DIAMOND_SMALL
	     SQUARE SQUARE_SMALL )
]

{ #category : #'argument menus' }
MicrobitBlockSpecs >> ledSymbolNames [

	^ #( HEART HEART_SMALL HAPPY SMILE SAD CONFUSED ANGRY ASLEEP SURPRISED
	     SILLY FABULOUS MEH YES NO )
]

{ #category : #'argument menus' }
MicrobitBlockSpecs >> microphoneNames [
	^ #(QUIET LOUD)
]

{ #category : #'argument menus' }
MicrobitBlockSpecs >> musicNames [

	^ #( DADADADUM ENTERTAINER PRELUDE ODE NYAN RINGTONE FUNK BLUES BIRTHDAY
	     WEDDING FUNERAL PUNCHLINE PYTHON BADDY CHASE BA_DING WAWAWAWAA
	     JUMP_UP JUMP_DOWN POWER_UP POWER_DOWN )
]

{ #category : #private }
MicrobitBlockSpecs >> setupIntModuleDef [
	super setupIntModuleDef.
	self addIntModuleDefNamed: 'microbit'
]

{ #category : #'argument menus' }
MicrobitBlockSpecs >> touchPinNames [
	^ #(pin_logo pin0 pin1 pin2)
]

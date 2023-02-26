Class {
	#name : #MicrobitGenerator,
	#superclass : #MicroPythonGenerator,
	#instVars : [
		'servos'
	],
	#category : #'MicroPythonBlocks-Process'
}

{ #category : #private }
MicrobitGenerator >> addServo: num [
	servos add: (self valueOf: num) asNumberNoError
]

{ #category : #private }
MicrobitGenerator >> button: aString [
	self from: 'microbit' import: 'button_' , aString.
	^ 'button_' , aString , '.'
]

{ #category : #'io ops' }
MicrobitGenerator >> buttonIsPressed: button [
	^ (self button: button) , (self nullaryFunction: 'is_pressed')
]

{ #category : #'io ops' }
MicrobitGenerator >> buttonWasPressed: button [
	^ (self button: button) , (self nullaryFunction: 'was_pressed')
]

{ #category : #'io ops' }
MicrobitGenerator >> countOfButtonPressed: button [
	^ (self button: button) , (self nullaryFunction: 'get_presses')
]

{ #category : #private }
MicrobitGenerator >> delServo: num [
	servos remove: (self valueOf: num) asNumberNoError ifAbsent: [  ]
]

{ #category : #initialization }
MicrobitGenerator >> initialize [
	super initialize.
	servos := Set new
]

{ #category : #private }
MicrobitGenerator >> microbit [
	self import: 'microbit'.
	^ 'microbit.'
]

{ #category : #private }
MicrobitGenerator >> pin: anInteger [
	^ self microbit, 'pin', (self valueOf: anInteger)
]

{ #category : #'io ops' }
MicrobitGenerator >> pinIsTouched: pin [

	self from: 'microbit' import: pin.
	^ pin , '.' , (self nullaryFunction: 'is_touched')
]

{ #category : #private }
MicrobitGenerator >> servos [
	^ servos
]

{ #category : #'io ops' }
MicrobitGenerator >> setServo: pin msec: msec min: min max: max [
	| p |
	p := self valueOf: pin.
	self
		appendWithNewline: (self pin: pin) , '.' , (self unaryFunction: 'set_analog_period' arg: msec).
	self
		appendWithNewline:
			'(_smin' , p , ',_smax' , p , ')=(' , (self valueOf: min) , ','
				, (self valueOf: max) , ')'.
	self delServo: p
]

{ #category : #'io ops' }
MicrobitGenerator >> writeServo: pin to: num [
	| p |
	p := self valueOf: pin.
	self addServo: p.
	self
		appendWithNewline:
			(self pin: pin) , '.write_analog((' , (self valueOf: num) , '*(_smax'
				, p , '-_smin' , p , ')/180)+_smin' , p , ')'
]

"
A MicrobitBlockSpecsTest is a test class for testing the behavior of MicrobitBlockSpecs
"
Class {
	#name : #MicrobitBlockSpecsTest,
	#superclass : #TestCase,
	#category : #'Microwitch-Tests'
}

{ #category : #private }
MicrobitBlockSpecsTest >> newSpecs [
	^ MicrobitBlockSpecs new
]

{ #category : #test }
MicrobitBlockSpecsTest >> testTouchPinNames [
	| s r |
	s := self newSpecs.
	r := s touchPinNames.
	self assertCollection: r equals: #(pin_logo pin0 pin1 pin2)
]

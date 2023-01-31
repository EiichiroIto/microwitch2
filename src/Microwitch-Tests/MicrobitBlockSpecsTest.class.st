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

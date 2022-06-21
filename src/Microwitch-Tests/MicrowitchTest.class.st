"
A MicrowitchTest is a test class for testing the behavior of Microwitch
"
Class {
	#name : #MicrowitchTest,
	#superclass : #TestCase,
	#category : #'Microwitch-Tests'
}

{ #category : #private }
MicrowitchTest >> newApp [

	^ Microwitch new
]

{ #category : #test }
MicrowitchTest >> testNormalizeModuleName [

	| app |
	app := self newApp.
	self assert: (app normalizeModuleName: nil) isNil.
	self assert: (app normalizeModuleName: '') isEmpty.
	self assert: (app normalizeModuleName: 'abc') equals: 'abc'.
	self assert: (app normalizeModuleName: '1bc') equals: 'v1bc'.
	self assert: (app normalizeModuleName: 'a b c') equals: 'abc'.
	self assert: (app normalizeModuleName: '___') isEmpty.
	self assert: (app normalizeModuleName: 'a12345678901234567890') equals: 'a123456789012345'
]

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
MicrowitchTest >> testInitialize [

	| app |
	app := self newApp.
	self assert: app showOutput.
	self assert: app lastInput isEmpty
]

{ #category : #test }
MicrowitchTest >> testLastInput [

	| app |
	app := self newApp.
	self assert: app lastInput isEmpty.
	app lastInput: 'abc'.
	self assert: app lastInput equals: 'abc'.
	app lastInput: 'def'.
	self assert: app lastInput equals: 'def'
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

{ #category : #test }
MicrowitchTest >> testShowOutput [

	| app |
	app := self newApp.
	self assert: app showOutput.
	app showOutput: false.
	self deny: app showOutput.
	app showOutput: true.
	self assert: app showOutput
]

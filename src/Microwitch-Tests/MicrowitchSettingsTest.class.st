"
A MicrowitchSettingsTest is a test class for testing the behavior of MicrowitchSettings
"
Class {
	#name : #MicrowitchSettingsTest,
	#superclass : #TestCase,
	#category : #'Microwitch-Tests'
}

{ #category : #private }
MicrowitchSettingsTest >> newObj [

	^ MicrowitchSettings new
]

{ #category : #test }
MicrowitchSettingsTest >> testDefaultModules [

	| obj |
	obj := self newObj.
	self assert: obj defaultModules isEmpty.
	obj defaultModules: 'abc def'.
	self assert: obj defaultModules equals: 'abc def'
]

{ #category : #test }
MicrowitchSettingsTest >> testInitialize [

	| obj |
	obj := self newObj.
	self deny: obj dontClose.
	self assert: obj inputFlowControlType equals: 0.
	self assert: obj outputFlowControlType equals: 0.
	self assert: obj defaultModules isEmpty
]

{ #category : #test }
MicrowitchSettingsTest >> testInputFlowControlType [

	| obj |
	obj := self newObj.
	self assert: obj inputFlowControlType equals: 0.
	obj inputFlowControlType: 1.
	self assert: obj inputFlowControlType equals: 1
]

{ #category : #test }
MicrowitchSettingsTest >> testOptionsFor [

	| obj |
	obj := self newObj.
	self
		assertCollection: (obj optionsFor: #inputFlowControlType)
		equals: #( 0 1 2 ).
	self
		assertCollection: (obj optionsFor: #outputFlowControlType)
		equals: #( 0 1 2 ).
	self assert: (obj optionsFor: #defaultModules) equals: #string
]

{ #category : #test }
MicrowitchSettingsTest >> testOutputFlowControlType [

	| obj |
	obj := self newObj.
	self assert: obj outputFlowControlType equals: 0.
	obj outputFlowControlType: 1.
	self assert: obj outputFlowControlType equals: 1
]

{ #category : #test }
MicrowitchSettingsTest >> testUnusedPortNames [

	| obj |
	obj := self newObj.
	self assert: obj unusedPortNames isEmpty.
	obj unusedPortNames: 'abc def'.
	self assert: obj unusedPortNames equals: 'abc def'
]

"
A MicroWizScriptTest is a test class for testing the behavior of MicroWizScript
"
Class {
	#name : #MicroPythonScriptTest,
	#superclass : #TestCase,
	#category : #'Microwitch-Tests'
}

{ #category : #private }
MicroPythonScriptTest >> newScript [
	^ MicroPythonScript new
]

{ #category : #test }
MicroPythonScriptTest >> testAddVariable [
	| s |
	s := self newScript.
	self assert: s varNames isEmpty.
	s addVariable: 'abc'.
	s addVariable: 'def'.
	self assert: (s varNames includes: 'abc').
	self assert: (s varNames includes: 'def')
]

{ #category : #test }
MicroPythonScriptTest >> testCompareHatBlockAnd [
	| s a b |
	s := self newScript.
	a := SubHatMorph new subName: 'a'.
	b := SubHatMorph new subName: 'b'.
	self assert: (s compareHatBlock: a and: b).
	self deny: (s compareHatBlock: b and: a).
	a := EventHatMorph new eventName: 'a'.
	self assert: (s compareHatBlock: b and: a).
	self deny: (s compareHatBlock: a and: b)
]

{ #category : #test }
MicroPythonScriptTest >> testConvertEventHatTuple [

	| obj tuple r |
	obj := self newScript.
	tuple := Array with: #EventHatMorph with: #start.
	r := obj convertEventHatTuple: tuple.
	self assertCollection: r equals: #( start ).
	tuple := Array with: #start: with: 'abc'.
	r := obj convertEventHatTuple: tuple.
	self assert: r identicalTo: tuple
]

{ #category : #test }
MicroPythonScriptTest >> testDeleteVariable [
	| s |
	s := self newScript.
	self assert: s varNames isEmpty.
	s addVariable: 'abc'.
	s addVariable: 'def'.
	self assert: (s varNames includes: 'abc').
	self assert: (s varNames includes: 'def').
	self deny: (s varNames includes: 'ghi').
	s deleteVariable: 'abc'.
	s deleteVariable: 'ghi'.
	self deny: (s varNames includes: 'abc').
	self assert: (s varNames includes: 'def').
	self deny: (s varNames includes: 'ghi')
]

{ #category : #test }
MicroPythonScriptTest >> testHatBlocks [
	| s ret |
	s := self newScript.
	s blocksBin addMorph: (EventHatMorph new eventName: 'a').
	s blocksBin addMorph: (SubHatMorph new subName: 'b').
	s blocksBin addMorph: (SubHatMorph new subName: 'c').
	ret := s hatBlocks.
	self assert: ret first subName equals: 'b'.
	self assert: ret second subName equals: 'c'.
	self assert: ret third eventName equals: 'a'
]

{ #category : #test }
MicroPythonScriptTest >> testInitialize [
	| s |
	s := self newScript.
	self assert: s varNames isEmpty
]

{ #category : #test }
MicroPythonScriptTest >> testIsValidSubName [
	| s |
	s := self newScript.
	self assert: (s isValidSubName: 'abc').
	self assert: (s isValidSubName: 'abc123').
	self deny: (s isValidSubName: '').
	self deny: (s isValidSubName: ' ').
	self deny: (s isValidSubName: '2abc').
	self deny: (s isValidSubName: '2a-bc').
	self deny: (s isValidSubName: '2a bc')
]

{ #category : #test }
MicroPythonScriptTest >> testObjName [

	self assert: self newScript objName equals: 'main'
]

{ #category : #test }
MicroPythonScriptTest >> testUseList [

	self deny: self newScript useList
]

{ #category : #test }
MicroPythonScriptTest >> testUseVariableWatcher [

	self deny: self newScript useVariableWatcher
]

{ #category : #test }
MicroPythonScriptTest >> testVarNames [
	self testAddVariable
]

{ #category : #test }
MicroPythonScriptTest >> testVariableNameInUse [
	| s |
	s := self newScript.
	self deny: (s variableNameInUse: 'abc').
	self deny: (s variableNameInUse: 'def').
	self deny: (s variableNameInUse: 'ghi').
	s addVariable: 'abc'.
	self assert: (s variableNameInUse: 'abc').
	self deny: (s variableNameInUse: 'def').
	self deny: (s variableNameInUse: 'ghi')
]

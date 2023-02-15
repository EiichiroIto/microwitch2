"
A MicroPythonModuleTest is a test class for testing the behavior of MicroPythonModule
"
Class {
	#name : #MicroPythonModuleTest,
	#superclass : #TestCase,
	#category : #'Microwitch-Tests'
}

{ #category : #private }
MicroPythonModuleTest >> newObj [

	^ MicroPythonModule new
]

{ #category : #test }
MicroPythonModuleTest >> testBlockSpecs [

	| obj a |
	obj := self newObj.
	self assert: obj blockSpecs isNil.
	a := #( a b c ).
	obj blockSpecs: a.
	self assert: obj blockSpecs identicalTo: a
]

{ #category : #test }
MicroPythonModuleTest >> testName [

	| obj |
	obj := self newObj.
	self assert: obj name isNil.
	obj name: 'abc'.
	self assert: obj name equals: 'abc'.
	obj name: 'def'.
	self assert: obj name equals: 'def'
]

{ #category : #test }
MicroPythonModuleTest >> testPrintOn [

	| obj s |
	obj := self newObj.
	s := WriteStream on: String new.
	obj printOn: s.
	self assert: s contents equals: 'MicroPythonModule(nil)'.
	obj name: 'abc'.
	obj blockSpecs: #( a b c ).
	s := WriteStream on: String new.
	obj printOn: s.
	self assert: s contents equals: 'MicroPythonModule(abc, 3 blockSpecs)'
]

"
A MicroWizProjectTest is a test class for testing the behavior of MicroWizProject
"
Class {
	#name : #MicroPythonProjectTest,
	#superclass : #TestCase,
	#category : #'Microwitch-Tests'
}

{ #category : #private }
MicroPythonProjectTest >> newProject [
	^ MicroPythonProject new
]

{ #category : #test }
MicroPythonProjectTest >> testAddModule [
	| p |
	p := self newProject.
	self assert: p modules isEmpty.
	p addModule: #abc.
	self assert: p modules size equals: 1.
	self assert: p modules first equals: #abc.
	p addModule: #def.
	self assert: p modules size equals: 2.
	self assert: p modules first equals: #abc.
	self assert: p modules second equals: #def
]

{ #category : #test }
MicroPythonProjectTest >> testDeleteModule [
	| p |
	p := self newProject.
	self assert: p modules isEmpty.
	p addModule: #abc.
	p addModule: #def.
	p addModule: #ghi.
	self assert: p modules size equals: 3.
	self assert: p modules first equals: #abc.
	self assert: p modules second equals: #def.
	self assert: p modules third equals: #ghi.
	p deleteModule: #def.
	p deleteModule: #pqr.
	self assert: p modules size equals: 2.
	self assert: p modules first equals: #abc.
	self assert: p modules second equals: #ghi
]

{ #category : #test }
MicroPythonProjectTest >> testFileVersionString [

	self assert: self newProject class fileVersionString equals: 'MicrowitchV01'
]

{ #category : #test }
MicroPythonProjectTest >> testModules [
	| p |
	p := self newProject.
	self assert: p modules isEmpty
]

{ #category : #test }
MicroPythonProjectTest >> testToggleModule [
	| p |
	p := self newProject.
	self assert: p modules isEmpty.
	p addModule: 'abc'.
	self assert: (p moduleInUse: 'abc').
	self deny: (p moduleInUse: 'def').
	p toggleModule: 'abc'.
	p toggleModule: 'def'.
	self deny: (p moduleInUse: 'abc').
	self assert: (p moduleInUse: 'def')
]

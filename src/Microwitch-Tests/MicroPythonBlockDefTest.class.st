"
A MicroWizBlockDefTest is a test class for testing the behavior of MicroWizBlockDef
"
Class {
	#name : #MicroPythonBlockDefTest,
	#superclass : #TestCase,
	#category : #'Microwitch-Tests'
}

{ #category : #private }
MicroPythonBlockDefTest >> newDef [
	^ MicroPythonBlockDef new
]

{ #category : #test }
MicroPythonBlockDefTest >> testIsBlockDef [
	self deny: self newDef isBlockDef
]

{ #category : #test }
MicroPythonBlockDefTest >> testIsCategory [
	self deny: self newDef isCategory
]

{ #category : #test }
MicroPythonBlockDefTest >> testIsReporter [
	self deny: self newDef isReporter
]

{ #category : #test }
MicroPythonBlockDefTest >> testIsSeparator [
	self deny: self newDef isSeparator
]

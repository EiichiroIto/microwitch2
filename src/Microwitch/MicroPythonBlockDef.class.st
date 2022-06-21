Class {
	#name : #MicroPythonBlockDef,
	#superclass : #Object,
	#category : #'Microwitch-Modules'
}

{ #category : #accessing }
MicroPythonBlockDef >> block [
	self subclassResponsibility
]

{ #category : #api }
MicroPythonBlockDef >> blockTuple [
	^ self block
]

{ #category : #testing }
MicroPythonBlockDef >> isBlockDef [
	^ false
]

{ #category : #testing }
MicroPythonBlockDef >> isCategory [
	^ false
]

{ #category : #testing }
MicroPythonBlockDef >> isReporter [
	^ false
]

{ #category : #testing }
MicroPythonBlockDef >> isSeparator [
	^ false
]

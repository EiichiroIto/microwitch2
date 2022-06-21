Class {
	#name : #BlockSeparator,
	#superclass : #MicroPythonBlockDef,
	#category : #'Microwitch-Modules'
}

{ #category : #'block specs' }
BlockSeparator >> block [
	^ '-'
]

{ #category : #testing }
BlockSeparator >> isSeparator [
	^ true
]

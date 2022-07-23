Class {
	#name : #MWComm,
	#superclass : #Object,
	#category : #'MicroPythonProxy-Comm'
}

{ #category : #api }
MWComm >> close [
	self subclassResponsibility
]

{ #category : #api }
MWComm >> get [
	self subclassResponsibility
]

{ #category : #api }
MWComm >> isConnected [
	self subclassResponsibility
]

{ #category : #testing }
MWComm >> isWebRepl [
	^ false
]

{ #category : #api }
MWComm >> name [
	^ self class name
]

{ #category : #api }
MWComm >> open [
	self subclassResponsibility
]

{ #category : #api }
MWComm >> put: aByteArray [
	self subclassResponsibility
]

Class {
	#name : 'DummyComm',
	#superclass : 'MWComm',
	#instVars : [
		'mode',
		'puts',
		'gets',
		'isConnected',
		'portName',
		'baudRate'
	],
	#category : 'MicroPythonProxy-Comm',
	#package : 'MicroPythonProxy',
	#tag : 'Comm'
}

{ #category : 'accessing' }
DummyComm >> baudRate [
	^ baudRate
]

{ #category : 'accessing' }
DummyComm >> baudRate: anObject [
	baudRate := anObject
]

{ #category : 'api' }
DummyComm >> close [
	isConnected := false
]

{ #category : 'api' }
DummyComm >> get [
	gets isEmpty ifTrue: [ ^ nil ].
	^ gets removeFirst
]

{ #category : 'api' }
DummyComm >> getSize [
	^ gets size
]

{ #category : 'accessing' }
DummyComm >> gets [

	^ gets
]

{ #category : 'accessing' }
DummyComm >> gets: anObject [

	gets := anObject asOrderedCollection
]

{ #category : 'initialization' }
DummyComm >> initialize [
	gets := OrderedCollection new.
	puts := OrderedCollection new.
	isConnected := false
]

{ #category : 'accessing' }
DummyComm >> isConnected [

	^ isConnected
]

{ #category : 'accessing' }
DummyComm >> isConnected: anObject [

	isConnected := anObject
]

{ #category : 'testing' }
DummyComm >> isWebRepl [
	^ false
]

{ #category : 'accessing' }
DummyComm >> mode [

	^ mode
]

{ #category : 'accessing' }
DummyComm >> mode: anObject [

	mode := anObject
]

{ #category : 'api' }
DummyComm >> open [
	mode = #cannotOpen
		ifTrue: [ ^ false ].
	isConnected := true.
	^ true
]

{ #category : 'accessing' }
DummyComm >> options [
	^ #()
]

{ #category : 'accessing' }
DummyComm >> optionsNamed: aString [ 
	^ #()
]

{ #category : 'accessing' }
DummyComm >> portName [

	^ portName
]

{ #category : 'accessing' }
DummyComm >> portName: anObject [

	portName := anObject
]

{ #category : 'api' }
DummyComm >> portNames [
	^ #(abc def)
]

{ #category : 'api' }
DummyComm >> put: aByteArray [
	puts add: aByteArray copy
]

{ #category : 'api' }
DummyComm >> putSize [
	^ puts size
]

{ #category : 'accessing' }
DummyComm >> puts [

	^ puts
]

{ #category : 'accessing' }
DummyComm >> puts: anObject [

	puts := anObject
]

{ #category : 'accessing' }
DummyComm >> setOption: aString to: aString2 [ 
	"do nothing"
]

{ #category : 'api' }
DummyComm >> step [
	
]

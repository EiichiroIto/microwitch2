Class {
	#name : #ReceiveQueue,
	#superclass : #Object,
	#instVars : [
		'queue',
		'pending'
	],
	#category : #'MicroPythonProxy-Comm'
}

{ #category : #api }
ReceiveQueue >> allReceived [
	| ret |
	ret := queue copy.
	pending notEmpty
		ifTrue: [ ret add: pending asByteArray ].
	^ ret
]

{ #category : #private }
ReceiveQueue >> enqueueWithDelimiter [
	pending addAll: #[13].
	queue add: pending asByteArray.
	pending := OrderedCollection new
]

{ #category : #api }
ReceiveQueue >> flush [
	queue := OrderedCollection new.
	pending := OrderedCollection new
]

{ #category : #api }
ReceiveQueue >> getAll [
	| ret |
	ret := self allReceived.
	self flush.
	^ ret
]

{ #category : #api }
ReceiveQueue >> getPending [
	pending isEmpty
		ifTrue: [ ^ nil ].
	^ pending
		in: [ :list | 
			pending := OrderedCollection new.
			list asByteArray ]
]

{ #category : #initialization }
ReceiveQueue >> initialize [
	self flush
]

{ #category : #testing }
ReceiveQueue >> isEmpty [
	queue notEmpty
		ifTrue: [ ^ false ].
	pending notEmpty
		ifTrue: [ ^ false ].
	^ true
]

{ #category : #api }
ReceiveQueue >> lineCount [
	^ queue size + (pending isEmpty ifTrue: [0] ifFalse: [1])
]

{ #category : #accessing }
ReceiveQueue >> pending [
	^ pending
]

{ #category : #accessing }
ReceiveQueue >> pending: aCollection [
	pending := aCollection asOrderedCollection
]

{ #category : #printing }
ReceiveQueue >> printOn: aStream [
	aStream
		nextPutAll: self className;
		nextPut: $(;
		nextPutAll: queue size asString;
		nextPut: $,.
	pending printElementsOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
ReceiveQueue >> queue [
	^ queue
]

{ #category : #api }
ReceiveQueue >> received: aByteArray [
	| r c mode |
	aByteArray ifNil: [ ^ self ].
	mode := nil.
	r := ReadStream on: aByteArray.
	[ r atEnd ]
		whileFalse: [ c := r next.
			mode
				caseOf:
					{([ nil ]
						-> [ c = 13
								ifTrue: [ mode := #cr ].
							c = 10
								ifTrue: [ mode := #lf ].
							(#(10 13) includes: c)
								ifFalse: [ pending add: c ] ]).
					([ #cr ]
						-> [ c = 13
								ifTrue: [ self enqueueWithDelimiter ].
							c = 10
								ifTrue: [ self enqueueWithDelimiter.
									mode := nil ].
							(#(10 13) includes: c)
								ifFalse: [ self enqueueWithDelimiter.
									pending add: c.
									mode := nil ] ]).
					([ #lf ]
						-> [ c = 13
								ifTrue: [ self enqueueWithDelimiter.
									mode := #cr ].
							c = 10
								ifTrue: [ self enqueueWithDelimiter ].
							(#(10 13) includes: c)
								ifFalse: [ self enqueueWithDelimiter.
									pending add: c.
									mode := nil ] ])} ].
	mode ifNotNil: [ self enqueueWithDelimiter ]
]

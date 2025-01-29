"
A ReceiveQueueTest is a test class for testing the behavior of ReceiveQueue
"
Class {
	#name : 'ReceiveQueueTest',
	#superclass : 'TestCase',
	#category : 'MicroPythonProxy-Tests',
	#package : 'MicroPythonProxy',
	#tag : 'Tests'
}

{ #category : 'private' }
ReceiveQueueTest >> newQueue [
	^ ReceiveQueue new
]

{ #category : 'test' }
ReceiveQueueTest >> testAllReceived [
	| q ret |
	q := self newQueue.
	q received: #[1 2 3].
	q received: #[4 13 10 5 6].
	q received: #[7 13 10 8 9 10].
	ret := q allReceived.
	self deny: q isEmpty.
	self assert: ret size equals: 3.
	self assertCollection: ret first equals: #[1 2 3 4 13].
	self assertCollection: ret second equals: #[5 6 7 13].
	self assertCollection: ret third equals: #[8 9 13].
	q := self newQueue.
	q received: #[1 2 3].
	q received: #[4 13 10 5 6].
	q received: #[7 13 10 8 9].
	ret := q allReceived.
	self deny: q isEmpty.
	self assert: ret size equals: 3.
	self assertCollection: ret first equals: #[1 2 3 4 13].
	self assertCollection: ret second equals: #[5 6 7 13].
	self assertCollection: ret third equals: #[8 9]
]

{ #category : 'test' }
ReceiveQueueTest >> testEnqueueWithDelimiter [
	| q |
	q := self newQueue.
	q pending add: 1.
	q pending add: 2.
	self assert: q queue isEmpty.
	q enqueueWithDelimiter.
	self assert: q queue size equals: 1.
	self assert: q queue first equals: #[1 2 13].
	self assert: q pending isEmpty
]

{ #category : 'test' }
ReceiveQueueTest >> testFlush [
	| q |
	q := self newQueue.
	self assert: q queue isCollection.
	self assert: q queue isEmpty.
	self assert: q pending isCollection.
	self assert: q pending isEmpty.
	q queue add: 1.
	q pending add: 2.
	self assert: q queue notEmpty.
	self assert: q pending notEmpty.
	q flush.
	self assert: q queue isEmpty.
	self assert: q pending isEmpty
]

{ #category : 'test' }
ReceiveQueueTest >> testGetAll [
	| q ret |
	q := self newQueue.
	q received: #[1 2 3].
	q received: #[4 13 10 5 6].
	q received: #[7 13 10 8 9 10].
	ret := q getAll.
	self assert: q isEmpty.
	self assert: ret size equals: 3.
	self assertCollection: ret first equals: #[1 2 3 4 13].
	self assertCollection: ret second equals: #[5 6 7 13].
	self assertCollection: ret third equals: #[8 9 13].
	q := self newQueue.
	q received: #[1 2 3].
	q received: #[4 13 10 5 6].
	q received: #[7 13 10 8 9].
	ret := q getAll.
	self assert: q isEmpty.
	self assert: ret size equals: 3.
	self assertCollection: ret first equals: #[1 2 3 4 13].
	self assertCollection: ret second equals: #[5 6 7 13].
	self assertCollection: ret third equals: #[8 9]
]

{ #category : 'test' }
ReceiveQueueTest >> testGetPending [
	| q |
	q := self newQueue.
	self assert: q getPending isNil.
	q pending add: 1.
	q pending add: 2.
	self assertCollection: q getPending equals: #[1 2].
	self assert: q pending isEmpty
]

{ #category : 'test' }
ReceiveQueueTest >> testInitialize [
	| q |
	q := self newQueue.
	self assert: q queue isCollection.
	self assert: q queue isEmpty.
	self assert: q pending isCollection.
	self assert: q pending isEmpty
]

{ #category : 'test' }
ReceiveQueueTest >> testIsEmpty [
	| q |
	q := self newQueue.
	self assert: q isEmpty.
	q received: #[1].
	self deny: q isEmpty.
	q received: #[13].
	self deny: q isEmpty
]

{ #category : 'test' }
ReceiveQueueTest >> testLineCount [
	| q |
	q := self newQueue.
	self assert: q lineCount equals: 0.
	q received: #[1 2 3].
	self assert: q lineCount equals: 1.
	q received: #[4 5 6].
	self assert: q lineCount equals: 1.
	q received: #[7 13].
	self assert: q lineCount equals: 1.
	q received: #[8].
	self assert: q lineCount equals: 2.
	q received: #[13 9].
	self assert: q lineCount equals: 3
]

{ #category : 'test' }
ReceiveQueueTest >> testPending [
	| q |
	q := self newQueue.
	self assert: q pending isCollection.
	self assert: q pending isEmpty
]

{ #category : 'test' }
ReceiveQueueTest >> testPrintOn [
	| q s |
	q := self newQueue.
	s := WriteStream on: String new.
	q printOn: s.
	self assert: s contents equals: 'ReceiveQueue(0,())'.
	q queue add: 10.
	q queue add: 20.
	q pending add: 'abc'.
	s := WriteStream on: String new.
	q printOn: s.
	self assert: s contents equals: 'ReceiveQueue(2,(''abc''))'
]

{ #category : 'test' }
ReceiveQueueTest >> testQueue [
	| q |
	q := self newQueue.
	self assert: q queue isCollection.
	self assert: q queue isEmpty
]

{ #category : 'test' }
ReceiveQueueTest >> testReceived [
	| q |
	q := self newQueue.
	q received: #[1 2 3].
	self assert: q queue isEmpty.
	self assertCollection: q pending equals: #(1 2 3) asOrderedCollection.
	q received: #[4 5 13 6 7 8].
	self assert: q queue size equals: 1.
	self assert: q queue first equals: #[1 2 3 4 5 13].
	self assertCollection: q pending equals: #(6 7 8) asOrderedCollection
]

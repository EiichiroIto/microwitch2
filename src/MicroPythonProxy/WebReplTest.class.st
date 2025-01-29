"
A WebReplTest is a test class for testing the behavior of WebRepl
"
Class {
	#name : 'WebReplTest',
	#superclass : 'TestCase',
	#category : 'MicroPythonProxy-Tests',
	#package : 'MicroPythonProxy',
	#tag : 'Tests'
}

{ #category : 'private' }
WebReplTest >> newComm [
	^ WebRepl new
]

{ #category : 'test' }
WebReplTest >> testAddress [
	| c |
	c := self newComm.
	self assert: c address isNil.
	c address: '192.168.254.123'.
	self assert: c address equals: '192.168.254.123'
]

{ #category : 'test' }
WebReplTest >> testBuffer [
	| c a |
	c := self newComm.
	self assert: c buffer isEmpty.
	self assert: (c buffer isKindOf: ByteArray).
	a := #[1 2 3].
	c buffer: a.
	self assert: c buffer identicalTo: a
]

{ #category : 'test' }
WebReplTest >> testCheckCanRetrieveData [
	| c a |
	c := self newComm.
	a := #[99 3 5 6 7].
	self assert: (c checkCanRetrieveData: a).
	a := #[99 3 5 6 7 8].
	self assert: (c checkCanRetrieveData: a).
	a := #[99 3 5 6].
	self deny: (c checkCanRetrieveData: a).
	a := #[99].
	self deny: (c checkCanRetrieveData: a).
	a := #[99 126 0 9 1 1 1 1 1 1 1 1 1].
	self assert: (c checkCanRetrieveData: a).
	a := #[99 126 0 9 1 1 1 1 1 1 1 1].
	self deny: (c checkCanRetrieveData: a).
	a := #[99 126 0].
	self deny: (c checkCanRetrieveData: a)
]

{ #category : 'test' }
WebReplTest >> testCheckWebSocketHeader [
	| c |
	c := self newComm.
	self deny: (c checkWebSocketHeader: #[1 2 3 13 10 4 5 6] asByteArray).
	self
		assert: (c checkWebSocketHeader: #[1 2 3 13 10 4 5 13 10 13 10 6] asByteArray)
]

{ #category : 'test' }
WebReplTest >> testClear [
	| c |
	c := self newComm.
	c buffer: #[1 2 3].
	c headerReceived: true.
	c clear.
	self assert: c buffer isEmpty.
	self deny: c headerReceived
]

{ #category : 'test' }
WebReplTest >> testDataFromFrame [
	| c r |
	c := self newComm.
	r := c
		dataFromFrame:
			{16r82.
			#[65 66 67].
			#[4 5 6]}.
	self assertCollection: r equals: #[65 66 67].
	r := c
		dataFromFrame:
			{16r81.
			#[65 66 67].
			#[4 5 6]}.
	self assertCollection: r equals: 'ABC'.
	r := c
		dataFromFrame:
			{16r83.
			#[65 66 67].
			#[4 5 6]}.
	self assert: r isNil
]

{ #category : 'test' }
WebReplTest >> testHeaderOfPutFileNamedContents [
	| c r |
	c := self newComm.
	r := c headerOfPutFileNamed: 'abc' contents: 'defgh'.
	self
		assertCollection: r
		equals:
			#[87 65 1 0 0 0 0 0 0 0 0 0 5 0 0 0 3 0 97 98 99 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
]

{ #category : 'test' }
WebReplTest >> testHeaderReceived [
	| c |
	c := self newComm.
	self deny: c headerReceived.
	c headerReceived: true.
	self assert: c headerReceived
]

{ #category : 'test' }
WebReplTest >> testInitialize [
	self testClear
]

{ #category : 'test' }
WebReplTest >> testIsWebRepl [
	self assert: self newComm isWebRepl
]

{ #category : 'test' }
WebReplTest >> testMakeHeaderOfSizeAsText [
	| c r |
	c := self newComm.
	r := c makeHeaderOfSize: 125 asText: true.
	self assertCollection: r equals: #[16r81 125].
	r := c makeHeaderOfSize: 125 asText: false.
	self assertCollection: r equals: #[16r82 125].
	r := c makeHeaderOfSize: 126 asText: true.
	self assertCollection: r equals: #[16r81 126 0 126].
	r := c makeHeaderOfSize: 127 asText: false.
	self assertCollection: r equals: #[16r82 126 0 127]
]

{ #category : 'test' }
WebReplTest >> testPrintOn [
	| c s |
	c := self newComm.
	c address: '192.168.254.123'.
	s := WriteStream on: String new.
	c printOn: s.
	self assert: s contents equals: 'WebRepl(192.168.254.123)'
]

{ #category : 'test' }
WebReplTest >> testRetrieveDataFrom [
	| c a r |
	c := self newComm.
	a := #[99 3 5 6 7].
	r := c retrieveDataFrom: a.
	self assert: r first equals: 99.
	self assertCollection: r second equals: #[5 6 7].
	self assert: r third isEmpty.
	a := #[98 3 5 6 7 8].
	r := c retrieveDataFrom: a.
	self assert: r first equals: 98.
	self assertCollection: r second equals: #[5 6 7].
	self assertCollection: r third equals: #[8].
	a := #[97 126 0 9 1 1 1 1 1 1 1 1 1 2 3 4].
	r := c retrieveDataFrom: a.
	self assert: r first equals: 97.
	self assertCollection: r second equals: #[1 1 1 1 1 1 1 1 1].
	self assertCollection: r third equals: #[2 3 4]
]

{ #category : 'test' }
WebReplTest >> testSkipWebSocketHeader [
	| c a r |
	c := self newComm.
	a := 'abc' , String crlf , 'def' , String crlf , 'ghi' , String crlf
		, String crlf , 'jkl'.
	r := c skipWebSocketHeader: a asByteArray.
	self assertCollection: r equals: 'jkl' asByteArray
]

{ #category : 'test' }
WebReplTest >> testSocket [
	| c s |
	c := self newComm.
	self assert: c socket isNil.
	s := Socket newTCP.
	c socket: s.
	self assert: c socket identicalTo: s
]

{ #category : 'test' }
WebReplTest >> testWebReplPortNo [
	self assert: self newComm webReplPortNo equals: 8266
]

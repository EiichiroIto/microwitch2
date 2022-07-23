Class {
	#name : #WebRepl,
	#superclass : #MWComm,
	#instVars : [
		'address',
		'buffer',
		'socket',
		'headerReceived'
	],
	#classVars : [
		'RecentAddresses'
	],
	#category : #'MicroPythonProxy-Comm'
}

{ #category : #accessing }
WebRepl class >> addresses [
	^ RecentAddresses
]

{ #category : #private }
WebRepl class >> clientRequestHeader [
	^ ('GET / HTTP/1.1
Host: echo.websocket.org
Connection: Upgrade
Upgrade: websocket
Sec-WebSocket-Key: foo

' copyReplaceAll: String cr with: String crlf) asByteArray
]

{ #category : #'class initialization' }
WebRepl class >> initialize [
	"self initialize"
	RecentAddresses := OrderedCollection new
]

{ #category : #accessing }
WebRepl >> address [
	^ address
]

{ #category : #accessing }
WebRepl >> address: aString [
	address := aString
]

{ #category : #accessing }
WebRepl >> buffer [
	^ buffer
]

{ #category : #accessing }
WebRepl >> buffer: anObject [
	^ buffer := anObject
]

{ #category : #testing }
WebRepl >> checkCanRetrieveData: aByteArray [
	| size offset |
	offset := 2.
	aByteArray size < offset
		ifTrue: [ ^ false ].
	size := aByteArray second.
	size > 126
		ifTrue: [ self error: 'not supported frame' ].
	size = 126
		ifTrue: [ offset := 4.
			aByteArray size < offset
				ifTrue: [ ^ false ].
			size := aByteArray third * 256 + aByteArray fourth ].
	^ aByteArray size >= (size + offset)
]

{ #category : #testing }
WebRepl >> checkWebSocketHeader: aByteArray [
	^ (aByteArray indexOfSubCollection: #[13 10 13 10] startingAt: 1) > 0
]

{ #category : #private }
WebRepl >> clear [
	buffer := ByteArray new.
	headerReceived := false
]

{ #category : #api }
WebRepl >> close [
	socket ifNil: [ ^ self ].
	socket closeAndDestroy.
	socket := nil.
	self clear
]

{ #category : #private }
WebRepl >> dataFromFrame: anArray [
	anArray first = 16r82
		ifTrue: [ ^ anArray second ].
	anArray first = 16r81
		ifTrue: [ ^ anArray second asString ].
	^ nil
]

{ #category : #api }
WebRepl >> get [
	| triple |
	self isConnected
		ifFalse: [ ^ nil ].
	headerReceived
		ifFalse: [ [ self checkWebSocketHeader: buffer ]
				whileFalse: [ socket dataAvailable
						ifFalse: [ ^ nil ].
					buffer := buffer , socket receiveData asByteArray ].
			buffer := self skipWebSocketHeader: buffer.
			headerReceived := true ].
	[ self checkCanRetrieveData: buffer ]
		whileFalse: [ socket dataAvailable
				ifFalse: [ ^ nil ].
			buffer := buffer , socket receiveData asByteArray ].
	triple := self retrieveDataFrom: buffer.
	triple ifNil: [ ^ nil ].
	buffer := triple third.
	^ (self dataFromFrame: triple) asByteArray
]

{ #category : #private }
WebRepl >> headerOfPutFileNamed: aString1 contents: aString2 [
	"<2sBBQLH64s"

	"WEBREPL_PUT_FILE = 1"

	"    rec = struct.pack(WEBREPL_REQ_S, 'WA', WEBREPL_PUT_FILE, 0, 0, sz,
	 len(dest_fname), dest_fname)"

	| stream |
	stream := WriteStream on: ByteArray new.
	stream
		nextPut: $W asciiValue;
		nextPut: $A asciiValue;
		nextPut: 1;
		nextPut: 0;
		nextPutAll: #(0 0 0 0 0 0 0 0);
		nextPutAll: (aString2 size asByteArrayOfSize: 4) reverse;
		nextPutAll: (aString1 size asByteArrayOfSize: 2) reverse;
		nextPutAll: (aString1 padRightTo: 64 with: Character null) asByteArray.
	^ stream contents
]

{ #category : #accessing }
WebRepl >> headerReceived [
	^ headerReceived
]

{ #category : #accessing }
WebRepl >> headerReceived: anObject [
	headerReceived := anObject
]

{ #category : #initialization }
WebRepl >> initialize [
	self clear
]

{ #category : #api }
WebRepl >> isConnected [
	^ socket notNil and: [ socket isConnected ]
]

{ #category : #testing }
WebRepl >> isWebRepl [
	^ true
]

{ #category : #private }
WebRepl >> makeHeaderOfSize: anInteger asText: aBoolean [
	| op |
	op := aBoolean ifTrue: [ 16r81 ] ifFalse: [ 16r82 ].
	^ anInteger < 126
		ifTrue: [ ByteArray with: op with: anInteger ]
		ifFalse: [ ByteArray
				with: op
				with: 126
				with: anInteger // 256
				with: anInteger \\ 256 ]
]

{ #category : #api }
WebRepl >> open [
	| s |
	self isConnected
		ifTrue: [ ^ true ].
	s := Socket newTCP.
	s
		connectTo: (NetNameResolver addressFromString: address)
		port: self webReplPortNo.
	s isConnected
		ifFalse: [ ^ false ].
	socket := s.
	RecentAddresses
		remove: address ifAbsent: [  ];
		addFirst: address.
	^ true
]

{ #category : #printing }
WebRepl >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		nextPut: $(.
	self isConnected
		ifTrue: [ aStream nextPut: $* ].
	aStream
		nextPutAll: self address asString;
		nextPut: $)
]

{ #category : #api }
WebRepl >> put: aByteArray [
	self put: aByteArray asText: true
]

{ #category : #private }
WebRepl >> put: aByteArray asText: aBoolean [
	| header |
	self isConnected
		ifFalse: [ ^ self ].
	header := self makeHeaderOfSize: aByteArray size asText: aBoolean.
	socket
		sendData: header;
		sendData: aByteArray
]

{ #category : #api }
WebRepl >> putFileNamed: aString1 contents: aString2 [
	| header stream buf |
	header := self headerOfPutFileNamed: aString1 contents: aString2.
	self put: (header copyFrom: 1 to: 10) asText: false.
	self put: (header copyFrom: 11 to: header size) asText: false.
	stream := ReadStream on: aString2 asByteArray.
	[ stream atEnd ]
		whileFalse: [ buf := stream next: 1024.
			self put: buf asText: false ]
]

{ #category : #accessing }
WebRepl >> recentAddresses [
	^ RecentAddresses
]

{ #category : #private }
WebRepl >> retrieveDataFrom: aByteArray [
	| opcode size pos |
	aByteArray isEmpty
		ifTrue: [ ^ nil ].
	opcode := aByteArray first.
	size := aByteArray second.
	pos := 3.
	size > 126
		ifTrue: [ self error: 'not supported frame' ].
	size = 126
		ifTrue: [ size := aByteArray third * 256 + aByteArray fourth.
			pos := 5 ].
	^ {opcode.
	(aByteArray copyFrom: pos to: pos + size - 1).
	(aByteArray copyFrom: pos + size to: aByteArray size)}
]

{ #category : #private }
WebRepl >> skipWebSocketHeader: aByteArray [
	| i |
	i := aByteArray indexOfSubCollection: #[13 10 13 10] startingAt: 1.
	^ aByteArray copyFrom: i + 4 to: aByteArray size
]

{ #category : #accessing }
WebRepl >> socket [
	^ socket
]

{ #category : #accessing }
WebRepl >> socket: anObject [
	socket := anObject
]

{ #category : #private }
WebRepl >> webReplPortNo [
	^ 8266
]

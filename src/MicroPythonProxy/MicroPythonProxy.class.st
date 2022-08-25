Class {
	#name : #MicroPythonProxy,
	#superclass : #Object,
	#instVars : [
		'comm',
		'receiveQueue',
		'timeout',
		'timeoutMsec',
		'autoPilot',
		'state'
	],
	#category : #'MicroPythonProxy-Core'
}

{ #category : #constants }
MicroPythonProxy class >> breakRequest [
	^ #[3]
]

{ #category : #constants }
MicroPythonProxy class >> cr [
	^ #[13]
]

{ #category : #constants }
MicroPythonProxy class >> enterPastePrompts [

	^ { 
		  ('paste mode; Ctrl-C to cancel, Ctrl-D to finish' , String cr)
			  asByteArray.
		  '=== ' asByteArray }
]

{ #category : #constants }
MicroPythonProxy class >> enterPasteRequest [
	^ #[5]
]

{ #category : #constants }
MicroPythonProxy class >> exitPasteRequest [
	^ #[4]
]

{ #category : #constants }
MicroPythonProxy class >> normalPrompt [

	^ '>>> ' asByteArray
]

{ #category : #constants }
MicroPythonProxy class >> pastePrompt [

	^ '=== ' asByteArray
]

{ #category : #constants }
MicroPythonProxy class >> rebootRequest [
	^ #[4]
]

{ #category : #accessing }
MicroPythonProxy >> autoPilot [

	^ autoPilot
]

{ #category : #accessing }
MicroPythonProxy >> autoPilot: anObject [

	autoPilot := anObject
]

{ #category : #api }
MicroPythonProxy >> break [

	state isIdle ifTrue: [ ^ self ].
	state isNotConnected ifTrue: [ ^ self ].
	autoPilot clear.
	comm put: self class breakRequest.
	state beWaiting.
	self updateTimeoutMsec
]

{ #category : #testing }
MicroPythonProxy >> checkEnterPastePrompted [

	| l |
	receiveQueue queue isEmpty ifTrue: [ ^ false ].
	l := self class enterPastePrompts.
	receiveQueue queue last = l first ifFalse: [ ^ false ].
	receiveQueue pending asByteArray = l last ifFalse: [ ^ false ].
	^ true
]

{ #category : #testing }
MicroPythonProxy >> checkPastePrompted [

	^ receiveQueue pending asByteArray = self class pastePrompt
]

{ #category : #testing }
MicroPythonProxy >> checkPrompted [
	^ receiveQueue pending asByteArray = self class normalPrompt
]

{ #category : #api }
MicroPythonProxy >> close [
	state isIdle ifTrue: [ ^ self ].
	autoPilot clear.
	comm close.
	state beNotConnected
]

{ #category : #accessing }
MicroPythonProxy >> comm [

	^ comm
]

{ #category : #accessing }
MicroPythonProxy >> comm: anObject [

	comm := anObject
]

{ #category : #private }
MicroPythonProxy >> defaultBaudRate [
	^ 115200
]

{ #category : #private }
MicroPythonProxy >> defaultTimeout [
	^ 1000
]

{ #category : #api }
MicroPythonProxy >> deleteFileNamed: aString [

	| lines |
	lines := self makeDeleteFileNamed: aString.
	autoPilot
		execute: lines;
		sendPaste
]

{ #category : #api }
MicroPythonProxy >> disconnect [
	comm close.
	state beIdle
]

{ #category : #api }
MicroPythonProxy >> downloadFileNamed: aString ifError: aBlock [

	| lines |
	lines := self makeDownloadFileNamed: aString.
	^ self evaluateLines: lines ifError: aBlock
]

{ #category : #api }
MicroPythonProxy >> enterPasteMode [
	state isReady ifFalse: [ ^ self ].
	comm put: self class enterPasteRequest.
	state beWaitingEnterPaste.
	self updateTimeoutMsec
]

{ #category : #api }
MicroPythonProxy >> evaluate: aString ifError: aBlock [

	| lines |
	lines := self linesWithoutComments: aString.
	^ self evaluateLines: lines ifError: aBlock
]

{ #category : #private }
MicroPythonProxy >> evaluateLines: aCollection ifError: aBlock [

	| stream |
	aCollection isEmpty ifTrue: [ ^ '' ].
	stream := WriteStream on: Array new.
	aCollection do: [ :each | 
		state isReady ifFalse: [ 
			aBlock cull: 'device is not ready' localized ].
		self sendLine: each.
		self waitPromptIfError: aBlock.
		stream nextPutAll: receiveQueue getAll ].
	^ self formatForEvaluate: stream contents
]

{ #category : #api }
MicroPythonProxy >> execute: aString [

	| lines |
	lines := self linesWithoutComments: aString.
	autoPilot
		execute: lines;
		sendPaste
]

{ #category : #api }
MicroPythonProxy >> exitPasteMode [
	state isPasteReady ifFalse: [ ^ self ].
	comm put: self class exitPasteRequest.
	state beRunning.
	timeoutMsec := nil
]

{ #category : #api }
MicroPythonProxy >> flush [
	receiveQueue flush.
	[ comm get notNil ] whileTrue
]

{ #category : #private }
MicroPythonProxy >> formatForEvaluate: aCollection [

	| result line i |
	aCollection isEmpty ifTrue: [ ^ '' ].
	aCollection size = 1 ifTrue: [ ^ aCollection first asString ].
	result := aCollection asOrderedCollection copyWithoutFirst.
	i := 1.
	[ i <= result size ] whileTrue: [ 
		line := result at: i.
		line = self class normalPrompt
			ifTrue: [ 
				i + 1 <= result size ifTrue: [ result removeIndex: i + 1 ].
				result removeIndex: i ]
			ifFalse: [ 
				(line beginsWith: self class normalPrompt)
					ifTrue: [ result removeIndex: i ]
					ifFalse: [ i := i + 1 ] ] ].
	^ ((result collect: #asString) joinUsing: Character space)
		  withoutTrailingNewlines
]

{ #category : #api }
MicroPythonProxy >> ifTimeoutDo: aBlock [

	(state isWaiting or: [ 
		 state isWaitingEnterPaste or: [ state isWaitingEnterPaste ] ]) 
		ifFalse: [ ^ self ].
	self isTimeout ifFalse: [ ^ self ].
	aBlock value.
	state beNotConnected
]

{ #category : #initialization }
MicroPythonProxy >> initialize [

	state := MicroPythonState new.
	receiveQueue := ReceiveQueue new.
	timeout := self defaultTimeout.
	autoPilot := MicroPythonAutoPilot new
		             proxy: self;
		             yourself
]

{ #category : #testing }
MicroPythonProxy >> isConnected [

	state isIdle ifTrue: [ ^ false ].
	^ state isNotConnected not
]

{ #category : #testing }
MicroPythonProxy >> isIdle [
	^ state isIdle
]

{ #category : #testing }
MicroPythonProxy >> isNotConnected [
	^ state isNotConnected
]

{ #category : #testing }
MicroPythonProxy >> isPasteReady [
	^ state isPasteReady
]

{ #category : #testing }
MicroPythonProxy >> isReady [
	^ state isReady
]

{ #category : #testing }
MicroPythonProxy >> isRunning [
	^ state isRunning
]

{ #category : #testing }
MicroPythonProxy >> isTimeout [

	timeoutMsec ifNil: [ ^ false ].
	^ Time millisecondClockValue >= timeoutMsec
]

{ #category : #testing }
MicroPythonProxy >> isWaiting [

	^ state isWaiting
]

{ #category : #utilities }
MicroPythonProxy >> linesWithoutComments: aString [

	| out i str |
	out := WriteStream on: Array new.
	aString lines do: [ :each | 
		i := each indexOf: $#.
		str := each.
		i > 0 ifTrue: [ str := each copyFrom: 1 to: i - 1 ].
		str := str trimRight.
		str isEmpty ifFalse: [ out nextPut: str ] ].
	^ out contents
]

{ #category : #private }
MicroPythonProxy >> logReceiveQueue [

	self traceCr: 'queues: '.
	receiveQueue queue do: [ :each | self traceCr: each asString ].
	self trace: 'pending: '.
	self traceCr: receiveQueue pending asString
]

{ #category : #utilities }
MicroPythonProxy >> makeDeleteFileNamed: aString [

	| result |
	result := OrderedCollection new.
	result add: 'import os'.
	result add: 'os.remove("' , aString , '")'.
	^ result
]

{ #category : #utilities }
MicroPythonProxy >> makeDownloadFileNamed: aString [

	| result |
	result := OrderedCollection new.
	result add: '_f=open("' , aString , '")'.
	result add: '_r=_f.read()'.
	result add: '_f.close()'.
	result add: '_r'.
	^ result
]

{ #category : #utilities }
MicroPythonProxy >> makeUpload: aCollection fileNamed: aString [

	| s result |
	result := OrderedCollection new.
	s := WriteStream on: String new.
	s
		nextPutAll: '_s=open("';
		nextPutAll: aString;
		nextPutAll: '","w")'.
	result add: s contents.
	aCollection do: [ :each | 
		s := WriteStream on: String new.
		s nextPutAll: '_=_s.write("'.
		each do: [ :c | 
			c = $\ ifTrue: [ s nextPut: $\ ].
			c = $" ifTrue: [ s nextPut: $\ ].
			s nextPut: c ].
		s nextPutAll: '\n")'.
		result add: s contents ].
	result add: '_s.close()'.
	^ result
]

{ #category : #api }
MicroPythonProxy >> open [
	state isIdle ifTrue: [ ^ false ].
	comm open ifFalse: [ ^ false ].
	autoPilot clear.
	self flush.
	state beConnected.
	^ true
]

{ #category : #api }
MicroPythonProxy >> portName [
	^ comm portName
]

{ #category : #api }
MicroPythonProxy >> portName: aString [

	aString ifNil: [ ^ state beIdle ].
	comm portName: aString.
	state beNotConnected
]

{ #category : #api }
MicroPythonProxy >> portNames [
	^ comm portNames
]

{ #category : #printing }
MicroPythonProxy >> printOn: aStream [

	aStream
		nextPutAll: self class name;
		nextPut: $(;
		nextPutAll: state asString;
		nextPut: $)
]

{ #category : #accessing }
MicroPythonProxy >> receiveQueue [

	^ receiveQueue
]

{ #category : #accessing }
MicroPythonProxy >> receiveQueue: anObject [

	receiveQueue := anObject
]

{ #category : #api }
MicroPythonProxy >> responseString [

	| s |
	s := WriteStream on: ByteArray new.
	receiveQueue getAll do: [ :each | s nextPutAll: each ].
	^ s contents asString
]

{ #category : #api }
MicroPythonProxy >> restart [

	state isReady ifFalse: [ ^ self ].
	autoPilot clear.
	comm put: self class rebootRequest.
	500 milliSecond wait.
	comm close.
	state beNotConnected
]

{ #category : #private }
MicroPythonProxy >> sendLine: aString [
	comm put: aString asByteArray , self class cr.
	state beWaiting
]

{ #category : #private }
MicroPythonProxy >> sendPasteLine: aString [
	comm put: aString asByteArray , self class cr.
	state beWaitingPaste
]

{ #category : #accessing }
MicroPythonProxy >> state [

	^ state
]

{ #category : #accessing }
MicroPythonProxy >> state: anObject [

	state := anObject
]

{ #category : #api }
MicroPythonProxy >> step [

	| msg |
	state isIdle ifTrue: [ ^ self ].

	[ 
	msg := comm get.
	msg notNil ] whileTrue: [ receiveQueue received: msg ].
	self updateState.
	autoPilot step
]

{ #category : #api }
MicroPythonProxy >> thenRestart [
	autoPilot thenRestart
]

{ #category : #accessing }
MicroPythonProxy >> timeout [

	^ timeout
]

{ #category : #accessing }
MicroPythonProxy >> timeout: anObject [

	timeout := anObject
]

{ #category : #accessing }
MicroPythonProxy >> timeoutMsec [

	^ timeoutMsec
]

{ #category : #accessing }
MicroPythonProxy >> timeoutMsec: anObject [

	timeoutMsec := anObject
]

{ #category : #private }
MicroPythonProxy >> updateState [
	comm isConnected ifFalse: [ ^ state beNotConnected ].
	self checkPrompted ifTrue: [ ^ state beReady ].
	state isWaitingEnterPaste ifTrue: [ 
		self checkEnterPastePrompted ifTrue: [ ^ state bePasteReady ] ].
	state isWaitingPaste ifTrue: [ 
		self checkPastePrompted ifTrue: [ ^ state bePasteReady ] ]
]

{ #category : #private }
MicroPythonProxy >> updateTimeoutMsec [
	timeoutMsec := Time millisecondClockValue + timeout
]

{ #category : #api }
MicroPythonProxy >> upload: aString fileNamed: aString2 [

	| lines |
	lines := self linesWithoutComments: aString.
	lines := self makeUpload: lines fileNamed: aString2.
	autoPilot
		execute: lines;
		sendNormal
]

{ #category : #api }
MicroPythonProxy >> waitCompleteSendIfError: aBlock [

	self updateTimeoutMsec.
	[ 
	self step.
	state isReady ifTrue: [ ^ self ].
	state isRunning ifTrue: [ ^ self ].
	self ifTimeoutDo: [ ^ aBlock cull: 'timeout' ].
	50 milliSeconds wait ] repeat
]

{ #category : #api }
MicroPythonProxy >> waitPromptIfError: aBlock [

	state isWaiting ifFalse: [ ^ aBlock cull: 'state is not waiting' ].
	self updateTimeoutMsec.
	[ 
	self step.
	state isReady ifTrue: [ ^ self ].
	self ifTimeoutDo: [ ^ aBlock cull: 'timeout' ].
	50 milliSeconds wait ] repeat
]

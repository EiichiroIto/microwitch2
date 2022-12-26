"
A MicroPythonProxy2Test is a test class for testing the behavior of MicroPythonProxy2
"
Class {
	#name : #MicroPythonProxyTest,
	#superclass : #TestCase,
	#category : #'MicroPythonProxy-Tests'
}

{ #category : #private }
MicroPythonProxyTest >> newComm [
	^ DummyComm new
]

{ #category : #private }
MicroPythonProxyTest >> newProxy [
	^ MicroPythonProxy new
]

{ #category : #test }
MicroPythonProxyTest >> testAutoPilot [

	| p |
	p := self newProxy.
	self assert: (p autoPilot isKindOf: MicroPythonAutoPilot).
	p autoPilot: nil.
	self assert: p autoPilot isNil
]

{ #category : #test }
MicroPythonProxyTest >> testBreak [

	| p c |
	p := self newProxy.
	c := self newComm.
	p comm: c.
	self assert: c putSize equals: 0.
	p state beIdle.
	p break.
	self assert: c putSize equals: 0.
	p state beNotConnected.
	p break.
	self assert: c putSize equals: 0.
	p state beConnected.
	p break.
	self assert: c putSize equals: 1.
	self assertCollection: c puts first equals: #[3].
	self assert: p state isWaiting
]

{ #category : #test }
MicroPythonProxyTest >> testCheckEnterPastePrompted [

	| p |
	p := self newProxy.
	self deny: p checkEnterPastePrompted.
	p receiveQueue queue add: 'abc' asByteArray.
	p receiveQueue queue add: 'def' asByteArray.
	p receiveQueue queue add: ('paste mode; Ctrl-C to cancel, Ctrl-D to finish' , String cr) asByteArray.
	self deny: p checkEnterPastePrompted.
	p receiveQueue pending: '=== ' asByteArray.
	self assert: p checkEnterPastePrompted
]

{ #category : #test }
MicroPythonProxyTest >> testCheckPastePrompted [

	| p |
	p := self newProxy.
	self deny: p checkPastePrompted.
	p receiveQueue queue add: 'abc' asByteArray.
	p receiveQueue queue add: 'def' asByteArray.
	p receiveQueue pending: '=== ' asByteArray.
	self assert: p checkPastePrompted.
	p receiveQueue flush.
	p receiveQueue queue add: 'abc' asByteArray.
	p receiveQueue queue add: 'def' asByteArray.
	p receiveQueue queue add: ('=== ' , String cr) asByteArray.
	self deny: p checkPastePrompted
]

{ #category : #test }
MicroPythonProxyTest >> testCheckPrompted [

	| p |
	p := self newProxy.
	self deny: p checkPrompted.
	p receiveQueue pending: '>>> ' asByteArray.
	self assert: p checkPrompted
]

{ #category : #test }
MicroPythonProxyTest >> testClose [

	| p c |
	p := self newProxy.
	c := self newComm.
	c isConnected: true.
	p comm: c.
	p state beIdle.
	p close.
	self assert: c isConnected.
	p state beConnected.
	p close.
	self deny: c isConnected.
	self assert: c putSize equals: 0.
	self assert: p state isNotConnected
]

{ #category : #test }
MicroPythonProxyTest >> testComm [
	| p c |
	p := self newProxy.
	self assert: p comm isNil.
	c := self newComm.
	p comm: c.
	self assert: p comm identicalTo: c
]

{ #category : #test }
MicroPythonProxyTest >> testDefaultBaudRate [

	self assert: self newProxy defaultBaudRate equals: 115200
]

{ #category : #test }
MicroPythonProxyTest >> testDefaultTimeout [
	self assert: self newProxy defaultTimeout equals: 1000
]

{ #category : #test }
MicroPythonProxyTest >> testDisconnect [

	| p c |
	p := self newProxy.
	c := self newComm.
	c isConnected: true.
	p comm: c.
	p state beIdle.
	p disconnect.
	self deny: c isConnected.
	self assert: c putSize equals: 0.
	self assert: p state isIdle.
	c isConnected: true.
	p state beConnected.
	p disconnect.
	self deny: c isConnected.
	self assert: c putSize equals: 0.
	self assert: p state isIdle
]

{ #category : #test }
MicroPythonProxyTest >> testEnterPasteMode [

	| p c |
	p := self newProxy.
	c := self newComm.
	p comm: c.
	p state beConnected.
	p enterPasteMode.
	self deny: p state isWaitingEnterPaste.
	self assert: c putSize equals: 0.
	p state beReady.
	p enterPasteMode.
	self assert: p state isWaitingEnterPaste.
	self assert: c putSize equals: 1.
	self assertCollection: c puts first equals: #[5]
]

{ #category : #test }
MicroPythonProxyTest >> testFlush [

	| p c |
	p := self newProxy.
	c := self newComm.
	p comm: c.
	p receiveQueue pending add: 1.
	p receiveQueue queue add: 2.
	c gets: #( a b c ).
	self deny: c gets isEmpty.
	self deny: p receiveQueue pending isEmpty.
	self deny: p receiveQueue queue isEmpty.
	p flush.
	self assert: c gets isEmpty.
	self assert: p receiveQueue pending isEmpty.
	self assert: p receiveQueue queue isEmpty
]

{ #category : #test }
MicroPythonProxyTest >> testFormatForEvaluate [
	| p s d |
	p := self newProxy.
	self assert: (p formatForEvaluate: #()) isEmpty.
	self assert: (p formatForEvaluate: #(#[65 66])) equals: 'AB'.
	s := #( 'abc' 'def' '>>> ' 'ghi' '>>> ' 'jkl' 'mno').
	d := p formatForEvaluate: (s collect: #asByteArray).
	self assert: d equals: 'def mno'.
	s := #( 'abc' 'def' '>>> ' 'ghi' '>>> ').
	d := p formatForEvaluate: (s collect: #asByteArray).
	self assert: d equals: 'def'.
	s := #( 'abc' '>>> ' 'ghi' '>>> ').
	d := p formatForEvaluate: (s collect: #asByteArray).
	self assert: d equals: ''.
	s := #( 'abc' 'def' '>>> ' 'ghi' '>>> jkl').
	d := p formatForEvaluate: (s collect: #asByteArray).
	self assert: d equals: 'def'
]

{ #category : #test }
MicroPythonProxyTest >> testInitialize [

	| p |
	p := self newProxy.
	self assert: p comm isNil.
	self assert: (p receiveQueue isKindOf: ReceiveQueue).
	self assert: (p state isKindOf: MicroPythonState).
	self assert: (p autoPilot isKindOf: MicroPythonAutoPilot).
	self assert: p timeout equals: p defaultTimeout.
	self assert: p timeoutMsec isNil
]

{ #category : #test }
MicroPythonProxyTest >> testIsConnected [

	| p |
	p := self newProxy.
	self deny: p isConnected.
	p state beNotConnected.
	self deny: p isConnected.
	p state beConnected.
	self assert: p isConnected
]

{ #category : #test }
MicroPythonProxyTest >> testIsIdle [

	| p |
	p := self newProxy.
	self assert: p isIdle.
	p state beNotConnected.
	self deny: p isIdle
]

{ #category : #test }
MicroPythonProxyTest >> testIsNotConnected [

	| p |
	p := self newProxy.
	self deny: p isNotConnected.
	p state beNotConnected.
	self assert: p isNotConnected
]

{ #category : #test }
MicroPythonProxyTest >> testIsPasteReady [

	| p |
	p := self newProxy.
	self deny: p isPasteReady.
	p state bePasteReady.
	self assert: p isPasteReady
]

{ #category : #test }
MicroPythonProxyTest >> testIsReady [

	| p |
	p := self newProxy.
	self deny: p isReady.
	p state beReady.
	self assert: p isReady
]

{ #category : #test }
MicroPythonProxyTest >> testIsRunning [

	| p |
	p := self newProxy.
	self deny: p isRunning.
	p state beRunning.
	self assert: p isRunning
]

{ #category : #test }
MicroPythonProxyTest >> testIsTimeout [

	| p t |
	p := self newProxy.
	self deny: p isTimeout.
	t := Time millisecondClockValue.
	p timeoutMsec: t + 1000.
	self deny: p isTimeout.
	p timeoutMsec: t - 1.
	self assert: p isTimeout
]

{ #category : #test }
MicroPythonProxyTest >> testIsWaiting [

	| p |
	p := self newProxy.
	self deny: p isWaiting.
	p state beWaiting.
	self assert: p isWaiting
]

{ #category : #test }
MicroPythonProxyTest >> testLinesWithDelimiterEvery [

	| proxy r |
	proxy := self newProxy.
	r := proxy lines: #( a b c ) withDelimiterEvery: 5.
	self assertCollection: r equals: #( a b c ).
	r := proxy lines: #( a b c d e ) withDelimiterEvery: 3.
	self assertCollection: r equals: #( a b c '#--- 3 ---' d e ).
	r := proxy lines: #( a b c d e f ) withDelimiterEvery: 3.
	self
		assertCollection: r
		equals: #( a b c '#--- 3 ---' d e f '#--- 6 ---' )
]

{ #category : #test }
MicroPythonProxyTest >> testLinesWithoutComments [

	| p r |
	p := self newProxy.
	r := p linesWithoutComments: 'abc'.
	self assertCollection: r equals: #( 'abc' ).
	r := p linesWithoutComments: 'abc
  def'.
	self assertCollection: r equals: #( 'abc' '  def' ).
	r := p linesWithoutComments: 'abc     
def     '.
	self assertCollection: r equals: #( 'abc' 'def' ).
	r := p linesWithoutComments: 'abc # aaa
def     # asda   '.
	self assertCollection: r equals: #( 'abc' 'def' ).
	r := p linesWithoutComments: 'abc # aaa
     # asda   
ghi'.
	self assertCollection: r equals: #( 'abc' 'ghi' ).
	r := p linesWithoutComments: ' # aaa
     # asda   '.
	self assert: r isEmpty.
	r := p linesWithoutComments: 'abc" # "aaa'.
	self assertCollection: r equals: #( 'abc" # "aaa' ).
	r := p linesWithoutComments: 'abc'' # ''aaa'.
	self assertCollection: r equals: #( 'abc'' # ''aaa' )
]

{ #category : #test }
MicroPythonProxyTest >> testMakeDeleteFileNamed [

	| p r |
	p := self newProxy.
	r := p makeDeleteFileNamed: 'main.py'.
	self assert: r isCollection.
	self assert: r size equals: 2.
	self assert: r first equals: 'import os'.
	self assert: r second equals: 'os.remove("main.py")'.

	r := p makeDeleteFileNamed: 'test.py'.
	self assert: r isCollection.
	self assert: r size equals: 2.
	self assert: r first equals: 'import os'.
	self assert: r second equals: 'os.remove("test.py")'
]

{ #category : #test }
MicroPythonProxyTest >> testMakeDownloadFileNamed [

	| p r |
	p := self newProxy.
	r := p makeDownloadFileNamed: 'main.py'.
	self assert: r isCollection.
	self assert: r size equals: 4.
	self assert: r first equals: '_f=open("main.py")'.
	self assert: r second equals: '_r=_f.read()'.
	self assert: r third equals: '_f.close()'.
	self assert: r fourth equals: '_r'
]

{ #category : #test }
MicroPythonProxyTest >> testMakeUploadFileNamed [

	| p r |
	p := self newProxy.
	r := p makeUpload: #( 'import microbit' ) fileNamed: 'main.py'.
	self assert: r isCollection.
	self assert: r size equals: 3.
	self assert: r first equals: '_s=open("main.py","w")'.
	self assert: r second equals: '_=_s.write("import microbit\n")'.
	self assert: r third equals: '_s.close()'.

	r := p makeUpload: #( 'hello("abc")' ) fileNamed: 'main.py'.
	self assert: r isCollection.
	self assert: r size equals: 3.
	self assert: r first equals: '_s=open("main.py","w")'.
	self assert: r second equals: '_=_s.write("hello(\"abc\")\n")'.
	self assert: r third equals: '_s.close()'.

	r := p
		     makeUpload: #( 'def a():' '  return 1+2' )
		     fileNamed: 'main.py'.
	self assert: r isCollection.
	self assert: r size equals: 4.
	self assert: r first equals: '_s=open("main.py","w")'.
	self assert: r second equals: '_=_s.write("def a():\n")'.
	self assert: r third equals: '_=_s.write("  return 1+2\n")'.
	self assert: r fourth equals: '_s.close()'
]

{ #category : #test }
MicroPythonProxyTest >> testOpen [

	| p c |
	p := self newProxy.
	c := self newComm.
	p comm: c.
	self deny: c isConnected.
	self deny: p open.
	p state beNotConnected.
	c mode: #cannotOpen.
	self deny: p open.
	self deny: c isConnected.
	c mode: nil.
	self assert: p open.
	self assert: c isConnected
]

{ #category : #test }
MicroPythonProxyTest >> testPortName [

	| p c |
	p := self newProxy.
	c := self newComm.
	p comm: c.
	self assert: p portName isNil.
	c portName: 'abc'.
	self assert: p portName equals: 'abc'.
	self assert: p state isIdle.
	p portName: 'def'.
	self assert: p portName equals: 'def'.
	self assert: p state isNotConnected
]

{ #category : #test }
MicroPythonProxyTest >> testPortNames [

	| p c |
	p := self newProxy.
	c := self newComm.
	p comm: c.
	self assert: p portNames identicalTo: c portNames
]

{ #category : #test }
MicroPythonProxyTest >> testReceiveQueue [

	| p |
	p := self newProxy.
	self assert: (p receiveQueue isKindOf: ReceiveQueue)
]

{ #category : #test }
MicroPythonProxyTest >> testRestart [

	| p c |
	p := self newProxy.
	c := self newComm.
	c isConnected: true.
	p comm: c.
	self assert: p state isIdle.
	p restart.
	self assert: c isConnected.
	self assert: p state isIdle.
	p state beReady.
	p restart.
	self assert: p state isNotConnected.
	self assert: c putSize equals: 1.
	self assertCollection: c puts first equals: #[4].
	self deny: c isConnected
]

{ #category : #test }
MicroPythonProxyTest >> testSendLine [

	| p c |
	p := self newProxy.
	c := self newComm.
	p comm: c.
	p sendLine: 'abc'.
	self assert: c putSize equals: 1.
	self assertCollection: c puts first equals: #[97 98 99 13].
	self assert: p state isWaiting
]

{ #category : #test }
MicroPythonProxyTest >> testSendPasteLine [

	| p c |
	p := self newProxy.
	c := self newComm.
	p comm: c.
	p sendPasteLine: 'abc'.
	self assert: c putSize equals: 1.
	self assertCollection: c puts first equals: #[97 98 99 13].
	self assert: p state isWaitingPaste
]

{ #category : #test }
MicroPythonProxyTest >> testState [

	| p |
	p := self newProxy.
	self assert: (p state isKindOf: MicroPythonState).
	p state: nil.
	self assert: p state isNil
]

{ #category : #test }
MicroPythonProxyTest >> testStringWithoutComment [

	| p r |
	p := self newProxy.
	r := p stringWithoutComment: ''.
	self assert: r isEmpty.
	r := p stringWithoutComment: 'abc'.
	self assert: r equals: 'abc'.
	r := p stringWithoutComment: 'abc#def'.
	self assert: r equals: 'abc'.
	r := p stringWithoutComment: 'abc"#"def'.
	self assert: r equals: 'abc"#"def'.
	r := p stringWithoutComment: 'abc''#''def'.
	self assert: r equals: 'abc''#''def'.
	r := p stringWithoutComment: 'abc"#"de#f'.
	self assert: r equals: 'abc"#"de'.
	r := p stringWithoutComment: 'abc''#''de"#f"'.
	self assert: r equals: 'abc''#''de"#f"'
]

{ #category : #test }
MicroPythonProxyTest >> testThenRestart [

	| p |
	p := self newProxy.
	self assert: p autoPilot selector isNil.
	p thenRestart.
	self assert: p autoPilot selector equals: #doRestart
]

{ #category : #test }
MicroPythonProxyTest >> testTimeout [

	| p |
	p := self newProxy.
	self assert: p timeout equals: p defaultTimeout.
	p timeout: 123.
	self assert: p timeout equals: 123
]

{ #category : #test }
MicroPythonProxyTest >> testTimeoutMsec [

	| p |
	p := self newProxy.
	self assert: p timeoutMsec isNil.
	p timeoutMsec: 123.
	self assert: p timeoutMsec equals: 123
]

{ #category : #test }
MicroPythonProxyTest >> testUpdateTimeoutMsec [

	| p t |
	p := self newProxy.
	p timeout: 100.
	t := Time millisecondClockValue.
	p updateTimeoutMsec.
	self assert: p timeoutMsec >= (t + 100).
	p timeout: 1000.
	t := Time millisecondClockValue.
	p updateTimeoutMsec.
	self assert: p timeoutMsec >= (t + 1000)
]

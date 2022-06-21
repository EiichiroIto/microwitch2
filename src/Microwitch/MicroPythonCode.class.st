Class {
	#name : #MicroPythonCode,
	#superclass : #ScratchCode,
	#category : #'Microwitch-MPython'
}

{ #category : #'code generator' }
MicroPythonCode >> argsOf: aMorph [
	^ aMorph blockArgs collect: [ :each | each argOf: parser ]
]

{ #category : #'control ops' }
MicroPythonCode >> doForeverBegin: aMorph [
	generator doForeverBegin
]

{ #category : #'control ops' }
MicroPythonCode >> doForeverEnd: aMorph [
	generator doForeverEnd
]

{ #category : #'control ops' }
MicroPythonCode >> doIfBegin: aMorph [
	| cond |
	cond := aMorph blockArgs first argString: parser.
	generator doIfBegin: cond
]

{ #category : #'control ops' }
MicroPythonCode >> doIfElseCenter: aMorph [
	generator doIfElse
]

{ #category : #'control ops' }
MicroPythonCode >> doIfEnd: aMorph [
	generator doIfEnd
]

{ #category : #'control ops' }
MicroPythonCode >> doIterateBegin: aMorph [
	| list var |
	list := aMorph blockArgs first choice.
	var := aMorph blockArgs second varName.
	generator doIterateBegin: list var: var
]

{ #category : #'control ops' }
MicroPythonCode >> doIterateEnd: aMorph [
	generator doIterateEnd
]

{ #category : #'control ops' }
MicroPythonCode >> doRepeatBegin: aMorph [
	| num var |
	num := aMorph blockArgs first argString: parser.
	var := aMorph blockArgs second varName.
	generator doRepeatBegin: num var: var
]

{ #category : #'control ops' }
MicroPythonCode >> doRepeatEnd: aMorph [
	generator doRepeatEnd
]

{ #category : #'control ops' }
MicroPythonCode >> doUntilBegin: aMorph [
	| cond |
	cond := aMorph blockArgs first argString: parser.
	generator doUntilBegin: cond
]

{ #category : #'control ops' }
MicroPythonCode >> doUntilEnd: aMorph [
	generator doUntilEnd
]

{ #category : #'control ops' }
MicroPythonCode >> doWhileBegin: aMorph [
	| cond |
	cond := aMorph blockArgs first argString: parser.
	generator doWhileBegin: cond
]

{ #category : #'control ops' }
MicroPythonCode >> doWhileEnd: aMorph [
	generator doWhileEnd
]

{ #category : #private }
MicroPythonCode >> eventTitleString: aString [
	self shouldBeImplemented
]

{ #category : #'arg generator' }
MicroPythonCode >> expressionArgWithMenuString: aMorph [
	| v |
	v := aMorph specialValue.
	v ifNil: [ ^ self argString: aMorph ].
	(#(#append:toList: #deleteLine:ofList: #insert:at:ofList: #setLine:ofList:to: #getLine:ofList:)
		includes: aMorph ownerSelector)
		ifTrue: [ v = #all
				ifTrue: [ ^ ':' ].
			v = #last
				ifTrue: [ ^ '-1' ] ].
	^ v
]

{ #category : #private }
MicroPythonCode >> falseString [
	^ generator falseString
]

{ #category : #'code generator' }
MicroPythonCode >> generateCode: aSymbol morph: aMorph [
	self class addCommand: aSymbol.
	SpScratchApp
		try: [ self rawGenerateCode: aSymbol morph: aMorph ]
		onFailure: [ aMorph showBalloon: 'error' ]
]

{ #category : #'code generator' }
MicroPythonCode >> generateEmptySubBody [
	generator generatePass
]

{ #category : #'code generator' }
MicroPythonCode >> generateGlobalVars: aCollection [
	generator generateGlobalVars: aCollection
]

{ #category : #'code generator' }
MicroPythonCode >> generateIndent: anInteger [
	generator indent: anInteger
]

{ #category : #'code generator' }
MicroPythonCode >> generatePass [
	generator generatePass
]

{ #category : #'code generator' }
MicroPythonCode >> generateReporter: aString [
	generator appendWithNewline: aString
]

{ #category : #'code generator' }
MicroPythonCode >> generateReporter: aSymbol morph: aMorph [
	| ret |
	self class addCommand: aSymbol.
	ret := 0.
	SpScratchApp
		try: [ ret := self rawGenerateCode: aSymbol morph: aMorph ]
		onFailure: [ aMorph showBalloon: 'error' ].
	^ ret
]

{ #category : #'code generator' }
MicroPythonCode >> generateSubHeader: aString [
	generator def: aString
]

{ #category : #'variable ops' }
MicroPythonCode >> getVar: var [
	^ generator getVar: var variable
]

{ #category : #accessing }
MicroPythonCode >> header [
	^ generator header
]

{ #category : #private }
MicroPythonCode >> indentLevelFor: aString [ 
	^ aString = 'start' "'Scratch-StartClicked'"
		ifTrue: [0]
		ifFalse: [1]
]

{ #category : #private }
MicroPythonCode >> localVarArgString: aString [
	^ generator localVarArgString: aString
]

{ #category : #accessing }
MicroPythonCode >> parse: aBlock withHeader: aBoolean [
	| code |
	code := self parse: aBlock.
	(code isEmpty or: [ aBoolean not ])
		ifTrue: [ ^ code ].
	^ self header , code
]

{ #category : #accessing }
MicroPythonCode >> parseHats: aCollection [
	| code |
	aCollection do: [ :each | each parseUsing: parser ].
	code := generator code.
	^ generator header , code
]

{ #category : #'code generator' }
MicroPythonCode >> rawGenerateCode: aSymbol morph: aMorph [
	| args script |
	script := aMorph script.
	args := self argsOf: aMorph.
	(script isExternalBlock: aSymbol)
		ifTrue: [ ^ generator
				generateExtCode: aSymbol asSymbol
				arguments: args
				for: script ].
	(script isInternalBlock: aSymbol)
		ifTrue: [ ^ generator
				generateIntCode: aSymbol asSymbol
				arguments: args
				for: script ].
	aSymbol = #getVar:
		ifTrue: [ ^ aMorph variable ].
	^ generator perform: aSymbol asSymbol withArguments: args
]

{ #category : #private }
MicroPythonCode >> variableArgString: aString [
	^ generator variableArgString: aString
]

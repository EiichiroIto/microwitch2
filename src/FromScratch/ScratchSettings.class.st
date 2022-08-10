Class {
	#name : #ScratchSettings,
	#superclass : #Object,
	#instVars : [
		'dictionary'
	],
	#category : #'FromScratch-Spec2'
}

{ #category : #accessing }
ScratchSettings >> at: aSymbol [

	^ self perform: aSymbol
]

{ #category : #accessing }
ScratchSettings >> at: aSymbol put: anObject [

	self perform: (aSymbol , ':') asSymbol with: anObject
]

{ #category : #accessing }
ScratchSettings >> dictionary [

	^ dictionary
]

{ #category : #accessing }
ScratchSettings >> dictionary: aDictionary [

	dictionary := aDictionary.
	SpScratchApp useErrorCatcher: self useErrorCatcher
]

{ #category : #accessing }
ScratchSettings >> dontClose [
	^ dictionary at: #dontClose ifAbsentPut: [ false ]
]

{ #category : #accessing }
ScratchSettings >> dontClose: aBoolean [
	dictionary at: #dontClose put: aBoolean
]

{ #category : #accessing }
ScratchSettings >> fullscreen [
	^ dictionary at: #fullscreen ifAbsent: [ false ]
]

{ #category : #accessing }
ScratchSettings >> fullscreen: aBoolean [
	dictionary at: #fullscreen put: aBoolean
]

{ #category : #accessing }
ScratchSettings >> hideDebugMenu [
	^ dictionary at: #hideDebugMenu ifAbsentPut: [ false ]
]

{ #category : #accessing }
ScratchSettings >> hideDebugMenu: aBoolean [
	dictionary at: #hideDebugMenu put: aBoolean
]

{ #category : #initialization }
ScratchSettings >> initialize [

	dictionary := Dictionary new.
	self dontClose: false.
	self keepMaximize: false.
	self hideDebugMenu: false.
	self projectDir: ''.
	self stickyWindow: false.
	self useErrorCatcher: false.
	self fullscreen: false.
	self resizable: true
]

{ #category : #accessing }
ScratchSettings >> keepMaximize [
	^ dictionary at: #keepMaximize ifAbsentPut: [ false ]
]

{ #category : #accessing }
ScratchSettings >> keepMaximize: aBoolean [
	dictionary at: #keepMaximize put: aBoolean
]

{ #category : #accessing }
ScratchSettings >> keys [

	^ dictionary keys sorted
]

{ #category : #accessing }
ScratchSettings >> language [
	^ dictionary at: #language ifAbsent: [ '' ]
]

{ #category : #accessing }
ScratchSettings >> language: aString [
	dictionary at: #language put: aString
]

{ #category : #accessing }
ScratchSettings >> optionsFor: aSymbol [
	aSymbol = #stickyWindow
		ifTrue: [ ^ {true . false} ].
	aSymbol = #useErrorCatcher
		ifTrue: [ ^ {true . false} ].
	aSymbol = #dontClose
		ifTrue: [ ^ {true . false} ].
	aSymbol = #keepMaximize
		ifTrue: [ ^ {true . false} ].
	aSymbol = #language
		ifTrue: [ ^ ScratchTranslator availableLocales ].
	aSymbol = #projectDir
		ifTrue: [ ^ #string ].
	aSymbol = #fullscreen
		ifTrue: [ ^ {true . false} ].
	aSymbol = #resizable
		ifTrue: [ ^ {true . false} ].
	aSymbol = #hideDebugMenu
		ifTrue: [ ^ {true . false} ].
	^ #()
]

{ #category : #accessing }
ScratchSettings >> projectDir [

	^ dictionary
		  at: #projectDir
		  ifAbsent: [ ^ FileSystem workingDirectory pathString ]
]

{ #category : #accessing }
ScratchSettings >> projectDir: aString [
	dictionary at: #projectDir put: aString
]

{ #category : #accessing }
ScratchSettings >> resizable [
	^ dictionary at: #resizable ifAbsentPut: [ true ]
]

{ #category : #accessing }
ScratchSettings >> resizable: aBoolean [
	dictionary at: #resizable put: aBoolean
]

{ #category : #accessing }
ScratchSettings >> stickyWindow [
	^ dictionary at: #stickyWindow ifAbsent: [ false ]
]

{ #category : #accessing }
ScratchSettings >> stickyWindow: aBoolean [
	dictionary at: #stickyWindow put: aBoolean
]

{ #category : #accessing }
ScratchSettings >> useErrorCatcher [
	^ dictionary at: #useErrorCatcher ifAbsent: [ false ]
]

{ #category : #accessing }
ScratchSettings >> useErrorCatcher: aBoolean [
	dictionary at: #useErrorCatcher put: aBoolean.
	SpScratchApp useErrorCatcher: aBoolean
]
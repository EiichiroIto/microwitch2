Class {
	#name : #MicrobitFirmware,
	#superclass : #Object,
	#instVars : [
		'firmwares'
	],
	#classVars : [
		'Default'
	],
	#category : #'Microwitch-Microbit'
}

{ #category : #accessing }
MicrobitFirmware class >> default [

	^ Default
]

{ #category : #accessing }
MicrobitFirmware class >> default: anObject [

	Default := anObject
]

{ #category : #initialization }
MicrobitFirmware class >> initialize [

	"MicrobitFirmware initialize"

	Default := self new
		           readFirmwares;
		           yourself
]

{ #category : #api }
MicrobitFirmware >> firmwareFor: aFileReference [

	| uniqueID version |
	uniqueID := self uniqueIDFrom: aFileReference contents.
	uniqueID ifNil: [ ^ nil ].
	version := self firmwareVersionForUniqueID: uniqueID.
	^ firmwares at: version ifAbsent: [ nil ]
]

{ #category : #api }
MicrobitFirmware >> firmwarePathIfFail: aBlock [

	| ret |
	Smalltalk os isWindows ifFalse: [ ^ nil ].
	ret := MicrowitchLibCall new microbitDriveLetters.
	ret isEmpty ifTrue: [ aBlock cull: 'micro:bit not found.' localized ].
	ret size > 1 ifTrue: [ 
		aBlock cull: 'Only one micro:bit can be updated.' localized ].
	^ ret first asFileReference
]

{ #category : #utilities }
MicrobitFirmware >> firmwareVersionForUniqueID: aString [

	aString = '9900' ifTrue: [ ^ #v10 ].
	aString = '9901' ifTrue: [ ^ #v10 ].
	aString = '9903' ifTrue: [ ^ #v20 ].
	aString = '9904' ifTrue: [ ^ #v20 ].
	aString = '9905' ifTrue: [ ^ #v20 ].
	aString = '9906' ifTrue: [ ^ #v20 ].
	^ nil
]

{ #category : #utilities }
MicrobitFirmware >> hardwareIdFrom: aString [ 
	| index vid pid |
	index := aString findString: 'VID_'.
	vid := index > 0 ifTrue: [aString copyFrom: index + 4 to: index + 7].
	index := aString findString: 'PID_'.
	pid := index > 0 ifTrue: [aString copyFrom: index + 4 to: index + 7].
	^ Array with: vid with: pid
]

{ #category : #printing }
MicrobitFirmware >> printOn: aStream [

	aStream
		nextPutAll: self class name;
		nextPut: $(;
		nextPutAll:
			(firmwares ifNil: [ 'no' ] ifNotNil: [ firmwares size ]) asString;
		nextPutAll: ' firms)'
]

{ #category : #api }
MicrobitFirmware >> readFirmwares [

	| dir dict |
	dict := Dictionary new.
	dir := FileSystem workingDirectory / 'MicroPython'.
	(dir filesMatching: '*.hex') do: [ :each | 
		dict at: each base asSymbol put: each contents ].
	firmwares := dict
]

{ #category : #utilities }
MicrobitFirmware >> uniqueIDFrom: aString [

	| tokens |
	aString lines do: [ :each | 
		tokens := each findTokens: ':'.

		tokens first = 'Unique ID' ifTrue: [ 
			^ tokens second trimBoth copyFrom: 1 to: 4 ] ].
	^ nil
]

{ #category : #api }
MicrobitFirmware >> versions [
	^ firmwares keys
]

Extension { #name : #String }

{ #category : #'*Microwitch' }
String >> animateOn: aLed atInterval: anInteger [
	aLed animateString: self interval: anInteger.
]

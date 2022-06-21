Extension { #name : #Number }

{ #category : #'*Microwitch' }
Number >> animateOn: aLed atInterval: anInteger [
	aLed animateString: self asString interval: anInteger
]

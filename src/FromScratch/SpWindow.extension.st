Extension { #name : 'SpWindow' }

{ #category : '*FromScratch' }
SpWindow >> displayExtentChanged [
	self model ifNil: [ ^ self ].
	(self model application respondsTo: #displayExtentChanged)
		ifFalse: [ ^ self ].
	self model application displayExtentChanged
]

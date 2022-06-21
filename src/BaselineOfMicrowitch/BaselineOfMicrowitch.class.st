Class {
	#name : #BaselineOfMicrowitch,
	#superclass : #BaselineOf,
	#category : #BaselineOfMicrowitch
}

{ #category : #baselines }
BaselineOfMicrowitch >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				package: 'FromScratch';
				package: 'FromScratch-Tests'
					with: [ spec requires: #('FromScratch') ];
				package: 'Microwitch' with: [ spec requires: #('FromScratch') ];
				package: 'Microwitch-Tests'
					with: [ spec requires: #('FromScratch' 'Microwitch') ] ]
]

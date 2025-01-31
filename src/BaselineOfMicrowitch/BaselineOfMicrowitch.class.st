Class {
	#name : 'BaselineOfMicrowitch',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfMicrowitch',
	#package : 'BaselineOfMicrowitch'
}

{ #category : 'baselines' }
BaselineOfMicrowitch >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			package: 'FromScratch';
			package: 'FromScratch-Tests'
			with: [ spec requires: #( 'FromScratch' ) ];
			package: 'MicroPythonProxy';
			package: 'MicroPythonBlocks'
			with: [ spec requires: #( 'FromScratch' 'MicroPythonProxy' ) ];
			package: 'Microwitch'
			with: [ spec requires: #( 'MicroPythonBlocks' ) ];
			package: 'Microwitch-Tests'
			with: [ spec requires: #( 'Microwitch' ) ] ].
	spec group: 'Deploy' with: #( 'Microwitch' )
]

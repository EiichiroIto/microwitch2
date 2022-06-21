"
A SpMicroWizStageTest is a test class for testing the behavior of SpMicroWizStage
"
Class {
	#name : #SpMicrowitchStageTest,
	#superclass : #TestCase,
	#category : #'Microwitch-Tests'
}

{ #category : #private }
SpMicrowitchStageTest >> newApplication [
	^ Microwitch new
]

{ #category : #private }
SpMicrowitchStageTest >> newStage [
	^ SpMicrowitchFrame basicNew
		application: self newApplication;
		initialize;
		privStage
]

{ #category : #test }
SpMicrowitchStageTest >> testPlotDataFromString [
	| s ret |
	s := self newStage.
	self assert: (s plotDataFromString: 'abc') isEmpty.
	ret := s plotDataFromString: '123'.
	self assert: ret size equals: 1.
	self assert: (ret first isKindOf: ScratchPlotData).
	self assert: ret first channel equals: 1.
	self assert: ret first data equals: 123.
	ret := s plotDataFromString: '45 67'.
	self assert: ret size equals: 2.
	self assert: (ret first isKindOf: ScratchPlotData).
	self assert: ret first channel equals: 1.
	self assert: ret first data equals: 45.
	self assert: (ret second isKindOf: ScratchPlotData).
	self assert: ret second channel equals: 2.
	self assert: ret second data equals: 67.
	ret := s plotDataFromString: '[45, 67]'.
	self assert: ret size equals: 2.
	self assert: (ret first isKindOf: ScratchPlotData).
	self assert: ret first channel equals: 1.
	self assert: ret first data equals: 45.
	self assert: (ret second isKindOf: ScratchPlotData).
	self assert: ret second channel equals: 2.
	self assert: ret second data equals: 67
]

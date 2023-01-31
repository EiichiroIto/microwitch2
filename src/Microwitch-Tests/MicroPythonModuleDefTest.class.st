"
A MicroWizModuleDefTest is a test class for testing the behavior of MicroWizModuleDef
"
Class {
	#name : #MicroPythonModuleDefTest,
	#superclass : #TestCase,
	#category : #'Microwitch-Tests'
}

{ #category : #private }
MicroPythonModuleDefTest >> newBlockDef [
	^ BlockDef new
]

{ #category : #private }
MicroPythonModuleDefTest >> newCategory [
	^ BlockCategory new
]

{ #category : #private }
MicroPythonModuleDefTest >> newChoiceArgDef [

	^ StaticChoiceArgDef new
]

{ #category : #private }
MicroPythonModuleDefTest >> newDef [
	^ MicroPythonModuleDef new
]

{ #category : #private }
MicroPythonModuleDefTest >> newSeparator [
	^ BlockSeparator new
]

{ #category : #test }
MicroPythonModuleDefTest >> testBlockDefAt [
	| d b1 b2 b3 |
	d := self newDef.
	b1 := self newBlockDef
		block: 'a %n b %s';
		id: 1;
		yourself.
	b2 := self newBlockDef
		block: 'aaa %x bbb';
		id: 2;
		yourself.
	b3 := self newBlockDef
		block: 'ab cd ef';
		id: 3;
		yourself.
	d
		blockDefs:
			{b1.
			b2.
			b3}.
	d setup.
	self assert: (d blockDefAt: #int1arg1:arg2:) equals: b1.
	self assert: (d blockDefAt: #int2arg1:) equals: b2.
	self assert: (d blockDefAt: #int3) equals: b3.
	self assert: (d blockDefAt: #int4) isNil
]

{ #category : #test }
MicroPythonModuleDefTest >> testBlockDefs [
	| d |
	d := self newDef.
	self assert: d blockDefs isNil.
	d blockDefs: #(1 2 3).
	self assertCollection: d blockDefs equals: #(1 2 3)
]

{ #category : #test }
MicroPythonModuleDefTest >> testBlockDict [
	| d dict |
	d := self newDef.
	self assert: d blockDefs isNil.
	dict := Dictionary new.
	d blockDict: dict.
	self assertCollection: d blockDict equals: dict
]

{ #category : #test }
MicroPythonModuleDefTest >> testBlockTuples [
	| d b1 b2 ret |
	d := self newDef.
	b1 := self newBlockDef
		block: 'set oled w %n h %n';
		id: 1;
		defaultArgs: #(64 128).
	b2 := self newBlockDef
		block: 'vl read';
		id: 2;
		return: 'r';
		defaultArgs: #().
	d
		blockDefs:
			{b1.
			b2};
		setup.
	ret := d blockTuples.
	self assert: ret size equals: 2.
	self
		assertCollection: ret first
		equals: #('set oled w %n h %n' - #int1arg1:arg2: 64 128).
	self assertCollection: ret second equals: #('vl read' r int2)
]

{ #category : #test }
MicroPythonModuleDefTest >> testBlocks [
	| d b1 b2 b3 s1 c1 ret |
	d := self newDef.
	b1 := self newBlockDef
		block: 'abc';
		yourself.
	b2 := self newBlockDef
		block: 'def';
		yourself.
	b3 := self newBlockDef
		block: 'ghi';
		yourself.
	s1 := self newSeparator.
	c1 := self newCategory
		categoryName: 'xyz';
		yourself.
	d
		blockDefs:
			{c1.
			b1.
			b2.
			s1.
			b3}.
	ret := d blocks.
	self
		assertCollection: ret
		equals:
			'xyz' , String lf , 'abc' , String lf , 'def' , String lf , '-'
				, String lf , 'ghi'
]

{ #category : #test }
MicroPythonModuleDefTest >> testChoiceArgs [

	| d b1 b2 b3 ret |
	d := self newDef.
	b1 := self newBlockDef
		      block: 'set oled w %n h %n';
		      id: 1;
		      defaultArgs: #( 64 128 ).
	b2 := self newChoiceArgDef arg: $x.
	b3 := self newBlockDef
		      block: 'vl read';
		      id: 2;
		      return: 'r';
		      defaultArgs: #(  ).
	d
		blockDefs: { 
				b1.
				b2.
				b3 };
		setup.
	ret := d choiceArgs.
	self assert: ret size equals: 1.
	self assert: (ret first isKindOf: StaticChoiceArgDef)
]

{ #category : #test }
MicroPythonModuleDefTest >> testSetup [
	self
		testSetupBlockDefs;
		testSetupBlockDict
]

{ #category : #test }
MicroPythonModuleDefTest >> testSetupBlockDefs [
	"do nothing"
]

{ #category : #test }
MicroPythonModuleDefTest >> testSetupBlockDict [
	| d b1 b2 b3 |
	d := self newDef.
	b1 := self newBlockDef
		block: 'a %n b %s';
		id: 1;
		yourself.
	b2 := self newBlockDef
		block: 'aaa %x bbb';
		id: 2;
		yourself.
	b3 := self newBlockDef
		block: 'ab cd ef';
		id: 3;
		yourself.
	d blockDefs: { b1. b2. b3 }.
	d setupBlockDefs.
	d setupBlockDict.
	self assert: d blockDict isDictionary.
	self assert: (d blockDict includesKey: #int1arg1:arg2:).
	self assert: (d blockDict includesKey: #int2arg1:).
	self assert: (d blockDict includesKey: #int3)
]

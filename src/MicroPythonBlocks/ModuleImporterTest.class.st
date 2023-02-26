"
An ExtModuleImporterTest is a test class for testing the behavior of ExtModuleImporter
"
Class {
	#name : #ModuleImporterTest,
	#superclass : #TestCase,
	#category : #'MicroPythonBlocks-Tests'
}

{ #category : #private }
ModuleImporterTest >> newImporter [
	^ ModuleImporter new
]

{ #category : #test }
ModuleImporterTest >> testAppName [

	| obj |
	obj := self newImporter.
	self assert: obj appName isNil.
	obj appName: 'abc'.
	self assert: obj appName equals: 'abc'.
	obj appName: 'def'.
	self assert: obj appName equals: 'def'
]

{ #category : #test }
ModuleImporterTest >> testCategory [
	| i out |
	i := self newImporter.
	out := i category: 'sensing'.
	self assert: (out isKindOf: ScratchBlockCategory).
	self assert: out categoryName equals: 'sensing'
]

{ #category : #test }
ModuleImporterTest >> testCommandBlockArgsCodeImportsSelector [

	| i out |
	i := self newImporter.
	out := i
		       commandBlock: 'set oled w %n h %n'
		       args: #( 64 128 )
		       code: 'oled=SSD1306_I2C(%n,%n,i2c)'
		       imports: #( i2c #( microbit * ) )
		       selector: #abc:def:.
	self assert: (out isKindOf: MicroPythonBlockSpec).
	self assert: out isCommandBlock.
	self assert: out label equals: 'set oled w %n h %n'.
	self assertCollection: out arguments equals: #( 64 128 ).
	self assert: out code equals: 'oled=SSD1306_I2C(%n,%n,i2c)'.
	self assertCollection: out imports equals: #( i2c #( microbit
	      * ) ).
	self assert: out selector equals: #abc:def:
]

{ #category : #test }
ModuleImporterTest >> testCommandBlockArgsCodeSelector [

	| i out |
	i := self newImporter.
	out := i
		       commandBlock: 'set oled w %n h %n'
		       args: #( 64 128 )
		       code: 'oled=SSD1306_I2C(%n,%n,i2c)'
		       selector: #abc:def:.
	self assert: (out isKindOf: MicroPythonBlockSpec).
	self assert: out isCommandBlock.
	self assert: out label equals: 'set oled w %n h %n'.
	self assertCollection: out arguments equals: #( 64 128 ).
	self assert: out code equals: 'oled=SSD1306_I2C(%n,%n,i2c)'.
	self assert: out selector equals: #abc:def:
]

{ #category : #test }
ModuleImporterTest >> testCommandBlockArgsCodeVarImportsSelector [

	| i out |
	i := self newImporter.
	out := i
		       commandBlock: 'set oled w %n h %n'
		       args: #( 64 128 )
		       code: 'oled=SSD1306_I2C(%n,%n,i2c)'
		       var: 'oled'
		       imports: #( i2c )
		       selector: #abc:def:.
	self assert: (out isKindOf: MicroPythonBlockSpec).
	self assert: out isCommandBlock.
	self assert: out label equals: 'set oled w %n h %n'.
	self assertCollection: out arguments equals: #( 64 128 ).
	self assert: out code equals: 'oled=SSD1306_I2C(%n,%n,i2c)'.
	self assert: out var equals: 'oled'.
	self assertCollection: out imports equals: #( i2c ).
	self assert: out selector equals: #abc:def:
]

{ #category : #test }
ModuleImporterTest >> testImport [

	| i in out |
	i := self newImporter.
	i appName: 'Microwitch'.
	in := '(Microwitch (name:blocks: oled ()))'.
	out := i import: in.
	self assert: (out isKindOf: MicroPythonModule).
	self assert: out name equals: 'oled'.
	self assert: out blockSpecs isEmpty
]

{ #category : #test }
ModuleImporterTest >> testImportBlockDef [
	| i in out |
	i := self newImporter.
	in := #('commandBlock:args:code:imports:selector:' 'set oled w %n h %n' (64 128) 'oled=SSD1306_I2C(%n,%n,i2c)' #(i2c) #w:h:).
	out := i importBlockDef: in.
	self assert: (out isKindOf: MicroPythonBlockSpec).
	in := #('reporterBlock:args:return:code:imports:selector:' 'vl read' () 'r' 'vl.read()' #() #vlread).
	out := i importBlockDef: in.
	self assert: (out isKindOf: MicroPythonBlockSpec).
	in := #('category:' 'sensing').
	out := i importBlockDef: in.
	self assert: (out isKindOf: ScratchBlockCategory).
	self assert: out categoryName equals: 'sensing'.
	in := #('separator').
	out := i importBlockDef: in.
	self assert: (out isKindOf: ScratchBlockSeparator)
]

{ #category : #test }
ModuleImporterTest >> testImportFrom [

	| i in out |
	i := self newImporter.
	i appName: 'Microwitch'.
	in := #( 'Microwitch' #( 'name:blocks:' 'oled' #(  ) ) ).
	out := i importFrom: in.
	self assert: (out isKindOf: MicroPythonModule)
]

{ #category : #test }
ModuleImporterTest >> testModuleName [

	| obj |
	obj := self newImporter.
	self assert: obj moduleName isNil.
	obj moduleName: 'abc'.
	self assert: obj moduleName equals: 'abc'.
	obj moduleName: 'def'.
	self assert: obj moduleName equals: 'def'
]

{ #category : #test }
ModuleImporterTest >> testNameBlocks [

	| i out |
	i := self newImporter.
	out := i name: 'microbit' blocks: #().
	self assert: (out isKindOf: MicroPythonModule).
	self assert: out name equals: 'microbit'.
	self assert: out blockSpecs isEmpty
]

{ #category : #test }
ModuleImporterTest >> testNewBlockSpec [

	| obj r |
	obj := self newImporter.
	obj moduleName: 'abc'.
	r := obj newBlockSpec.
	self assert: (r isKindOf: MicroPythonBlockSpec).
	self assert: r moduleName equals: 'abc'
]

{ #category : #test }
ModuleImporterTest >> testReporterBlockArgsReturnCodeImportsSelector [

	| i out |
	i := self newImporter.
	out := i
		       reporterBlock: 'vl read'
		       args: #(  )
		       return: 'r'
		       code: 'vl.read()'
		       imports: #(  )
		       selector: #vlread.
	self assert: (out isKindOf: MicroPythonBlockSpec).
	self assert: out isReporterBlock.
	self assert: out label equals: 'vl read'.
	self assert: out arguments isEmpty.
	self assert: out code equals: 'vl.read()'.
	self assert: out imports isEmpty.
	self assert: out selector equals: #vlread
]

{ #category : #test }
ModuleImporterTest >> testReporterBlockArgsReturnCodeSelector [

	| i out |
	i := self newImporter.
	out := i
		       reporterBlock: 'vl read'
		       args: #(  )
		       return: 'r'
		       code: 'vl.read()'
		       selector: #vlread.
	self assert: (out isKindOf: MicroPythonBlockSpec).
	self assert: out isReporterBlock.
	self assert: out label equals: 'vl read'.
	self assert: out arguments isEmpty.
	self assert: out code equals: 'vl.read()'.
	self assert: out selector equals: #vlread
]

{ #category : #test }
ModuleImporterTest >> testSeparator [
	| i out |
	i := self newImporter.
	out := i separator.
	self assert: (out isKindOf: ScratchBlockSeparator)
]

{ #category : #test }
ModuleImporterTest >> testTypeOf [

	| obj |
	obj := self newImporter.
	self assert: (obj typeOf: '-') equals: #isCommandBlock.
	self assert: (obj typeOf: 'r') equals: #isReporterBlock.
	self assert: (obj typeOf: 'b') equals: #isBooleanReporter.
	self assert: (obj typeOf: 's') equals: #isSpecialForm.
	self assert: (obj typeOf: 't') equals: #isTimedBlock
]

Class {
	#name : #MicrowitchLibrary,
	#superclass : #FFILibrary,
	#category : #'Microwitch-Plugins'
}

{ #category : #'accessing platform' }
MicrowitchLibrary >> macModuleName [
	^ 'microwitch.so'
]

{ #category : #'accessing platform' }
MicrowitchLibrary >> unixModuleName [
	^ 'microwitch.so'
]

{ #category : #'accessing platform' }
MicrowitchLibrary >> win32ModuleName [
	^ 'microwitch.dll'
]

Class {
	#name : #CZToolBar,
	#superclass : #SpPresenter,
	#instVars : [
		'btnSave',
		'btnInspect'
	],
	#category : #'arXivConnector-gui'
}

{ #category : #layout }
CZToolBar >> defaultLayout [

	^SpBoxLayout newLeftToRight
		add: btnSave expand: false ;
		add: btnInspect expand: false ;
		yourself
]

{ #category : #initialization }
CZToolBar >> initializePresenters [ 
	super initializePresenters.

	btnSave    := self newButton
		icon: (self iconNamed: #smallSave) ;
		action: [ owner toolbarSave ] ;
		yourself.

	btnInspect := self newButton
		icon: (self iconNamed: #smallInspectIt) ;
		action: [ owner toolbarInspect ] ;
		yourself
]

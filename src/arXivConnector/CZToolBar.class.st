Class {
	#name : #CZToolBar,
	#superclass : #SpPresenter,
	#instVars : [
		'btnSave',
		'btnInspect',
		'btnNew',
		'btnDelete'
	],
	#category : #'arXivConnector-gui'
}

{ #category : #layout }
CZToolBar >> defaultLayout [

	^SpBoxLayout newLeftToRight
		add: btnNew expand: false ;
		add: btnSave expand: false ;
		add: btnDelete expand: false ;
		add: btnInspect expand: false ;
		yourself
]

{ #category : #initialization }
CZToolBar >> initializePresenters [ 
	super initializePresenters.

	btnNew  := self newButton
		icon: (self iconNamed: #smallNew) ;
		help: 'New item' ;
		action: [ owner toolbarNew ] ;
		yourself.

	btnDelete  := self newButton
		icon: (self iconNamed: #smallDelete) ;
		help: 'Delete item' ;
		action: [ owner toolbarDelete ] ;
		yourself.

	btnSave := self newButton
		icon: (self iconNamed: #smallSave) ;
		help: 'Save' ;
		action: [ owner toolbarSave ] ;
		yourself.

	btnInspect := self newButton
		icon: (self iconNamed: #smallInspectIt) ;
		help: 'Inspect' ;
		action: [ owner toolbarInspect ] ;
		yourself
]

Class {
	#name : #CZEntryListPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'lstEntries',
		'lblEntries',
		'checkEntryIcon',
		'checkEntryBlock',
		'toolbar'
	],
	#category : #'arXivConnector-gui'
}

{ #category : #'instance creation' }
CZEntryListPresenter class >> on: aBibset [

	^self new
		on: aBibset ;
		open
]

{ #category : #accessing }
CZEntryListPresenter >> checkEntryBlock [

	^ checkEntryBlock
]

{ #category : #accessing }
CZEntryListPresenter >> checkEntryBlock: anObject [

	checkEntryBlock := anObject
]

{ #category : #accessing }
CZEntryListPresenter >> checkEntryIcon [

	^ checkEntryIcon
]

{ #category : #accessing }
CZEntryListPresenter >> checkEntryIcon: anObject [

	checkEntryIcon := anObject
]

{ #category : #layout }
CZEntryListPresenter >> defaultLayout [

	^SpBoxLayout newTopToBottom 
		add: #lblEntries expand: false ;
		add: #lstEntries ;
		add: #toolbar expand: false ;
		yourself
]

{ #category : #interaction }
CZEntryListPresenter >> iconForEntry: entry [

	^ self iconNamed: ((checkEntryBlock value: entry)
			   ifTrue: [ self checkEntryIcon ]
			   ifFalse: [ #blank ])
]

{ #category : #initialization }
CZEntryListPresenter >> initialize [

	super initialize.

	checkEntryBlock := [ :entry | false ].
	checkEntryIcon := #smallOk
]

{ #category : #initialization }
CZEntryListPresenter >> initializePresenters [

	lstEntries := self newList.
	lstEntries
		beSingleSelection ;
		display: [ :entry | entry title value ] ;
		displayIcon: [ :entry | self iconForEntry: entry ] ;
		sortingBlock: [:a :b | a title value < b title value ] ;
		whenSelectionChangedDo: [ :selection | selection isEmpty
			ifTrue: [ owner clearForm ]
			ifFalse: [ self showEntry: selection ] ].

	lblEntries := self newLabel.
	lblEntries label: '0 entry'.

	toolbar := self instantiate: CZToolBar
]

{ #category : #'instance creation' }
CZEntryListPresenter >> on: aBibset [

	self onEntries: aBibset entries
]

{ #category : #'instance creation' }
CZEntryListPresenter >> onEntries: aCollection [

	lstEntries items: aCollection.
	lstEntries unselectAll.
	lstEntries items ifNotEmpty: [ lstEntries clickAtIndex: 1].

	lblEntries label: (aCollection size asString , ' entries').
]

{ #category : #interaction }
CZEntryListPresenter >> selectArticle: anArticle [

	lstEntries clickAtIndex: (lstEntries items indexOf: anArticle)
]

{ #category : #interaction }
CZEntryListPresenter >> showEntry: selection [

	owner showArticle: selection selectedItem
]

{ #category : #action }
CZEntryListPresenter >> toolbarInspect [
]

{ #category : #action }
CZEntryListPresenter >> toolbarSave [

	| saveFile |

	lstEntries items ifEmpty: [
		UIManager default inform: 'No articles selected'.
		^self ].

	saveFile := UIManager default
		chooseForSaveFileReference: 'Save entries to file:'
		extensions: 'bib'
		path: self owner defaultDirectoryName asFileReference.

	saveFile ifNil: [ ^self ].
	owner saveArticles: lstEntries items on: saveFile
]

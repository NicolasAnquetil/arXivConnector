"
GUI for visualizing articles in a CZBibset and taking notes on them

To import a library: `(CZLibraryGUI onBibFile: 'a/file/name') open`
"
Class {
	#name : #CZLibraryGUI,
	#superclass : #SpPresenter,
	#instVars : [
		'wdwArticle',
		'model',
		'lstKeywords',
		'lstPapers'
	],
	#category : #'arXivConnector-gui'
}

{ #category : #'instance creation' }
CZLibraryGUI class >> myBib [
	<example>

	self new
		myBib
]

{ #category : #'instance creation' }
CZLibraryGUI class >> on: aCZBibset [

	^self new
		on: aCZBibset
]

{ #category : #'instance creation' }
CZLibraryGUI class >> rmodBib [
	<example>

	self new
		rmodBib
]

{ #category : #interaction }
CZLibraryGUI >> clearArticleList [

	lstPapers reset
]

{ #category : #accessing }
CZLibraryGUI >> defaultDirectoryName [

	^'/home/anquetil/Documents/RMod/Rech/'
]

{ #category : #layout }
CZLibraryGUI >> defaultLayout [

	^SpBoxLayout newHorizontal
		add: lstKeywords ;
		add: lstPapers ;
		add: wdwArticle ;
		yourself
]

{ #category : #interaction }
CZLibraryGUI >> deleteAction [

	self shouldBeImplemented 
]

{ #category : #initialization }
CZLibraryGUI >> initialize [

	super initialize.

	self model: CZLibraryModel new.
	model view: self
]

{ #category : #initialization }
CZLibraryGUI >> initializePresenters [

	super initializePresenters.

	lstKeywords := self instantiate: CZKeywordListPresenter.
	lstPapers := self instantiate: CZPaperListPresenter.
	wdwArticle := self instantiate: CZEntryPresenter
]

{ #category : #initialization }
CZLibraryGUI >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.

	aWindowPresenter
		title: 'BibTeX library';
		initialExtent: (1200@600)
]

{ #category : #accessing }
CZLibraryGUI >> keywordList [

	^self model keywords associations

]

{ #category : #accessing }
CZLibraryGUI >> model [

	^ model
]

{ #category : #accessing }
CZLibraryGUI >> model: anObject [

	model := anObject
]

{ #category : #'instance creation' }
CZLibraryGUI >> myBib [

	model myBib
]

{ #category : #interaction }
CZLibraryGUI >> newKeywordAction [
	"Creating a new key word"

	| kw |
	kw := SpRequestDialog new
		title: 'New keyword' ;
		acceptLabel: 'OK' ;
		openModal.

	kw ifNil: [ ^self ].
	model addKeyword: kw.
]

{ #category : #interaction }
CZLibraryGUI >> noArticleSelected [

	wdwArticle clearForm
]

{ #category : #interaction }
CZLibraryGUI >> noKeywordSelected [
	lstPapers reset.
	self noArticleSelected
]

{ #category : #'instance creation' }
CZLibraryGUI >> on: aCollection [
	model articles: aCollection.
	model updateKeywordsList.

]

{ #category : #interaction }
CZLibraryGUI >> resetView [

	lstKeywords reset.
	lstPapers reset
]

{ #category : #'instance creation' }
CZLibraryGUI >> rmodBib [

	model rmodBib
]

{ #category : #interaction }
CZLibraryGUI >> saveAction [

	model saveArticles
]

{ #category : #interaction }
CZLibraryGUI >> saveArticles: czEntries on: aFileReference [

	SpConfirmDialog new
		title: 'Confirm library save';
		label: 'Are you sure you want to overwrite the library bibfile?';
		acceptLabel: 'Yes';
		cancelLabel: 'No';
		onCancel: [ ^self ];
		openDialog.

	model saveArticles: czEntries on: aFileReference
]

{ #category : #interaction }
CZLibraryGUI >> selectKeyword: keyword andArticle: anArticle [

	lstKeywords selectKey: keyword.
	anArticle ifNotNil: [ lstPapers selectArticle: anArticle ]
]

{ #category : #interaction }
CZLibraryGUI >> selectedKeyword: selectedKeywords [

	model selectedKeyword: selectedKeywords
]

{ #category : #interaction }
CZLibraryGUI >> showArticle: anArticle [

	wdwArticle on: anArticle
]

{ #category : #interaction }
CZLibraryGUI >> showArticles: aCollection [

	lstPapers showArticles: aCollection
]

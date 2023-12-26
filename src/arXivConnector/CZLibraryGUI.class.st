"
GUI for visualizing articles in a CZBibset and taking notes on them

To import a library: `(CZLibraryGUI onBibFile: 'a/file/name') open`
"
Class {
	#name : #CZLibraryGUI,
	#superclass : #SpPresenter,
	#instVars : [
		'lstKeywords',
		'lstOwners',
		'article',
		'wdwArticle',
		'keywords',
		'lblKeywords',
		'model',
		'wdwKeywordArticles',
		'toolbar'
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
CZLibraryGUI >> clearAll [
	wdwKeywordArticles on: (CZSet new).
	self clearForm
]

{ #category : #action }
CZLibraryGUI >> clearArticleList [

	wdwKeywordArticles onEntries: #()
]

{ #category : #interaction }
CZLibraryGUI >> clearForm [

	wdwArticle clearForm
]

{ #category : #initialization }
CZLibraryGUI >> connectPresenters [
	super connectPresenters.

	lstKeywords whenSelectionChangedDo: [ :selection |
		selection selectedItem
			ifNil: [ self clearAll ]
			ifNotNil: [ :keyAndArticles | model selectedKeyword: keyAndArticles ]
	].

	lstOwners  whenSelectionChangedDo: [ :selection |
		selection selectedItem
			ifNotNil: [ :key | 
				self selectKey: key andArticle: article ]
	].
]

{ #category : #accessing }
CZLibraryGUI >> defaultDirectoryName [

	^'/home/anquetil/Documents/RMod/Rech/'
]

{ #category : #layout }
CZLibraryGUI >> defaultLayout [

	^SpBoxLayout newHorizontal
		add: (SpBoxLayout newVertical
			add: #toolbar expand: false ;
			add: #lblKeywords expand: false ;
			add: #lstKeywords ;
			yourself) ;
		add: (SpBoxLayout newVertical
			add: 'Keyword papers' expand: false ;
			add: #wdwKeywordArticles ;
			add: 'Paper keywords' expand: false ;
			add: #lstOwners ;
			yourself) ;
		add: #wdwArticle ;
		yourself
]

{ #category : #initialization }
CZLibraryGUI >> initialize [

	super initialize.

	self model: CZLibraryModel new.
	model view: self
]

{ #category : #initialization }
CZLibraryGUI >> initializePresenters [
	lblKeywords := self newLabel
		label: 'Keywords: 0' ;
		yourself.
	lstKeywords := self instantiate: SpFilteringListPresenter.
	lstKeywords display: [ :keyAndArticles | keyAndArticles key , ': ' , keyAndArticles value size asString ].
	lstKeywords listPresenter
		beSingleSelection ;
		sortingBlock: [:a :b | a key < b key ].

	wdwKeywordArticles := self instantiate: CZEntryListPresenter.
	wdwKeywordArticles model: self model.
	wdwKeywordArticles checkEntryBlock: [ :entry | model articleHasNote: entry ].

	lstOwners := self newList
		sortingBlock: [:a :b | a < b ] ;
		enabled: false ;
		yourself.

	wdwArticle := self instantiate: CZEntryPresenter.

	toolbar := self instantiate: CZToolBar.
]

{ #category : #initialization }
CZLibraryGUI >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.

	aWindowPresenter
		title: 'BibTeX library';
		initialExtent: (1200@600)
]

{ #category : #accessing }
CZLibraryGUI >> lstKeywords [
	^ lstKeywords
]

{ #category : #accessing }
CZLibraryGUI >> model [

	^ model
]

{ #category : #accessing }
CZLibraryGUI >> model: anObject [

	model := anObject.
	wdwKeywordArticles model: anObject
]

{ #category : #'instance creation' }
CZLibraryGUI >> myBib [

	model myBib
]

{ #category : #'instance creation' }
CZLibraryGUI >> on: aCollection [
	model articles: aCollection.
	model updateKeywordsList.

]

{ #category : #interaction }
CZLibraryGUI >> resetView [

	lstKeywords items: (model keywords associations sorted: [:a :b | a key < b key ]).
	lblKeywords label: 'Keywords: ' , lstKeywords items size asString
]

{ #category : #'instance creation' }
CZLibraryGUI >> rmodBib [

	model rmodBib
]

{ #category : #action }
CZLibraryGUI >> saveArticles: czEntries on: aFileReference [

	SpConfirmDialog new
		title: 'Confirm library save';
		label: 'Are you sure you want to overwrite the library bibfile?';
		acceptLabel: 'Yes';
		cancelLabel: 'No';
		onCancel: [ ^self ];
		openDialog.
1halt.
	model saveArticles: czEntries on: aFileReference
]

{ #category : #interaction }
CZLibraryGUI >> selectKey: key andArticle: anArticle [
	lstKeywords listPresenter
		selectIndex: (lstKeywords items findFirst: [ :kwItem | kwItem key = key])
		scrollToSelection: true.

	anArticle ifNotNil: [ wdwKeywordArticles selectArticle: anArticle ]
]

{ #category : #interaction }
CZLibraryGUI >> showArticle: anArticle [

	article := anArticle.

	lstOwners items: (model articleKeywords: anArticle).
	wdwArticle on: anArticle
]

{ #category : #action }
CZLibraryGUI >> showArticles: aCollection [

	wdwKeywordArticles onEntries: aCollection
]

{ #category : #action }
CZLibraryGUI >> toolbarNew [
	"Creating a new key word"

	| kw |
	kw := SpRequestDialog new
		title: 'New keyword' ;
		acceptLabel: 'OK' ;
		openModal.

	kw ifNil: [ ^self ].
	model addKeyword: kw.
]

{ #category : #action }
CZLibraryGUI >> toolbarSave [

	model saveArticles
]

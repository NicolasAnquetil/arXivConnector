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
		'pstrArticles',
		'keywords',
		'lblKeywords',
		'model'
	],
	#category : #'arXivConnector-core'
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
	pstrArticles on: (CZSet new).
	self clearForm
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
			ifNotNil: [ :keyAndArticles | pstrArticles onEntries: keyAndArticles value ]
	].

	lstOwners  whenSelectionChangedDo: [ :selection |
		selection selectedItem
			ifNotNil: [ :key | 
				self selectKey: key andArticle: article ]
	].
]

{ #category : #layout }
CZLibraryGUI >> defaultLayout [

	^SpBoxLayout newHorizontal
		add: (SpBoxLayout newVertical
			add: #lblKeywords expand: false ;
			add: #lstKeywords ;
			yourself) ;
		add: (SpBoxLayout newVertical
			add: 'Keyword papers' expand: false ;
			add: #pstrArticles ;
			add: 'Paper keywords' expand: false ;
			add: #lstOwners ;
			yourself) ;
		add: #wdwArticle ;
		yourself
]

{ #category : #initialization }
CZLibraryGUI >> initialize [

	super initialize.

	model := CZLibraryModel new.
	model view: self
]

{ #category : #initialization }
CZLibraryGUI >> initializePresenters [
	lblKeywords := self newLabel
		label: 'Keywords: 0' ;
		yourself.
	lstKeywords := self newList
		beSingleSelection ;
		display: [ :keyAndArticles | keyAndArticles key , ': ' , keyAndArticles value size asString ] ;
		sortingBlock: [:a :b | a key < b key ] ;
		yourself.

	pstrArticles   := self instantiate: CZEntryListPresenter.
	pstrArticles parentPresenter: self.

	lstOwners   := self newList
		enabled: false ;
		yourself.

	"wdwArticle := self instantiate: ArXPaperPresenter."
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
CZLibraryGUI >> lstKeywords [
	^ lstKeywords
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

	lstKeywords items: model keywords associations.
	lblKeywords label: 'Keywords: ' , lstKeywords items size asString
]

{ #category : #'instance creation' }
CZLibraryGUI >> rmodBib [

	model rmodBib
]

{ #category : #interaction }
CZLibraryGUI >> selectKey: key andArticle: anArticle [
	lstKeywords
		selectIndex: (lstKeywords items findFirst: [ :kwItem | kwItem key = key])
		scrollToSelection: true.

	pstrArticles selectArticle: anArticle
]

{ #category : #interaction }
CZLibraryGUI >> showArticle: anArticle [

	article := anArticle.

	lstOwners items: (model articleKeywords: anArticle).
	wdwArticle on: anArticle
]

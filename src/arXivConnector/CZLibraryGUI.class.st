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
		'db',
		'btnBar',
		'wdwArticle',
		'pstrArticles',
		'keywords',
		'lblKeywords'
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
		on: aCZBibset ;
		open
]

{ #category : #'instance creation' }
CZLibraryGUI class >> onBibFile: bibFileName [

	self
		on: (bibFileName asFileReference readStreamDo: [ :stream |
			CZBibParser parse: stream contents ]) ;
		open
]

{ #category : #'instance creation' }
CZLibraryGUI class >> rmodBib [
	<example>

	self new
		rmodBib
]

{ #category : #interaction }
CZLibraryGUI >> articleKeywords: anArticle [

	^ (Character space split: (anArticle at: #keywords) value) reject:
		  #isEmpty
]

{ #category : #TOREMOVE }
CZLibraryGUI >> articleToZotero [
	article toZoteroCollection: db getCollectionFromZotero.
	db removeArticle: article.
	self on: db
]

{ #category : #accessing }
CZLibraryGUI >> btnBar [
	^ btnBar
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

{ #category : #TOREMOVE }
CZLibraryGUI >> defaultDB [ 

	self on: ArXHandler new reloadDB.

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

	btnBar := self newActionBar
		add: (self newButton
			label: 'Zotero'; 
			help: 'to Zotero';
			action: [ self articleToZotero ];
			yourself) ;
		add: (self newButton
			label: 'Inspect'; 
			help: 'to Zotero';
			action: [ article inspect ];
			yourself) ;
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

	
	self onBibFile: self myBibFileName 
]

{ #category : #accessing }
CZLibraryGUI >> myBibFileName [

	^'/home/anquetil/Documents/RMod/Rech/literature.bib'
]

{ #category : #'instance creation' }
CZLibraryGUI >> on: articles [ 
	db := articles.
	self updateKeywordsList.

]

{ #category : #'instance creation' }
CZLibraryGUI >> onBibFile: bibFileName [

	self
		on: (bibFileName asFileReference readStreamDo: [ :stream |
			CZBibParser parse: stream contents ]) ;
		open
]

{ #category : #'instance creation' }
CZLibraryGUI >> rmodBib [

	
	self onBibFile: self rmodBibFileName 
]

{ #category : #accessing }
CZLibraryGUI >> rmodBibFileName [

	^'/home/anquetil/Documents/RMod/Reports/Bibliography/bib/rmod.bib'
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

	lstOwners items: (self articleKeywords: anArticle).
	wdwArticle on: anArticle
]

{ #category : #'instance creation' }
CZLibraryGUI >> updateKeywordsList [

	keywords := Dictionary new.

	db do: [ :czArticle |
		(self articleKeywords: czArticle) do: [ :keywrd || kwMembers |
			kwMembers := keywords at: keywrd ifAbsentPut: [ OrderedCollection new ].
			kwMembers add: czArticle
		]
	].

	lstKeywords items: (keywords associations).
	lblKeywords label: 'Keywords: ' , (lstKeywords items size asString)

]

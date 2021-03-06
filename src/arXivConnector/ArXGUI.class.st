Class {
	#name : #ArXGUI,
	#superclass : #SpPresenter,
	#instVars : [
		'lstKeywords',
		'lstTitles',
		'lstOwners',
		'txtTitle',
		'txtAuthors',
		'txtAbstract',
		'key',
		'article',
		'db',
		'btnBar'
	],
	#category : #'arXivConnector-core'
}

{ #category : #specs }
ArXGUI class >> defaultSpec [
	<spec>
	^SpBoxLayout newHorizontal
		add: #lstKeywords ;
		add: (SpBoxLayout newVertical
			add: #lstTitles ;
			add: #lstOwners ;
			yourself) ;
		add: (SpBoxLayout newVertical
			add: #txtTitle ;
			add: #txtAuthors ;
			add: #txtAbstract ;
			addLast: #btnBar expand: false fill: false padding: 0 ;
			yourself) ;
		yourself
]

{ #category : #accessing }
ArXGUI >> article: arXArticle [
	article := arXArticle.
	txtTitle    text: arXArticle title.
	txtAuthors  text: arXArticle authors.
	txtAbstract text: arXArticle abstract.
	lstOwners items: (db keysOwningArticle: arXArticle) 
]

{ #category : #initialization }
ArXGUI >> articleToZotero [
	article toZoteroCollection: db getCollectionFromZotero.
	db removeArticle: article.
	self db: db
]

{ #category : #accessing }
ArXGUI >> btnBar [
	^ btnBar
]

{ #category : #initialization }
ArXGUI >> clearAll [
	lstTitles items: #().
	self clearForm
]

{ #category : #initialization }
ArXGUI >> clearForm [
	txtAbstract text: ''.
	txtAuthors text: ''.
	txtTitle text: ''.
	article := nil
]

{ #category : #initialization }
ArXGUI >> connectPresenters [
	super connectPresenters.
	lstKeywords whenSelectionChangedDo: [ :selection |
		selection selectedItem
			ifNil: [ self clearAll ]
			ifNotNil: [ :keyAndArticles | 
				lstTitles unselectAll.
				lstTitles items: keyAndArticles value.
				lstTitles clickAtIndex: 1 ]
	].
	lstTitles whenSelectionChangedDo: [ :selection |
		selection selectedItem
			ifNil: [ self clearForm ]
			ifNotNil: [ :art | 
				self article: art ]
	
	].
	lstOwners  whenSelectionChangedDo: [ :selection |
		selection selectedItem
			ifNotNil: [ :keyAndArticles | 
				self selectKey: keyAndArticles andArticle: article ]
	
	].
]

{ #category : #accessing }
ArXGUI >> db [
	^ db
]

{ #category : #accessing }
ArXGUI >> db: arXDB [ 
	db := arXDB.
	lstKeywords items: arXDB allKeys
]

{ #category : #initialization }
ArXGUI >> initialize [ 
	super initialize.
	self db: ArXHandler new reloadDB.

]

{ #category : #initialization }
ArXGUI >> initializePresenters [
	lstKeywords := self newList
		beSingleSelection ;
		display: [ :keyAndArticles | keyAndArticles key , ' - ' , keyAndArticles value size asString ] ;
		yourself.
	lstTitles   := self newList
		beSingleSelection ;
		display: [ :arXArticle | arXArticle title ] ;
		yourself.
	lstOwners   := self newList
		enabled: false ;
		display: [ :keyAndArticles | keyAndArticles key ] ;
		yourself.

	txtTitle    := self newText enabled: false ; yourself.
	txtAuthors  := self newText enabled: false ; yourself.
	txtAbstract := self newText enabled: false ; yourself.
	
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
]

{ #category : #accessing }
ArXGUI >> lstKeywords [
	^ lstKeywords
]

{ #category : #accessing }
ArXGUI >> lstTitles [
	^ lstTitles
]

{ #category : #initialization }
ArXGUI >> selectKey: keyAndArticles andArticle: anArticle [
	lstKeywords clickAtIndex: (lstKeywords items indexOf: keyAndArticles).
	lstTitles clickAtIndex: (lstTitles items indexOf: anArticle)
]

{ #category : #accessing }
ArXGUI >> txtAbstract [
	^ txtAbstract
]

{ #category : #accessing }
ArXGUI >> txtAuthors [
	^ txtAuthors
]

{ #category : #accessing }
ArXGUI >> txtTitle [
	^ txtTitle
]

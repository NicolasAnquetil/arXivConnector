Class {
	#name : #CZPaperListPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'article',
		'lstArticles',
		'lstArticleKeywords'
	],
	#category : #'arXivConnector-gui'
}

{ #category : #layout }
CZPaperListPresenter >> defaultLayout [

	^SpBoxLayout newVertical
		add: 'Keyword papers' expand: false ;
		add: lstArticles ;
		add: lstArticleKeywords ;
		yourself
]

{ #category : #interaction }
CZPaperListPresenter >> deleteAction: keyword [

	self model removeKeyword: keyword inArticle: article
]

{ #category : #initialization }
CZPaperListPresenter >> initializePresenters [

	super initializePresenters.

	lstArticles := self instantiate: CZEntryListPresenter.
	lstArticles checkEntryBlock: [ :entry | self model articleHasNote: entry ].

	lstArticleKeywords := self instantiate: CZKeywordListPresenter.
	lstArticleKeywords label: 'Paper keywords'

]

{ #category : #interaction }
CZPaperListPresenter >> keywordList [

	^(self model articleKeywords: article)
		collect: [ :keyword | keyword -> article ]

]

{ #category : #accessing }
CZPaperListPresenter >> model [

	^owner model
]

{ #category : #interaction }
CZPaperListPresenter >> newKeywordAction [

	SpRequestDialog new
		title: 'Keyword';
		label: 'Enter keyword';
		onAccept: [ :dialog |  self model addKeyword: dialog presenter text inArticle: article ];
		openDialog
]

{ #category : #interaction }
CZPaperListPresenter >> noArticleSelected [

	owner noArticleSelected
]

{ #category : #initialization }
CZPaperListPresenter >> noKeywordSelected [

]

{ #category : #initialization }
CZPaperListPresenter >> reset [

	article := nil.
	lstArticles onEntries: #().
	lstArticleKeywords reset.
	self noArticleSelected
]

{ #category : #interaction }
CZPaperListPresenter >> selectArticle: anArticle [

	lstArticles selectArticle: anArticle
]

{ #category : #initialization }
CZPaperListPresenter >> selectedKeyword: keyword [

	owner selectKeyword: keyword andArticle: article
]

{ #category : #interaction }
CZPaperListPresenter >> showArticle: anArticle [

	article := anArticle.

	lstArticleKeywords reset.
	owner showArticle: anArticle
]

{ #category : #interaction }
CZPaperListPresenter >> showArticles: aCollection [

	lstArticles onEntries: aCollection
]

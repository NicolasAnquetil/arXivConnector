Class {
	#name : #ArXPaperPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'txtTitle',
		'txtAuthors',
		'txtAbstract',
		'key',
		'article'
	],
	#category : #'arXivConnector-core'
}

{ #category : #accessing }
ArXPaperPresenter >> article: arXArticle [
	article := arXArticle.
	txtTitle    text: arXArticle title.
	txtAuthors  text: arXArticle authors.
	txtAbstract text: arXArticle abstract.

]

{ #category : #initialization }
ArXPaperPresenter >> clearForm [
	txtAbstract text: ''.
	txtAuthors text: ''.
	txtTitle text: ''.
	article := nil
]

{ #category : #layout }
ArXPaperPresenter >> defaultLayout [

	^SpBoxLayout newVertical
		add: #txtTitle ;
		add: #txtAuthors ;
		add: #txtAbstract ;
		yourself
]

{ #category : #initialization }
ArXPaperPresenter >> initializePresenters [
	super initializePresenters.

	txtTitle    := self newText enabled: false ; yourself.
	txtAuthors  := self newText enabled: false ; yourself.
	txtAbstract := self newText enabled: false ; yourself.

]

{ #category : #accessing }
ArXPaperPresenter >> txtAbstract [
	^ txtAbstract
]

{ #category : #accessing }
ArXPaperPresenter >> txtAuthors [
	^ txtAuthors
]

{ #category : #accessing }
ArXPaperPresenter >> txtTitle [
	^ txtTitle
]

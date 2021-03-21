Class {
	#name : #ArXArticle,
	#superclass : #Object,
	#instVars : [
		'title',
		'url',
		'authors',
		'abstract',
		'comment'
	],
	#category : #'arXivConnector-core'
}

{ #category : #accessing }
ArXArticle >> abstract [
	^ abstract
]

{ #category : #accessing }
ArXArticle >> abstract: anObject [
	abstract := anObject
]

{ #category : #activation }
ArXArticle >> asPharoteroItem [
	^PharoteroItem new
		title: title ;
		url: url ;
		abstract: abstract ;
		authors: (self parseAuthors: authors) ;
		comment: self comment ;
		yourself
]

{ #category : #accessing }
ArXArticle >> authors [
	^ authors
]

{ #category : #accessing }
ArXArticle >> authors: anObject [
	authors := anObject
]

{ #category : #accessing }
ArXArticle >> comment [
	^ comment
]

{ #category : #accessing }
ArXArticle >> comment: anObject [
	comment := anObject
]

{ #category : #printing }
ArXArticle >> longPrintOn: aStream [
	aStream
		nextPutAll: self authors ;
		nextPut: Character cr ;
		nextPutAll: self title ;
		nextPut: Character cr ;
		nextPutAll: self url ;
		nextPut: Character cr 
]

{ #category : #activation }
ArXArticle >> parseAuthors: aString [
	^((', ' split: aString) flatCollect: [ :s | ' and ' split: s ])
		collect: [ :auth | PharoteroAuthor name: auth ]
]

{ #category : #printing }
ArXArticle >> printOn: aStream [
	aStream
		nextPutAll: 'ArXArticle: ' ;
		nextPutAll: self title
]

{ #category : #accessing }
ArXArticle >> title [
	^ title
]

{ #category : #accessing }
ArXArticle >> title: anObject [
	title := anObject
]

{ #category : #activation }
ArXArticle >> toZotero [
	^self toZoteroCollection: ArXHandler new getCollectionFromZotero
]

{ #category : #activation }
ArXArticle >> toZoteroCollection: aCollectionName [
	PharoteroServer new
		rmodIdentity ;
		addItem: (self asPharoteroItem) type: 'document' in: aCollectionName
]

{ #category : #accessing }
ArXArticle >> url [
	^url
]

{ #category : #accessing }
ArXArticle >> url: aString [
	url := aString
]

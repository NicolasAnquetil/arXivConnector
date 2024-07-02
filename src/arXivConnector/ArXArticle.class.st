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
	#category : #'arXivConnector-old'
}

{ #category : #'as yet unclassified' }
ArXArticle class >> presenterClass [

	^ArXPaperPresenter 
]

{ #category : #accessing }
ArXArticle >> abstract [
	^ abstract
]

{ #category : #accessing }
ArXArticle >> abstract: anObject [
	abstract := anObject
]

{ #category : #converting }
ArXArticle >> asCitezen [

	| czEntry |
	
	czEntry := CZEntry type: CZEntry techreport.
	
	czEntry key: self czKey.
	czEntry at: #title put: self title.
	czEntry at: #url put: self url.
	czEntry at: #author put: self authorsCleaned.
	czEntry at: #abstract put: self abstract.
	czEntry at: #note put: (self comment ifNil: ['']).
	"czEntry at: #keywords put: (self comment ifNil: [''])."

	^czEntry
	
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

{ #category : #converting }
ArXArticle >> authorsCleaned [

	^String streamContents: [ :stream |
		authors do: [ :c |
			(c = $,)
			ifTrue: [ stream << ' and ' ]
			ifFalse: [
				(c = $;)
				ifTrue: [ stream << ' and ' ]
				ifFalse: [ stream << c ] ] ]
	]
]

{ #category : #accessing }
ArXArticle >> comment [
	^ comment
]

{ #category : #accessing }
ArXArticle >> comment: anObject [
	comment := anObject
]

{ #category : #converting }
ArXArticle >> czKey [

	| arXivNumber |
	arXivNumber := ($/ split: self url) last.

	^('arxiv' , arXivNumber) asSymbol
]

{ #category : #initialization }
ArXArticle >> initialize [

	super initialize.
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
	PharoteroServer instance
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

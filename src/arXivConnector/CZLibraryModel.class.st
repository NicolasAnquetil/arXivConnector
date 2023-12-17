Class {
	#name : #CZLibraryModel,
	#superclass : #Object,
	#instVars : [
		'articles',
		'keywords',
		'view'
	],
	#category : #'arXivConnector-core'
}

{ #category : #accessing }
CZLibraryModel >> addArticles: aCollection [

	articles addAll: aCollection
]

{ #category : #interaction }
CZLibraryModel >> articleKeywords: anArticle [

	^ (Character space split: (anArticle at: #keywords) value) reject:
		  #isEmpty
]

{ #category : #accessing }
CZLibraryModel >> articles [

	^ articles
]

{ #category : #accessing }
CZLibraryModel >> articles: anObject [

	articles := anObject
]

{ #category : #initialization }
CZLibraryModel >> initialize [

	super initialize.

	keywords := Dictionary new.
	articles := OrderedCollection new
]

{ #category : #accessing }
CZLibraryModel >> keywords [

	^ keywords
]

{ #category : #accessing }
CZLibraryModel >> keywords: anObject [

	keywords := anObject
]

{ #category : #'instance creation' }
CZLibraryModel >> loadBibFile: bibFileName [

	^ bibFileName asFileReference readStreamDo: [ :stream |
		  CZBibParser parse: stream contents ]
]

{ #category : #'instance creation' }
CZLibraryModel >> myBib [

	
	self onBibFile: self myBibFileName 
]

{ #category : #accessing }
CZLibraryModel >> myBibFileName [

	^'/home/anquetil/Documents/RMod/Rech/literature.bib'
]

{ #category : #'instance creation' }
CZLibraryModel >> onBibFile: bibFileName [

	self articles: (self loadBibFile: bibFileName).
	self updateKeywordsList.
	view open

]

{ #category : #'instance creation' }
CZLibraryModel >> onBibFile: bibFileName keyWord: aKeyWord [
	"loads new articles in existing DB and classify them in aKeyWord"

	articles := self loadBibFile: bibFileName.

	self addArticles: articles.
	(keywords at: aKeyWord ifAbsentPut: [ OrderedCollection new ])
		addAll: articles
]

{ #category : #'instance creation' }
CZLibraryModel >> rmodBib [

	
	self onBibFile: self rmodBibFileName 
]

{ #category : #accessing }
CZLibraryModel >> rmodBibFileName [

	^'/home/anquetil/Documents/RMod/Reports/Bibliography/bib/rmod.bib'
]

{ #category : #'instance creation' }
CZLibraryModel >> updateKeywordsList [

	self articles do: [ :czArticle |
		(self articleKeywords: czArticle) do: [ :keywrd |
			| kwMembers |
			kwMembers := keywords
				             at: keywrd
				             ifAbsentPut: [ OrderedCollection new ].
			kwMembers add: czArticle ] ].
	view resetView
]

{ #category : #accessing }
CZLibraryModel >> view [

	^ view
]

{ #category : #accessing }
CZLibraryModel >> view: anObject [

	view := anObject
]

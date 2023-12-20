Class {
	#name : #CZLibraryModel,
	#superclass : #Object,
	#instVars : [
		'articles',
		'keywords',
		'view'
	],
	#category : #'arXivConnector-model'
}

{ #category : #accessing }
CZLibraryModel >> addArticles: aCollection [

	articles addAll: aCollection
]

{ #category : #'instance creation' }
CZLibraryModel >> articleKeywords: anArticle [

	^($, split: (anArticle at: #keywords) value)
		reject: #isEmpty
		thenCollect: #trimBoth
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
	articles := CZSet new
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

	articles addAll: (self loadBibFile: bibFileName).
	self updateKeywordsList

]

{ #category : #'instance creation' }
CZLibraryModel >> rmodBib [

	
	self onBibFile: self rmodBibFileName 
]

{ #category : #accessing }
CZLibraryModel >> rmodBibFileName [

	^'/home/anquetil/Documents/RMod/Reports/Bibliography/bib/rmod.bib'
]

{ #category : #action }
CZLibraryModel >> saveArticles: czEntries on: aFileReference [

	| renderer |
	aFileReference writeStreamDo: [ :stream |
		renderer := BibBibRenderer new.
		renderer setStream: stream.
		czEntries do: [ :article | renderer render: article ]
	]
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

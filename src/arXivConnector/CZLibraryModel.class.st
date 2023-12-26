Class {
	#name : #CZLibraryModel,
	#superclass : #Object,
	#instVars : [
		'articles',
		'keywords',
		'view',
		'bibFile',
		'selectedKeyword'
	],
	#category : #'arXivConnector-model'
}

{ #category : #accessing }
CZLibraryModel >> addArticle: anArticle [

	articles add: anArticle.
	self updateKeywordsList
]

{ #category : #accessing }
CZLibraryModel >> addArticles: aCollection [

	articles addAll: aCollection.
	self updateKeywordsList
]

{ #category : #accessing }
CZLibraryModel >> addKeyword: aString [

	keywords at: aString put: OrderedCollection new.
	view resetView.
	view selectKey: aString andArticle: nil
]

{ #category : #'as yet unclassified' }
CZLibraryModel >> articleHasNote: article [

	(article at: #note) isUndefined ifTrue: [ ^false ].

	(article at: #note) value ifEmpty: [ ^false ].

	^true
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

	articles := anObject.
	self updateKeywordsList
]

{ #category : #action }
CZLibraryModel >> createArticle [

	self keyword: selectedKeyword addArticle: self newArticle.
	self selectedKeyword: selectedKeyword
]

{ #category : #initialization }
CZLibraryModel >> initialize [

	super initialize.

	keywords := Dictionary new.
	articles := CZSet new
]

{ #category : #'instance creation' }
CZLibraryModel >> keyword: keywrd addArticle: czArticle [

	| kwMembers |
	kwMembers := keywords
		             at: keywrd
		             ifAbsentPut: [ OrderedCollection new ].
	^ kwMembers add: czArticle
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

{ #category : #accessing }
CZLibraryModel >> newArticle [

	^CZEntry new
]

{ #category : #'instance creation' }
CZLibraryModel >> onBibFile: bibFileName [

	bibFile := bibFileName.
	self articles: (self loadBibFile: bibFileName)
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
CZLibraryModel >> saveArticles [

	| bibReferenceFile |

	bibReferenceFile := bibFile asFileReference.
	bibReferenceFile exists
		ifTrue: [ bibReferenceFile delete ].
	self saveArticles: articles on: bibReferenceFile
]

{ #category : #action }
CZLibraryModel >> saveArticles: czEntries on: aFileReference [

	| renderer |
	aFileReference writeStreamDo: [ :stream |
		renderer := BibBibRenderer new.
		renderer library: BibPhraseArxivLibrary new.
		renderer setStream: stream.
		czEntries do: [ :article | renderer render: article ]
	]
]

{ #category : #action }
CZLibraryModel >> selectedKeyword: aKeywordEntry [

	aKeywordEntry ifNil: [
		selectedKeyword := nil.
		view clearArticleList.
		^self
	].

	aKeywordEntry isAssociation ifTrue: [
		selectedKeyword := aKeywordEntry key.
		view showArticles: aKeywordEntry value.
		^self
	].

	selectedKeyword := aKeywordEntry.
	view showArticles:  (keywords at: aKeywordEntry)
]

{ #category : #'instance creation' }
CZLibraryModel >> updateKeywordsList [

	self articles do: [ :czArticle |
		(self articleKeywords: czArticle) do: [ :keywrd |
			self keyword: keywrd addArticle: czArticle ] ].
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

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

{ #category : #keywords }
CZLibraryModel >> addKeyword: aString [

	keywords at: aString put: OrderedCollection new.
	view resetView.
	view selectKeyword: aString andArticle: nil
]

{ #category : #keywords }
CZLibraryModel >> addKeyword: keyword inArticle: aCZEntry [ 

	| entryKeywords |
	entryKeywords := self articleKeywords: aCZEntry.

	aCZEntry
		at: #keywords
		put: (', ' join: (entryKeywords , {keyword})).

	self updateKeywordsList.
	view selectedKeyword: keyword 
]

{ #category : #testing }
CZLibraryModel >> articleHasNote: article [

	(article at: #note) isUndefined ifTrue: [ ^false ].

	(article at: #note) value ifEmpty: [ ^false ].

	^true
]

{ #category : #keywords }
CZLibraryModel >> articleKeywords: anArticle [

	anArticle ifNil: [ ^#() ].

	(anArticle at: #keywords) isUndefined ifTrue: [ ^#( allPapers ) ].

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
CZLibraryModel >> backupFile: aFileReference [

	| backupFile |
	backupFile := (aFileReference fullName , '~') asFileReference.

	backupFile exists ifTrue: [ backupFile delete ].

	aFileReference renameTo: backupFile basename
	
]

{ #category : #action }
CZLibraryModel >> createArticleFromArxiv: arxivEntryText [

	(self arxivTextToCZEntry: arxivEntryText)
	ifNotNil: [ :article |
		self keyword: selectedKeyword addArticle: article.
		self selectedKeyword: selectedKeyword
	]
]

{ #category : #initialization }
CZLibraryModel >> initialize [

	super initialize.

	keywords := Dictionary new.
	articles := CZSet new
]

{ #category : #keywords }
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

{ #category : #action }
CZLibraryModel >> loadBibFile: bibFileName [

	^ bibFileName asFileReference readStreamDo: [ :stream |
		  CZBibParser parse: stream contents ]
]

{ #category : #initialization }
CZLibraryModel >> myBib [
	
	self onBibFile: self myBibFileName 
]

{ #category : #accessing }
CZLibraryModel >> myBibFileName [

	^'/home/anquetil/Documents/RMod/Rech/literature.bib'
]

{ #category : #initialization }
CZLibraryModel >> onBibFile: bibFileName [

	bibFile := bibFileName.
	self articles: (self loadBibFile: bibFileName)
]

{ #category : #keywords }
CZLibraryModel >> removeKeyword: keyword inArticle: aCZEntry [ 

	| entryKeywords |
	entryKeywords := self articleKeywords: aCZEntry.
	entryKeywords remove: keyword.

	aCZEntry
		at: #keywords
		put: (', ' join: entryKeywords).

	self updateKeywordsList.

	self keywords
		at: keyword
		ifPresent: [ view selectedKeyword: keyword ]
		ifAbsent: [  view clearArticleList ]
]

{ #category : #initialization }
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
		ifTrue: [ self backupFile: bibReferenceFile copy  ].
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

{ #category : #keywords }
CZLibraryModel >> updateKeywordsList [

	keywords := Dictionary new.

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

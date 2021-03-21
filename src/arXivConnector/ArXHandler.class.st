"
Usage: arXiv <cmd>
	
Commands:
  importMessage <file.mbox> -- Imports given mbox file into DB (outputs a backup of the DB)
  importWithKey <file.mbox> <key> -- Imports given mbox file into DB
  zotero <file.mbox> [ <collection> ] -- Imports given mbox file into Zotero collection
  listKeywords -- list all indexing key words in the DB
  listArticles -- list all indexed articles in the DB
  searchKeyword <keyword> -- search articles indexed with a given keyword
  cleanBackups -- keep only the last 5 backup files
  help -- prints this message

"
Class {
	#name : #ArXHandler,
	#superclass : #CommandLineHandler,
	#instVars : [
		'articles',
		'factory'
	],
	#category : #'arXivConnector-core'
}

{ #category : #accessing }
ArXHandler class >> commandName [
	^ 'arXiv'
]

{ #category : #accessing }
ArXHandler class >> description [
	^ 'Handles arXiv commands'
]

{ #category : #activation }
ArXHandler >> activate [
	| cmd |
	self activateHelpWithoutArguments
		ifTrue: [ self exitFailure ].

	cmd := self arguments first asSymbol.
	[ self perform: cmd ]
   on: MessageNotUnderstood
	do: [
		self printHelp.
		self exitFailure: 'Could not process command: ' , self arguments first ].
	self exitSuccess 
]

{ #category : #helpers }
ArXHandler >> allKeys [
	^(self articles associations
		sorted: [ :a :b | a key < b key ])
]

{ #category : #accessing }
ArXHandler >> articles [
	^articles
]

{ #category : #accessing }
ArXHandler >> backupFilename [
	^self backupFilename: 0
]

{ #category : #accessing }
ArXHandler >> backupFilename: indice [
	^'/home/anquetil/articles.' , indice asString ,'.ston'
]

{ #category : #activation }
ArXHandler >> cleanBackups [
	self removeBackupsAfterVersion: 4
]

{ #category : #helpers }
ArXHandler >> countArticles [
	^(articles values flatCollectAsSet: #yourself) size
]

{ #category : #'private - utilities' }
ArXHandler >> getCollection [
	(self arguments size > 2)
	ifTrue: [ ^ ' ' join: (self arguments allButFirst: 2) ].

	^[self getCollectionFromZotero]
	on: Exception
	do: [ :except |
		self exitFailure: except messageText
	]

]

{ #category : #helpers }
ArXHandler >> getCollectionFromZotero [
	PharoteroServer new desktopClientIsUp
	ifFalse: [ Exception signal: 'Could not find a Zotero collection, none found in parameters and desktop client not running' ].

	^PharoteroServer new desktopCurrentCollection
		ifNil: [ Exception signal: 'Failed to retrieve current Zotero collection from desktop client' ]
]

{ #category : #'private - utilities' }
ArXHandler >> getMboxFile: filename [
	| file |
	(filename endsWith: '.mbox')
		ifFalse: [ ^ nil ].
	file := filename asFileReference.
	file exists ifFalse: [ ^ false ].
	^file

]

{ #category : #activation }
ArXHandler >> importMessage [
	| file |
	file := self getMboxFile: (self arguments second).
	file ifNil: [ self exitFailure: 'Could not process file: ' , self arguments second].
	self parseMessage: file.
	self reloadDB.
	self index: factory article at: factory getKeywords.
	self saveDB.
	self nbArticlesFound: (self countArticles)
]

{ #category : #activation }
ArXHandler >> importWithKey [
	| key file |

	(self arguments size < 3)
	ifTrue: [ 
		self exitFailure: 'importWithKey requires 2 arguments: <file.mbox> <keyword>'	].

	file := self getMboxFile: (self arguments second).
	file ifNil: [ self exitFailure: 'Could not process file: ' , self arguments third].

	key := ' ' join: (self arguments allButFirst: 2).

	self parseMessage: file.
	self reloadDB.
	self index: factory article at: { key }.
	self saveDB.
	self nbArticlesFound: (self countArticles)
]

{ #category : #'private - utilities' }
ArXHandler >> index: article at: keywords [
	keywords do: [ :key |
		self keyword: key add: article
	]
]

{ #category : #initialization }
ArXHandler >> initialize [
	super initialize.
	factory := ArXArticleFactory new
]

{ #category : #helpers }
ArXHandler >> keysOwningArticle: anArticle [
	^self articles associations select: [ :keyAndArticles |
		keyAndArticles value anySatisfy: [ :art | art = anArticle]]
]

{ #category : #'private - utilities' }
ArXHandler >> keyword: key add: article [
	| coll |
	coll := self articles at: key ifAbsentPut: [ OrderedCollection new ].
	coll add: article
]

{ #category : #activation }
ArXHandler >> listArticles [
	|totalArt|
	totalArt := 0.
	self reloadDB.
	(self articles flatCollectAsSet: #yourself)
		do: [ :art |
			totalArt := totalArt + 1.
			art longPrintOn: self stdout.
			self stdout
				nextPutAll: '-----' ;
				nextPut: Character cr.
		].
	self nbArticlesFound: totalArt.
	self exitSuccess
]

{ #category : #activation }
ArXHandler >> listKeywords [
	|totalArt|
	totalArt := 0.
	self reloadDB.
	self allKeys do: [ :keyAndArticles || nbArt |
		nbArt := keyAndArticles value size.
			totalArt := totalArt + nbArt.
			self stdout
				nextPutAll: (keyAndArticles key) ;
				nextPutAll: ' - ' ;
				nextPutAll: (nbArt asString) ;
				nextPut: Character cr
		].
	self stdout
		nextPutAll: 'TOTAL - ' ;
		nextPutAll: (totalArt asString) ;
		nextPut: Character cr.
	self exitSuccess 
]

{ #category : #activation }
ArXHandler >> merge [
	| key1 key2 |
	(self arguments size < 3)
		ifTrue: [
			self printHelp.
			self exitFailure 
			].
	key1 := self arguments second.
	key2 := self arguments third.
	self reloadDB.
	(self articles at: key2) do: [ :art|
		self keyword: key1 add: art
	].
	self articles removeKey: key2.
	self saveDB 
]

{ #category : #activation }
ArXHandler >> nbArticlesFound: nb [
	self stdout
		nextPutAll: nb asString ;
		nextPutAll: ' article(s) found' ;
		nextPut: Character cr.

]

{ #category : #'private - utilities' }
ArXHandler >> newArticle: content [
	^ ArXArticle new content: content ; yourself.

]

{ #category : #'private - utilities' }
ArXHandler >> parseMessage: file [
	^file readStreamDo: [ :st | factory articleFrom: st ].
]

{ #category : #helpers }
ArXHandler >> reloadDB [
	articles := self backupFilename asFileReference
		readStreamDo: [ :st | STON fromStream: st].

]

{ #category : #helpers }
ArXHandler >> removeArticle: anArticle [
	articles associations do: [ :keyAndArticles || newArticles |
		newArticles := keyAndArticles value reject: [:art | art = anArticle].
		newArticles
			ifEmpty: [ articles removeKey: keyAndArticles key ]
			ifNotEmpty: [ articles at: keyAndArticles key put: newArticles]
	]
]

{ #category : #'private - utilities' }
ArXHandler >> removeBackupsAfterVersion: aNumber [
	"shift backups files until last one as version <= aNumber"
	| shiftFrom shiftTo nextVersion |
	nextVersion := ((self secondaryBackup basename copyAfter: $.) copyUpTo: $.) asInteger .
	(nextVersion <= aNumber) ifTrue: [ ^ self ].
	shiftTo := 1.
	shiftFrom := nextVersion - aNumber.
	[ nextVersion > shiftFrom ]
	whileTrue: [
		self renameFile: (self backupFilename: shiftFrom) to: (self backupFilename: shiftTo).
		shiftTo := shiftTo+1.
		shiftFrom := shiftFrom+1.
	]

]

{ #category : #'private - utilities' }
ArXHandler >> renameFile: fromName to: toName [
	| fromFile toFile |
	fromFile := fromName asFileReference.
	fromFile exists ifFalse: [ FileDoesNotExistException signal: fromName ].
	toFile := toName asFileReference.
	toFile exists
		ifTrue: [ toFile delete ].
	fromFile renameTo: toName
]

{ #category : #'private - utilities' }
ArXHandler >> saveDB [
	FileSystem disk rename: self backupFilename to: self secondaryBackup.
	self backupFilename asFileReference writeStreamDo: [ :st |
		st nextPutAll: (STON toString: self articles) 
	].

]

{ #category : #activation }
ArXHandler >> searchKeyword [
	| searched found |
	found := 0.
	searched := self arguments second.
	self reloadDB.
	self articles associationsDo: [ :assoc |
			(assoc key includesSubstring: searched)
				ifTrue: [
					assoc value do: [ :art |
						found := found + 1.
						self stdout
							nextPutAll: '---- ' ;
							nextPutAll: found asString ;
							nextPutAll: ' ----' ;
							nextPut: Character cr.
						art longPrintOn: self stdout.
					]
				]
	].
	self stdout
		nextPutAll: '---- ----' ;
		nextPut: Character cr.
	self nbArticlesFound: found.
	self exitSuccess
]

{ #category : #'private - utilities' }
ArXHandler >> secondaryBackup [
	^self backupFilename asFileReference nextVersion
]

{ #category : #activation }
ArXHandler >> zotero [
	| key file |

	(self arguments size < 2)
	ifTrue: [ 
		self exitFailure: 'zotero requires at least 1 argument: <file.mbox> [ <collection> ]'	].

	file := self getMboxFile: (self arguments second).
	file ifNil: [ self exitFailure: 'Could not process file: ' , self arguments second].
	self parseMessage: file.

	key := self getCollection.

	factory article toZoteroCollection: key

]

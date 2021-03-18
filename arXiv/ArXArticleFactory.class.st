Class {
	#name : #ArXArticleFactory,
	#superclass : #Object,
	#instVars : [
		'content',
		'lines',
		'bounds',
		'article'
	],
	#category : #'arXiv-core'
}

{ #category : #accessing }
ArXArticleFactory >> article [
	^article
]

{ #category : #factory }
ArXArticleFactory >> articleFrom: aSteam [
	lines := aSteam contents lines.
	self setMessageBounds.
	article := ArXArticle new.
	article title: self getTitle.
	article url: self getURL.
	article authors: self getAuthors.
	article abstract: self getAbstract.
	^ article
]

{ #category : #'private-parsing' }
ArXArticleFactory >> bodyEnd [
	^ bounds third
]

{ #category : #'private-parsing' }
ArXArticleFactory >> bodyStart [
	^ bounds second
]

{ #category : #'private-parsing' }
ArXArticleFactory >> content: aMessage [
	lines := aMessage lines.
	
	self setMessageBounds.

	self setTitle.
	self setAuthors.
	self setAbstract.
]

{ #category : #factory }
ArXArticleFactory >> getAbstract [
	"abstract starts after an empty line after the Title: line
	 and ends with the body"
	| startLine |
	startLine := self lineFor: [ :l | l beginsWith: 'Authors:'] fromLine: self bodyStart toLine: self bodyEnd.
	startLine := self lineFor: [ :l | l isEmpty ] fromLine: startLine toLine: self bodyEnd.
	^ String cr join: (lines copyFrom: startLine+1 to: self bodyEnd-1).
]

{ #category : #factory }
ArXArticleFactory >> getAuthors [
	"authors can be multiline, ended by next field: Categories"

	^ self getMultilineField: 'Authors:' endedBy: 'Categories:'
]

{ #category : #'private-parsing' }
ArXArticleFactory >> getField: aString [
	| field |
	field := self searchInBody: aString.
	^ field copyFrom: aString size+2 to: field size.
	
]

{ #category : #'private-parsing' }
ArXArticleFactory >> getField: startString markedBy: endString [
	| field |
	field := self searchInBody: startString.
	^ field copyFrom: startString size+2 to: field size.
	
]

{ #category : #factory }
ArXArticleFactory >> getKeywords [
	"keywords start after an empty line after the note header which is a 'second message' after the body of the 'first' nessage
	 it ends with an empty line after the start line"
	| startLine endline |
	startLine := self lineFor: [ :l | l beginsWith: 'Subject: '] fromLine: self bodyEnd toLine: self noteEnd.
	startLine := self lineFor: [ :l | l isEmpty ] fromLine: startLine toLine: self noteEnd.
	startLine := startLine + 1.
	endline := self lineFor: [ :l | l isEmpty ] fromLine: startLine toLine: self noteEnd.
	^ lines copyFrom: startLine to: endline - 1
]

{ #category : #'private-parsing' }
ArXArticleFactory >> getMultiline [
	| endLine startLine |
	startLine := self
		lineFor: [ :l | l beginsWith: 'Authors:' ]
		fromLine: self bodyStart
		toLine: self bodyEnd.
	endLine := self
		lineFor: [ :l | l beginsWith: 'Categories:' ]
		fromLine: startLine
		toLine: self bodyEnd.
	^ self
		joinMultiline: (lines copyFrom: startLine + 1 to: endLine - 1)
		forField: 'Authors:'
]

{ #category : #'private-parsing' }
ArXArticleFactory >> getMultilineField: startString endedBy: endString [
	| endLine startLine |
	startLine := self
		lineFor: [ :l | l beginsWith: startString ]
		fromLine: self bodyStart
		toLine: self bodyEnd.
	endLine := self
		lineFor: [ :l | l beginsWith: endString ]
		fromLine: startLine
		toLine: self bodyEnd.
	^ self
		joinMultiline: (lines copyFrom: startLine to: endLine - 1)
		forField: startString
]

{ #category : #factory }
ArXArticleFactory >> getTitle [
	"title can be multiline, ended by next field: Authors"
	^ self getMultilineField: 'Title:' endedBy:'Authors:'
]

{ #category : #factory }
ArXArticleFactory >> getURL [
	^self getField: 'View the submission at'
]

{ #category : #'private-parsing' }
ArXArticleFactory >> joinMultiline: anArrayOfString forField: aPrefix [
	^String streamContents: [:s |
		s nextPutAll: (anArrayOfString first allButFirst: aPrefix size + 1 ).
		anArrayOfString allButFirstDo: [ :line |
			"remove first character (a space) of the line"
			s nextPutAll: line allButFirst
		]
	]
]

{ #category : #'private-parsing' }
ArXArticleFactory >> lineFor: aBlock fromLine: startLine toLine: endLine [
	startLine to: endLine do: [ :i |
		(aBlock value: (lines at: i))
		ifTrue: [ ^ i ]
	].
	^0
]

{ #category : #accessing }
ArXArticleFactory >> lines [
	^ lines
]

{ #category : #accessing }
ArXArticleFactory >> lines: aStringCollection [
	lines := aStringCollection 
]

{ #category : #'private-parsing' }
ArXArticleFactory >> mimeBound [
	| bound |
	bound := self search: 'Content-Type: multipart/mixed; boundary=' fromLine: 1 toLine: lines size.
	^bound copyFrom: (bound indexOf: $") + 1 to: (bound size - 1).
]

{ #category : #'private-parsing' }
ArXArticleFactory >> noteEnd [
	^ bounds fourth
]

{ #category : #'private-parsing' }
ArXArticleFactory >> search: aString fromLine: startLine toLine: endLine [
	| i |
	i := self lineFor: [ :l | l beginsWith: aString ] fromLine: startLine toLine: endLine.
	^i = 0
		ifTrue: [ KeyNotFound signal ]
		ifFalse: [ lines at: i ]
]

{ #category : #'private-parsing' }
ArXArticleFactory >> searchInBody: aString [
	^ self search: aString fromLine: self bodyStart toLine: self bodyEnd
	
]

{ #category : #'private-parsing' }
ArXArticleFactory >> setMessageBounds [
	"set the line bounds of the main message and optional note message"
	| bound |
	bounds := OrderedCollection new: 4.
	[
		bound := self mimeBound.
		lines withIndexDo: [ :l :i | (l includesSubstring: bound) ifTrue: [ bounds add: i ]]
	] on: KeyNotFound
	do: [ | i |
		i := self
			lineFor: [ :l | l beginsWith: 'View the submission at http://arxiv.org']
			fromLine: 1
			toLine: lines size.
		bounds
			add: 0 ;  "actually not used"
			add: i ;
			add: lines size ;
			add: lines size
		]
]

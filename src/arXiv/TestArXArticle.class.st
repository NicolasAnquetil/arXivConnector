Class {
	#name : #TestArXArticle,
	#superclass : #TestCase,
	#instVars : [
		'article'
	],
	#category : #'arXiv-tests'
}

{ #category : #running }
TestArXArticle >> setUp [
	super setUp.
	article := ArXArticle new
		title: 'My nice title' ;
		url: 'http://somewhere.com' ;
		authors: 'First Author, 2. Author and The Third Author' ;
		abstract: 'And a very short asbtract'
]

{ #category : #running }
TestArXArticle >> testAsPharoteroItem [
	| pharoteroItem |
	pharoteroItem := article asPharoteroItem.

	self assert: pharoteroItem title equals: 'My nice title'.
	self assert: pharoteroItem url equals: 'http://somewhere.com'.
	self assert: pharoteroItem abstract equals: 'And a very short asbtract'.
	self assert: pharoteroItem authors size equals: 3
	
]

{ #category : #running }
TestArXArticle >> testParseAuthors [
	| parsed |
	parsed := article parseAuthors: article authors.
	self assert: parsed size equals: 3.

	self assert: (parsed first firstName) equals: 'First'.
	self assert: (parsed first lastName) equals: 'Author'.
	self assert: (parsed second firstName) equals: '2.'.
	self assert: (parsed second lastName) equals: 'Author'.
	self assert: (parsed third firstName) equals: 'The Third'.
	self assert: (parsed third lastName) equals: 'Author'.
]

{ #category : #running }
TestArXArticle >> zoteroEmptyDocumentJSON [
	^'{
	"itemType": "document",
	"title": "",
	"creators": [
		{
			"creatorType": "author",
			"firstName": "",
			"lastName": ""
		}
	],
	"abstractNote": "",
	"publisher": "",
	"date": "",
	"language": "",
	"shortTitle": "",
	"url": "",
	"accessDate": "",
	"archive": "",
	"archiveLocation": "",
	"libraryCatalog": "",
	"callNumber": "",
	"rights": "",
	"extra": "",
	"tags": [],
	"collections": [],
	"relations": {}
}'
]

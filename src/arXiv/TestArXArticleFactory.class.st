Class {
	#name : #TestArXArticleFactory,
	#superclass : #TestCase,
	#instVars : [
		'factory'
	],
	#category : #'arXiv-tests'
}

{ #category : #example }
TestArXArticleFactory >> exampleSimple [
	^ 'From e-prints@arxiv.org Fri Mar 12 09:23:00 2021
Return-Path: <e-prints@arxiv.org>
To: nicolas.anquetil@inria.fr
From: e-prints@arxiv.org
Subject: arXiv submission submit/3646706 to cs.SE by Miroslaw Staron
Content-Type: text/plain; charset=utf-8
Message-Id: <submit.3646706@arxiv.org>
X-Evolution-Source: 7a3e51702fc394751839a3888502b1b6602b2755
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0


View the submission at http://arxiv.org/mod/123456789
From: Tan Author <tan.author@some.place>
Date: Sun, 16 Feb 2020 08:56:07 EST   (587kb,D)

Title: This is a Title
  on 2 lines
Authors: These are the authors
  on several lines
  also
Categories: cs.SE
Classifier: cs.SE 0.95 cs.AB 0.21 cs.CD 0.15
Status: next

  And this is a multi line abstract.
It is a bit uninformative, but we don''t care,
as it is for testing purposes

'
]

{ #category : #example }
TestArXArticleFactory >> exampleWithNote [
	^ 'From e-prints@arxiv.org Sun Feb 16 14:56:26 2020
Return-Path: e-prints@arxiv.org
To: nicolas.anquetil@inria.fr
From: e-prints@arxiv.org
Subject: arXiv submission
Date: Sun, 16 Feb 2020 08:56:18 -0500
Content-Type: multipart/mixed; boundary="=-U19OAwka/AclnO2vl3Z7"
MIME-Version: 1.0


--=-U19OAwka/AclnO2vl3Z7
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


View the submission at http://arxiv.org/mod/123456789
From: Tan Author <tan.author@some.place>
Date: Sun, 16 Feb 2020 08:56:07 EST   (587kb,D)

Title: This is a Title
  on 2 lines
Authors: These are the authors
  on several lines
  also
Categories: cs.SE
Classifier: cs.SE 1
Status: submitted - Scheduled for announcement: 2021-03-18 20:00 EDT
Comments: This is a comment
It has 2 lines

  And this is a multi line abstract.
It is a bit uninformative, but we don''t care,
as it is for testing purposes

--=-U19OAwka/AclnO2vl3Z7
X-Evolution-Note: True
Content-Disposition: inline
Content-Description: Message Note
Content-Type: message/rfc822

From: me
Date: Mon, 17 Feb 2020 10:24:46 +0100
Subject: Message Note
Message-ID: <b40be4539c357bbc53320a318d065c5c171f322c.camel@przewalski>
Content-Type: text/plain
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

keyword1
key word2

--=-U19OAwka/AclnO2vl3Z7--

'
]

{ #category : #running }
TestArXArticleFactory >> setUp [
	factory := ArXArticleFactory new.
]

{ #category : #tests }
TestArXArticleFactory >> testArticleAlone [
	| art |
	art := factory articleFrom: self exampleSimple.
	
	self assert: art title equals: 'This is a Title on 2 lines'.
	self assert: art authors equals: 'These are the authors on several lines also'.
	self assert: art url equals: 'http://arxiv.org/mod/123456789'.
	self assert: art comment equals: ''.
	self assert: art abstract = '  And this is a multi line abstract.
It is a bit uninformative, but we don''t care,
as it is for testing purposes'

	
	
]

{ #category : #tests }
TestArXArticleFactory >> testArticleWithNote [
	| art |
	art := factory articleFrom: self exampleWithNote.
	
	self assert: art title equals: 'This is a Title on 2 lines'.
	self assert: art authors equals: 'These are the authors on several lines also'.
	self assert: art url equals: 'http://arxiv.org/mod/123456789'.
	self assert: art comment equals: 'This is a comment
It has 2 lines'.
	self assert: art abstract = '  And this is a multi line abstract.
It is a bit uninformative, but we don''t care,
as it is for testing purposes
'

	
	
]

{ #category : #tests }
TestArXArticleFactory >> testKeywordsInNote [
	| keywords |
	factory articleFrom: self exampleWithNote.
	keywords := factory getKeywords.

	self assert: keywords size equals: 2.
	self assert: keywords first equals: 'keyword1'.
	self assert: keywords second equals: 'key word2'.

	
	
]

{ #category : #tests }
TestArXArticleFactory >> testLineFor [
	factory lines: #( 'line 1' 'line 2' 'and 3').

	self assert: (factory lineFor: [ :l | l beginsWith: 'line'] fromLine: 1 toLine: 3) equals: 1.
	self assert: (factory lineFor: [ :l | l beginsWith: 'line'] fromLine: 2 toLine: 3) equals: 2.
	self assert: (factory lineFor: [ :l | l beginsWith: 'line'] fromLine: 3 toLine: 3) equals: 0.
	self assert: (factory lineFor: [ :l | l beginsWith: 'and']  fromLine: 1 toLine: 3) equals: 3.
	self assert: (factory lineFor: [ :l | l beginsWith: 'blah'] fromLine: 1 toLine: 3) equals: 0.

]

{ #category : #tests }
TestArXArticleFactory >> testParsingSetup [
	factory lines: self exampleWithNote lines.
	self assert: factory lines size equals: 53.

	factory setMessageBounds.
	self assert: factory bodyStart equals: 11.
	self assert: factory bodyEnd equals: 35.
	self assert: factory noteEnd equals: 52.
	
	
]

{ #category : #tests }
TestArXArticleFactory >> testSearchLine [
	| testLines |
	testLines := #( 'line 1' 'line 2' 'and 3').
	factory lines: testLines.

	self assert: (factory search: 'line' fromLine: 1 toLine: 3) equals: testLines first.
	self assert: (factory search: 'line' fromLine: 2 toLine: 3) equals: testLines second.
	self assert: (factory search: 'and'  fromLine: 1 toLine: 3) equals: testLines third.

	self should: [factory search: 'line' fromLine: 3 toLine: 3] raise: NotFound.
	self should: [factory search: 'blah' fromLine: 1 toLine: 3] raise: NotFound.

]

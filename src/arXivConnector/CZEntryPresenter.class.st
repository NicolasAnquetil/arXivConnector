"
a presenter for a Citezen Entry

Gives:
- authors
- year
- title
- bibtex kind of entry
- publication venue

use:

`CZEntryPresenter on: <aCZEntry>`

"
Class {
	#name : #CZEntryPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'txtAuthors',
		'txtTitle',
		'txtYear',
		'txtVenue',
		'txtKind',
		'txtAbstract',
		'txtUrl',
		'txtNote',
		'toolbar',
		'czEntry'
	],
	#category : #'arXivConnector-gui'
}

{ #category : #'instance creation' }
CZEntryPresenter class >> on: aCZEntry [

	^self new
		on: aCZEntry ;
		open
]

{ #category : #initialization }
CZEntryPresenter >> clearForm [

	txtAuthors text: ''.
	txtTitle   text: ''.
	txtAbstract text: ''.
	txtYear    text: ''.
	txtVenue   text: ''.
	txtKind    text: ''.
]

{ #category : #layout }
CZEntryPresenter >> defaultLayout [

	^SpBoxLayout newTopToBottom
	
		add: 'Author(s): ' height: self lineHeight  ;
		add: (SpBoxLayout newLeftToRight
			add: #txtAuthors ;
			yourself)
		height: self toolbarHeight * 1.2;
	
		add: 'Title:'  height: self lineHeight ;
		add: #txtTitle height: self toolbarHeight  ;
	
		add: (SpBoxLayout newLeftToRight
			add: (SpBoxLayout newTopToBottom
				add: 'Entry kind:' height: self lineHeight ;
				add: #txtKind height: self toolbarHeight ;
				yourself) ;
			add: (SpBoxLayout newTopToBottom
				add: 'Year:' height: self lineHeight ;
				add: #txtYear height: self lineHeight * 1.5;
				"add: 'Published in:' height: self lineHeight ;
				add: #txtVenue height: self toolbarHeight ;"
				yourself) ;
			yourself)
		expand: false ;
	
		add: 'Abstract:' height: self lineHeight  ;
		add: #txtAbstract height: self lineHeight*8 ;

		add: #txtUrl height: self lineHeight   ;

		add: 'Notes:' height: self lineHeight ;
		add: #txtNote height: self lineHeight*5 ;

		add: #toolbar expand: false ;
		yourself
]

{ #category : #accessing }
CZEntryPresenter >> defaultNoteStructure [

	^'ABSTRACT

QUALITY

EVALUATION

LIMITATIONS

CITATIONS

INTERESTING REFERENCES
'
]

{ #category : #initialization }
CZEntryPresenter >> initializePresenters [ 
	super initializePresenters.

	txtAuthors := self newText.
	txtTitle   := self newText.
	txtYear    := self newText.
	txtVenue   := self newText.
	txtKind    := self newText.
	txtUrl     := self newText.
	txtNote    := self newText.
	txtAbstract:= self newText.

	toolbar := self instantiate: CZToolBar
]

{ #category : #accessing }
CZEntryPresenter >> lineHeight [

	^self class defaultFont height
]

{ #category : #action }
CZEntryPresenter >> on: aCZEntry [

	czEntry := aCZEntry.

	txtAuthors text: (aCZEntry at: #author) value asString.
	txtYear    text: (aCZEntry at: #year) value asString.
	txtTitle   text: (aCZEntry at: #title) value asString.
	txtAbstract text: (aCZEntry at: #abstract) value asString.
	txtKind    text: (aCZEntry type) asString.
	txtUrl     text: (aCZEntry at: #url) value asString.
	txtNote    text: (aCZEntry at: #note) value asString
]

{ #category : #action }
CZEntryPresenter >> toolbarDelete [

	self shouldBeImplemented
]

{ #category : #accessing }
CZEntryPresenter >> toolbarHeight [

	^self class toolbarHeight
]

{ #category : #action }
CZEntryPresenter >> toolbarInspect [

	czEntry inspect
]

{ #category : #action }
CZEntryPresenter >> toolbarNew [

	txtNote text: self defaultNoteStructure
]

{ #category : #action }
CZEntryPresenter >> toolbarSave [

	czEntry at: #author put: txtAuthors text.
	czEntry at: #year put: txtYear text.
	czEntry at: #title put: txtTitle text.
	czEntry at: #abstract put: txtAbstract text.
	
	czEntry at: #note put: ((txtNote text = self defaultNoteStructure)
		ifTrue: [ '' ]
		ifFalse: [ txtNote text ] ).

	Smalltalk snapshot: true andQuit: false. 
]

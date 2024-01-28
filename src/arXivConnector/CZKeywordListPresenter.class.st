Class {
	#name : #CZKeywordListPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'lstKeywords',
		'lblKeywords',
		'toolbar',
		'label'
	],
	#category : #'arXivConnector-gui'
}

{ #category : #initialization }
CZKeywordListPresenter >> connectPresenters [
	super connectPresenters.

	lstKeywords whenSelectionChangedDo: [ :selection |
		selection selectedItem
			ifNil: [ owner noKeywordSelected ]
			ifNotNil: [ :keyword | owner selectedKeyword: keyword key ]
	]
]

{ #category : #layout }
CZKeywordListPresenter >> defaultLayout [

	^SpBoxLayout newVertical
		add: #toolbar expand: false ;
		add: #lblKeywords expand: false ;
		add: #lstKeywords ;
		yourself
]

{ #category : #initialization }
CZKeywordListPresenter >> initializePresenters [

	toolbar := self instantiate: CZToolBar.
	
	lblKeywords := self newLabel
		label: self label , ': 0' ;
		yourself.

	lstKeywords := self instantiate: SpFilteringListPresenter.
	lstKeywords display: [ :keyAndArticles | keyAndArticles key , ': ' , keyAndArticles value size asString ].
	lstKeywords listPresenter
		beSingleSelection ;
		sortingBlock: [:a :b | a key < b key ].

]

{ #category : #accessing }
CZKeywordListPresenter >> label [

	^label ifNil: [ 'Keywords' ]
]

{ #category : #accessing }
CZKeywordListPresenter >> label: aString [

	label := aString
]

{ #category : #accessing }
CZKeywordListPresenter >> model [

	^owner model
]

{ #category : #interaction }
CZKeywordListPresenter >> reset [

	lstKeywords items: owner keywordList.
	lblKeywords label: self label , ': ' , lstKeywords items size asString
]

{ #category : #interaction }
CZKeywordListPresenter >> selectKey: key [

	lstKeywords listPresenter
		selectIndex: (lstKeywords items findFirst: [ :kwItem | kwItem key = key])
		scrollToSelection: true.
]

{ #category : #accessing }
CZKeywordListPresenter >> selectedKeyword [

	^lstKeywords selectedItem
		ifNil: [ nil ]
		ifNotNil: [ :selectedItem | selectedItem key ]
]

{ #category : #interaction }
CZKeywordListPresenter >> toolbarDelete [

	self selectedKeyword
	ifNil: [ self inform: 'No keyword selected !' ]
	ifNotNil: [ : selectedKeyword | owner deleteAction: self selectedKeyword]
]

{ #category : #interaction }
CZKeywordListPresenter >> toolbarNew [
	"Creating a new keyword"

	owner newKeywordAction
]

{ #category : #interaction }
CZKeywordListPresenter >> toolbarSave [

	owner saveAction
]

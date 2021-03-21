Class {
	#name : #BaselineOfArXiv,
	#superclass : #BaselineOf,
	#category : #BaselineOfArXiv
}

{ #category : #baselines }
BaselineOfArXiv >> baseline: spec [
	<baseline>
	spec for: #common do: [
		spec baseline: 'Pharotero' with: [ spec repository: 'github://NicolasAnquetil/Pharotero/tree/main' ].
		spec package: 'arXivConnector'  with: [ spec requires: #('Pharotero') ]				
	].

]

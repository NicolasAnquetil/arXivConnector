Class {
	#name : #BaselineOfArXiv,
	#superclass : #BaselineOf,
	#category : #BaselineOfArXiv
}

{ #category : #baselines }
BaselineOfArXiv >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			spec baseline: 'arXivConnector' with: [ spec repository: 'github://NicolasAnquetil/arXivConnector' ]
		].


]

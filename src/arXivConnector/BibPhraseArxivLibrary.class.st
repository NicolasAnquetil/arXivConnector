"
To export CZEntries generated from ArXiv into a bib file:

```
arXivDB := ArXHandler new reloadDB.
(BibBibRenderer new
	library: BibPhraseArxivLibrary new ;
	arXivDB asCitezen) contents
```
"
Class {
	#name : #BibPhraseArxivLibrary,
	#superclass : #BibPhraseLibrary,
	#category : #arXivConnector
}

{ #category : #'phrases-partial' }
BibPhraseArxivLibrary class >> numberedReportFrom: institution type: aString [ 
	^ (BibSequencePhrase new)
		addBlockWithField: #author;
		addBlockWithField: #title;
		add: (((BibSequencePhrase new)
					add: ((BibSequencePhrase new)
								add: (self field: #type default: aString);
								addField: #number;
								separatorText: ' ';
								yourself);
					addField: institution;
					addField: #address;
					add: self locationMonthYear;
					separatorText: ', ';
					yourself) blockNamed: #publishing);
		addBlockWithField: #abstract;
		addBlockWithField: #url;
		addBlockWithField: #keywords;
		addBlockWithField: #note;
		separatorText: '. ';
		terminatorText: '.'
]

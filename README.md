# beta-nlp-project
NLP Project of Team Beta for the Information Retrieval (IN4325) course

## Methodology
1. Tokenize Reviews to Sentences ->  `pos-tagging/Aspects.R`
2. Tokenize Sentences to Words ->  `pos-tagging/Aspects.R`
3. POS Tagging ->  `pos-tagging/Aspects.R`
4. Chunking ->  `pos-tagging/Aspects.R`
5. Aggregate metadata (cast, director, writer)  -> `metadata-aspects/aggregate_metadata.py`
6. Extracting “nouns” ->  `metadata-aspects/process_tokens.py`
	* Marking cast, director, writer with appropriate aspect category
7. Clustering nouns 
	* Convert nouns to vectors -> `word2vec/word2vec_wrapper.py`
	* Clustering -> 
8. Analyse the clusters for appropriate aspect labelling
9. Evaluation on Test Dataset

## Output Files
* `metadata-aspects/potential-aspects.csv`: contains a list of noun tokens processed from `pos-tagging/token.csv` (see Step 6 of [Methodology](#methodology))
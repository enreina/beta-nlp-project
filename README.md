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
* `metadata-aspects/potential-aspects.csv`: contains a list of noun tokens from processed from `pos-tagging/token.csv`  on Step 6 (see [Methodology](#methodology)). Additionally it adds the `aspect_category` with this labels:
	* `overall` (from movie title)
	* `directing` (from director names)
	* `cast`(from actor names)
	* `story` (from writer names)
	* `?` (none of the above, this would mean it needs to be clustered)
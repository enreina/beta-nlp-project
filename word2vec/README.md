# Word2Vec Wrapper

## Output

We have two word vectors output (generated from applying word2vec model on unique tokens by `metadata-aspects/process_tokens.py`):

* word_vectors_training.csv: this one is generated from word2vec model trained on the IMDB movie review dataset itself
* word_vectors_training_googleNews.csv: this one is generated from word2vec model trained on Google News (from [word2vec-slim](https://github.com/eyaler/word2vec-slim))

Both output is available our [Google Drive](https://drive.google.com/drive/u/0/folders/1ZYCkftnc-ULMqGr2v3Gj4ldogpzVtFC_).

## Sample Usage

You have to be in the current (`word2vec`) directory. Run the following in Python 2.7

```
import word2vec_wrapper
similarity = word2vec_wrapper.word_similarity("actor","actress")
```

The default is to use the word2vec model trained on IMDB reviews, but if you want to use the google news model you can call the similarity function like:

```
similarity = word2vec_wrapper.word_similarity("actor","actress", "google-news")
```



Ping me (enreina@gmail.com or via WhatsApp) when you have a problem!

## Notes

* The function right now is using the word2vec model trained on [Large Movie Review Dataset](http://ai.stanford.edu/~amaas/data/sentiment/). I'm still working to setup similar function using the model trained on the Google News dataset (the file is so big!).


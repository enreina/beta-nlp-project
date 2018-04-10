# Word2Vec Wrapper

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


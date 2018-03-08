# Dataset

## How to use the script for crawling metadata

1. Download the "Large Movie Review Dataset" from [here](http://ai.stanford.edu/~amaas/data/sentiment/)
2. Extract the tar and put the `aclImdb` folder here.
3. Replace the `[api-key]` with your OMDB API Key in the `crawl_metadata.py` script
4. Run the following command (we use Python 2.7.14)

```
python crawl_metadata.py pos
```
for positive reviews

```
python crawl_metadata.py neg
```
for negative reviews

The output will be either `metadata_pos.json` or `metadata_neg.json`

## Reviews Dataset

1. Again put the `aclImdb` folder here, if you haven't done so.
2. Run the following command, replacing `[pos|neg]` and `[train|test]` appropriately

```
python aggregate_reviews.py [pos|neg] [train|test]
```

The output will be `reviews_[train|test]_[pos|neg]_.csv` with the following data in order

```
review_id,review_text,rating,imdb_id
```

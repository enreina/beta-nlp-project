# Dataset

## How to use the script

1. Download the "Large Movie Review Dataset" from [here](http://ai.stanford.edu/~amaas/data/sentiment/)
2. Extract the tar and put the `aclImdb` folder here.
3. Run the following command (we use Python 2.7.14)

```
python crawl_metadata.py pos
```
for positive reviews

```
python crawl_metadata.py neg
```
for negative reviews

The output will be either `metadata_pos.json` or `metadata_neg.json`
import csv
import word2vec_wrapper
tokenReader = csv.DictReader(open("../metadata-aspects/potential_aspects_train.csv"))
tokens = [x for x in tokenReader if x["aspect_category"] == "?"]
wordList = [x["Word"] for x in tokens]
wordList = list(set(wordList))
word2vec_wrapper.createWordVectors(wordList, "word_vectors_training_googleNews.csv")
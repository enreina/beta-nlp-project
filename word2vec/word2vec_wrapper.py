from urllib2 import Request, urlopen, URLError
from gensim.models import word2vec
from gensim.models import KeyedVectors
import csv

url_imdb = "http://159.65.200.91:5000/word2vec/imdb/similarity?w1=[word1]&w2=[word2]"
url_google = "http://159.65.200.91:5001/word2vec/google-news/similarity?w1=[word1]&w2=[word2]"

word_vectors = KeyedVectors.load_word2vec_format("models/300features_40minwords_10context_phrases.wv", binary=False)
# word_vectors = KeyedVectors.load_word2vec_format("models/GoogleNews-vectors-negative300-SLIM.bin.gz", binary=True)

def word_similarity(word1, word2, model="imdb"):
	if model == "google-news":
		url_req = url_imdb
	elif model == "imdb":
		url_req = url_google
	else:
		raise Exception("Model name is not valid, supply either 'imdb' or 'google-news'") 

	url_req = url_req.replace("[word1]", word1)
	url_req = url_req.replace("[word2]", word2)
	try:
		response = urlopen(url_req)
		return float(response.read())
	except(URLError, e):
		print('Error requesting similarity', e)

def createWordVectors(wordList, outputFileName):
	with open(outputFileName, 'w') as csvfile:
		csvWriter = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
		for word in wordList:
			csvRow = []
			keyWord = word.lower().replace(" ", "_")
			if keyWord in word_vectors:
				csvRow = [keyWord]
				csvRow.extend(word_vectors[keyWord].tolist())
			else:
				keyWordList = keyWord.split("_")
				for x in keyWordList:
					if x in word_vectors:
						csvRow = [x]
						csvRow.extend(word_vectors[x].tolist())
			if len(csvRow) > 0:
				csvWriter.writerow(csvRow)
			


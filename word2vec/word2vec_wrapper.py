from urllib2 import Request, urlopen, URLError

url_imdb = "http://159.65.200.91:5000/word2vec/imdb/similarity?w1=[word1]&w2=[word2]"
url_google = "http://159.65.200.91:5001/word2vec/google-news/similarity?w1=[word1]&w2=[word2]"

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
	except URLError, e:
		print 'Error requesting similarity', e


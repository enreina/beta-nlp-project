from urllib2 import Request, urlopen, URLError

url = "http://159.65.200.91:5000/word2vec/imdb/similarity?w1=[word1]&w2=[word2]"

def word_similarity(word1, word2):
	url_req = url.replace("[word1]", word1)
	url_req = url_req.replace("[word2]", word2)
	try:
		response = urlopen(url_req)
		return float(response.read())
	except URLError, e:
		print 'Error requesting similarity', e


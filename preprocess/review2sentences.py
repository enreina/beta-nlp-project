from bs4 import BeautifulSoup
import re
from nltk.corpus import stopwords
import pandas as pd
import nltk.data 
import pickle

# read and store reviews
reviews = pd.read_csv("../dataset/review_train_unsup.csv")

# function to convert review to wordlist
def review_to_wordlist( review, remove_stopwords=False ):
    # Function to convert a document to a sequence of words,
    # optionally removing stop words.  Returns a list of words.
    #
    # 1. Remove HTML
    review_text = BeautifulSoup(review).get_text()
    #  
    # 2. Remove non-letters
    review_text = re.sub("[^a-zA-Z]"," ", review_text)
    #
    # 3. Convert words to lower case and split them
    words = review_text.lower().split()
    #
    # 4. Optionally remove stop words (false by default)
    if remove_stopwords:
        stops = set(stopwords.words("english"))
        words = [w for w in words if not w in stops]
    #
    # 5. Return a list of words
    return(words)

 # Load the punkt tokenizer
tokenizer = nltk.data.load('tokenizers/punkt/english.pickle')

# Define a function to split a review into parsed sentences
def review_to_sentences( review, tokenizer, remove_stopwords=False ):
    # Function to split a review into parsed sentences. Returns a 
    # list of sentences, where each sentence is a list of words
    #
    # 1. Use the NLTK tokenizer to split the paragraph into sentences
    raw_sentences = tokenizer.tokenize(review.strip())
    #
    # 2. Loop over each sentence
    sentences = []
    for raw_sentence in raw_sentences:
        # If a sentence is empty, skip it
        if len(raw_sentence) > 0:
            # Otherwise, call review_to_wordlist to get a list of words
            sentences.append( review_to_wordlist( raw_sentence, \
              remove_stopwords ))
    #
    # Return the list of sentences (each sentence is a list of words,
    # so this returns a list of lists
    return sentences

try:
	sentences = pickle.load(open("sentences.pkl", 'rb'))  # Initialize an empty list of sentences
except:
	sentences = []

if len(sentences) == 0:	
	print("Parsing sentences from unlabeled set")
	for idx,review in enumerate(reviews["review_text"]):
		print("Parsing review " + str(idx+1) + "/" + str(len(reviews["review_text"])))
		sentences += review_to_sentences(review, tokenizer)

	pickle.dump(sentences, open("sentences.pkl","wb"))
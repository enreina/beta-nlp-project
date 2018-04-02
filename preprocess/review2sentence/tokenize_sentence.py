import csv,re,sys
from nltk.tokenize import sent_tokenize
import nltk.data 
# set positive or negative based on arguments

review_type = "pos"
if len(sys.argv) > 1 and sys.argv[1] in ["pos", "neg"]:
	review_type = sys.argv[1]

input_files = ['../../dataset/review_test_'+review_type+'.csv']
items = [];
csvwriter = csv.writer(open("fullsen_"+review_type+".csv",'w'), delimiter=",", quotechar='"', quoting=csv.QUOTE_ALL)

tokenizer = nltk.data.load('tokenizers/punkt/english.pickle')

for input_file in input_files:
	readCsv = csv.reader(open(input_file))
	for row in readCsv:
		reviewId = row[0]
		reviewText = re.sub('<br />',' ',row[1])
		reviewText = re.sub(r'\.(?=[^ \W\d])', '. ', reviewText)
		movieId = row[3]
		try:
			sentences = tokenizer.tokenize(reviewText.strip())
			for idx, sentence in enumerate(sentences):
				print(reviewId)
				items.append([movieId, reviewId, idx, sentence])
				csvwriter.writerow([movieId, reviewId, idx, sentence])
		except:
			continue


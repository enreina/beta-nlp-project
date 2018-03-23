import csv,re,sys
from nltk.tokenize import sent_tokenize
# set positive or negative based on arguments

review_type = "pos"
if len(sys.argv) > 1 and sys.argv[1] in ["pos", "neg"]:
	review_type = sys.argv[1]

input_files = ['../dataset/review_train_'+review_type+'.csv']
items = [];
csvwriter = csv.writer(open("fullsen_"+review_type+".csv",'w'), delimiter=",", quotechar='"', quoting=csv.QUOTE_ALL)

for input_file in input_files:
	readCsv = csv.reader(open(input_file))
	for row in readCsv:
		reviewId = row[0]
		reviewText = re.sub('<br />',' ',row[1])
		movieId = row[3]
		try:
			sentences = sent_tokenize(reviewText)
			for idx, sentence in enumerate(sentences):
				print(reviewId)
				items.append([movieId, reviewId, idx, sentence])
				csvwriter.writerow([movieId, reviewId, idx, sentence])
		except:
			continue


import os,csv,sys

import re
def sorted_alphanumeric(data):
    convert = lambda text: int(text) if text.isdigit() else text.lower()
    alphanum_key = lambda key: [ convert(c) for c in re.split('([0-9]+)', key) ] 
    return sorted(data, key=alphanum_key)

# set positive or negative based on arguments
review_type = "pos"
if len(sys.argv) > 1 and sys.argv[1] in ["pos", "neg", "unsup"]:
	review_type = sys.argv[1]

train_or_test = "train"
if len(sys.argv) > 2 and sys.argv[2] in ["train", "test"]:
	train_or_test = sys.argv[2]

# get file name list
filenames = sorted_alphanumeric(os.listdir("aclImdb/"+train_or_test+"/" + review_type))

# read urls.txt & urls.txt
urls_file = open("aclImdb/"+train_or_test+"/urls_"+review_type+".txt")
urls = [x for x in urls_file]
# extract IMDB ids
imdb_ids = [x.replace("http://www.imdb.com/title/", "").replace("/usercomments\n", "") for x in urls]

output_file = open("review_"+train_or_test+"_"+review_type+".csv", "w")
csvwriter = csv.writer(output_file, delimiter=",", quotechar='"')

for filename in filenames:
	split_filename = filename.split(".")[0].split("_")
	review_id = int(split_filename[0])
	rating = int(split_filename[1])
	imdb_id = imdb_ids[review_id]
	review_text = open("aclImdb/"+train_or_test+"/"+review_type+"/"+filename).read()
	csvwriter.writerow([review_id,review_text,rating,imdb_id])
	

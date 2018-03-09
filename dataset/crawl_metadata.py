import urllib, json, sys
# replace [api_key] with your OMDB API Key
omdb_url = "http://www.omdbapi.com/?i=[movie_id]&apikey=[api_key]"
# set positive or negative based on arguments
review_type = "pos"
if len(sys.argv) > 1 and sys.argv[1] in ["pos", "neg"]:
	review_type = sys.argv[1]

# crawl for training or test data
train_or_test = "train"
if len(sys.argv) > 2 and sys.argv[2] in ["train", "test"]:
	train_or_test = sys.argv[2]

# output file
metadata_output_filename = "metadata_"+review_type+"_"+train_or_test+".json"

# read urls.txt & urls.txt
urls_file = open("aclImdb/"+train_or_test+"/urls_"+review_type+".txt")
urls = [x for x in urls_file]
# extract IMDB ids
imdb_ids = [x.replace("http://www.imdb.com/title/", "").replace("/usercomments\n", "") for x in urls]


# limit number of movies
limit = 500
if len(sys.argv) > 3:
	limit = int(sys.argv[3])

# keeping a list of already fetched ids
fetched_ids = []
# dictionary of metadata
try:
	metadata = json.load(open(metadata_output_filename))
	offset_idx = max(sum([x[review_type+"_review_ids"] for x in metadata.values()],[])) + 1
except:
	metadata = {}
	offset_idx = 0

imdb_ids = imdb_ids[offset_idx:]

for idx,id in enumerate(imdb_ids):
	print(str(offset_idx+idx+1) + " out of " + str(len(imdb_ids)+offset_idx))
	if id in fetched_ids:
		if idx not in metadata[id][review_type+'_review_ids']:
			metadata[id][review_type+'_review_ids'].append(idx)
	else:
		# stop when already collected 500 movies
		if len(metadata.keys()) >= limit:
			break;

		# fetch metadata using omdb
		try:
			url = omdb_url.replace("[movie_id]", id)
			response = urllib.urlopen(url)
			data = json.loads(response.read())
		except:
			continue
		metadata[id] = data
		metadata[id][review_type+'_review_ids'] = []
		metadata[id][review_type+'_review_ids'].append(idx + offset_idx)
		# put id in fetched_ids
		fetched_ids.append(id)

	with open(metadata_output_filename, 'w') as f:
		json.dump(metadata, f)



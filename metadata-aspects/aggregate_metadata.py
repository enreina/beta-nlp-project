import json
import unidecode
import re

metadata = json.load(open("../dataset/metadata_pos_test.json"))
metadata_new = {}

for k in metadata.keys():
	if "Title" not in metadata[k]:
		continue

	# store director name(s)
	directors = unidecode.unidecode(metadata[k]["Director"]).split(",")
	directors = [x.strip().split(" ") for x in directors]
	directors = [item for sublist in directors for item in sublist]
	# store cast name(s)
	actors = unidecode.unidecode(metadata[k]["Actors"]).split(",")
	actors = [x.strip().split(" ") for x in actors]
	actors = [item for sublist in actors for item in sublist]
	# store writer name(s)
	writers = unidecode.unidecode(metadata[k]["Writer"])
	writers = re.sub(r'\([A-Za-z\s]+\)',"",writers)
	writers = writers.split(",")
	writers = [x.strip().split(" ") for x in writers]
	writers = [item for sublist in writers for item in sublist]
	# store movie title
	title = metadata[k]['Title']
	metadata_new[k] = {"title":title,"directors": directors,"actors":actors, "writers":writers}

	with open('metadata_aspects_test.json', 'w') as f:
		json.dump(metadata_new, f)



import csv
import json

metadata = json.load(open("metadata_aspects_test.json"))
tokenReader = csv.DictReader(open("../pos-tagging/token.csv"))
tokens = []

for x in tokenReader:
	if x['POS'] == 'noun' and x['Movie_ID'] in metadata:
		x_metadata = metadata[x['Movie_ID']]

		split_tokens = set(x["Word"].split(" "))
		
		if x["Word"].lower == x_metadata['title'].lower:
			x['aspect_category'] = 'overall'
		elif split_tokens.issubset(x_metadata['directors']):
			x['aspect_category'] = 'directing'
		elif split_tokens.issubset(x_metadata['actors']):
			x['aspect_category'] = 'cast'
		elif split_tokens.issubset(x_metadata['writers']):
			x['aspect_category'] = 'story'
		else:
			x['aspect_category'] = '?'

		tokens.append(x)

dict_writer = csv.DictWriter(open("potential_aspects.csv","wb"), ["","Movie_ID","Rev_ID","Sen_ID","Word","POS", "aspect_category"])
dict_writer.writeheader()
dict_writer.writerows(tokens)



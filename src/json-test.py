import json

with open('people.json') as file:
	data = json.load(file)

for person in data['people']:
	print(person['name'], person['last_name'])

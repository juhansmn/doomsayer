import json

with open('serverMessage.json') as file:
	data = json.load(file)

for person in data['players']:
	print(person['playerID'])

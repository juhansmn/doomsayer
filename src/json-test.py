import json

#with open('serverMessage.json') as file:
	#data = json.load(file)

#for person in data['players']:
	#print(person['playerID'])

cuck = []

with open("casesInfo.json", encoding='utf-8') as file:
	cases_json = json.loads(file.read())

for i in range(8):
	cuck.append(str(cases_json["case"][0]["situations"][i]["description"]))
	print(cuck)

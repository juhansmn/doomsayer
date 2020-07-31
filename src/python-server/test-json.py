import json

# some JSON:
x = '''{
	"people": [
        {
          "name": "John",
          "last_name": "Smith",
          "is_a_beater": true
        },
        {
            "name": "Gary",
            "last_name": "Oldman",
            "is_a_beater": true
        }
    ]
}
'''

# parse x:
y = json.loads(x)

# the result is a Python dictionary:
print(y["people"][1]["name"], y["people"][1]["is_a_beater"])

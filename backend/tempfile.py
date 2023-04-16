import json

with open('.env', 'r') as file:
    # read the file contents as a string
    data = file.read()

# parse the JSON data into a Python dictionary
__ENV__ = json.loads(data)

print(__ENV__)

print()

__ENV__['bcrypt'] = b'$2b$12$Ru9/2dOBYZGGL2Koj5tIju'

print(json.dumps(__ENV__))


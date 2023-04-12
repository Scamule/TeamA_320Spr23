import os
from flask import Flask, request
import json
import boto3
from databaseInterface import UserInterface

app = Flask(__name__)

with open('.env', 'r') as file:
    data = file.read()

__ENV__ = json.loads(data)



os.environ['AWS_DEFAULT_REGION'] = 'us-east-2'
client = boto3.client('dynamodb')
db = boto3.resource('dynamodb',aws_access_key_id=__ENV__['database_key'],aws_secret_access_key=__ENV__['database_secret'])

userInterface = UserInterface(db)



@app.route('/user', methods=['POST'])
def userCreate():
    return userInterface.registerUser(request.args.get('email'), request.args.get('password'), request.args.get('userid'), request.args.get('firstName'), request.args.get('lastName'))















# ////////////////////////////////////////////////////////////////

@app.route('/', methods=['GET'])
def home():
    return f'Home page'


@app.route('/hello', methods=['GET'])
def hello():
    name = request.args.get('name')
    password = request.args.get('password')
    thing = { "name": name, "password": password }
    return json.dumps(thing)


@app.route('/post', methods=['POST'])
def post():
    a = int(request.args.get('a'))
    b = int(request.args.get('b'))
    instance = {
        "num_a": a,
        "num_b": b,
        "sum": a + b
    }
    return json.dumps(instance)


@app.route('/get', methods=['GET'])
def get():
    a = int(request.args.get('a'))
    b = int(request.args.get('b'))
    instance = {
        "num_a": a,
        "num_b": b,
        "sum": a + b
    }
    return json.dumps(instance)

@app.route('/dynamic/<user>', methods=['GET'])
def findUserExpl(user):
    instance = {
        "username": user,
        "fakeData": "DATA"
    }
    return json.dumps(instance)


# ////////////////////////////////////////////////////////////////


if __name__ == '__main__':
    app.run(debug=True)

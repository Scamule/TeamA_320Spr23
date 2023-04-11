
from flask import Flask, request
import json
import boto3
from databaseInterface import UserInterface


app = Flask(__name__)

__ENV__ = json.load(open(".env"))

import os
os.environ['AWS_DEFAULT_REGION'] = 'us-east-2'
client = boto3.client('dynamodb')
db = boto3.resource('dynamodb',aws_access_key_id=__ENV__['database_key'],aws_secret_access_key=__ENV__['database_secret'])


user = UserInterface(db)
@app.route('/users', methods=['GET'])
def userIndex():
    return user.getAllUsers()

@app.route('/user', methods=['POST'])
def userCreate():
    return user.registerUser(request.args.get('email'), request.args.get('password'), request.args.get('userid'), request.args.get('firstName'), request.args.get('lastName'))



if __name__ == '__main__':
    app.run(debug=True, port=7000)

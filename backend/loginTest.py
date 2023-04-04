
from flask import Flask, request
import json
import boto3
from databaseInterface import User


app = Flask(__name__)

import os
os.environ['AWS_DEFAULT_REGION'] = 'us-east-2'
client = boto3.client('dynamodb')
db = boto3.resource('dynamodb',aws_access_key_id='AKIAYQDOESACBSLNBPE5',aws_secret_access_key='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')


user = User(db)
@app.route('/users', methods=['GET'])
def userIndex():
    return user.getAllUsers()

@app.route('/user', methods=['GET'])
def userCreate():
    return user.registerUser(request.args.get('email'), request.args.get('password'))



if __name__ == '__main__':
    app.run(debug=True, port=7000)

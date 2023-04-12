from flask import Flask, request
import json
import boto3
from databaseInterface import UserInterface
from http import HTTPStatus


app = Flask(__name__)

__ENV__ = json.load(open(".env"))

import os
os.environ['AWS_DEFAULT_REGION'] = 'us-east-2'
client = boto3.client('dynamodb')
db = boto3.resource('dynamodb',aws_access_key_id=__ENV__['database_key'],aws_secret_access_key=__ENV__['database_secret'])

@app.route('/', methods=['GET'])
def home():
    return '<h1>Nothing to see here'

user = UserInterface(db)
@app.route('/users', methods=['GET'])
def userIndex():
    return user.getAllUsers()

@app.route('/user', methods=['POST'])
def userCreate():
    # Just a note for the future, we're definitely goign to want to precondition
    # this function call to ensure the arguments are valid
    return user.registerUser(request.args.get('email'), request.args.get('password'), request.args.get('userid'), request.args.get('firstName'), request.args.get('lastName'))



# Routing for loging in as an existing user
server_data = {
    'ksubbaswamy@umass.edu': '12345',
    'epickard@umass.edu': 'umass',
    'dummy@umass.edu': 'dummy',
}
@app.route('/userlogin', methods=['POST'])
def user_login():
    client_request = request.form.to_dict()
    client_email = client_request.get('email')
    client_password = client_request.get('password')
    if (client_email is None) or (client_password is None):
        return json.dumps({
            "statusCode": HTTPStatus.PRECONDITION_FAILED,
            "error": "Did not provide either an email or password"
        })
    
    server_password = server_data.get(client_email)
    if server_password is None:
        return json.dumps({
            "statusCode": HTTPStatus.NOT_FOUND,
            "error": "The email was not found in the database"
        })
    
    if server_password != client_password:
        return json.dumps({
            "statusCode": HTTPStatus.NOT_FOUND,
            "error": "The email and password you typed do not match"
        })
    
    # User input was correct and is logged in
    # Maybe fetch data from the database on class information
    return json.dumps({
        "statusCode": HTTPStatus.OK,
        "error": "None",
        "body": json.dumps({"classes": ['COMPSCI 377', 'COMPSCI 320', 'COMPSCI 383']})
    })

if __name__ == '__main__':
    app.run(debug=True, port=5000)

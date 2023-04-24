from datetime import datetime, timedelta

import jwt
from flask import Flask, request, make_response, jsonify
from pymongo import MongoClient
from db.database import Database
import bcrypt
import os
from utils.email_sender import EmailSender
from dotenv import load_dotenv
import random
from APIs.spire_api import SpireAPI
import json

load_dotenv()

app = Flask(__name__)
client = MongoClient()
database = Database(client)
email_sender = EmailSender(smtp_server='smtp.gmail.com', smtp_port=587,
                           username=os.getenv('SENDER_EMAIL'), password=os.getenv('SENDER_PASSWORD'))
spire_api = SpireAPI()

# client.server_info()



@app.route('/user/login', methods=['POST'])
def userLogin():

    try:
        json_data = request.get_json()
        email = json_data.get('email')
        password = json_data.get('password')
    except:
        return make_response("BAD REQUEST: missing argument(email, password)", 400)



    user = database.auth_user(email, password)
    # user = {}
    # user['firstName'] = "testusername"
    # user['id'] = 7


    if user:
        token = jwt.encode(
            {'user_id': user['id'], 'user_firstName': user['firstName'],
             'exp': datetime.utcnow() + timedelta(days=1)},
            os.getenv('JWT_SECRET'))

        return make_response(jsonify({'token': token}), 200)
    else:
        return make_response('Invalid Login', 401)



@app.route('/user/validate_email', methods=['POST'])
def userValidateEmail():
    json = request.get_json()
    email = json.get('email')
    code = random.randint(100000, 999999)
    res = email_sender.send_email(
        os.getenv('SENDER_EMAIL'), email, 'Email verification', 'Here is your confirmation code: ' + str(code))
    if res != None:
        return "Exception: " + str(res)
    return str(code)


@app.route('/user/recover_password', methods=['POST'])
def userRecoverPassword():
    json = request.get_json()
    email = json.get('email')
    if not database.user_exists(email):
        return "Exception: user does not exist"
    code = random.randint(100000, 999999)
    res = email_sender.send_email(
        os.getenv('SENDER_EMAIL'), email, 'Password recovery', 'Here is your recover password code: ' + str(code))
    if res != None:
        return "Exception: " + str(res)
    return str(code)


@app.route('/user/change_password', methods=['POST'])
def userChangePassword():
    json = request.get_json()
    email = json.get('email')
    password = json.get('password')
    return database.change_user_password(email, password)


@app.route('/user/signup', methods=['POST'])
def userSignup():
    json = request.get_json()
    return database.insert_new_user(json.get('email'), json.get('password'))


@app.route('/events/get', methods=['POST'])
def getEvents():
    jobj = request.get_json()
    query = jobj.get('query')
    return json.dumps(spire_api.getRelevantClasses(query, 10))


if __name__ == '__main__':
    app.run(debug=True, port=3000)

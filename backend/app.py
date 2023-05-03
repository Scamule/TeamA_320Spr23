import sys
from datetime import datetime, timedelta
from functools import wraps

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
from APIs.entities.schedule_builder import ScheduleBuilder
import json

load_dotenv()

app = Flask(__name__)
client = MongoClient()
database = Database(client)
email_sender = EmailSender(smtp_server='smtp.gmail.com', smtp_port=587,
                           username=os.getenv('SENDER_EMAIL'), password=os.getenv('SENDER_PASSWORD'))
spire_api = SpireAPI()
schedule_builder = ScheduleBuilder()
# client.server_info()


def jwt_required(func):
    @wraps(func)
    def decorated(*args, **kwargs):
        try:
            auth_header = request.headers.get('Authorization', None)
        except:
            return make_response(jsonify({'message': 'Authorization header is required'}), 401)

        token = auth_header.split(' ')[1]

        data = jwt.decode(token, os.getenv(
            'JWT_SECRET'), algorithms=["HS256"])
        try:
            data = jwt.decode(token, os.getenv(
                'JWT_SECRET'), algorithms=["HS256"])
        except:
            return make_response(jsonify({'message': 'Invalid token'}), 401)

        return func(data, *args, **kwargs)
    return decorated


@app.route('/user/login', methods=['POST'])
def userLogin():
    try:
        json_data = request.get_json()
        email = json_data.get('email')
        password = json_data.get('password')
    except:
        return make_response("BAD REQUEST: missing argument(email, password)", 400)

    user = database.auth_user(email, password)
    if user != None:
        exp = datetime.utcnow() + timedelta(days=1)
        exp = exp.timestamp()
        token = jwt.encode(
            {'email': email,
             'exp': exp},
            os.getenv('JWT_SECRET'), algorithm="HS256")

        return make_response(jsonify({'token': token}), 200)
    else:
        return make_response('Email and Password do not match', 401)


@app.route('/test/protectedRoute', methods=['GET'])
@jwt_required
def get_user_name(data):
    print(request.headers)
    return make_response(jsonify(data['user_firstName']), 200)


@app.route('/user/validate_email', methods=['POST'])
def userValidateEmail():
    json = request.get_json()
    email = json.get('email')
    code = random.randint(100000, 999999)
    # res = email_sender.send_email(os.getenv('SENDER_EMAIL'), email, 'Email verification', 'Here is your confirmation code: ' + str(code))
    # if res != None:
    #     return "Exception: " + str(res)
    return str(code)


@app.route('/user/recover_password', methods=['POST'])
def userRecoverPassword():
    json = request.get_json()
    email = json.get('email')
    if not database.user_exists(email):
        return "Exception: user does not exist"
    code = random.randint(100000, 999999)
    # res = email_sender.send_email(
    #     os.getenv('SENDER_EMAIL'), email, 'Password recovery', 'Here is your recover password code: ' + str(code))
    # if res != None:
    #     return "Exception: " + str(res)
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
@jwt_required
def getEvents(jwt_data):
    jobj = request.get_json()
    query = jobj.get('query')
    return json.dumps(spire_api.getRelevantClasses(query, 10))


@app.route('/user/events/add', methods=['POST'])
@jwt_required
def addEvent(jwt_data):
    jobj = request.get_json()
    event = jobj.get('event')
    return str(database.addEvent(jwt_data.get('email'), event))


@app.route('/user/events/delete', methods=['POST'])
@jwt_required
def deleteEvent(jwt_data):
    jobj = request.get_json()
    event = jobj.get('event')
    return str(database.deleteEvent(jwt_data.get('email'), event))


@app.route('/user/events/get', methods=['POST'])
@jwt_required
def getEvent(jwt_data):
    return json.dumps(database.getEvent(jwt_data.get('email')))


@app.route('/user/events/suggest', methods=['POST'])
@jwt_required
def suggestEvents(jwt_data):
    return json.dumps(spire_api.suggestEvents(jwt_data.get('email')))


@app.route('/user/schedule/generate', methods=['POST'])
@jwt_required
def generateSchedules(jwt_data):
    print(json.dumps(schedule_builder.getAllPossibleSchedules(
        database.getEvent(jwt_data.get('email')))))
    return json.dumps(schedule_builder.getAllPossibleSchedules(database.getEvent(jwt_data.get('email'))))


if __name__ == '__main__':
    app.run(debug=True, port=3000)

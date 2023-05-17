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
email_sender = EmailSender(smtp_server='smtp.gmail.com', smtp_port=587, username=os.getenv(
    'SENDER_EMAIL'), password=os.getenv('SENDER_PASSWORD'))
spire_api = SpireAPI()
schedule_builder = ScheduleBuilder()

# Define a decorator for requiring JWT authentication


def jwt_required(func):
    @wraps(func)
    def decorated(*args, **kwargs):
        try:
            auth_header = request.headers.get('Authorization', None)
        except:
            return make_response(jsonify({'message': 'Authorization header is required'}), 401)

        token = auth_header.split(' ')[1]

        # Verify and decode the JWT token
        try:
            data = jwt.decode(token, os.getenv(
                'JWT_SECRET'), algorithms=["HS256"])
        except:
            return make_response(jsonify({'message': 'Invalid token'}), 401)

        return func(data, *args, **kwargs)
    return decorated


# Endpoint for user login
@app.route('/user/login', methods=['POST'])
def userLogin():
    try:
        json_data = request.get_json()
        email = json_data.get('email')
        password = json_data.get('password')
    except:
        return make_response("BAD REQUEST: missing argument(email, password)", 400)

    # Authenticate user credentials
    user = database.auth_user(email, password)
    if user is not None:
        # Generate a JWT token with the user's email and expiration time
        exp = datetime.utcnow() + timedelta(days=1)
        exp = exp.timestamp()
        token = jwt.encode({'email': email, 'exp': exp},
                           os.getenv('JWT_SECRET'), algorithm="HS256")

        return make_response(jsonify({'token': token}), 200)
    else:
        return make_response('Email and Password do not match', 401)


# Protected route that requires JWT authentication
@app.route('/test/protectedRoute', methods=['GET'])
@jwt_required
def get_user_name(data):
    print(request.headers)
    return make_response(jsonify(data['user_firstName']), 200)


# Endpoint for validating user email
@app.route('/user/validate_email', methods=['POST'])
def userValidateEmail():
    json_data = request.get_json()
    email = json_data.get('email')
    code = random.randint(100000, 999999)
    # res = email_sender.send_email(os.getenv('SENDER_EMAIL'), email, 'Email verification', 'Here is your confirmation code: ' + str(code))
    # if res is not None:
    #     return "Exception: " + str(res)
    return str(code)


# Endpoint for recovering user password
@app.route('/user/recover_password', methods=['POST'])
def userRecoverPassword():
    json_data = request.get_json()
    email = json_data.get('email')
    if not database.user_exists(email):
        return "Exception: user does not exist"
    code = random.randint(100000, 999999)

    # res = email_sender.send_email(os.getenv('SENDER_EMAIL'), email, 'Password recovery', 'Here is your recover password code: ' + str(code))
    # if res is not None:
    # return "Exception: " + str(res)
    return str(code)

# Endpoint for changing user password


@app.route('/user/change_password', methods=['POST'])
def userChangePassword():
    json_data = request.get_json()
    email = json_data.get('email')
    password = json_data.get('password')
    return database.change_user_password(email, password)

# Endpoint for user signup


@app.route('/user/signup', methods=['POST'])
def userSignup():
    json_data = request.get_json()
    return database.insert_new_user(json_data.get('email'), json_data.get('password'))

# Endpoint for getting events


@app.route('/events/get', methods=['POST'])
@jwt_required
def getEvents(jwt_data):
    json_data = request.get_json()
    query = json_data.get('query')
    return json.dumps(spire_api.getRelevantClasses(query, 10))

# Endpoint for adding an event


@app.route('/user/events/add', methods=['POST'])
@jwt_required
def addEvent(jwt_data):
    json_data = request.get_json()
    event = json_data.get('event')
    return str(database.addEvent(jwt_data.get('email'), event))

# Endpoint for deleting an event


@app.route('/user/events/delete', methods=['POST'])
@jwt_required
def deleteEvent(jwt_data):
    json_data = request.get_json()
    event = json_data.get('event')
    return str(database.deleteEvent(jwt_data.get('email'), event))

# Endpoint for getting user events


@app.route('/user/events/get', methods=['POST'])
@jwt_required
def getEvent(jwt_data):
    return json.dumps(database.getEvent(jwt_data.get('email')))

# Endpoint for suggesting events


@app.route('/user/events/suggest', methods=['POST'])
@jwt_required
def suggestEvents(jwt_data):
    return json.dumps(spire_api.suggestEvents(jwt_data.get('email')))

# Endpoint for generating schedules


@app.route('/user/schedule/generate', methods=['POST'])
@jwt_required
def generateSchedules(jwt_data):
    print(json.dumps(schedule_builder.getAllPossibleSchedules(
        database.getEvent(jwt_data.get('email')))))
    return json.dumps(schedule_builder.getAllPossibleSchedules(database.getEvent(jwt_data.get('email'))))


# Run the Flask application
if name == 'main':
    app.run(debug=True, port=3000)

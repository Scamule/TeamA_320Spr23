from flask import Flask, request
from pymongo import MongoClient
from db.database import Database

app = Flask(__name__)
client = MongoClient()
database = Database(client)


@app.route('/user/signup', methods=['POST'])
def userSignup():
    json = request.get_json()
    return database.insert_new_user(json.get('email'), json.get('password'))


if __name__ == '__main__':
    app.run(debug=True)

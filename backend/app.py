import json

from flask import Flask, request

app = Flask(__name__)


@app.route('/', methods=['GET'])
def home():
    return f'Home page'


@app.route('/hello', methods=['GET'])
def hello():
    name = request.args.get('name')
    return f'Hello, {name}!'


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


if __name__ == '__main__':
    app.run(debug=True)

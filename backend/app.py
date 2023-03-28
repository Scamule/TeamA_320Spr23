from flask import Flask, request
import json

app = Flask(__name__)

@app.route('/hello', methods=['GET'])
def hello():
    name = request.args.get('name')
    password = request.args.get('password')
    thing = { "name": name }
    return json.dumps(thing)

if __name__ == '__main__':
    app.run(debug=True)
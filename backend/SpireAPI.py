import requests
import json

def get_class(class_id: int):
    class_data = []
    api_url = 'http://spire-api.melanson.dev/courses/?search=COMPSCI'

    response = requests.get(api_url)
    response = response.json()

    print(response['results'][0])

    return class_data

def parse_class(class_id: int):
    class_data = get_class(class_id)

    return class_data

def main():
    return parse_class(2323232)

main()
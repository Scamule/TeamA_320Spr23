import requests
import json

def get_class(class_id: int):
    #pulls a specific class from the set of all classes returned by the api.

    class_data = []
    api_url = "http://spire-api.melanson.dev/courses/?page=1&search=COMPSCI"

    response = requests.get(api_url)
    response = response.json()

    #classes that api returns
    classes_len = len(response['results'])
    classes = response['results']

    #looping through classes
    for i in range(15):
        for c in classes:
            print(c.get('id'))
        if(i != 14):
            api_url = response['next']
            response = requests.get(api_url)
            response = response.json()
            classes = response['results']


    return class_data

def parse_class(class_id: int):
    #going to parse the class data returned from get_class. Sort it into a data model TBD. Make the data for each
    #class easily accessible.
    class_data = get_class(class_id)

    return class_data

def main():
    return parse_class(2323232)

main()
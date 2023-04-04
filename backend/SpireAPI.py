import requests
import json

def sort_classes(api_url: str):
    #pulls a specific class from the set of all classes returned by the api.

    class_data = {}
    #api_url = "http://spire-api.melanson.dev/courses/?page=1&search=COMPSCI"

    response = requests.get(api_url)
    response = response.json()

    #classes that api returns
    classes_len = len(response['results'])
    classes = response['results']

    #looping through classes, and sending each one to parse_class to be parsed
    while True:
        for c in classes:
            parse_class(c)
        if(response['next'] is None):
            break
        api_url = response['next']
        response = requests.get(api_url)
        response = response.json()
        classes = response['results']    

    return class_data

def parse_class(c: dict):
    #going to parse the class data returned from get_class. Sort it into a data model TBD. Make the data for each
    #class easily accessible.
    class_data = {'id': '', 'class_number': 0, 'class_title': '', 'description': '', 'requirement': '', 'attribute': '', 'offerings': ''}
    #print(c.get('id'))
    for i in range(7):
        class_data['id'] = c.get('id')
        class_data['class_number'] = c.get('number')
        class_data['class_title'] = c.get('title')
        class_data['description'] = c.get('description')
        if(c.get('enrollment_information') is not None):
            class_data['requirement'] = c.get('enrollment_information').get('enrollment_requirement')
            class_data['attribute'] = c.get('enrollment_information').get('course_attribute')
        class_data['offerings'] = c.get('offerings')

    print(class_data)
    print('\n')
    
    return 'buns'

def main():
    api_url = "http://spire-api.melanson.dev/courses/?page=1&search=COMPSCI"
    sort_classes(api_url)
    return 'done'

main()
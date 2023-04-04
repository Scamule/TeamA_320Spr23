import requests
import json

def sort_classes(api_url: str):
    #pulls a specific class from the set of all classes returned by the api.

    all_class_data = {}
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
            class_data = parse_class(c)
            all_class_data[class_data['class_number']] = class_data
        if(response['next'] is None):
            break
        api_url = response['next']
        response = requests.get(api_url)
        response = response.json()
        classes = response['results']    

    return all_class_data

def parse_class(c: dict):
    #going to parse the class data returned from get_class. Sort it into a data model TBD. Make the data for each
    #class easily accessible.
    class_data = {'id': '', 'class_number': 0, 'class_title': '', 'description': '', 'requirement': '', 'attribute': '', 'offerings': ''}
    #print(c.get('id'))
    for i in range(len(class_data)):
        class_data['id'] = c.get('id')
        class_data['class_number'] = c.get('number')
        class_data['class_title'] = c.get('title')
        class_data['description'] = c.get('description')
        if(c.get('enrollment_information') is not None):
            class_data['requirement'] = c.get('enrollment_information').get('enrollment_requirement')
            class_data['attribute'] = c.get('enrollment_information').get('course_attribute')
        class_data['offerings'] = c.get('offerings')

    #print(class_data)
    #print('\n')
    
    return class_data

def get_offerings(all_class_data: dict, class_number: str):
    #takes in a class number and dictionary of classes and returns the offerings for the 
    #corresponding class number in the all class data dictionary
    return all_class_data[class_number].get('offerings')

def get_class(all_class_data: dict, class_number: str):
    #takes in a class number and dictionary of classes and returns the class for the 
    #corresponding class number and all the stored data for that class
    return all_class_data[class_number]

def main():
    api_url = "http://spire-api.melanson.dev/courses/?page=1&search=COMPSCI"
    all_class_data = sort_classes(api_url)
    #print(all_class_data)
    #print(get_offerings(all_class_data, '220'))
    print(get_class(all_class_data, '220'))

    return 'done'

main()
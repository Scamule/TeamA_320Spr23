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

def get_time(response,course_name):
    course_obj = response
    ret_arr = []
    if course_obj == '':
        return ret_arr
    offerings = course_obj['offerings']
    num_offerings = len(offerings)
    if num_offerings==0:
        return ret_arr
    for i in range(0,num_offerings):
        offering_obj = offerings[i]
        url = offering_obj['url']
        resp = requests.get(url).json()
        secs = resp['sections']
        for j in range(0,len(secs)):
            section_obj = secs[j]
            url2 = section_obj['url']
            resp2 = requests.get(url2).json()
            class_no = resp2['spire_id']
            meeting_info = resp2['meeting_information'][0]
            schd = meeting_info['schedule']
            schd['class_no'] = class_no
            ret_arr.append(schd)
    return ret_arr

def print_course_offerings(all_class_data: list, course_name: str):

    response = get_class(all_class_data, course_name)

    ret_arr = get_time(response=response,course_name=course_name)

    if(len(ret_arr)==0):
        print("Course Not offered this semester")
    else:
        print("Available classes for " + course_name + " are:")
        for i in range(0,len(ret_arr)):
            obj = ret_arr[i]
            days_arr = obj['days']
            listToStr = ' '.join([str(elem) for elem in days_arr])
            print("Lecture no: " + obj['class_no'] + " at " + obj['start_time'] + "-" + obj['end_time'] + " on days: " + listToStr)



def main():
    #using api url to get all the class data we want
    api_url = "http://spire-api.melanson.dev/courses/?page=1&search=COMPSCI"
    all_class_data = sort_classes(api_url)

    #test print statements
    #print(all_class_data)
    #print(get_offerings(all_class_data, '220'))
    #print(get_class(all_class_data, '220'))

    #test variables
    course_name = '220'
    #response = get_class(all_class_data, course_name)

    print_course_offerings(all_class_data, course_name)

    return print('\nfinished\n')

main()
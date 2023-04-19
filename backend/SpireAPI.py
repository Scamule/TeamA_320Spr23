import requests
import json
import time

# Returns a dictionary object, and None if failed
# @param:url is the url to request the json from
# @param:testing is used to return the fail_counter
def get_url_data(url:str, testing:bool=False):
    fail_limit = 10
    # wait_time is in milliseconds
    wait_time = 20
    for fail_counter in range(fail_limit):
        try:
            # Try and get the data
            obj = requests.get(url).json()
            # Success
            return obj if not testing else { "obj": obj, "fail_counter": fail_counter }
        except:
            # Failed to get the data
            time.sleep(wait_time / 1000)
    # Failed to get the data 
    raise ValueError('Could not fetch data from API')

def get_class(class_number: str):
    #pulls a specific class from the set of all classes returned by the api.
    api_url = 'http://spire-api.melanson.dev/courses/COMPSCI%20'
    api_url += class_number + '/'
    
    response = get_url_data(api_url)
    
    return parse_class(response)

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

def get_time(response, course_name):
    course_obj = response
    print(response)
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
        resp = get_url_data(url)
        secs = resp['sections']
        for j in range(0,len(secs)):
            section_obj = secs[j]
            url2 = section_obj['url']
            resp2 = get_url_data(url2)
            class_no = resp2['spire_id']
            meeting_info = resp2['meeting_information'][0]
            schd = meeting_info['schedule']
            schd['class_no'] = class_no
            ret_arr.append(schd)
    return ret_arr

def print_course_offerings(course_name: str):

    response = get_class(course_name)

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

    #test print statements
    #print(all_class_data)
    #print(get_offerings(all_class_data, '220'))
    #print(get_class(all_class_data, '220'))

    #test variables
    course_name = '220'
    #response = get_class(all_class_data, course_name)

    print_course_offerings(course_name)

    return print('\nfinished\n')

if __name__ == '__main__':
    main()
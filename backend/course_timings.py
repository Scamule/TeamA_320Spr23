import requests
import json 

def get_time(response,course_name):
    course_obj = None
    for i in range(0,len(response)):
        course = response[i]
        if course['id']==course_name:
            course_obj = course
            break
    ret_arr = []
    if course_obj is None:
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



def main():
    api_url = "http://spire-api.melanson.dev/courses/?page=1&search=COMPSCI"
    response = requests.get(api_url)
    response = response.json()['results']
    course_name = "COMPSCI 120"
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

main()

#Converts time to number of minutes.
#Eg - Converts 13:30 to 810 minutes.
def time_to_hours(timeStr):
    time_arr = timeStr.split("-")
    start_time = ""
    end_time = ""
    for i in range(0,len(time_arr)):
        time = time_arr[i]
        hrs,mins = time.split(":")
        int_hrs = int(hrs)
        int_mins = int(mins)
        int_totalMins = (int_hrs*60) + int_mins
        if i==0:
            start_time=int_totalMins
        else:
            end_time = int_totalMins
    return (start_time,end_time)

# Converts minutes back into time.
#Eg - Converts 170 to 2:00, converts 840 to 14:00
def hours_to_time(ret_dict,mapping):
    key_arr = list(ret_dict.keys())
    for i in range(0,len(key_arr)):
        dict_arr = ret_dict[key_arr[i]]
        for j in range(0,len(dict_arr)):
            dict_ele = dict_arr[j]
            dict_arr[j] = mapping[dict_ele] 
        ret_dict[key_arr[i]] = dict_arr
    return ret_dict

        
#Takes in an array of class selection timings in the format "day time" - eg: "Monday 11:15-12:30" 
#And checks if the schedule is valid
def schedule_helper(timearr):
    dict = {}
    mapping = {}
    for i in range(0,len(timearr)):
        arrStr = timearr[i]
        day,time = arrStr.split()
        mins_tuple = time_to_hours(time)
        mapping[mins_tuple] = time
        if day not in dict:
            dict_arr = []
            dict_arr.append(mins_tuple)
            dict[day] = dict_arr
        else:
            dict_arr = dict[day]
            for j in range(0,len(dict_arr)):
                curr_tup = dict_arr[j]
                if (mins_tuple[0]>=curr_tup[0] and mins_tuple[0]<=curr_tup[1]) or (mins_tuple[1]>=curr_tup[0] and mins_tuple[1]<=curr_tup[1]):
                    return {},{}
            dict_arr.append(mins_tuple)
            dict[day] = dict_arr
    return dict,mapping


#Passes in a potential schedule and makes a call to a function which validates the schedule
# TODO: Parse the spire API to get all of the users course offerings, form different combinations of the course offerings and validate schedules
def main_schedule():
    arr = ["Monday 11:15-12:10","Monday 12:15-13:00","Tuesday 14:00-17:00"]
    ret_dict,mapping = schedule_helper(arr)
    if not ret_dict:
        print("No schedules generated")
        return
    ret_dict = hours_to_time(ret_dict,mapping)
    print(str(ret_dict))
    

# ret = time_to_hours("1:10-2:00")
# print(ret)
main_schedule()

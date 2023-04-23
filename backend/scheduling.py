import SpireAPI as sp
import itertools

def schedule_builder():
    pass



def schedule(class_arr):
    ret_arr = []
    for i in range(0,len(class_arr)):
        class_info = sp.get_class(class_arr[i])
        arr = sp.get_time(class_info,class_arr[i])
        for j in range(0,len(arr)):
            obj = arr[j]
            strobj = obj['start_time'] + "-" + obj['end_time']
            arr[j] = strobj
        ret_arr.append(arr)
    for t in itertools.product(*ret_arr):
        print(t)

    


def main():
    arr = ["220","230"]
    schedule(arr)

main()
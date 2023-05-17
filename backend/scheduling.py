# Importing the SpireAPI module for interaction with some API.
import SpireAPI as sp
import itertools  # Importing the itertools module for later use.


def schedule_builder():
    pass  # Placeholder function, currently empty.


def schedule(class_arr):
    ret_arr = []  # Initialize an empty list to store the class schedules.

    # Iterate over the class IDs provided in the class_arr list.
    for i in range(0, len(class_arr)):
        # Get class information using the SpireAPI.
        class_info = sp.get_class(class_arr[i])
        # Get the schedule information.
        arr = sp.get_time(class_info, class_arr[i])

        # Convert the start and end time of each schedule object to a string format.
        for j in range(0, len(arr)):
            obj = arr[j]
            strobj = obj['start_time'] + "-" + obj['end_time']
            arr[j] = strobj

        # Append the modified schedule array to the ret_arr list.
        ret_arr.append(arr)

    # Generate all possible combinations of schedules in ret_arr using itertools.product.
    for t in itertools.product(*ret_arr):
        print(t)  # Print each combination.


def main():
    arr = ["220", "230"]  # Example array with class IDs.
    schedule(arr)  # Call the schedule function with arr as an argument.


main()  # Call the main function to start the program.

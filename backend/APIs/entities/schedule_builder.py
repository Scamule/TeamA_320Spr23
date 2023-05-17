from ..spire_api import SpireAPI
from datetime import datetime, date


class ScheduleBuilder():


    """
    ScheduleBuilder creates a class of functions intended on creating a schedule for a group of class information.
    This class information is going to be grabbed from spireAPI. This class will most likely be implemented by
    frontend to create the schedules for students. This class pulls all possible lectures and discussions using
    getAllPossibleSchedules, and then uses the remaing functions hash, hashable, checkifvalid, and solvecsp to
    create all possible schedules for the student.
    """

    def __init__(self):
        self.spire_api = SpireAPI()

    def getAllPossibleSchedules(self, events):
        """
        getAllPosibleSchedules takes in a ScheduleBuilder object and an event List. It parses through
        this list and for each event it grabs all of the offerings and determines if the offering is a
        discussion or class. It then takes the relavant data: end,start,days,id and puts this into a classes
        or discussion list.


        param self: Schedule Builder object
        param events: list of events
        return: none (sets the classes and discussions to the given event)
        """
        # Define variables
        term = self.spire_api.getClosestTerm().get('id')
        csp = []
        # loop through each event and grab the offerings
        for e in events:
            offering = None
            for o in e.get('offerings'):
                if o.get('term').get('id') == term:
                    offering = o
                    break
            if offering == None:
                break

            classes = []
            discussions = []
            # start looping through each offering and grabbing the different sections
            for s in self.spire_api.request(offering.get('url')).get('sections'):
                # set desc equal to the raw data from spire
                desc = self.spire_api.request(s.get('url')).get(
                    'meeting_information')[0].get('schedule')
                start, end, id, days = None, None, e.get('id'), None

                # Check to make sure desc is not None
                if(desc is not None):
                    # We can call desc.get, update parameters with supplied data from desc
                    start, end, days = desc.get('start_time'), desc.get(
                        'end_time'), desc.get('days')

                # Put data in object
                obj = {
                    'id': id,
                        'start_time': datetime.strptime(start, '%H:%M:%S') if start is not None else None,
                        'end_time': datetime.strptime(end, '%H:%M:%S') if end is not None else None,
                        'days': days
                }

                # Lecture or discussion
                if "LEC" in s.get('spire_id'):
                    classes.append(obj)
                else:
                    discussions.append(obj)
        # append the class and discussion lists for each event to csp
        csp.append(Event(classes))
        csp.append(Event(discussions))

        schedules = set()

        # print(csp)

        def solveCsp(queue, events_list):
            if len(events_list) == 0:
                schedules.add(hashable(queue))
                return
            event = events_list.pop(0)
            for section in event.sections:
                if checkIfValid(queue, section):
                    solveCsp(queue + [section], events_list)

        def checkIfValid(queue, section):
            """
            checkIfValid takes in a queue and a section. It is a basic collision check to see that if a given class
            can fit into the section data, mainly if it can fit into the day and time of the section.

            param queue: a queue of classes
            param section: a defined section that has data date and time
            return: boolean: true if the queue works, false if any single class fails
            """
            # loop through each class in queue
            for s in queue:
                    days = section.get('days')
                    # check if the class matches the sections day data
                    for day in s.get('days'):
                        if day in days:
                            # check if the section matches the time data
                            if section.get('start_time') <= s.get('end_time') and section.get('end_time') >= s.get('start_time'):
                                return False
            return True

        def hash(x):
            """
            hashes a given input

            param x: input to be hashed
            return: tuple of hashed input items
            """
            x = x.copy()
            days = x.get('days')
            x['days'] = tuple(days)
            x['start_time'] = x['start_time'].strftime("%H:%M:%S")
            x['end_time'] = x.get('end_time').strftime("%H:%M:%S")
            items = x.items()
            return tuple(sorted(items))

        def hashable(queue):
            """
            implements the hash function

            param queue: a queue of classes
            return: a tuple mapping the hash of x and the inputted queue
            """
            return tuple(map(lambda x: hash(x), queue))

        def convertBack(input):
            """
            convertBack takes in input and reverts it to a list of section dictionaries holding just a value for
            days.

            param input: input is a list of lists
            return: a list of lists of dictionaries holding days information
            """
            output = []
            # loop through each item in input
            for group in input:
                sections = []
                for section in group:
                    # set the different attributes of section_dict then add to sections
                    section_dict = dict(section)
                    section_dict['days'] = list(section_dict['days'])
                    sections.append(section_dict)
                # add it to the output
                output.append(sections)
            return output

        for e in csp:
            solveCsp([], csp.copy())
        print(list(schedules))
        return convertBack(list(schedules))


class Event():
    def __init__(self, sections):
        self.sections = sections

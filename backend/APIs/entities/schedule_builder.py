from ..spire_api import SpireAPI
from datetime import datetime, date


class ScheduleBuilder():
    def __init__(self):
        self.spire_api = SpireAPI()

    def getAllPossibleSchedules(self, events):
        term = self.spire_api.getClosestTerm().get('id')
        csp = []
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
            for s in self.spire_api.request(offering.get('url')).get('sections'):
                desc = self.spire_api.request(s.get('url')).get(
                    'meeting_information')[0].get('schedule')
                start, end, id, days = desc.get('start_time'), desc.get('end_time'), e.get('id'), desc.get('days')
                if(start is None or end is None):
                    obj = {
                            'id': id,
                            'days': days,
                            'start_time': None,
                            'end_time': None
                        }     
                else:
                    obj = {
                            'id': id,
                            'days': days,
                            'start_time': datetime.strptime(start, '%H:%M:%S'),
                            'end_time': datetime.strptime(end, '%H:%M:%S')
                        }         
                    if "LEC" in s.get('spire_id'):
                        classes.append(obj)
                    else:
                        discussions.append(obj)

            csp.append(Event(classes))
            csp.append(Event(discussions))

        schedules = set()

        print(csp)

        def solveCsp(queue, events_list):
            if len(events_list) == 0:
                schedules.add(hashable(queue))
                return
            event = events_list.pop(0)
            for section in event.sections:
                if checkIfValid(queue, section):
                    solveCsp(queue + [section], events_list)

        def checkIfValid(queue, section):
            for s in queue:
                days = section.get('days')
                for day in s.get('days'):
                    if day in days:
                        if section.get('start_time') <= s.get('end_time') and section.get('end_time') >= s.get('start_time'):
                            return False
            return True

        def hash(x):
            x = x.copy()
            days = x.get('days')
            x['days'] = tuple(days)
            x['start_time'] = x['start_time'].strftime("%H:%M:%S")
            x['end_time'] = x.get('end_time').strftime("%H:%M:%S")
            items = x.items()
            return tuple(sorted(items))

        def hashable(queue):
            return tuple(map(lambda x: hash(x), queue))

        def convertBack(input):
            output = []
            for group in input:
                sections = []
                for section in group:
                    section_dict = dict(section)
                    section_dict['days'] = list(section_dict['days'])
                    sections.append(section_dict)
                output.append(sections)
            return output

        for e in csp:
            solveCsp([], csp.copy())
        print(list(schedules))
        return convertBack(list(schedules))


class Event():
    def __init__(self, sections):
        self.sections = sections

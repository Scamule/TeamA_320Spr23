import requests
from datetime import datetime, date
from .entities.cources_filter import CourcesFilter


class SpireAPI:
    def __init__(self):
        pass

    def getRelevantClasses(self, query, num_classes):
        max_pages = 5
        c = 0
        courses = []
        next_page = "https://spire-api.melanson.dev/courses/"
        params = {'search': query}
        while True:       # Python does not have do-while loops so sorry for that trash
            response = requests.get(next_page, params=params)
            if response.status_code != 200:
                raise Exception("API is unavailable")
            response = response.json()
            courses.extend(response.get('results'))
            next_page = response.get('next')
            if next_page == None or c == max_pages:
                break
            c += 1
        term = self.getClosestTerm().get('id')
        return CourcesFilter(courses).filterOfferingsByTerm(term).max(num_classes).getCources()

    def getAllTerms(self):
        terms = []
        next_page = "https://spire-api.melanson.dev/terms/"
        while True:  # Python does not have do-while loops so sorry for that trash
            response = requests.get(next_page)
            if response.status_code != 200:
                raise Exception("API is unavailable")
            response = response.json()
            terms.extend(response.get('results'))
            next_page = response.get('next')
            if next_page == None:
                break
        return terms

    def getClosestTerm(self):
        terms = self.getAllTerms()
        dates = []
        cur_date = date.today()
        for i, term in enumerate(terms):
            start_date = datetime.strptime(
                term.get('start_date'), '%Y-%m-%d').date()
            end_date = datetime.strptime(
                term.get('end_date'), '%Y-%m-%d').date()

            if cur_date > start_date or cur_date < start_date and cur_date > end_date:
                return terms[i]

        return terms[-1]


api = SpireAPI()
print(api.getRelevantClasses('250', 0))

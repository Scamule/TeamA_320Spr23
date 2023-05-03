import requests
from datetime import datetime, date
from .entities.cources_filter import CourcesFilter
from db.database import Database
from pymongo import MongoClient
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np


class SpireAPI:
    def __init__(self):
        client = MongoClient()
        self.database = Database(client)

    def getRelevantClasses(self, query, num_classes):
        courses = self.database.searchforCources(query)
        term = self.getClosestTerm().get('id')
        return CourcesFilter(courses).filterOfferingsByTerm(term).max(num_classes).getCources()

    def getAllTerms(self):
        return self.database.getAllTerms()

    def request(self, url):
        return requests.get(url).json()

    def getClosestTerm(self):
        terms = self.getAllTerms()
        cur_date = date.today()
        for i, term in enumerate(terms):
            start_date = datetime.strptime(
                term.get('start_date'), '%Y-%m-%d').date()
            end_date = datetime.strptime(
                term.get('end_date'), '%Y-%m-%d').date()
            if cur_date > start_date or cur_date < start_date and cur_date > end_date:
                return terms[i]

        return terms[-1]

    def suggestEvents(self, email):
        term = self.getClosestTerm().get('id')
        cources = CourcesFilter(self.database.getAllCources(
        )).filterOfferingsByTerm(term).getCources()
        events = self.database.getEvent(email)
        if len(events) == 0:
            return []

        results = []
        for cource in cources:
            maxsim = -1.0
            e = None
            for event in events:
                sim = cosine_similarity(
                    [np.array(cource.get('token')), np.array(event.get('token'))])[0][1]
                if e == None or sim > maxsim:
                    maxsim = sim
                    e = event
            results.append((maxsim, cource))

        results.sort(key=lambda a: a[0])
        ret = []
        for i in range(5):
            ret.append(results[-i - len(events) - 1][1])
        return ret

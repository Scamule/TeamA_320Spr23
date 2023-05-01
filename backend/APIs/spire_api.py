import requests
from datetime import datetime, date
from .entities.cources_filter import CourcesFilter
from db.database import Database
from pymongo import MongoClient


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

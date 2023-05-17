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
        # Get the relevant courses based on the query
        courses = self.database.searchforCources(query)
        # Get the closest term
        term = self.getClosestTerm().get('id')
        # Filter the courses based on the term, limit the number of classes, and get the courses
        return CourcesFilter(courses).filterOfferingsByTerm(term).max(num_classes).getCources()

    def getAllTerms(self):
        # Retrieve all terms from the database
        return self.database.getAllTerms()

    def request(self, url):
        # Send a GET request to the specified URL and return the JSON response
        return requests.get(url).json()

    def getClosestTerm(self):
        # Get all terms
        terms = self.getAllTerms()
        # Get the current date
        cur_date = date.today()
        for i, term in enumerate(terms):
            # Convert start and end dates of each term to date objects
            start_date = datetime.strptime(
                term.get('start_date'), '%Y-%m-%d').date()
            end_date = datetime.strptime(
                term.get('end_date'), '%Y-%m-%d').date()
            # Find the term that matches the current date or is the closest to it
            if cur_date > start_date or (cur_date < start_date and cur_date > end_date):
                return terms[i]

        # If no term matches, return the last term in the list
        return terms[-1]

    def suggestEvents(self, email):
        # Get the closest term
        term = self.getClosestTerm().get('id')
        # Get all courses filtered by the term
        cources = CourcesFilter(self.database.getAllCources(
        )).filterOfferingsByTerm(term).getCources()
        # Get the events for the specified email
        events = self.database.getEvent(email)
        if events is None or len(events) == 0:
            return []

        results = []
        # Calculate cosine similarity between courses and events' tokens
        for cource in cources:
            maxsim = -1.0
            e = None
            for event in events:
                sim = cosine_similarity(
                    [np.array(cource.get('token')), np.array(event.get('token'))])[0][1]
                if e is None or sim > maxsim:
                    maxsim = sim
                    e = event
            results.append((maxsim, cource))

        # Sort the results based on similarity
        results.sort(key=lambda a: a[0])
        ret = []
        # Get the top 5 courses with the highest similarity, excluding already enrolled events
        for i in range(5):
            ret.append(results[-i - len(events) - 1][1])
        return ret

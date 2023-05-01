import requests
from db.database import Database
from pymongo import MongoClient
from sentence_transformers import SentenceTransformer


class SpireScraper:

    def __init__(self, max_requests=5):
        self.max_requests = max_requests
        client = MongoClient()
        self.database = Database(client)
        self.bert = SentenceTransformer('bert-base-nli-mean-tokens')

    def scrapeAllTerms(self):
        url = "https://spire-api.melanson.dev/terms/"
        response = self.requestTilMax(url, self.max_requests).json()

        while True:
            url = response.get('next')
            for term in response.get('results'):
                self.database.upsertTerm(term)
            if url == None:
                break
            response = self.requestTilMax(url, self.max_requests).json()

    def scrapeAllCources(self):
        url = "https://spire-api.melanson.dev/courses/"
        response = self.requestTilMax(url, self.max_requests).json()

        while True:
            url = response.get('next')
            for course in response.get('results'):
                course['token'] = self.bert.encode(
                    str(course['id']) + ' ' + str(course['description'])).tolist()
                self.database.upsertCourse(course)
            if url == None:
                break
            response = self.requestTilMax(url, self.max_requests).json()

    def requestTilMax(self, url, max):
        response = requests.get(url, params={})
        c = 1
        while response.status_code != 200 and c < max:
            response = requests.get(url, params={})

        if response.status_code != 200:
            raise Exception("API is unavailable")
        else:
            return response


scraper = SpireScraper()
scraper.scrapeAllTerms()
scraper.scrapeAllCources()

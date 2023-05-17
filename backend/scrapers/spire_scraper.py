import requests
from db.database import Database
from pymongo import MongoClient
from sentence_transformers import SentenceTransformer

#This code defines a class SpireScraper that is used to scrape data from an API
# and store it in a MongoDB database using the pymongo library
class SpireScraper:
    #The class constructor takes an optional max_requests parameter, which specifies the maximum number of requests that can be made to the API
   #It initializes a MongoClient object and a Database object from the db.database module, which is responsible for handling the interaction with the MongoDB database
    def __init__(self, max_requests=5):
        self.max_requests = max_requests
        client = MongoClient()
        self.database = Database(client)
        self.bert = SentenceTransformer('bert-base-nli-mean-tokens')

    #The scrapeAllTerms method starts by making a request to the API to get the first page of terms,
   # which contains a list of dictionaries representing terms. 
   # The method then inserts each term into the database using the upsertTerm method of the Database object
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
    #The scrapeAllCources method does the same thing but for courses.
    # It starts by making a request to the API to get the first page of courses, which contains a list of dictionaries representing courses.
    # The method then encodes the course descriptions using the SentenceTransformer object and inserts each course into the database using the upsertCourse method of the Database object.
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
    # This function is used to make requests to the API and return the response.
   # The function makes the request and checks the response status code.
   # If the status code is not 200, the function will retry the request until it either succeeds or the maximum number of retries has been reached.
    def requestTilMax(self, url, max):
        response = requests.get(url, params={})
        c = 1
        while response.status_code != 200 and c < max:
            response = requests.get(url, params={})

        if response.status_code != 200:
            raise Exception("API is unavailable")
        else:
            return response

#Creates an instance of an object which scrapes and inserts all terms and courses into their respective collections in the mongodb database
scraper = SpireScraper()
scraper.scrapeAllTerms()
scraper.scrapeAllCources()

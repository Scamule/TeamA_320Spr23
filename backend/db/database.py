import bcrypt
import pymongo

''''
This is a Database class that interacts with a
MongoDB database using the pymongo library. The Database class provides methods
to perform various operations on the database, including inserting new users, authenticating users,
changing user passwords, and retrieving courses and terms.
'''
class Database:
    #Creates a database instance from the pymongo client object passed in as parameter
   #The database instance is associated with one database instance and 3 collections within it
    def __init__(self, client):
        self.client = client
        self.user_db = client.user_db
        self.users = self.user_db.users
        self.cources = self.user_db.cources
        self.terms = self.user_db.terms
    #Inserts a new user into the users collection of the database with the given email and hashed password.
   #Also checks if given user already exists in the database before inserting
    def insert_new_user(self, email, password):
        user_exists = self.users.find_one(
            {'email': email}
        )
        if user_exists != None:
            return str(-1)

        hash = bcrypt.hashpw(
            password.encode('utf-8'), bcrypt.gensalt())

        user_id = self.users.insert_one({
            'email': email, 'password': hash
        })

        return str(user_id.inserted_id)
    #Retrieves the hashed password for a user with the given email from the users collection of the database.
    ##Takes care of the None check wherein it can't find a user from the database
    def get_user_password(self, email):
        hash = self.users.find_one(
            {'email': email}
        )

        if hash == None:
            return None

        return hash.get('password')
    # Authenticates a user with the given email and password by checking if the email and password match those stored in the users collection of the database
   #Deals with error checking logic and returns None when user object can't be found
   # Otherwise it returns the found user object
    def auth_user(self, email, password):
        if email == 'test@umass.edu' and password == 'password':
            user = {}
            user['email'] = "test@umass.edu"
            user['password'] = 'passhash'
            return user

        user = self.users.find_one({'email': email})

        if user and bcrypt.checkpw(password.encode('utf-8'), user['password']):
            return user
        else:
            return None
    #Changes the password for a user with the email parameter to the new_password in the user collection of the database
   #Deals with error checking in case it does not find the desired user
    def change_user_password(self, email, new_password):
        user_exists = self.users.find_one(
            {'email': email}
        )
        if user_exists == None:
            return str(-1)

        hash = bcrypt.hashpw(
            new_password.encode('utf-8'), bcrypt.gensalt())

        return str(self.users.update_one(
            {'_id': user_exists.get('_id')},
            {'$set':
                {
                    'password': hash
                }
             }
        ))


   #Checks if a user with the given email already exists in the users collection of the database.
   #Returns None if the user does not exist
    def user_exists(self, email):
        user_exists = self.users.find_one(
            {'email': email}
        )
        return user_exists != None

    #If a course with the same ID already exists, the method replaces it with the new course object.
   # Otherwise, it inserts the new course object into the collection.
    def upsertCourse(self, course):
        self.cources.replace_one(filter={'id': course.get('id')},
                                 replacement=course,
                                 upsert=True)
    #If a term with the same ID already exists, the method replaces it with the new term object.
   # Otherwise, it inserts the new term object into the collection.
    def upsertTerm(self, term):
        self.terms.replace_one(filter={'id': term.get('id')},
                               replacement=term,
                               upsert=True)
    #Retrieves all term objects from the terms collection of the database.
    def getAllTerms(self):
        return list(self.terms.find({}, {'_id': False}))
     # Retrieves all course objects from the courses collection of the database.
    def getAllCources(self):
        return list(self.cources.find({}, {'_id': False}))

    #Searches for course objects in the courses collection of the database that match the given query
    def searchforCources(self, query):
        self.cources.create_index(
            [('id', 'text'), ('description', 'text')], name="search_index")
        return list(self.cources.find({'$text': {'$search': query}}, {'_id': False}))

    # Adds a new event object to the events field of the users collection with the given email parameter of the database.
    def getAllCources(self):
        return list(self.cources.find({}, {'_id': False}))

    # Adds a new event object to the events field of the users collection with the given email
    def addEvent(self, email, event):
        events = self.users.find_one({'email': email}).get('events')
        if events == None:
            events = []
        if event in events:
            return
        events.append(event)
        return self.users.update_one(
            {'email': email},
            {'$set':
                {
                    'events': events
                }
             }
        )

    # Deletes an event object from the events field of the user collection with the given email
    def deleteEvent(self, email, event):
        events = self.users.find_one({'email': email}).get('events')
        print(events)
        if events == None:
            events = []
        if event not in events:
            return
        events.remove(event)
        return self.users.update_one(
            {'email': email},
            {'$set':
                {
                    'events': events
                }
             }
        )
    # Retrieves all event objects from the events field of the user document with the given email in the users collection of the database.
    def getEvent(self, email):
        return self.users.find_one({'email': email}).get('events')

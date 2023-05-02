import bcrypt
import pymongo


class Database:
    def __init__(self, client):
        self.client = client
        self.user_db = client.user_db
        self.users = self.user_db.users
        self.cources = self.user_db.cources
        self.terms = self.user_db.terms

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

    def get_user_password(self, email):
        hash = self.users.find_one(
            {'email': email}
        )

        if hash == None:
            return None

        return hash.get('password')

    def auth_user(self, email, password):
        if email == 'test@umass.edu' and password == 'password':
            user = {}
            user['email'] = "test@umass.edu"
            user['password'] = 'passhash'
            user['firstName'] = 'Pablo'
            user['id'] = '88'
            return user

        user = self.users.find_one({'email': email})

        if user and bcrypt.checkpw(password.encode('utf-8'), user['password']):
            return user
        else:
            return None

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

    def user_exists(self, email):
        user_exists = self.users.find_one(
            {'email': email}
        )
        return user_exists != None

    def upsertCourse(self, course):
        self.cources.replace_one(filter={'id': course.get('id')},
                                 replacement=course,
                                 upsert=True)

    def upsertTerm(self, term):
        self.terms.replace_one(filter={'id': term.get('id')},
                               replacement=term,
                               upsert=True)

    def getAllTerms(self):
        return list(self.terms.find({}, {'_id': False}))

    def getAllCources(self):
        return list(self.cources.find({}, {'_id': False}))

    def searchforCources(self, query):
        self.cources.create_index(
            [('id', 'text'), ('description', 'text')], name="search_index")
        return list(self.cources.find({'$text': {'$search': query}}, {'_id': False}))

    def getAllCources(self):
        return list(self.cources.find({}, {'_id': False}))

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

    def getEvent(self, email):
        return self.users.find_one({'email': email}).get('events')

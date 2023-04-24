import bcrypt


class Database:
    def __init__(self, client):
        self.client = client
        self.user_db = client.user_db
        self.users = self.user_db.users

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

import bcrypt


class Database:
    def __init__(self, client):
        self.client = client
        self.user_db = client.user_db
        self.users = self.user_db.users

    def insert_new_user(self, email, password):
        print(email)
        user_exists = self.users.find_one(
            {'email': email}
        )
        if user_exists:
            return str(-1)

        hash = bcrypt.hashpw(
            password.encode('utf-8'), bcrypt.gensalt())

        user_id = self.users.insert_one({
            'email': email, 'password': hash
        })

        return str(user_id.inserted_id)

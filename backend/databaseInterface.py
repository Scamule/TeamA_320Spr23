class User:
    def __init__(self, dyn_resource):
        self.dyn_resource = dyn_resource
        self.table = dyn_resource.Table('Users')

    def registerUser(self, email, password):
        response = self.table.put_item(
            Item={
                'Student_ID': "444",
                'Cur_Courses': None,
                'Email': email,
                'First_Name': "Test",
                'Last_Name': "Datta",
                'Major': "CS",
                'Password': password
            }
        )
        return(response)

    def getAllUsers(self):
        response = self.table.scan()
        return(response["Items"])

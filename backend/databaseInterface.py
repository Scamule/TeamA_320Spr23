class UserInterface:
    def __init__(self, dyn_resource):
        self.dyn_resource = dyn_resource
        self.table = dyn_resource.Table('Users')

    def registerUser(self, email, password, userid, firstName, lastName):
        response = self.table.put_item(
            Item={
                'Student_ID': userid,
                'Cur_Courses': None,
                'Email': email,
                'First_Name': firstName,
                'Last_Name': lastName,
                'Major': "CS",
                'Password': password
            }
        )
        return(response)

    def getAllUsers(self):
        response = self.table.scan()
        return(response["Items"])

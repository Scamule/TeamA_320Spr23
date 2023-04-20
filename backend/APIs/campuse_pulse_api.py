import requests

class CampusPulseAPI():

    def __init__(self):
        pass

    def getOrganisations(self, query="", num_orgs=9999999):
        url = 'https://umassamherst.campuslabs.com/engage/api/discovery/search/organizations'
        params = {'top': num_orgs, 'filter': '', 'query': query, 'skip': 0}
        response = requests.get(url, params=params)
        if response.status_code != 200:
            raise Exception("API is unavailable")
        response = response.json()
        return response['value']

    def getOrgWithId(self, id):
        url = 'https://umassamherst.campuslabs.com/engage/api/discovery/branch'
        params = {'orgId': id, 'take': 50, 'orderByField': 'name'}
        response = requests.get(url, params=params)
        if response.status_code != 200:
            raise Exception("API is unavailable")
        response = response.json()
        if len(response['items']) == 0 or response['items'][0]['id'] != id:
            raise Exception("No existing organisation with specified Id")
        return response['items'][0]
import requests


class CampusPulseAPI():
    def __init__(self):
        pass

    def getOrganisations(self, query="", num_orgs=9999999):
        # Endpoint URL to retrieve organizations
        url = 'https://umassamherst.campuslabs.com/engage/api/discovery/search/organizations'

        # Parameters for the API request
        params = {'top': num_orgs, 'filter': '', 'query': query, 'skip': 0}

        # Send GET request to retrieve organizations
        response = requests.get(url, params=params)
        if response.status_code != 200:
            raise Exception("API is unavailable")
        response = response.json()

        # Return the list of organizations from the response
        return response['value']

    def getOrgWithId(self, id):
        # Endpoint URL to retrieve an organization by ID
        url = 'https://umassamherst.campuslabs.com/engage/api/discovery/branch'

        # Parameters for the API request
        params = {'orgId': id, 'take': 50, 'orderByField': 'name'}

        # Send GET request to retrieve the organization with the specified ID
        response = requests.get(url, params=params)
        if response.status_code != 200:
            raise Exception("API is unavailable")
        response = response.json()

        # Check if the organization exists and return the organization data
        if len(response['items']) == 0 or response['items'][0]['id'] != id:
            raise Exception("No existing organization with specified ID")
        return response['items'][0]

import json


class CourcesFilter:
    def __init__(self, cources):
        self.cources = cources

    @staticmethod
    def is_json(j):
        try:
            json.loads(j)
        except ValueError as e:
            return False
        return True

    def filterOfferingsByTerm(self, target_term):
        # Filter the courses based on the target term
        def filter_fn(term):
            offerings = term.get('offerings')
            for offering in offerings:
                if offering.get('term').get('id') == target_term:
                    return True
            return False

        return CourcesFilter(list(filter(filter_fn, self.cources)))

    def max(self, max_n):
        # Limit the number of courses to the specified maximum
        if len(self.cources) < max_n:
            return self
        return CourcesFilter(self.cources[:max_n])

    def getCources(self):
        # Return the list of courses
        return self.cources

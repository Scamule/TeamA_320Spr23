import json


class CourcesFilter:
    def __init__(self, cources):
        self.cources = cources

    def is_json(j):
        try:
            json.loads(j)
        except ValueError as e:
            return False
        return True

    def filterOfferingsByTerm(self, target_term):
        def filter_fn(term):
            offerings = term.get('offerings')
            for offering in offerings:
                if offering.get('term').get('id') == target_term:
                    return True
            return False
        return CourcesFilter(list(filter(filter_fn, self.cources)))

    def max(self, max_n):
        if len(self.cources) < max_n:
            return self
        return CourcesFilter(self.cources[:max_n])

    def getCources(self):
        return self.cources

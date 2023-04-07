from SpireAPI import get_url_data
import unittest

"""
    TODO: Test the API and see how it fails sometimes.
"""

class Tests(unittest.TestCase):
  
    url = 'https://spire-api.melanson.dev/courses/'

    # Tests the ability to call the API tons of times
    def test_endurance(self):
        for i in range(20):
            obj = get_url_data(self.url, testing=True)
            self.assertIsNotNone(obj, 'Object was None')
            self.assertEqual(obj['fail_counter'], 0, 'The call failed at least once')

    # MORE TESTS GO IN THE 'TESTS' CLASS
    # Example test syntax:
    # def test_<Function Name>(self): None
    def test_dummy(self):
        pass

if __name__ == '__main__':
    unittest.main()

import unittest
import app

class TestApp(unittest.TestCase):
    def setUp(self):
        app.app.testing = True
        self.app = app.app.test_client()

    def test_home(self):
        result = self.app.get('/')
        self.assertEqual(result.status_code, 200)
        self.assertEqual(result.data, b"Hello World!\n")

if __name__ == '__main__':
    unittest.main()
import unittest

from vm.VocabAPI import VocabAPI


class TestVCAPI(unittest.TestCase):

    def setUp(self):
        self.api = VocabAPI()

    def test_login_status(self):
        logged = self.api.is_logged_in
        print("test login status: ", logged)
        assert logged in [False, True]


if __name__ == '__main__':
    unittest.main()

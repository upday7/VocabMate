import unittest
from pprint import pprint

from vm.VocabAPI import VocabLists, EnumWordListCategory


class TestWordList(unittest.TestCase):
    def setUp(self):
        self.api = VocabLists()

    def test_feature_list(self):
        lists = self.api.featured_lists
        assert lists
        pprint(lists)

    def test_get_category_list(self):
        for em in [getattr(EnumWordListCategory, n)
                   for n in EnumWordListCategory.__members__]:
            lists = self.api.get_category_list(em)
            assert lists
            pprint(lists)


if __name__ == '__main__':
    unittest.main()

import json
import unittest
from pathlib import Path

from dataclasses import asdict

from vm.VocabAPI import VocabLists, EnumWordListCategory


class TestWordList(unittest.TestCase):
    def setUp(self):
        self.api = VocabLists()

    def test_feature_list(self):
        featured_list = self.api.featured_lists
        assert featured_list
        r_list = []
        for word_list_dict in featured_list:
            _ = []
            _.extend([asdict(i) for i in word_list_dict['lists']])
            r_list.append({
                'category': word_list_dict['category'],
                'lists': _
            })

        json.dump(r_list, Path("support", "feature_list.json").open("w"), skipkeys=True, indent=True)

    def test_get_category_list(self):
        for em in [getattr(EnumWordListCategory, n)
                   for n in EnumWordListCategory.__members__]:
            lists = self.api.get_category_wordlist(em)
            assert lists

    def test_get_category_list_by_code(self):
        lists = self.api.get_category_wordlist("LIT")
        assert lists


if __name__ == '__main__':
    unittest.main()

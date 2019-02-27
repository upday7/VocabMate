import unittest

from dataclasses import asdict

from vm.VocabAPI import VocabLists, EnumWordListCategory


class TestWordList(unittest.TestCase):
    def setUp(self):
        self.api = VocabLists()

    def _login(self):
        self.assertEqual(self.api.login('VocabMate', 'rvQWzCK5fAerfZX', True), '')

    def test_get_mywordlist(self):
        self._login()
        assert self.api.my_lists_all
        assert self.api.my_lists_created
        assert self.api.my_lists_shared
        assert self.api.my_lists_learning

    def test_get_my_word_list_detail(self):
        self._login()
        my_lists = self.api.my_lists_all
        assert my_lists
        list = my_lists[0]
        assert self.api.get_my_list_detail(list.listId)
        assert self.api.get_my_list_detail(list.listId)

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

        assert r_list

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

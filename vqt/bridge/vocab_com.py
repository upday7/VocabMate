import json
import logging

from PySide2.QtCore import Signal, QJsonValue, Slot, Property as QProperty, QJsonArray
from dataclasses import asdict

from vm.VocabAPI import ChallengeRsp, VocabPractice, VocabLists
from vqt.bridge import BridgeObj


class VCPracticeAPIObj(BridgeObj):
    signingIn = Signal(bool)
    loggedIn = Signal(str)

    started = Signal(QJsonValue)
    loading = Signal(bool)
    newCard = Signal(QJsonValue)
    roundSummary = Signal(QJsonValue)
    answerBingo = Signal(int, QJsonValue)
    simpleDefGot = Signal(str)

    def __init__(self):
        super(VCPracticeAPIObj, self).__init__()
        self.p = VocabPractice()
        self.loading.emit(True)

    @Slot()
    def get_question(self):
        logging.info("Getting Question")
        self.loading.emit(True)

        def cb(res: ChallengeRsp):
            if res.qtype == 'roundSummary':
                prg_data = [
                    {
                        'wrd': asdict(i)['prg'][0]['wrd'],
                        'prg': asdict(i)['prg'][0]["prg"],
                        'def_': asdict(i)['prg'][0]['def_']
                    }
                    for i in res.pdata.round]

                self.roundSummary.emit(QJsonArray.fromVariantList(prg_data))
            else:
                self.newCard.emit(QJsonValue(asdict(res)))

        self.ac(self.p.get_next_question, cb)

    @Slot(int, str)
    def verify_answer(self, idx, nonce):
        logging.info(f'Getting answer for option {idx}, {nonce}')
        self.ac(self.p.verify_answer,
                lambda answer: self.answerBingo.emit(idx, QJsonValue(asdict(answer))),
                nonce, self.p.cur_question.secret)

    @Slot()
    def start(self):
        self.loading.emit(True)
        self.ac(self.p.start, lambda rsp: self.started.emit(QJsonValue(asdict(rsp))), )

    @Slot(str, result=str)
    def get_simple_def(self, word: str):
        self.ac(self.p.get_autocomplete_list,
                lambda auto_complete_items: self.simpleDefGot.emit(auto_complete_items[0].short_def), word)

    @Slot(str, str, result=str)
    def login(self, email: str, pwd: str):
        self.signingIn.emit(True)
        self.ac(self.p.login, self.loggedIn.emit, email, pwd)

    @QProperty(float, )
    def cur_word_leaning_progress(self):
        return self.p.current_word_leaning_progress

    @Slot()
    def clear_cache(self):
        self.p.clear_cache()

    @QProperty(bool, )
    def is_logged_in(self):
        return self.p.is_logged_in


class VCWordListAPIObj(BridgeObj):
    loadingWordList = Signal()
    wordListLoaded = Signal(str)  # json string

    def __init__(self):
        super(VCWordListAPIObj, self).__init__()
        self.p = VocabLists()

    @Slot(str, )
    def get_wordlist_sections(self, category_id: str):
        self.loadingWordList.emit()

        if category_id == "*":
            def _get_featured_lists():
                return json.dumps(self.p.to_dict(self.p.featured_lists), skipkeys=True, )

            self.ac(_get_featured_lists, self.wordListLoaded.emit, )

            return

        def _get_category_data():
            list_data = self.p.get_category_wordlist(category_id)
            return json.dumps(self.p.to_dict([{'category': list_data[0].category, "lists": list_data}]), skipkeys=True)

        self.ac(_get_category_data, self.wordListLoaded.emit, )

    @QProperty(bool)
    def is_logged_in(self):
        return self.p.is_logged_in

    @Slot()
    def clear_cache(self):
        self.p.clear_cache()

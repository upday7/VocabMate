import logging
from collections import Callable
from functools import partial

from PySide2.QtCore import QObject, Signal, QJsonValue, Slot, QThreadPool, QRunnable, Property as QProperty, QJsonArray
from dataclasses import asdict

from vm.VocabAPI import VocabPractice, ChallengeRsp


class _AsyncRunner(QRunnable, QObject):
    done = Signal(object)

    def __init__(self, func: Callable, callback: Callable, *func_args, **func_kwargs):
        QRunnable.__init__(self)
        QObject.__init__(self)
        self.callable = partial(func, *func_args, **func_kwargs)
        self.callback = partial(callback)

    def run(self):
        self.done.connect(self.callback)
        res = self.callable()
        logging.debug(f"AsyncRunner response: {res}")
        self.done.emit(res)
        self.done.disconnect(self.callback)


class VocabComAPIObj(QObject):
    signingIn = Signal(bool)
    loggedIn = Signal(str)

    started = Signal(QJsonValue)
    loading = Signal(bool)
    newCard = Signal(QJsonValue)
    roundSummary = Signal(QJsonValue)
    answerBingo = Signal(int, QJsonValue)
    simpleDefGot = Signal(str)

    def __init__(self):
        super(VocabComAPIObj, self).__init__()
        self.loading.emit(True)
        self.p = VocabPractice()
        self._async_pool = QThreadPool(self)

    def ac(self, func: Callable, callback: Callable, *func_args, **func_kwargs, ):
        """
        Async Call function
        """
        _async = _AsyncRunner(func, callback, *func_args, **func_kwargs)
        self._async_pool.globalInstance().start(_async)

    @Slot()
    def get_question(self):
        logging.info("Getting Question")
        self.loading.emit(True)

        def cb(res: ChallengeRsp):
            if res.pdata.round.__len__() == 10:
                self.roundSummary.emit(QJsonArray.fromVariantList(
                    [asdict(i)['prg'][0] for i in res.pdata.round]
                ))
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

    def _get_cur_word_leaning_progress(self):
        return self.p.current_word_leaning_progress

    cur_word_leaning_progress = QProperty(float, _get_cur_word_leaning_progress, )

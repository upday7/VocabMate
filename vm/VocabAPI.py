import base64
import logging
import re
import tempfile
from enum import Enum
from pathlib import Path
from time import sleep
from typing import List, Union

from PySide2.QtCore import QUrl
from box import Box
from bs4 import BeautifulSoup
from dataclasses import asdict
from dataclasses import dataclass
from diskcache import Cache
from requests import Session


# region dataclasses


class EnumLearningPriority(Enum):
    Auto = 0
    High = 1
    Low = -1


@dataclass
class _ChallengeAuth:
    loggedin: bool = False
    uid: str = ''
    nickname: str = ''
    fullname: str = ''
    email: str = ''
    role: Union[None, str] = None


@dataclass
class _ChallengeLevel:
    id: str
    name: str


@dataclass
class _ChallengePrg:
    wrd: str
    cp: int
    cc: int
    ci: int
    dfp: str  # "2019-01-28T16:02:09.436Z",
    dlp: str  # "2019-01-28T16:02:09.436Z",
    prg: float
    pri: 0
    kv: float
    lrn: bool
    dif: float
    pos: str
    def_: str
    aud: List[str]


@dataclass
class _ChallengeRound1:
    cor: bool
    hnt: bool
    bns: int
    pts: int
    tps: int
    prg: List[_ChallengePrg]


@dataclass
class _ChallengeRound2:
    number: int
    streak: int
    played_count: int


@dataclass
class _ChallengePData:
    points: int
    level: _ChallengeLevel
    numplayed: int
    nummastered: int
    a: int
    round: List[_ChallengeRound1] = ()


@dataclass
class _Question:
    turn: int
    type: str  # ["H","P","S"]
    hints: List
    code: str  # base64
    qtype: str


@dataclass
class _WordSense:
    id: int
    part_of_speech: str
    audio: str
    definition: str
    ordinal: str  # "1.01.01.01"
    pos: str = ''


@dataclass
class _AnswerBlurb:
    short: str
    long: str


@dataclass
class _WordProgress:
    progress: float
    played_at: str
    scheduled_at: str
    play_count: int
    correct_count: int
    incorrect_count: int
    value: float
    priority: int


@dataclass
class _QuestionOption:
    option: str
    nonce: str


@dataclass
class _QuestionContent:
    sentence: str
    instructions: str
    choices: List[_QuestionOption]
    status: str
    def_: str


@dataclass
class ChallengeRsp:
    __module__ = None
    v: int
    hints: List
    code: str
    question_content: Union[_QuestionContent, None]
    # S: simple - XXX means
    # L: In this sentence XXX means
    # I: Choose picture for XXX
    # H: In this sentence XXX means
    # P:
    qtype: str
    cmd: str
    pdata: _ChallengePData
    auth: _ChallengeAuth
    secret: str
    valid: bool


@dataclass
class HintRsp:
    pos: str
    def_: str
    pdata: _ChallengePData
    secret: str


@dataclass
class SaveAnswerRspV2:  # V = ChallengeRsp.v value
    turn: int
    question_mode: str  # "i"
    question_type: str
    word: str
    sense: _WordSense
    correct_choice: int
    user_choice: int
    progress: _WordProgress
    points: int
    bonus: int
    streak: int
    round_streak: int
    round_turn: int
    response_time: int
    session_time: int
    played_at: str
    correct: bool
    hints: bool
    blurb: _AnswerBlurb
    round: _ChallengeRound2
    pdata: _ChallengePData
    secret: str
    accepted_answers: List[str] = ('',)
    sentence_html: str = ""


@dataclass
class WordProgressRsp:
    word: str
    sense: _WordSense
    pkv: Union[int, None]
    progress: Union[_WordProgress, None]
    learnable: bool


@dataclass
class MeRsp:
    validUser: bool
    guid: str
    auth: _ChallengeAuth
    perms: dict
    points: int
    level: _ChallengeLevel
    ima: str
    paid: bool


@dataclass
class WordDefSense:
    pos_short: str
    pos_long: str
    def_: str
    example: str = ''


@dataclass
class WordDef:
    word: str
    audio: str
    blurb: _AnswerBlurb
    def_groups: List[List[WordDefSense]]


@dataclass
class AutoCompleteItem:
    word: str
    short_def: str
    freq: float


# endregion


class VocabAPI:
    BASE_URL = "https://www.vocabulary.com"
    API_BASE_URL = 'https://api.vocab.com/1.0'
    PLAY_URL = BASE_URL + "/play"
    START_URL = BASE_URL + "/challenge/start.json"
    NEXT_URL = BASE_URL + "/challenge/nextquestion.json"
    HINT_URL = BASE_URL + "/challenge/hint.json"
    SAVE_ANSWER_URL = BASE_URL + "/challenge/saveanswer.json"
    ME_URL = BASE_URL + "/auth/me.json"
    LOGIN_URL = BASE_URL + "/login/"
    SET_PRIORITY_URL = BASE_URL + "/progress/setpriority.json"
    AUTO_COMPLETE_URL = BASE_URL + "/dictionary/autocomplete?search="

    APL_WORD_PROGRESS_URL = API_BASE_URL + "/progress/words"
    API_AUTH_TOKEN_URL = API_BASE_URL + "/auth/token"

    answer_list = [0]  # todo: just for test, delete it after test

    def __init__(self):
        super(VocabAPI, self).__init__()
        self._access_token = ''
        self._me_info = None  # type: MeRsp

        self.s = Session()
        self.cache_dir = Path(tempfile.gettempdir(), '_vocab_tmp')
        self.cache = Cache(self.cache_dir)
        self.s.headers.update(
            {
                "authority": "www.vocabulary.com",
                "accept": "application/json, text/javascript, */*; q=0.01",
                "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) "
                              "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36",
                "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
                "accept-encoding": "gzip, deflate, br",
                "accept-language": "zh-CN,zh;q=0.9",
                "origin": self.BASE_URL,
                "referer": self.BASE_URL,
            }
        )

        self.s.headers.update({
            'authorization': f'Bearer {self.access_token}'
        })

    def login(self, user_name, password) -> str:

        # login procedure
        login_data = {
            'username': user_name,
            'password': password,
            '.cb-autoLogon': '1'
        }
        login_rqs = self.s.post(self.LOGIN_URL, data=login_data)
        login_rqs.raise_for_status()  # todo: solve the http request err

        if login_rqs.status_code != 200:
            raise NotImplementedError
        login_bs = BeautifulSoup(login_rqs.content.decode(), features='lxml')  # .errors
        error_tag = login_bs.find(class_='errors')
        if error_tag:
            error_msg = error_tag.find(class_='msg').text
            return error_msg
        return ''

    @property
    def access_token(self):
        if not self._access_token:
            rsp = self.s.post(self.API_AUTH_TOKEN_URL)
            self._access_token = Box.from_json(json_string=rsp.content.decode()).access_token
        return self._access_token

    def get_autocomplete_list(self, word: str) -> List[AutoCompleteItem]:
        rsp = self.s.get(self.AUTO_COMPLETE_URL + word)
        if rsp.status_code != 200:
            raise NotImplementedError  # todo
        rsp_bs = BeautifulSoup(rsp.content.decode(), features='lxml')
        r_list = []
        for li in rsp_bs.select("li"):
            freq = li.get('freq', 0)
            if freq == '∞':
                freq = 0
            auto_item = AutoCompleteItem(word=li['word'], short_def=str(li.select(".definition")[0].string),
                                         freq=float(freq))
            r_list.append(auto_item)
        return r_list

    def get_word_progress(self, word: str) -> WordProgressRsp:
        try:
            rsp = self.s.get(self.APL_WORD_PROGRESS_URL + f"/{word}")
        except ConnectionError as exc:
            try_count = 10
            while try_count:
                try:
                    rsp = self.s.get(self.APL_WORD_PROGRESS_URL + f"/{word}")
                    break
                except:
                    pass
                try_count -= 1
                sleep(1)

        word_prg_box = Box.from_json(json_string=rsp.content.decode())
        progress = None
        if word_prg_box.get('progress'):
            progress = _WordProgress(
                progress=word_prg_box.progress.progress,
                played_at=word_prg_box.progress.played_at,
                scheduled_at=word_prg_box.progress.scheduled_at,
                play_count=word_prg_box.progress.play_count,
                correct_count=word_prg_box.progress.correct_count,
                incorrect_count=word_prg_box.progress.incorrect_count,
                value=word_prg_box.progress.value,
                priority=word_prg_box.progress.priority
            )
        return WordProgressRsp(
            word=word_prg_box.word,
            sense=_WordSense(id=word_prg_box.sense.id,
                             part_of_speech=word_prg_box.sense.part_of_speech,
                             audio=self.get_first_audio_url(word_prg_box.sense),
                             definition=word_prg_box.sense.definition,
                             ordinal=word_prg_box.sense.ordinal),
            progress=progress,
            pkv=word_prg_box.get('pkv', None),
            learnable=word_prg_box.learnable
        )

    def set_word_priority(self, word: str, priority: EnumLearningPriority) -> bool:
        rsp = self.s.post(self.SET_PRIORITY_URL, {'word': word, "priority": priority.value})
        return rsp.status_code == 200

    @staticmethod
    def get_first_audio_url(sense: Box) -> str:
        if sense.audio:
            return f"https://audio.vocab.com/1.0/us/{sense.audio[0]}.mp3"
        return ''

    @property
    def meInfo(self) -> MeRsp:
        if not self._me_info:
            rsp = self.s.get(self.ME_URL)
            rsp.raise_for_status()  # todo: solve select answer rqs http err
            if rsp.status_code != 200:
                raise NotImplementedError  # todo
            rsp_box = Box.from_json(json_string=rsp.content.decode())
            if rsp_box.auth.loggedin:
                self._me_info = MeRsp(
                    validUser=rsp_box.validUser,
                    guid=rsp_box.guid,
                    auth=_ChallengeAuth(
                        loggedin=rsp_box.auth.loggedin,
                        uid=rsp_box.auth.uid,
                        nickname=rsp_box.auth.nickname,
                        fullname=rsp_box.auth.fullname,
                        email=rsp_box.auth.email
                    ),
                    perms=dict(rsp_box.perms),
                    points=rsp_box.points,
                    level=_ChallengeLevel(id=rsp_box.level.id, name=rsp_box.level.name),
                    ima=rsp_box.ima, paid=rsp_box.paid
                )
            else:
                self._me_info = _ChallengeAuth(loggedin=False)
        return self._me_info

    def get_word_def(self, word: str) -> WordDef:
        cache_key = f"word_def: {word}"
        if not self.cache.get(cache_key):
            def_url = self.BASE_URL + f"/dictionary/{word}"
            rsp = self.s.get(def_url)
            if rsp.status_code != 200:
                raise not NotImplementedError
            rsp_bs = BeautifulSoup(rsp.content.decode(), features='lxml')
            # get response word
            word_ = ''
            word_tag = rsp_bs.find(class_='dynamictext')
            if word_tag:
                word_ = word_tag.contents[0].__str__()

            # get audio url
            audio_tag = rsp_bs.find(class_='audio')
            if audio_tag:
                audio_url = self.get_first_audio_url(Box(audio=[audio_tag['data-audio'], ]))
            else:
                audio_url = ''

            # get word short/long blurb
            blurb_tag = rsp_bs.find(class_='blurb')
            if blurb_tag:
                short_tag = blurb_tag.find('p', class_='short')
                long_tag = blurb_tag.find('p', class_='long')
                short_blurb_txt = "".join([i.__str__() for i in short_tag.contents])
                long_blurb_txt = "".join([i.__str__() for i in long_tag.contents])
            else:
                short_blurb_txt, long_blurb_txt = '', ''

            def_groups = []
            for group_tag in rsp_bs.select(".group"):
                ordinals = []
                for ordinal_tag in group_tag.select(".ordinal"):
                    senses = []
                    for sense_tag in ordinal_tag.select(".sense"):
                        def_example = ''
                        def_content_tag = sense_tag.find(class_='defContent')
                        if def_content_tag:
                            def_example_tag = sense_tag.find(class_='example')
                            if def_example_tag:
                                def_example = " ".join([re.sub(r"\s+", " ", str(i)) for i in def_example_tag.contents])
                        def_tag = ordinal_tag.find(class_="definition")
                        pos_full = def_tag.a['title']
                        pos_short = def_tag.contents[1].text.strip()
                        def_txt = def_tag.contents[2].strip()
                        senses.append(
                            WordDefSense(pos_short=pos_short, pos_long=pos_full, def_=def_txt, example=def_example))
                    ordinals.append(senses)
                def_groups.append(ordinals)
            self.cache.set(cache_key,
                           WordDef(word_, audio_url, _AnswerBlurb(short_blurb_txt, long_blurb_txt), def_groups))
        return self.cache.get(cache_key)


class VocabPractice(VocabAPI):
    def __init__(self):
        super(VocabPractice, self).__init__()
        self._start_json = None  # type: ChallengeRsp
        self._secret = ''
        self._answer = None  # type: SaveAnswerRspV2
        self._question = None  # type: ChallengeRsp

    def _reset_temp_values(self):
        # self._clg_json = None  # type: ChallengeRsp
        self._answer = None  # type: SaveAnswerRspV2
        self._question = None  # type: ChallengeRsp

    def download_img(self, url: str) -> Path:
        if not self.cache.get(Path(url).stem):
            local_file = Path(self.cache.directory, Path(url).name)
            rsp = self.s.get(url, stream=True)
            local_file.write_bytes(rsp.content)
            self.cache.set(Path(url).stem, local_file)
        return self.cache.get(Path(url).stem)

    def _compose_challenge_rsp(self, rsp_box: Box) -> ChallengeRsp:
        # roundSummary
        rounds = []
        for round_box in rsp_box.pdata.round:
            prgs = []
            for prg_box in round_box.prg:
                prgs.append(
                    _ChallengePrg(
                        wrd=prg_box.wrd,
                        cp=prg_box.cp,
                        cc=prg_box.cc,
                        ci=prg_box.ci,
                        dfp=prg_box.dfp,
                        dlp=prg_box.dlp,
                        prg=prg_box.prg,
                        pri=prg_box.pri,
                        kv=prg_box.kv,
                        lrn=prg_box.lrn,
                        dif=prg_box.dif,
                        pos=prg_box.pos,
                        def_=getattr(prg_box, "def", ''),
                        aud=prg_box.aud
                    )
                )
            rounds.append(_ChallengeRound1(
                cor=round_box.cor,
                hnt=round_box.hnt,
                bns=round_box.bns,
                pts=round_box.pts,
                tps=round_box.tps,
                prg=prgs
            ))

        # rsp_box.code
        content_bs = BeautifulSoup(base64.decodebytes(rsp_box.code.encode()), features='lxml')
        rm_dup_spaces = lambda s: re.sub(r"\s+", " ", s).strip()
        sentence_tag = content_bs.find(attrs={'class': 'sentence'})
        instructions_tag = content_bs.find(attrs={'class': 'instructions'})

        choices_tag = content_bs.find(attrs={'class': 'choices'})
        status_tag = content_bs.find(attrs={'class': 'status'})
        def_tag = content_bs.find(attrs={'class': 'def'})
        sentence = rm_dup_spaces(" ".join([str(s) for s in sentence_tag.contents])) if sentence_tag else ''
        status = rm_dup_spaces(status_tag.text) if status_tag else ''
        def_ = rm_dup_spaces(def_tag.text) if def_tag else ''
        instructions = rm_dup_spaces(" ".join([str(s) for s in instructions_tag.contents])) if instructions_tag else ''

        if rsp_box.qtype != 'roundSummary':
            try:
                if instructions_tag.find("strong"):
                    word = instructions_tag.find("strong").text
                    instructions = instructions.replace(word, f"<b>{word}</b>")
            except AttributeError:
                print("TODO")  # todo when meet round == 9

            if rsp_box.qtype == 'I':
                word_tag = content_bs.find(attrs={'class': 'word'})  # consists of instructions tag and last word text
                instructions = instructions + f"<br><b style='color: orange'>" \
                    f"{rm_dup_spaces(word_tag.text.replace(instructions, ' '))}</b>"
            else:
                if instructions:
                    body_tag = BeautifulSoup(instructions, features='lxml').body
                    opposite_tag = body_tag.find(class_='opposite')
                    if opposite_tag:
                        opposite_tag['style'] = 'color: orange;font-weight: bold'
                    for content in body_tag.find_all("strong") + body_tag.find_all("b"):
                        content.attrs['style'] = 'color: black'
                    else:
                        instructions = "".join([str(s) for s in body_tag.contents]).replace("<p>", '').replace("</p>",
                                                                                                               '')
                if sentence:
                    body_tag = BeautifulSoup(sentence, features='lxml').body
                    for content in body_tag.find_all("strong") + body_tag.find_all("b"):
                        content.attrs['style'] = 'color: black'
                    else:
                        sentence = "".join([str(s) for s in body_tag.contents]).replace("<p>", '').replace("</p>", '')
            if rsp_box.qtype == 'T':
                choices = []
            else:
                choices = [_QuestionOption(
                    rm_dup_spaces(a.text) if rsp_box.qtype != "I"
                    else QUrl.fromLocalFile(
                        self.download_img(re.search(r"https.+\.jpg", a.__str__()).group(0)).__str__()),
                    a.attrs['nonce']) for a in choices_tag.find_all('a')]

            content = _QuestionContent(
                sentence=sentence,
                instructions=instructions,
                choices=choices,
                status=status,
                def_=def_
            )
        else:
            content = None
        return ChallengeRsp(
            v=rsp_box.v,
            hints=list(rsp_box.get('hints', [])),
            code=rsp_box.code,
            question_content=content,
            qtype=rsp_box.qtype,
            cmd=rsp_box.cmd,
            pdata=_ChallengePData(
                points=rsp_box.pdata.points,
                level=_ChallengeLevel(rsp_box.pdata.level.id, rsp_box.pdata.level.name, ),
                numplayed=rsp_box.pdata.numplayed,
                nummastered=rsp_box.pdata.nummastered,
                a=rsp_box.pdata.a,
                round=rounds
            ),
            auth=_ChallengeAuth(loggedin=rsp_box.auth.loggedin),
            secret=rsp_box.secret,
            valid=rsp_box.valid,
        )

    def _compose_answer_rsp(self, rsp_box: Box) -> SaveAnswerRspV2:

        return SaveAnswerRspV2(
            turn=rsp_box.answer.turn,
            question_mode=rsp_box.answer.question_mode,
            question_type=rsp_box.answer.question_type,
            word=rsp_box.answer.word,
            sense=_WordSense(id=rsp_box.answer.sense.id, pos=rsp_box.answer.sense.pos,
                             part_of_speech=rsp_box.answer.sense.part_of_speech,
                             audio=self.get_first_audio_url(rsp_box.answer.sense),
                             definition=rsp_box.answer.sense.definition,
                             ordinal=rsp_box.answer.sense.ordinal),
            correct_choice=rsp_box.answer.get('correct_choice', -1),
            user_choice=rsp_box.answer.get("user_choice", -1),
            progress=_WordProgress(
                progress=rsp_box.answer.progress.progress,
                played_at=rsp_box.answer.progress.played_at,
                scheduled_at=rsp_box.answer.progress.scheduled_at,
                play_count=rsp_box.answer.progress.play_count,
                correct_count=rsp_box.answer.progress.correct_count,
                incorrect_count=rsp_box.answer.progress.incorrect_count,
                value=rsp_box.answer.progress.value,
                priority=rsp_box.answer.progress.priority
            ),  # todo: complement _AnswerProgress

            points=rsp_box.answer.points,
            bonus=rsp_box.answer.bonus,
            streak=rsp_box.answer.streak,
            round_streak=rsp_box.answer.round_streak,
            round_turn=rsp_box.answer.round_turn,
            response_time=rsp_box.answer.response_time,
            session_time=rsp_box.answer.session_time,
            played_at=rsp_box.answer.played_at,
            correct=rsp_box.answer.correct,
            hints=rsp_box.answer.hints,  # bool
            blurb=_AnswerBlurb(rsp_box.answer.blurb.short, rsp_box.answer.blurb.long),  # html format
            round=_ChallengeRound2(
                number=rsp_box.round.number,
                streak=rsp_box.round.streak,
                played_count=rsp_box.round.played_count
            ),
            pdata=_ChallengePData(
                points=rsp_box.pdata.points,
                level=_ChallengeLevel(rsp_box.pdata.level.id, rsp_box.pdata.level.name, ),
                numplayed=rsp_box.pdata.numplayed,
                nummastered=rsp_box.pdata.nummastered,
                a=rsp_box.pdata.a,
            ),
            accepted_answers=rsp_box.answer.get('accepted_answers', []),
            sentence_html=rsp_box.answer.get("sentence_html", ""),
            secret=rsp_box.secret
        )

    def get_next_question(self) -> ChallengeRsp:
        if self._start_json.cmd == 'newround' and self._question is not self._start_json:
            self._question = self._start_json
        else:
            self._reset_temp_values()
            rsp = self.s.post(self.NEXT_URL, data=dict(v=0, secret=self.secret))
            rsp.raise_for_status()  # todo: check next question http request
            if rsp.status_code != 200:
                raise NotImplementedError  # todo
            rsp_box = Box.from_json(json_string=rsp.content.decode())
            if rsp_box.qtype == 'roundSummary':
                print(rsp_box.qtype)
            if rsp_box.qtype == 'interstitial':
                logging.warning('rsp_box.qtype == interstitial, restarting ')
                return self.get_next_question()
            self._question = self._compose_challenge_rsp(rsp_box)
        return self._question

    @property
    def secret(self) -> str:
        if not self._secret:
            self._secret = self.start().secret
        return self._secret

    @property
    def cur_question(self) -> ChallengeRsp:
        if not self._question:
            self._question = self.get_next_question()
        return self._question

    @property
    def cur_answer(self) -> SaveAnswerRspV2:
        if not self._answer:
            raise Exception("Use function verify_answer first before calling this property")
        return self._answer

    @property
    def current_word_leaning_progress(self) -> float:
        if self.leaning_progress:
            prg_val = self.leaning_progress[-1][0].progress.progress
            return round(prg_val if prg_val else 0, 2)
        return 0

    @property
    def leaning_progress(self) -> list:
        return self.cache.get('leaning_progresses', [])

    def reset_leaning_progress(self):
        self.cache.set('leaning_progresses', [])

    def add_leaning_progress(self, answer: SaveAnswerRspV2):
        progresses = self.leaning_progress
        progresses.append([answer, self.get_word_progress(answer.word)])
        self.cache.set('leaning_progresses', progresses)

    def start(self) -> ChallengeRsp:
        logging.info(f"Starting vocabulary.com", )
        rsp = self.s.get(self.START_URL, )
        rsp.raise_for_status()  # todo: check next question http request
        if rsp.status_code != 200:
            raise NotImplementedError  # todo
        rsp_box = Box.from_json(json_string=rsp.content.decode())
        if 'action' in rsp_box.keys():
            logging.info(f"'action' in response data: {rsp_box.action}")
            if rsp_box.action != 'resume':
                self.reset_leaning_progress()
            return self.start()
        else:
            if rsp_box.qtype == 'interstitial':
                logging.warning('rsp_box.qtype == interstitial, restarting ')
                return self.start()
            self._start_json = self._compose_challenge_rsp(rsp_box)
            if self._start_json.cmd == 'newround':
                self.reset_leaning_progress()
        logging.info(f"Start response got: {asdict(self._start_json)}")
        return self._start_json

    def verify_answer(self, nonce: str, secret: str) -> SaveAnswerRspV2:

        if not self._answer:
            answer_data = {'a': nonce, 'secret': secret, 'v': 2}
            rqs = self.s.post(self.SAVE_ANSWER_URL, data=answer_data, verify=True)
            rqs.raise_for_status()  # todo: solve select answer rqs http err
            # todo: implement answer process
            if rqs.status_code != 200:
                raise NotImplementedError  # todo
            rsp_box = Box.from_json(json_string=rqs.content.decode())
            self._answer = self._compose_answer_rsp(rsp_box)
            if self._answer.round.played_count == 10:
                self.reset_leaning_progress()
            self.add_leaning_progress(answer=self._answer)

        return self.cur_answer

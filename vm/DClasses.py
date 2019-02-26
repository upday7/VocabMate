from datetime import datetime
from enum import Enum
from typing import List, Union

from dataclasses import dataclass


# region Dataclasses


@dataclass
class ChallengeAuth:
    loggedin: bool = False
    uid: str = ''
    nickname: str = ''
    fullname: str = ''
    email: str = ''
    role: Union[None, str] = None


@dataclass
class ChallengeLevel:
    id: str
    name: str


@dataclass
class ChallengePrg:
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
class ChallengeRound1:
    cor: bool
    hnt: bool
    bns: int
    pts: int
    tps: int
    prg: List[ChallengePrg]


@dataclass
class ChallengeRound2:
    number: int
    streak: int
    played_count: int


@dataclass
class UserWordlistLeaningProgress:
    active: bool
    progress: float
    mastered_word_count: int


@dataclass
class UserWordlistDetail:
    starred: bool
    word_count: int
    learnable_word_count: int
    learning_progress: UserWordlistLeaningProgress


@dataclass
class UserWordlist:
    listId: int
    wordcount: int
    name: str
    created: datetime.date


@dataclass
class ChallengeWordList(UserWordlist):
    current: bool
    priority: int
    progress: float
    listId: int
    wordcount: int
    name: str


@dataclass
class ChallengePData:
    points: int
    level: ChallengeLevel
    numplayed: int
    nummastered: int
    a: int
    round: List[ChallengeRound1] = ()
    lists: List[ChallengeWordList] = ()


@dataclass
class Question:
    turn: int
    type: str  # ["H","P","S"]
    hints: List
    code: str  # base64
    qtype: str


@dataclass
class WordSense:
    id: int
    part_of_speech: str
    audio: str
    definition: str
    ordinal: str  # "1.01.01.01"
    pos: str = ''


@dataclass
class AnswerBlurb:
    short: str
    long: str


@dataclass
class WordProgress:
    progress: float
    played_at: str
    scheduled_at: str
    play_count: int
    correct_count: int
    incorrect_count: int
    value: float
    priority: int


@dataclass
class QuestionOption:
    option: str
    nonce: str


@dataclass
class QuestionContent:
    sentence: str
    instructions: str
    choices: List[QuestionOption]
    status: str
    def_: str


@dataclass
class ChallengeRsp:
    __module__ = None
    v: int
    hints: List
    code: str
    question_content: Union[QuestionContent, None]
    # S: simple - XXX means
    # L: In this sentence XXX means
    # I: Choose picture for XXX
    # H: In this sentence XXX means
    # P:
    qtype: str
    cmd: str
    pdata: ChallengePData
    auth: ChallengeAuth
    secret: str
    valid: bool


@dataclass
class HintRsp:
    pos: str
    def_: str
    pdata: ChallengePData
    secret: str


@dataclass
class SaveAnswerRspV2:  # V = ChallengeRsp.v value
    turn: int
    question_mode: str  # "i"
    question_type: str
    word: str
    sense: WordSense
    correct_choice: int
    user_choice: int
    progress: WordProgress
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
    blurb: AnswerBlurb
    round: ChallengeRound2
    pdata: ChallengePData
    secret: str
    accepted_answers: List[str] = ('',)
    sentence_html: str = ""


@dataclass
class WordProgressRsp:
    word: str
    sense: WordSense
    pkv: Union[int, None]
    progress: Union[WordProgress, None]
    learnable: bool


@dataclass
class MeRsp:
    validUser: bool
    guid: str
    auth: ChallengeAuth
    perms: dict
    points: int
    level: ChallengeLevel
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
    blurb: AnswerBlurb
    def_groups: List[List[WordDefSense]]


@dataclass
class AutoCompleteItem:
    word: str
    short_def: str
    freq: float


@dataclass
class WordList:
    category: str
    name: str
    description: str
    url: str
    total_words: str
    id_: int


# endregion

# region Enums


class EnumLearningPriority(Enum):
    Auto = 0
    High = 1
    Low = -1


class EnumWordListCategory(Enum):
    Literature = "LIT", "Literature"
    JustForFun = "FUN", 'Just for Fun'
    PreTest = "TST", "Test Prep"
    MorphologyNRoots = "ROOTS", "Morphology & Roots"
    NonFiction = "NON", 'Non-Fiction'
    HistoricalDoc = "HIS", "Historical Documents"
    Speeches = "SPH", "Speeches"
    News = "NWS", 'News'

# endregion

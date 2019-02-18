import logging
import sys

DEBUG = False
BETA = True
VERSION = "0.1.1"
APP_NAME_SHORT = 'VocabMate'
APP_NAME_VERBOSE = 'Vocabulary Mate'
_stdout_handler = logging.StreamHandler(sys.stdout)
if DEBUG:
    _file_handler = logging.FileHandler(filename='logging.log')
    LOGGING_HANDLERS = [_file_handler, _stdout_handler]
else:
    LOGGING_HANDLERS = [_stdout_handler, ]

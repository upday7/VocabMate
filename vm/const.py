import logging
import os
import sys
import tempfile
from pathlib import Path

from PySide2 import __version__
from PySide2.QtCore import qVersion
from shiboken2 import __version__ as _shiboken_ver

# application settings
BETA = True
VERSION = "0.1.55"
APP_NAME_SHORT = 'VocabMate'
APP_NAME_VERBOSE = 'Vocabulary Mate'
_stdout_handler = logging.StreamHandler(sys.stdout)
if os.environ.get('DEBUG'):
    _file_handler = logging.FileHandler(filename='logging.log')
    LOGGING_HANDLERS = [_file_handler, _stdout_handler]
else:
    LOGGING_HANDLERS = [_stdout_handler, ]
# Qt versions
PYSIDE_VERSION = __version__
QT_VERSION = qVersion()
SHIBOKEN_VERSION = _shiboken_ver
# project repository
PROJECT_URL = "https://github.com/upday7/VocabMate"
PROJECT_ISSUE_URL = PROJECT_URL + "/issues"

# variables
CACHE_DIR = Path(tempfile.gettempdir(), '_vocab_tmp')
SESSION_CACHE_DIR = Path(tempfile.gettempdir(), '_vocab_tmp', 'secret')
TEST_CACHE_DIR = Path(tempfile.gettempdir(), '_vocab_tmp', 'secret')

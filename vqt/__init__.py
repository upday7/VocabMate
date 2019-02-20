import logging
import sys
# noinspection PyUnresolvedReferences
from urllib.request import getproxies, proxy_bypass

from PySide2.QtGui import QIcon, QWindow
from PySide2.QtQml import QQmlApplicationEngine, qmlRegisterType
from PySide2.QtWidgets import QApplication

from vm.const import VERSION, LOGGING_HANDLERS, BETA, APP_NAME_VERBOSE
from vqt.bridge.vocab_com import VocabComAPIObj


class VMApplication(QApplication):
    def __init__(self, *args):
        super(VMApplication, self).__init__(*args)

        self.engine = None
        self.error_handler = None

        self.setup_error_handler()
        self.setup_logging()
        self.register_types()
        self.setup_engine()
        self.set_root_obj_attributes()

        self.setApplicationName(APP_NAME_VERBOSE)
        self.setWindowIcon(QIcon("qml/res/img/icon.png"))
        logging.info("Stating Vocab Mate")

    def setup_error_handler(self):
        from vqt.error import ErrorHandler
        self.error_handler = ErrorHandler()
        ...

    @staticmethod
    def setup_logging():
        logging.basicConfig(level=logging.DEBUG,
                            format='[%(asctime)s] {%(filename)s:%(lineno)d} %(levelname)s - %(message)s',
                            handlers=LOGGING_HANDLERS)

    @staticmethod
    def register_types():
        qmlRegisterType(VocabComAPIObj, 'pyAPIBridge', 1, 0, 'VocabComAPIObj')

    def setup_engine(self):
        self.engine = QQmlApplicationEngine(self)
        self.engine.load('qml/main.qml', )

    def set_root_obj_attributes(self):
        self.root_win.setTitle(f"{self.root_win.title()} {VERSION} {'Beta' if BETA else ''}")

    @property
    def root_win(self) -> QWindow:
        return self.engine.rootObjects()[0]

    def show_win(self):
        self.root_win.show()


def run():
    app = VMApplication(sys.argv)
    app.show_win()
    sys.exit(app.exec_())

import logging
import sys
# noinspection PyUnresolvedReferences
from pathlib import Path

from PySide2.QtCore import Qt
from PySide2.QtGui import QIcon, QWindow, QFontDatabase, QFont
from PySide2.QtQml import QQmlApplicationEngine, qmlRegisterType
from PySide2.QtWidgets import QApplication

from vm.const import VERSION, LOGGING_HANDLERS, BETA, APP_NAME_VERBOSE
from vqt.bridge.vocab_com import VCPracticeAPIObj, VCWordListAPIObj


class VMApplication(QApplication):
    def __init__(self, *args):
        self.setup_qgui_attrs()
        super(VMApplication, self).__init__(*args)
        self.setup_logging()
        self.engine = None
        self.error_handler = None

        self.setup_error_handler()
        self.register_types()
        self.setup_engine()
        self.set_root_obj_attributes()

        self.setApplicationName(APP_NAME_VERBOSE)
        self.setWindowIcon(QIcon("qml/res/img/icon.png"))
        self.load_fonts()
        logging.info("Stating Vocab Mate")

    def setup_qgui_attrs(self):
        QApplication.setAttribute(Qt.AA_EnableHighDpiScaling)
        self.setFont(QFont("Open Sans"))

    @staticmethod
    def load_fonts():
        list(map(QFontDatabase.addApplicationFont,
                 [f.absolute().__str__() for f in Path('qml/res/fonts').glob("*") if f.suffix in ('.woff', '.ttf')]))

    def setup_error_handler(self):
        from vqt.error import ErrorHandler
        self.error_handler = ErrorHandler()

    @staticmethod
    def setup_logging():
        if sys.platform == 'win32':
            return
        logging.basicConfig(level=logging.DEBUG,
                            format='[%(asctime)s] {%(filename)s:%(lineno)d} %(levelname)s - %(message)s',
                            handlers=LOGGING_HANDLERS)

    @staticmethod
    def register_types():
        qmlRegisterType(VCPracticeAPIObj, 'pyAPIBridge', 1, 0, 'VCPracticeAPI')
        qmlRegisterType(VCWordListAPIObj, 'pyAPIBridge', 1, 0, 'VCWordListAPI')

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

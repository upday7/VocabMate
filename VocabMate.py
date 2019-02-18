import logging
import sys

# noinspection PyUnresolvedReferences
import PySide2.QtQuick
from PySide2.QtGui import QGuiApplication, QIcon, QWindow
from PySide2.QtQml import QQmlApplicationEngine, qmlRegisterType

from vm.const import VERSION, LOGGING_HANDLERS, BETA
from vqt.bridge.vocab_com import VocabComAPIObj

logging.basicConfig(level=logging.DEBUG, format='[%(asctime)s] {%(filename)s:%(lineno)d} %(levelname)s - %(message)s',
                    handlers=LOGGING_HANDLERS)


def run():
    logging.info("Stating Vocab Mate")
    app = QGuiApplication(sys.argv)
    logging.info(f"Application directory: {app.applicationDirPath()}")
    logging.info(f"QtGuiApplication Library Paths: {app.libraryPaths()}")

    # QGuiApplication.setAttribute(Qt.AA_EnableHighDpiScaling)
    app.setApplicationName("Vocabulary Mate")
    app.setWindowIcon(QIcon("qml/res/img/icon.png"))

    qmlRegisterType(VocabComAPIObj, 'pyAPIBridge', 1, 0, 'VocabComAPIObj')

    engine = QQmlApplicationEngine(app)
    engine.load('qml/main.qml', )

    win = engine.rootObjects()[0]  # type: QWindow
    win.setTitle(f"{win.title()} {VERSION} {'Beta' if BETA else ''}")
    win.show()
    sys.exit(app.exec_())


if __name__ == '__main__':
    run()

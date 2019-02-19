import html
import os
import sys
import traceback

from PySide2.QtCore import QObject, Signal, Slot

from vm.const import QT_VERSION, SHIBOKEN_VERSION, APP_NAME_SHORT, VERSION
from vqt.utils import show_text

if not os.environ.get("DEBUG"):
    def excepthook(etype, val, tb):
        sys.stderr.write("Caught exception:\n%s%s\n" % (
            ''.join(traceback.format_tb(tb)),
            '{0}: {1}'.format(etype, val)))


    sys.excepthook = excepthook


class ErrorHandler(QObject):
    error_received = Signal(str)

    def __init__(self, parent=None):
        super(ErrorHandler, self).__init__(parent)
        self.mw = parent
        self.timer = None
        self._oldstderr = sys.stderr
        self.error_received.connect(self.on_error_received)
        sys.stderr = self

    def unload(self):
        sys.stderr = self._oldstderr
        sys.excepthook = None

    def write(self, data):
        # dump to stdout
        sys.stdout.write(data)
        # and update timer
        self.error_received.emit(data)

    @Slot(str)
    def on_error_received(self, err_msg: str):
        error = html.escape(err_msg)
        txt = 'An error occurred, please report this error to maintainer:'
        # show dialog
        txt = txt + "<br><div style='white-space: pre-wrap'>" + error + "</div>" + f"<p>{self.support_msg}</p>"
        show_text(txt, parent=self.mw, send_issue=True)

    @property
    def support_msg(self) -> str:
        msg = f"--------------------<br>" \
            f"{APP_NAME_SHORT} ({VERSION})<br>" \
            f"Qt: {QT_VERSION}, PySide: {SHIBOKEN_VERSION}, Shiboken2: {SHIBOKEN_VERSION}<br>" \
            f"Platform: {sys.platform}" \
            f"<br>Environ:<br> {';'.join(k + '=' + v for k, v in os.environ.items())}"
        return msg

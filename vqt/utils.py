from PySide2.QtWidgets import QDialog, QVBoxLayout, QTextBrowser, QDialogButtonBox, QApplication, QPushButton

from vm.IssueReporter import IssueReporter
from vm.const import APP_NAME_SHORT


def show_text(txt, parent, type_text: bool = False, run: bool = True, min_width: int = 500, min_height: int = 400,
              title: str = APP_NAME_SHORT, copy_btn: bool = False, send_issue: bool = False):
    diag = QDialog(parent)
    diag.setWindowTitle(title)
    layout = QVBoxLayout(diag)
    diag.setLayout(layout)
    text = QTextBrowser()
    text.setOpenExternalLinks(True)
    if type_text:
        text.setPlainText(txt)
    else:
        text.setHtml(txt)
    layout.addWidget(text)
    box = QDialogButtonBox(QDialogButtonBox.Close)
    layout.addWidget(box)
    if copy_btn:
        def onCopy():
            QApplication.clipboard().setText(text.toPlainText())

        btn = QPushButton("Copy to Clipboard")
        btn.clicked.connect(onCopy)
        box.addButton(btn, QDialogButtonBox.ActionRole)

    if send_issue:
        def on_send():
            title = 'An error occurred'
            body = text.toPlainText()
            IssueReporter().sent_report(title, body)

        btn = QPushButton("Report Issue")
        btn.clicked.connect(on_send)
        box.addButton(btn, QDialogButtonBox.ActionRole)

    def onReject():
        QDialog.reject(diag)

    box.rejected.connect(onReject)
    diag.setMinimumHeight(min_height)
    diag.setMinimumWidth(min_width)
    if run:
        diag.exec_()
    else:
        return diag

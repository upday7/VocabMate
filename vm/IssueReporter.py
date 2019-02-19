import webbrowser
from urllib.parse import quote

from vm.const import PROJECT_ISSUE_URL


class IssueReporter:

    def __init__(self):
        ...

    @staticmethod
    def sent_report(title: str, body: str, ):
        title = quote(title)
        body = quote(body)
        url = f'{PROJECT_ISSUE_URL}/new?body={body}&title={title}'
        webbrowser.open_new_tab(url)

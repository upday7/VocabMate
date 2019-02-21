class VocabComError(Exception):
    ...


class APIGetError(VocabComError):
    def __init__(self, url: str):
        super(APIGetError, self).__init__(f"Exception in getting {url}")

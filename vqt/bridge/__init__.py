import logging
from collections import Callable
from functools import partial

from PySide2.QtCore import QObject, Signal, QRunnable, QThreadPool


class _AsyncRunner(QRunnable, QObject):
    done = Signal(object)

    def __init__(self, func: Callable, callback: Callable, *func_args, **func_kwargs):
        QRunnable.__init__(self)
        QObject.__init__(self)
        self.callable = partial(func, *func_args, **func_kwargs)
        self.callback = partial(callback)

    def run(self):
        self.done.connect(self.callback)
        res = self.callable()
        logging.debug(f"AsyncRunner response: {res}")
        self.done.emit(res)
        self.done.disconnect(self.callback)


class BridgeObj(QObject):

    def __init__(self):
        super(BridgeObj, self).__init__()

        self._async_pool = QThreadPool(self)

    def ac(self, func: Callable, callback: Callable, *func_args, **func_kwargs, ):
        """
        Async Call function
        """
        _async = _AsyncRunner(func, callback, *func_args, **func_kwargs)
        self._async_pool.globalInstance().start(_async)

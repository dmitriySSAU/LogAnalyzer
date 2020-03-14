import threading
from multiprocessing import Queue


class Collector(threading.Thread):
    def __init__(self, max_buffer_len):
        super().__init__()

        self._data_queue = Queue()
        self._max_buffer_len = max_buffer_len

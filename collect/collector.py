import threading
from queue import Queue

from common import tools
from init.log import Log


class Collector(threading.Thread):
    """Класс реализует логику сбора информации из лога.

    """

    def __init__(self, collector_settings: dict, log: Log):
        super().__init__()

        self._is_run: bool = False
        self._is_run_locker: threading.Lock = threading.Lock()

        self._data_queue: Queue = Queue()
        self._log: Log = log

        tools.check_dict_key_exists(collector_settings, ["buffer_len", "max_file_size", "path"], "collector_settings",
                                    True)
        self._buffer_len: int = collector_settings["buffer_len"]
        self._max_file_size: int = collector_settings["max_file_size"]
        self._path: str = collector_settings["path"]

    def stop(self) -> None:
        """Полная остановка сборщика.

        """
        self._is_run_locker.acquire()
        self._is_run = False
        self._is_run_locker.release()

    def run(self) -> None:
        """Переопределенная функция запуска потока.

            Запускает сбор информации из лога.
        """
        file_name: str = self._log.get_file_name()
        format_file: str = self._log.get_format()
        write_mode: str = self._log.get_write_mode()
        repeat_time: int = self._log.get_repeat_time()
        if self._log.is_indexing():
            indexing: dict = self._log.get_indexing()
        else:
            indexing: dict = {}

        self._is_run = True
        previous_file_info: dict = {}
        while True:
            self._is_run_locker.acquire()
            if self._is_run is False:
                self._is_run_locker.release()
                break
            self._is_run_locker.release()

            file_info: dict = self._get_next_file(file_name, format_file, write_mode,
                                                  indexing, previous_file_info)
            collected_data: dict = self._collect_data(file_info)
            self._data_queue.put(collected_data)

            previous_file_info = file_info

    def _collect_data(self, file_info: dict) -> dict:
        lines_buffer: list = []
        with open(self._path + "\\" + file_info["full_file_name"], encoding="utf-8") as log_file:
            if file_info["write_mode"] == "gradual" or file_info["size"] > self._max_file_size:
                for index, line in enumerate(log_file):
                    if index < file_info["line_index"]:
                        continue
                    if len(lines_buffer) < self._buffer_len:
                        lines_buffer.append(line)
            else:
                lines_buffer = log_file.readlines()
        return {}

    def _get_next_file(self, file_name: str, format_file: str, write_mode: str, indexing: dict,
                       previous_file_info: dict) -> dict:
        if not indexing:
            if write_mode == "gradual":
                file_meta_data: dict = self._change_file_waiting(file_name, format_file, previous_file_info)
                if not previous_file_info:
                    line_index = 0
                else:
                    line_index = previous_file_info["line_index"] + 1
                return {
                    "full_file_name": file_name + "." + format_file,
                    "write_mode": write_mode,
                    "line_index": line_index,
                    "hash": file_meta_data["hash"],
                    "size": file_meta_data["size"]
                }

    def _exist_file_waiting(self, full_path: str):
        return True

    def _change_file_waiting(self, file_name: str, format_file: str, previous_file_info: dict) -> dict:

        return {}


    def _check_file_change(self, ):
        return True
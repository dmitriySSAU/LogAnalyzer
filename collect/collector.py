import os
import threading
from queue import Queue

from common import tools
from init.log import Log

from collect.file import File


class Collector(threading.Thread):
    """Класс реализует логику сбора информации из лога.

    """

    def __init__(self, collector_settings: dict, log: Log):
        super().__init__()

        self._is_run: bool = False
        self._is_run_locker: threading.Lock = threading.Lock()

        self._data_queue: Queue = Queue()
        self._log: Log = log
        self._log_info = {
            "path": self._log.get_path(),
            "file_name": self._log.get_file_name(),
            "format_file": self._log.get_format(),
            "write_mode": self._log.get_write_mode(),
            "repeat_time": self._log.get_repeat_time(),
            "indexing": self._log.get_indexing(),
        }

        self._current_file: File = File(self._log_info)
        self._previous_file: File = File(self._log_info)

        tools.check_dict_key_exists(collector_settings, ["buffer_len", "max_file_size", "path", "waiting_limit"],
                                    "collector_settings", True)
        self._buffer_len: int = collector_settings["buffer_len"]
        self._max_file_size: int = collector_settings["max_file_size"]
        self._waiting_limit = collector_settings["waiting_limit"]

    def run(self) -> None:
        """Переопределенная функция запуска потока.

            Запускает сбор информации из лога.
        """
        self._is_run = True

        if self._log_info["indexing"]:
            self._start_collecting_indexing_log()

    def stop(self) -> None:
        """Полная остановка сборщика.

        """
        self._is_run_locker.acquire()
        self._is_run = False
        self._is_run_locker.release()

    def _is_stop(self) -> bool:
        self._is_run_locker.acquire()
        if self._is_run is False:
            self._is_run_locker.release()
            return True
        else:
            self._is_run_locker.release()
            return False

    def _start_collecting_indexing_log(self) -> None:
        collected_file_info: dict = {}
        while True:
            if self._is_stop():
                break

            if self._current_file.get_file_info() == self._previous_file.get_file_info():
                self._current_file.update_file_info()

            waiting_count = 0
            while True:
                file_collect_number = self._waiting_for_collect()

                if file_collect_number == 0:
                    if self._is_stop():
                        return None
                    else:
                        waiting_count += 1
                        if waiting_count == self._waiting_limit:
                            # вывести сообщение наружу
                            return None
                        continue
                elif file_collect_number == 1:
                    collected_file_info = self._current_file.get_file_info()
                    break
                elif file_collect_number == 2:
                    collected_file_info = self._previous_file.get_file_info()
                    break
                else:
                    raise AssertionError("")

            collected_data: dict = self._collect_data(collected_file_info)
            self._data_queue.put(collected_data)

            self._previous_file.set_file_info(collected_file_info)

    def _waiting_for_collect(self) -> int:
        if self._previous_file is None:
            old_hash: str = self._current_file.get_hash()
            if self._current_file.waiting_for_file(self._log_info["repeat_time"]) is False:
                return 0
            current_hash: str = self._current_file.get_hash()
            if old_hash != current_hash:
                return 1
            if self._current_file.waiting_for_hash_change((self._log_info["repeat_time"])):
                return 1
            else:
                return 0
        else:
            next_file_exist = self._current_file.waiting_for_file((self._log_info["repeat_time"]))
            old_hash_old_file = self._previous_file.get_hash()
            self._previous_file.update_hash()
            current_hash_old_file = self._previous_file.get_hash()
            if current_hash_old_file == old_hash_old_file and next_file_exist:
                return 1
            elif current_hash_old_file == old_hash_old_file and next_file_exist is False:
                return 0
            else:
                return 2

    def _collect_data(self, file_info: dict) -> dict:
        lines_buffer: list = []
        full_path = os.path.join(self._path, file_info["full_name"])
        with open(full_path, encoding="utf-8") as log_file:
            if file_info["write_mode"] == "single-time" and file_info["size"] > self._max_file_size:
                for index, line in enumerate(log_file):
                    if index < file_info["line_index"] + 1:
                        continue
                    if len(lines_buffer) < self._buffer_len:
                        lines_buffer.append(line)
            else:
                lines_buffer = log_file.readlines()

        if not lines_buffer:
            raise AssertionError("There is no data after collecting!")

        return {
            "name": file_info["full_name"],
            "data": lines_buffer
        }

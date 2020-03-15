import os
import time
import threading
from queue import Queue

from common import tools
from init.log import Log

from collect import file


class Collector(threading.Thread):
    """Класс реализует логику сбора информации из лога.

    """

    def __init__(self, collector_settings: dict, log: Log):
        super().__init__()

        self._is_run: bool = False
        self._is_run_locker: threading.Lock = threading.Lock()

        self._data_queue: Queue = Queue()
        self._log: Log = log

        tools.check_dict_key_exists(collector_settings, ["buffer_len", "max_file_size", "path", "waiting_limit"],
                                    "collector_settings", True)
        self._buffer_len: int = collector_settings["buffer_len"]
        self._max_file_size: int = collector_settings["max_file_size"]
        self._path: str = collector_settings["path"]
        self._waiting_limit = collector_settings["waiting_limit"]

    def run(self) -> None:
        """Переопределенная функция запуска потока.

            Запускает сбор информации из лога.
        """
        self._is_run = True

        file_name: str = self._log.get_file_name()
        format_file: str = self._log.get_format()
        write_mode: str = self._log.get_write_mode()
        repeat_time: int = self._log.get_repeat_time()
        if self._log.is_indexing():
            indexing: dict = self._log.get_indexing()
        else:
            indexing: dict = {}
        log_info = {
            "file_name": file_name,
            "format_file": format_file,
            "write_mode": write_mode,
            "repeat_time": repeat_time,
            "indexing": indexing,
            "cycling": True
        }

        self._start_collecting(log_info)

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

    def _start_collecting(self, log_info: dict) -> None:
        previous_file_info: dict = {}
        while True:
            if self._is_stop():
                break

            file_info: dict = file.get_file_info_for_collect(log_info, previous_file_info)
            waiting_count = 0
            collect_file_info = {}
            while True:
                file_collect_number = self._waiting_for_collect(file_info, previous_file_info, log_info["repeat_time"])
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
                    collect_file_info = file_info
                    break
                elif file_collect_number == 2:
                    collect_file_info = previous_file_info
                    break
                else:
                    raise AssertionError("")

            collected_data: dict = self._collect_data(collect_file_info)
            self._data_queue.put(collected_data)

            previous_file_info = collect_file_info

    def _waiting_for_collect(self, file_info: dict, previous_file_info: dict, timeout: int) -> int:
        if not previous_file_info:
            if self._waiting_for_file(file_info, timeout):
                return 1
            else:
                return 0
        else:
            if file_info["index"] == -1:
                if self._waiting_for_hash_change(file_info, timeout):
                    return 1
                else:
                    return 0
            else:
                next_file_exist = self._waiting_for_file(file_info, timeout)
                current_hash_old_file = file.get_hash(previous_file_info["full_name"])
                if current_hash_old_file == previous_file_info["hash"] and next_file_exist:
                    return 1
                elif current_hash_old_file == previous_file_info["hash"] and next_file_exist is False:
                    return 0
                else:
                    return 2

    def _waiting_for_file(self, file_info: dict, timeout: int) -> bool:
        elapsed_time = 0
        full_path = os.path.join(self._path, file_info["full_name"])
        while os.path.isfile(full_path) is False:
            time.sleep(1)
            elapsed_time += 1
            if elapsed_time == timeout:
                return False

        file_info["hash"] = file.get_hash(full_path)
        file_info["size"] = file.get_size(full_path)
        return True

    def _waiting_for_hash_change(self, file_info: dict, timeout: int) -> bool:
        full_path = os.path.join(self._path, file_info["full_name"])
        elapsed_time = 0
        while True:
            current_hash = file.get_hash(full_path)
            if current_hash != file_info["hash"]:
                file_info["hash"] = current_hash
                return True
            time.sleep(1)
            elapsed_time += 1
            if elapsed_time == timeout:
                return False

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

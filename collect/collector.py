import threading
from queue import Queue

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

        self._current_file: File = File(self._log)
        self._previous_file: File = File(self._log)

        self._buffer_len: int = collector_settings["buffer_len"]
        self._max_file_size: int = collector_settings["max_file_size"]
        self._waiting_limit = collector_settings["waiting_limit"]

    def get_data_queue(self):
        """Метод доступа к полю класса _data_queue

        :return: очередь пакетов собранных данных из лога
        """
        return self._data_queue

    def run(self) -> None:
        """Переопределенная функция запуска потока.

            Запускает сбор информации из лога.
        """
        self._is_run = True

        if self._log.is_indexing():
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
        is_current_collected = False
        self._current_file.update_file_info()

        # инициализация объекта File, в котором будет храниться ссылка на файл, из которого нужно собрать данные
        file_to_collect: File = File(self._log)
        while True:
            if self._is_stop():
                break

            if is_current_collected:
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
                    file_to_collect = self._current_file
                    is_current_collected = True
                    break
                elif file_collect_number == 2:
                    file_to_collect = self._previous_file
                    is_current_collected = False
                    break
                else:
                    raise AssertionError("")

            self._collect_data(file_to_collect)

    def _waiting_for_collect(self) -> int:
        if self._previous_file is None:
            old_hash: str = self._current_file.get_hash()
            if self._current_file.waiting_for_file(self._log.get_repeat_time()) is False:
                return 0
            current_hash: str = self._current_file.get_hash()
            if old_hash != current_hash:
                return 1
            if self._current_file.waiting_for_hash_change((self._log.get_repeat_time())):
                return 1
            else:
                return 0
        else:
            next_file_exist = self._current_file.waiting_for_file((self._log.get_repeat_time()))
            old_hash_old_file = self._previous_file.get_hash()
            self._previous_file.update_hash()
            current_hash_old_file = self._previous_file.get_hash()
            if current_hash_old_file == old_hash_old_file and next_file_exist:
                return 1
            elif current_hash_old_file == old_hash_old_file and next_file_exist is False:
                return 0
            else:
                return 2

    def _collect_data(self, file: File) -> None:
        if self._log.get_write_mode() == "single-time" and file.get_size() <= self._max_file_size:
            read_mode = "all"
        else:
            read_mode = "buffer"

        lines_buffer: list = []
        last_line_index = 0
        with open(file.get_full_path(), encoding="utf-8") as log_file:
            if read_mode == "buffer":
                for index, line in enumerate(log_file):
                    if index < file.get_line_index() + 1:
                        continue
                    if len(lines_buffer) < self._buffer_len:
                        lines_buffer.append(line)
                        last_line_index = index
                    else:
                        self._data_queue.put({
                            "name": file.get_full_name(),
                            "data": lines_buffer
                        })
                        lines_buffer.clear()
                        file.set_last_line_index(last_line_index)
                        continue
            else:
                lines_buffer = log_file.readlines()

        if not lines_buffer:
            raise AssertionError("There is no data after collecting!")

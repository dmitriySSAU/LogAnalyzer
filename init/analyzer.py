import threading

from init.log import Log
from common import tools
from collect.collector import Collector


class Analyzer(threading.Thread):
    """Данный класс реализует логику pipeline: сбор, обработка, анализ, архив и вывод результатов.

    """

    def __init__(self, input_settings: dict):
        super().__init__()

        self._is_run = False
        self._is_run_locker = threading.Lock()

        tools.check_dict_key_exists(input_settings, ["log", "collector"], "input_settings", True)
        self._log = Log(input_settings["log"])
        self._collector = Collector(input_settings["collector"], self._log)

    def stop(self) -> None:
        """Полная остановка анализатора.

        """
        self._is_run_locker.acquire()
        self._is_run = False
        self._is_run_locker.release()

    def run(self) -> None:
        """Метод запуска логики pipeline.

        """
        self._is_run_locker.release()
        self._is_run = True

        self._collector.start()
        data_queue = self._collector.get_data_queue()
        while True:

            self._is_run_locker.acquire()
            if self._is_run is False:
                self._is_run_locker.release()
                break
            self._is_run_locker.release()
            collected_data: dict = {}
            collected_data = data_queue.get(timeout=self._log.get_repeat_time() + 5)
            if not collected_data:
                raise AssertionError("There is no data! Time out!!!")



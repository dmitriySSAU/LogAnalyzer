from typing import List

from database import log as db_log

from patterns.pattern import Pattern


class Log:
    """Класс анализируемого лог-файла.

        Хранит в себе настройки, шаблоны, а также обработанную полезную информацию за крайнюю обработку.
    """
    def __init__(self, input_settings: dict):
        """Конструктор создания лога для анализатора.

        :param input_settings: входные настройки логи. Словарь с ключами:
            1) logsGroup
            2) logName
            3) patternsGroup
        """
        settings: dict = db_log.get_settings(input_settings["groupName"], input_settings["logName"])
        self._path: str = settings['path']
        self._format: str = settings['format']
        self._write_mode: str = settings['write_mode']
        self._repeat_time: int = settings['repeat_time']

        self._is_indexing: bool = settings["indexing"]['is_indexing']
        self._full_file_name: str = settings['indexing']['full_file_name']
        self._index_format: str = settings['indexing']['format']
        self._start_index: int = settings['indexing']['start']
        self._end_index: int = settings['indexing']['end']
        self._is_indexing_cycle: bool = settings['indexing']['cycle']

        self._patterns: List[Pattern] = db_log.get_patterns(input_settings["patternsGroup"])
        self._is_multi_threading = False
        for pattern in self._patterns:
            if pattern.get_type() == "multi-threading":
                self._is_multi_threading = True

    def get_path(self) -> str:
        """

        :return:
        """
        return self._path

    def get_format(self) -> str:
        """Получение формата (расширения) файла лога.

        :return: формат файла лога
        """
        return self._format

    def get_write_mode(self) -> str:
        """Получение режима записи файла лога.

        Возможные значения:

        1) single-time - если файл существует и он не пустой, значит в него дописываться ничего не будет.
        ps он может только перезаписаться полностью.

        2) gradual - в конец файла может дописываться информация.

        :return: режим записи файла
        """
        return self._write_mode

    def get_repeat_time(self) -> int:
        """Получение времени перезаписи/формирования лога/появления следующего индексируемого файла лога.

        Возможные значения:

        1) -1 - не повторять.

        2) -2 - автоматический режим. Автосчитывание из файла при любом его изменении.

        3) > -1 - время в секундах.

        :return: режим записи файла.
        """
        return self._repeat_time

    def get_indexing_full_file_name(self) -> str:
        """Получение полного имени лога с индексном.

        :return: полное имя лога с индексом.
        """
        return self._full_file_name

    def get_index_format(self) -> str:
        """Получение формата индекса лога.

        :return: формат индекса лога.
        """
        return self._index_format

    def get_start_index(self) -> int:
        """Получение стартового значения индекса.

        :return: стартовое значение индекса.
        """
        return self._start_index

    def get_end_index(self) -> int:
        """Получение конечного значения индекса.

        :return: конечное значение индекса.
        """
        return self._end_index

    def is_indexing_cycle(self) -> bool:
        """Возвращает флаг - является ли индексация циклической..

        :return: индексация по циклу.
        """
        return self._is_indexing_cycle

    def is_indexing(self) -> bool:
        """Возвращает флаг - являются ли файлы лога индексируемыми.

        :return: флаг индексации.
        """
        return self._is_indexing

    def is_multi_threading(self) -> bool:
        """Возвращает флаг - является ли запись в лог многопоточной.

        :return: флаг многопоточности.
        """
        return self._is_multi_threading

    def compare_with_patterns(self, input_data: str) -> List[dict]:
        """Метод сравнения данного из журнала со всеми шаблонами (кому оно принадлежит).

        :param input_data: входное данное
        :return: список словарей с индексом шаблона и статусом сравнения (success или wait).
        """
        compared_results: List[dict] = []
        for index, pattern in enumerate(self._patterns):
            compared_result = pattern.check_data(input_data)
            if compared_result != "error":
                compared_results.append({
                    "index": index,
                    "status": compared_result
                })
        return compared_results

    def compare_with_pattern(self, log_string: str, pattern_index: int, start_index_line: int) -> str:
        return "succes/wait/error"
from common import tools
from database import log


class Log:
    """Класс анализируемого лог-файла.

        Хранит в себе настройки, шаблоны, а также обработанную полезную информацию за крайнюю обработку.
    """
    def __init__(self, input_settings: dict):
        tools.check_dict_key_exists(input_settings, ["groupName", "logName", "patterns"], "input_settings", True)
        self._settings: dict = log.get_settings(input_settings["groupName"], input_settings["logName"])
        tools.check_dict_key_exists(self._settings, ["groupName", "logName", "patterns", "path", "file_name", "format",
                                                     "write_mode", "repeat_time", "indexing"], "log_settings", True)
        self._is_indexing: bool = True
        if not self._settings["indexing"]:
            self._is_indexing = False
        else:
            tools.check_dict_key_exists(self._settings["indexing"], ["positions", "format", "from", "to", "cycling"],
                                        '_settings["indexing"]', True)

    def get_settings(self) -> dict:
        """Получение всех настроек лог файла.

        :return: настройки лога
        """
        return self._settings

    def get_path(self) -> str:
        """

        :return:
        """
        return self._settings["path"]

    def get_file_name(self) -> str:
        """Получение имени файла лога.

        :return: имя файла лога
        """
        return self._settings["file_name"]

    def get_format(self) -> str:
        """Получение формата (расширения) файла лога.

        :return: формат файла лога
        """
        return self._settings["format"]

    def get_write_mode(self) -> str:
        """Получение режима записи файла лога.

        Возможные значения:

        1) single-time - если файл существует и он не пустой, значит в него дописываться ничего не будет.
        ps он может только перезаписаться полностью.

        2) gradual - в конец файла может дописываться информация.

        :return: режим записи файла
        """
        return self._settings["write_mode"]

    def get_repeat_time(self) -> int:
        """Получение времени перезаписи/формирования лога/появления следующего индексируемого файла лога.

        Возможные значения:

        1) -1 - не повторять.

        2) -2 - автоматический режим. Автосчитывание из файла при любом его изменении.

        3) > -1 - время в секундах.

        :return: режим записи файла
        """
        return self._settings["write_mode"]

    def get_indexing(self) -> dict:
        """Получение настроек индексации файла лога.

        :return: настройки индексации файла
        """
        return self._settings["indexing"]

    def is_indexing(self) -> bool:
        """Возвращает флаг - являются ли файлы лога индексируемыми.

        :return: флаг индексации
        """
        return self._is_indexing

import os
import time
import hashlib

from init.log import Log


def format_converter(index: int, count_zeros: int) -> str:
    """Функция изменения формата индекса.

    :param index: индекс
    :param count_zeros: количество нулей перед индексом
    :return: отформатированный индекс.
    """
    return "{:0" + str(count_zeros) + "d}".format(index)


class File:
    """Класс Файл, предназначенный для хранения информации о файле журнала, из которого идет сбор данных.

    """
    def __init__(self, log: Log):
        self._log = log
        self._full_name = ""
        self._full_path = ""
        self._current_index = -1
        self._last_line_index = -1
        self._size = -1
        self._hash = ""

    def get_full_path(self) -> str:
        """Метод-геттер поля full_path.

        Полный путь до файла.

        :return: поле full_path.
        """
        return self._full_path

    def get_full_name(self) -> str:
        """Метод-геттер поля full_name.

        Полное имя файла с индексом.

        :return: поле full_name.
        """
        return self._full_name

    def get_size(self) -> int:
        """Метод-геттер поля size.

        Размер файла.

        :return: поле size.
        """
        return self._size

    def get_current_index(self) -> int:
        """Метод-геттер поля current_index.

        Индекс файла, который присутствует в его полном имени.

        :return: поле current_index.
        """
        return self._current_index

    def get_line_index(self) -> int:
        """Метод-геттер поля line_index.

        Индекс строки, на котором остановилось чтение файла в крайний раз.

        :return: поле line_index.
        """
        return self._last_line_index

    def set_last_line_index(self, last_line_index: int) -> None:
        """Метод-сеттер нового значения поля last_line_index

        :param last_line_index: новое значение поля
        """
        self._last_line_index = last_line_index

    def get_hash(self) -> str:
        """Метод-геттер поля hash.

        Хэш от даты изменения файла.

        :return:
        """
        return self._hash

    def update_file_info(self) -> None:
        """Метод получения информации о файле, из которого нужно считать.

        :return: информация о файле
        """
        if self._log.is_indexing():
            simple_file_info = self._get_next_name_and_index()
            self._full_name = simple_file_info["full_name"]
            self._current_index = simple_file_info["index"]

        self._full_path = os.path.join(self._log.get_path(), self._full_name)

    def _get_next_name_and_index(self) -> dict:
        """

        :return:
        """
        next_index = self._get_next_index()
        formatted_index = self._get_formatted_index(next_index)
        position = str(self._log.get_indexing_full_file_name())
        return {
            "full_name": position.replace("$ind#$", formatted_index) + "." + self._log.get_format(),
            "index": next_index
        }

    def _get_next_index(self) -> int:
        """

        :return:
        """
        next_index = self._current_index + 1
        if next_index < self._log.get_end_index():
            return next_index
        elif self._log.is_indexing_cycle():
            return self._log.get_start_index()
        else:
            return -1

    def _get_formatted_index(self, index: int) -> str:
        """

        :param index:
        :return:
        """
        count_zeros = len(self._log.get_format()) - len(str(index))
        return format_converter(index, count_zeros)

    def update_hash(self) -> None:
        """

        :return:
        """
        file_change_time = os.path.getmtime(self._full_path)
        self._hash = hashlib.md5(str(file_change_time))

    def update_size(self) -> None:
        """

        :return:
        """
        self._size = os.path.getsize(self._full_path)

    def waiting_for_hash_change(self, timeout: int) -> bool:
        """

        :param timeout:
        :return:
        """
        old_hash = self.get_hash()
        elapsed_time = 0
        while True:
            self.update_hash()
            current_hash = self.get_hash()
            if current_hash != old_hash:
                return True
            time.sleep(1)
            elapsed_time += 1
            if elapsed_time == timeout:
                return False

    def waiting_for_file(self, timeout: int) -> bool:
        """Метод ожидания существования файла.

        :param timeout: таймаут ожидания
        :return: флаг существования файла
        """
        elapsed_time = 0
        while os.path.isfile(self.get_full_path()) is False:
            time.sleep(1)
            elapsed_time += 1
            if elapsed_time == timeout:
                return False

        self.update_hash()
        self.update_size()

        return True

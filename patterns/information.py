from abc import ABC, abstractmethod

from database import pattern


class Information(ABC):
    """Абстрактный класс Информация, предназначеный для работы с информацией в строке.

    """
    def __init__(self, name: str):
        settings = pattern.get_info_settings(name)
        self._name: str = name
        self._start: str = settings['start']
        self._end: str = settings['end']
        self._data_type: str = settings['dataType']
        self._is_keyword: bool = settings['keyword']
        self._extra_settings: dict = settings['extra_settings']

    def get_name(self) -> str:
        """Метод-геттер поля name.

        :return: поле name.
        """
        return self._name

    def get_start(self) -> str:
        """Метод-геттер поля start.

        :return: поле start
        """
        return self._start

    def get_end(self) -> str:
        """Метод-геттер поля end.

        :return: поле end.
        """
        return self._end

    def is_keyword(self) -> bool:
        """Метод проверки на ключевое слово.

        Является ли информация ключевым словом.

        :return: True - является. False - не является.
        """
        return self._is_keyword

    def get_data_type(self) -> str:
        """Метод-геттер поля data_type.

        :return: поле data_type.
        """
        return self._data_type

    @abstractmethod
    def get_info(self, string: str, start_position: int) -> dict:
        """Метод получения информации из строки

        :param string: входная строка с данными
        :param start_position: стартовая позиция индекса - откуда начинать искать и парсить информацию
        """
        pass

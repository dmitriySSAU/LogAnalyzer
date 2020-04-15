from typing import List
from abc import ABC, abstractmethod


class Pattern(ABC):
    """Абстрактный класс Шаблон. Предоставляет механизмы по работе с шаблонами.

    """
    def __init__(self, name: str, type_: str, input_data: List[dict]):
        super().__init__()

        self._name: str = name
        self._type: str = type_

    def get_name(self) -> str:
        """Метод получения имени шаблона.

        :return: имя шаблона
        """
        return self._name

    def get_type(self) -> str:
        """Метод получения типа шаблона (простой/связанный).

        :return: тип шаблона
        """
        return self._type

    @abstractmethod
    def check_data(self, input_data: str, index: int = 0) -> str:
        """Метод определения - принадлежать ли данные указанном индексу данных в шаблоне..

        :param input_data: входное данное
        :param index: требуемое место входных данных в последовательности данных шаблона
        :return: статус проверки принадлежности:
            1) "success" - если данное принадлежит и у шаблона больше нет следующих данных;
            2) "wait" - если данное принадлежит, но шаблон еще ожидает следующих данных;
            3) "error" - не принадлежит.
        """
        pass

    @abstractmethod
    def get_info(self, input_data: List[str], index: int = 0) -> List[dict]:
        """Извлечение полезной информации из данных.

        :param input_data: входные данные
        :param index: индекс данного в шаблоне.
        :return: полезная извлеченная информация из данных.
        """
        pass

from typing import List
from database import pattern as db_pattern

from patterns.pattern import Pattern
from patterns.string import String


class SimplePattern(Pattern):
    """Класс реализует абстрактный класс Шаблон и представляет собой простой шаблон (имеет только одно данное).

    """
    def __init__(self, name: str, type_: str, input_data: List[dict]):
        super().__init__(name, type_, input_data)
        self._string: String = db_pattern.get_strings(name)[0]

    def check_data(self, input_data: str, index: int = 0) -> str:
        """Реализация абстрактного метода.

        :param input_data: входное данное
        :param index: Для простого шаблона всегда 0.
        :return: статус (см. описание абстрактного метода).
        """
        if self._string.identify(input_data):
            return "success"
        else:
            return "error"

    def get_info(self, input_data: List[str], index: int = 0) -> List[dict]:
        """Реализация абстрактного метода.

        :param input_data: входные данные
        :param index: индекс данного в шаблоне
        """
        return self._string.extract_info(input_data[0])

from typing import List

from database import pattern as db_pattern

from patterns.information import Information


class String:
    """Класс Строка, представляющий строку журнала как данное.

    Предназначен для работы со конкретной строкой журнала, а именно:
    1) идентификация строки по ключевым словам;
    2) извлечение из нее полезной информации.
    """
    def __init__(self, name: str):
        super().__init__(name)

        self._information: List[Information] = db_pattern.get_information(name)

    def identify(self, string: str) -> bool:
        """Реализация абстрактного метода.

        Идентификация строки.

        :param string: входная строка
        :return: флаг успешности идентификации строки: True - это подходящая строка, False - нет.
        """
        previous_index = 0
        for info in self._information:
            # Сначала проверяется наличие всех ключевых слов в строке.
            # Если хотя бы одного нет, то считается, что строка не прошла идентификацию.
            # При поиске очередного ключевого слова учитывается его порядок следования относительно предыдущего.
            if info.is_keyword():
                index = string.find(info.get_start(), previous_index)
                if index == -1:
                    return False
                previous_index = index + 1
                continue
            # После проверки всех ключевых слов проверяется наличие всей полезной информации в строке.
            if previous_index != 0:
                previous_index = 0
            index = string.find(info.get_start(), previous_index)
            if index == -1:
                return False
            previous_index = index + 1

        return True

    def extract_info(self, string: str) -> List[dict]:
        """Реализация абстрактного метода.

        Извлечение информации из строки.

        :param string: входная строка
        :return: список объектов dict - извлеченная информация
        """
        all_useful_info = []
        previous_end_index = 0
        for info in self._information:
            useful_info: dict = info.get_info(string, previous_end_index)
            all_useful_info.append({
                "name": useful_info['name'],
                "info": useful_info['info']
            })

            if useful_info['stop_index'] == -1:
                break

            previous_end_index = useful_info['stop_index']

        return all_useful_info

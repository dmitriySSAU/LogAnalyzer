from patterns.information import Information


class Simple(Information):
    """Реализация абстрактного класса Информация для простых типов данных информации (int, string, bool).

    """
    def __init__(self, name):
        super().__init__(name)

    def get_info(self, string: str, start_index: int) -> dict:
        """Реализация абстрактного метода по получению конкретной информации из строки.

        :param string: строки
        :param start_index: индекс с которого следует начать поиск и извлечение информации
        :return: словарь с полученной информацией с ключами:
            1) name - имя информации;
            2) info - информация;
            3) stop_index - индекс, на котором данная информация закончилась
             (необходима для извлечения следующей по порядку информации).
        """
        current_start_index = string.find(super()._start, start_index) + len(super()._start)

        if super()._end == "":
            useful_info = {
                "name": super()._name,
                "info": string[current_start_index:],
                "stop_index": -1
            }
        else:
            current_end_index = string.find(super()._end, current_start_index)

            useful_info = {
                "name": super()._name,
                "info": string[current_start_index:current_end_index],
                "stop_index": current_end_index + len(super()._end)
            }

            if super()._data_type == "int":
                useful_info['info'] = int(useful_info['info'])

        return useful_info

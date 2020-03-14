from database import db


def get_settings(log_group_name: str, log_name: str) -> dict:
    """Получение настроек лог файла из БД.

    :param log_group_name: имя группы
    :param log_name: имя лога
    :return: настройки лога
    """
    return {"settings:": []}

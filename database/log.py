from typing import List
from database import db
from patterns.pattern import Pattern


def get_settings(log_group_name: str, log_name: str) -> dict:
    """Получение настроек лог файла из БД.

    :param log_group_name: имя группы
    :param log_name: имя лога
    :return: настройки лога
    """
    return {
        "path": "D:\\cpu",
        "format": "txt",
        "write_mode": "single-time",
        "repeat_timeout": 30,
        "indexing": {
            "is_indexing": True,
            "full_file_name": "cpu001",
            "index_format": "###",
            "start": 1,
            "end": 30,
            "cycle": True
        }
    }


def get_patterns(patternsGroup: str) -> List[Pattern]:

    return []

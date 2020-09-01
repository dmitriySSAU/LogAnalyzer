from typing import List

from patterns.string import String
from patterns.information import Information


def get_strings(pattern_name: str) -> List[String]:
    return [String("Строка 1")]


def get_information(string_name) -> List[Information]:
    return [Information("Информация 1")]


def get_info_settings(info_name) -> dict:
    return {
        "start": "cpu146=",
    }
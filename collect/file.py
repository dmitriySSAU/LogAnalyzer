import hashlib
import os


def get_file_info_for_collect(log_info: dict, previous_file_info: dict) -> dict:
    """Метод получения информации о файле, из которого нужно считать.

    :param log_info: общая информация по файлу лога
    :param previous_file_info: информация о крайнем полученном файле
    :return: информация о файле
    """
    simple_file_info = get_next_name_and_index(log_info, previous_file_info)
    file_info = {
        "full_name": simple_file_info["full_name"],
        "index": simple_file_info["index"],
        "read_mode": "",
        "line_index": 0,
        "size": 0,
        "hash": ""
    }

    if log_info["write_mode"] == "gradual":
        file_info["read_mode"] = "buffer"
    if not log_info["indexing"]:
        file_info["line_index"] = previous_file_info["line_index"]

    return file_info


def get_next_name_and_index(log_info: dict, previous_file_info: dict) -> dict:
    """

    :param log_info:
    :param previous_file_info:
    :return:
    """
    if not log_info["indexing"]:
        return {
            "full_name": log_info["file_name"] + "." + log_info["format"],
            "index": -1
        }
    else:
        next_index = get_next_index(log_info["indexing"], previous_file_info["current_index"])
        formatted_index = get_formatted_index(next_index, log_info["indexing"]["format"])
        position = str(log_info["indexing"]["position"])
        return {
            "full_name": position.replace("$ind#$", formatted_index) + "." + log_info["format"],
            "index": next_index
        }


def get_next_index(indexing_info: dict, current_index: int) -> int:
    """

    :param indexing_info:
    :param current_index:
    :return:
    """
    next_index = current_index + 1
    if next_index < indexing_info["to"]:
        return next_index
    elif indexing_info["cycling"]:
        return indexing_info["from"]
    else:
        return -1


def get_formatted_index(index: int, format_: str) -> str:
    """

    :param index:
    :param format_:
    :return:
    """
    count_zeros = len(format_) - len(str(index))
    return format_converter(index, count_zeros)


def format_converter(index: int, count_zeros: int) -> str:
    """

    :param index:
    :param count_zeros:
    :return:
    """
    return "{:0" + str(count_zeros) + "d}".format(index)


def get_hash(full_path: str) -> str:
    """

    :param full_path:
    :return:
    """
    return hashlib.md5(str(os.path.getmtime(full_path)))


def get_size(full_path: str) -> int:
    """

    :param full_path:
    :return:
    """
    return os.path.getsize(full_path)
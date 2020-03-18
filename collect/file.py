import hashlib
import os
import time


def format_converter(index: int, count_zeros: int) -> str:
    """

    :param index:
    :param count_zeros:
    :return:
    """
    return "{:0" + str(count_zeros) + "d}".format(index)


class File:
    def __init__(self, log_info: dict):
        self._log_info: dict = log_info
        self._file_info: dict = None

    def get_full_path(self):
        """

        :return:
        """
        return self._file_info["full_path"]

    def get_file_info(self) -> dict:
        """

        :return:
        """
        return self._file_info

    def set_file_info(self, file_info: dict) -> None:
        """

        :param file_info:
        """
        self._file_info = file_info

    def get_hash(self) -> str:
        """

        :return:
        """
        return self._file_info["hash"]

    def update_file_info(self) -> dict:
        """Метод получения информации о файле, из которого нужно считать.

        :return: информация о файле
        """
        if self._file_info is None:
            self._file_info = {
                "full_name": "",
                "full_path": "",
                "index": -1,
                "read_mode": "",
                "line_index": -1,
                "size": -1,
                "hash": ""
            }

            if self._log_info["write_mode"] == "gradual":
                self._file_info["read_mode"] = "buffer"

        if self._log_info["indexing"]:
            simple_file_info = self.get_next_name_and_index()
            self._file_info["full_name"] = simple_file_info["full_name"]
            self._file_info["index"] = simple_file_info["index"]

        self._file_info["full_path"] = os.path.join(self._log_info["path"], self._file_info["full_name"])

        return self._file_info

    def get_next_name_and_index(self) -> dict:
        """

        :return:
        """
        next_index = self._get_next_index()
        formatted_index = self._get_formatted_index(next_index)
        position = str(self._log_info["indexing"]["position"])
        return {
            "full_name": position.replace("$ind#$", formatted_index) + "." + self._log_info["format"],
            "index": next_index
        }

    def _get_next_index(self) -> int:
        """

        :return:
        """
        next_index = self._file_info["index"] + 1
        if next_index < self._log_info["indexing"]["to"]:
            return next_index
        elif self._log_info["indexing"]["cycling"]:
            return self._log_info["indexing"]["from"]
        else:
            return -1

    def _get_formatted_index(self, index: int) -> str:
        """

        :param index:
        :return:
        """
        count_zeros = len(self._log_info["indexing"]["format"]) - len(str(index))
        return format_converter(index, count_zeros)

    def update_hash(self) -> None:
        """

        :param file_dir_path:
        :return:
        """
        file_change_time = os.path.getmtime(self._file_info["full_path"])
        self._file_info["hash"] = hashlib.md5(str(file_change_time))

    def update_size(self) -> None:
        """

        :param full_path:
        :return:
        """
        self._file_info["size"] = os.path.getsize(self._file_info["full_path"])

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
        """

        :param timeout:
        :return:
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

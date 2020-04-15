from typing import List

from init.log import Log


class DataHandler:
    """Класс для обработки собранных данных.

    """
    def __init__(self):
        self._input_data_buffer: dict = {}
        self._output_data: List[dict] = [
            {
                "pattern_index": 0,
                "data_strings": []
            }
        ]
        self._temp_data: List[dict] = []

    def set_data_buffer(self, input_data_buffer: dict) -> None:
        self._input_data_buffer = input_data_buffer

    def handle(self, log: Log):
        if not self._input_data_buffer:
            raise AssertionError("")
        if log.is_multi_threading():
            self._handle_multi_threading_log()
        else:
            self._hadnle_singal_threading_log(log)

    def _hadnle_singal_threading_log(self, log: Log) -> None:
        for input_data in self._input_data_buffer["data"]:
            if self._temp_data:
                for index, temp_data in enumerate(self._temp_data):
                    status = log.compare_with_pattern(input_data, temp_data['index'], len(temp_data['strings']))
                    if status == "success":
                        temp_data["strings"].append(input_data)
                        self._output_data.append({
                            "pattern_index": temp_data['index'],
                            "data_strings": temp_data['strings']
                        })
                        self._temp_data.pop(index)
                    elif status == "wait":
                        self._temp_data[index]['strings'].append(input_data)
                    else:
                        self._temp_data.pop(index)

            compared_result: List[dict] = log.compare_with_patterns(input_data)
            for result in compared_result:
                data_info: dict = {
                    "pattern_index": result['index'],
                    "data_strings": [input_data]
                }
                if result['status'] == "success":
                    self._output_data.append(data_info)
                elif result['status'] == "wait":
                    self._temp_data.append(data_info)

    def _handle_multi_threading_log(self):
        return True

import json

from init.log import Log


class Analyzer:
    def __init__(self, input_settings):
        self._input_settings = input_settings
        self._is_run = False

        if "log" not in input_settings:
            raise AssertionError("There is no key 'log' in input settings!")
        self.log = Log(input_settings["log"])

    def run(self):
        self._is_run = True

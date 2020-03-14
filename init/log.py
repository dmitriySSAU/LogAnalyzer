import json

from common import tools


class Log:
    def __init__(self, input_settings):
        self._input_settings = input_settings
        tools.check_dict_key_exists(input_settings, [input_settings["groupName"], input_settings["logName"],
                                                     input_settings["patterns"]], True)




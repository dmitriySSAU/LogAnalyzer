from abc import ABC, abstractmethod


class Pattern(ABC):
    def __init__(self, name):
        self._name = name
        super().__init__()

    def get_name(self):
        return self._name

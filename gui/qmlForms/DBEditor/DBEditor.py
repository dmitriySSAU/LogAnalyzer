from PyQt5.QtCore import pyqtProperty, QObject, pyqtSignal, pyqtSlot

from database.db import DataBase
from database import log as db_log


class DBEditor(QObject):
    """Класс для работы с БД из QML.

    """
    logGroupsChanged = pyqtSignal()

    def __init__(self, parent=None):
        super().__init__(parent)

        self._database = DataBase()
        self._database.connect()

    @pyqtSlot(str, str, result=int)
    def create_log_group(self, log_group_name: str, description: str) -> int:
        """Qt слот создания группы жруналов.
        Используется в LogEditor.qml

        :param log_group_name: имя группы журналов;
        :param description: описание группы журналов.

        :return: код ответа функции создания (см описание функции ниже).
        """
        code = db_log.create_log_group(self._database, log_group_name, description)
        if code == 0:
            self.logGroupsChanged.emit()
        return code

    @pyqtSlot(result=list)
    def get_log_groups(self) -> list:
        """Qt слот получения списка групп журналов.

        :return: список групп журналов.
        """
        return list(db_log.get_log_group_names(self._database))

    @pyqtSlot(str, result=str)
    def get_log_group_description(self, log_group_name: str) -> str:
        """Qt слот получения описания группы журналов.

        :param log_group_name: имя группы журналов.

        :return: описание группы журналов.
        """
        return db_log.get_log_group_description(self._database, log_group_name)

    @pyqtSlot(str, str, str, result=int)
    def edit_log_group_info(self, current_name: str, new_name: str, new_description: str) -> int:
        """Qt слот редактирование информации по группе журналов (имя и описание).

        :param current_name: старое имя;
        :param new_name: новое имя;
        :param new_description: новое описание.

        :return: код ответа функции создания (см описание функции ниже).
        """
        code = db_log.edit_log_group_info(self._database, current_name, new_name, new_description)
        if code == 0:
            self.logGroupsChanged.emit()
        return code

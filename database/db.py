import sqlite3


class DataBase:
    """Класс по работе с баззой данных анализатора журналов.

    """
    def __init__(self):
        self._DB_PATH = "./databases/log_analyzer.db"
        self._connection = None
        self._cursor = None

    def connect(self) -> None:
        """Метод соединения с БД.

        """
        self._connection = sqlite3.connect(self._DB_PATH)
        self._cursor = self._connection.cursor()

    def disconnect(self) -> None:
        """Метод отсоединения от БД.

        """
        self._connection.close()

    def _execute_modify_cmd(self, sql_cmd: str, parameters: tuple) -> int:
        """Метод непосредственного выполнения запроса.

        :param sql_cmd: SQL запрос;
        :param parameters: параметры запроса.

        :return: код выполнения запроса:
                0 - успешно;
               -1 - не соблюдена уникальность чего-либо;
        """
        try:
            self._cursor.execute(sql_cmd, parameters)
            self._connection.commit()
        except sqlite3.IntegrityError as error:
            if error.args[0].startswith("UNIQUE constraint failed"):
                return -1
        return 0

    def _execute_select_cmd(self, sql_cmd: str, parameters: tuple) -> tuple:
        self._cursor.execute(sql_cmd, parameters)
        return self._cursor.fetchall()

    def insert_log_group(self, name: str, description: str) -> int:
        """Метод создание новой группы шаблонов.

        :param name: имя группы журнала;
        :param description: описание журнала.

        :return: код выполнения запроса:
                0 - успешно;
               -1 - не соблюдена уникальность чего-либо;
        """

        sql_cmd = "INSERT INTO LogsGroup (idLogsGroup, name, description) VALUES (?, ?, ?)"
        parameters = (None, name, description)
        return self._execute_modify_cmd(sql_cmd, parameters)

    def get_log_group_names(self) -> tuple:
        """Метод получения списка групп шаблонов

        :return: список групп шаблонов
        """
        sql_cmd = "SELECT name FROM LogsGroup"
        parameters = ()
        result = self._execute_select_cmd(sql_cmd, parameters)

        log_groups = []
        for log_group in result:
            log_groups.append(log_group[0])
        return tuple(log_groups)

    def get_log_group_description(self, name: str) -> str:
        """Метод выполнения SQL запроса получения описания группы шаблонов.

        :param name: имя группы шаблонов.

        :return: описание группы шаблона.
        """
        sql_cmd = "SELECT description FROM LogsGroup WHERE name = ?"
        parameters = (name, )
        result = self._execute_select_cmd(sql_cmd, parameters)
        if not result:
            return ""
        return result[0][0]

    def update_log_group_info(self, current_name: str, new_name: str, new_description: str) -> int:
        """Метод выполнения SQL запроса обновления информации по группе журналов.

        :param current_name: старое имя группы журналов (которая сейчас в БД);
        :param new_name: новое имя группы журналов;
        :param new_description: новое описание группы журналов.

        :return: код выполнения запроса:
                0 - успешно;
               -1 - не соблюдена уникальность чего-либо;
        """
        sql_cmd = "UPDATE LogsGroup SET name = ?, description = ? WHERE name = ?"
        parameters = (new_name, new_description, current_name)
        return self._execute_modify_cmd(sql_cmd, parameters)
from database.db import DataBase


def create_log_group(database: DataBase, log_group_name: str, description: str) -> int:
    """Функция создания группы журналов.

    :param database: объект класса БД;
    :param log_group_name: имя группы;
    :param description: описание группы.

    :return: код выполнения запроса:
                0 - успешно;
               -1 - не соблюдена уникальность имени группы шаблона;
    """
    return database.insert_log_group(log_group_name, description)


def get_log_group_names(database: DataBase) -> tuple:
    """Функция получения групп шаблонов

    :param database: объъект класса БД.

    :return: список групп шаблонов.
    """
    return database.get_log_group_names()


def get_log_group_description(database: DataBase, log_group_name: str) -> str:
    """Функция получения описания группы шаблонов.

    :param database: объект класса БД;
    :param log_group_name: имя группы шаблонов.

    :return: описание группы шаблонов. Если из Бд вернулось "", то это ошибка, такого быть не должно,
            по какой-то причине группа шаблонов с таким именем не была найдена.
    """
    description = database.get_log_group_description(log_group_name)
    assert description != "NULL", "[1001] Группы шаблонов " + log_group_name + " не существует!"
    return description


def edit_log_group_info(database: DataBase, current_name: str, new_name: str, new_description: str) -> int:
    """Функция редактирования информации по группе журналов (имя и описание).

    :param database: объект класса БД;
    :param current_name: старое имя;
    :param new_name: новое имя;
    :param new_description: новое описание.

    :return: код выполнения запроса:
                0 - успешно;
               -1 - не соблюдена уникальность имени группы шаблона;
    """
    return database.update_log_group_info(current_name, new_name, new_description)


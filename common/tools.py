from logs import log


def check_dict_key_exists(dict_: dict, list_keys: list, dict_name, raise_except: bool) -> bool:
    """Функция проверки на наличие ключей в словаре.

        :param dict_: словарь к проверке
        :param list_keys: список ключей, на существование которых идет проверка
        :param dict_name: имя проверяемого словаря для понимания пользователем
        :param raise_except: флаг - выбрасывать исключение при отсутствии ключа или нет и отпечатать только сообщение
        """
    logger = log.get_logger("scripts/common/tools")
    logger.info("was called (dict_: dict, list_keys: list, dict_name, raise_except: bool)")
    logger.debug("with params (" + str(dict_) + ", " + str(list_keys) + ", " + dict_name + ", " +
                 str(raise_except) + ")")
    if isinstance(dict_, dict) is False:
        log.raise_error("key '" + dict_name + "' isn't a dict!", logger)

    success: bool = True
    for key in list_keys:
        if key not in dict_:
            success = False
            if raise_except:
                log.raise_error("There is no key '" + key + "' in '" + dict_name + "'!", logger)
            else:
                logger.error("There is no key '" + key + "' in '" + dict_name + "'!")
                #log.print_error("There is no key '" + key + "' in '" + dict_name + "'!")

    return success


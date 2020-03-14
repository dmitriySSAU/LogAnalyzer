import logging
import os
import datetime
import configparser
import shutil
import threading

# установка формата строки лога
formatter = logging.Formatter('%(asctime)s - func %(funcName)s() - keyline=%(lineno)d - %(levelname)s - %(message)s')

# начало относительного пути при запуске
# # если Runner запускается как дочерний процесс (run_mode=app), то path='./Runner'
# # если Runner запускается отдельно через main.py, то path=""
path = ""

# режим вывода сообщений в консоль
# уровни от самого краткого до самого подробного: ERROR -> WARNING -> TEST -> ALL
# ERROR - ошибки
# WARNING - предупреждения
# TEST - различные информативные сообщения, связанные непосредственно с тестами
# ALL - любая другая различная информация
output_mode = "TEST"

# режим запуска Runner
# app - запуск из стороннего приложения (Runner - дочерний процесс)
# console - запуск Runner как родительского процесса (main.py из консоли)
run_mode = "console"

# блокировщик для функций вывода в консоль
# так как может быть несколько одновременных тестов (из разных потоков)
threadLock = threading.Lock()


# rename last logs and create new
def init_log():
    # удаление самой старой папки log при необходимости
    delete_directory()
    # переименовывание папки log в log+current_time
    rename_directory()
    # создание директорий для логов
    os.mkdir(path + "log")
    os.mkdir(path + "log/collect")
    os.mkdir(path + "log/common")
    os.mkdir(path + "log/database")
    os.mkdir(path + "log/handler")
    os.mkdir(path + "log/init")
    os.mkdir(path + "log/patterns")


# get logger for py-module
def get_logger(py_module_name):
    logger = logging.getLogger(py_module_name)
    if create_directory(py_module_name) is False:
        return logger
    fh = logging.FileHandler(path + "log/" + py_module_name + "/log.txt")
    fh.setFormatter(formatter)
    set_log_level(logger)
    logger.addHandler(fh)

    return logger


# delete the oldest directory
def delete_directory():
    list_dir = []
    list_log_dir = []
    if path == "":
        for root in os.walk("../Runner"):
            list_dir = root[1]
            break
    else:
        for root in os.walk("./"):
            list_dir = root[1]
            break

    for dir in list_dir:
        if dir.find(path + "log_") != -1:
            list_log_dir.append(dir)

    config = configparser.ConfigParser()
    config.read(path + "runner.conf")
    max_dir = config.get("log", "max_dir")

    if len(list_log_dir) < int(max_dir):
        return

    # сортируем по возрастанию
    # самая первая - самая старая
    list_log_dir.sort()

    # удаляем рекурсивно самую первую директорию
    shutil.rmtree(list_log_dir[0])


# set log level (check runner.conf file)
def set_log_level(logger):
    config = configparser.ConfigParser()
    config.read(path + "runner.conf")
    level = config.get("log", "level")

    if level == "DEBUG":
        logger.setLevel(logging.DEBUG)

    if level == "INFO":
        logger.setLevel(logging.INFO)

    if level == "ERROR":
        logger.setLevel(logging.ERROR)

    if level == "CRITICAL":
        logger.setLevel(logging.CRITICAL)

    return


# create directory for py-module's log
def create_directory(name):
    try:
        os.mkdir(path + "log/" + name)
        return True
    except OSError:
        return False


# rename last log's directory by adding current system time
def rename_directory():
    current_time = datetime.datetime.now()
    try:
        os.rename(path + "log", path + "log_" + current_time.strftime("%Y%m%d_%H%M%S"))
    except OSError:
        return


# запись error лога и выброс исключения с сообщением об ошибке
def raise_error(error_message, logger):
    logger.error(error_message)
    raise AssertionError("[ERROR] " + error_message)
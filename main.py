from PyQt5.QtGui import QGuiApplication
from PyQt5.QtCore import QUrl
from PyQt5.QtQml import QQmlApplicationEngine, qmlRegisterType

from gui.qmlForms.DBEditor import DBEditor


def main():
    app = QGuiApplication([])
    engine = QQmlApplicationEngine()
    qmlRegisterType(DBEditor.DBEditor, 'DBEditor', 1, 0, 'DBEditor')
    engine.load(QUrl.fromLocalFile("./gui/qmlForms/MainWindow/MainWindow.qml"))
    app.exec_()


if __name__ == "__main__":
    main()
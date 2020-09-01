import QtQuick 2.14
import QtQuick.Window 2.13
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

import "../../qmlStyles"
import "../Components"

Window {
    id: rootArchiveWindow
    width: 888
    height: 480
    minimumWidth: 888
    minimumHeight: 480
    maximumHeight: 480
    maximumWidth: 888
    title: "Архив"
    color: "#2b3136"
    visible: true
    Column {
        anchors.fill: parent
        TopBarMenu {
            id: barMenu
            anchors.right: parent.right
            anchors.left: parent.left
             ListModel {
                 id: barModel
                 ListElement {
                     imgUsual: "../../images/chart_usual.png"
                     imgHover: "../../images/chart_hover.png"
                 }
                 ListElement {
                     imgUsual: "../../images/delete_bin_usual.png"
                     imgHover: "../../images/delete_bin_hover.png"
                 }

             }

             Connections {
                 target: barMenu
                 onElementClicked: {
                     if (index === 0)
                     {
                        errorMessageDialog.open()
                     }
                 }
             }
        }

        MessageDialog {
            id: errorMessageDialog
            title: "Ошибка сравнения статистик!"
            icon: StandardIcon.Warning
            //text: "Сравнение статистик допустимо только по одному параметру!"
            text: "Сравнение статистик допустимо только при однотипном комментарии!"
        }

        Dialog {
            id: openFewStats
            visible: false
            title: "Сравнение архивных статистик"
            contentItem: Rectangle {
                anchors.fill: parent
                implicitWidth: 250
                implicitHeight: 160
                color: "#2b3136"
                ColumnLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    CustomText {
                        Layout.topMargin: 5
                        text: "Введите имя категории"
                    }
                    TextField {
                        Layout.alignment: Qt.AlignTop
                        implicitWidth: 225
                        text: ""
                        font.pointSize: 12
                        font.family: "Times New Roman"
                    }
                    RowLayout {
                        Layout.alignment: Qt.AlignRight
                        CustomButton {
                            text: "Сравнить"
                            implicitWidth: 90
                            implicitHeight: 30
                        }
                        CustomButton {
                            Layout.leftMargin: 10
                            Layout.rightMargin: 15
                            text: "Отмена"
                            implicitWidth: 90
                            implicitHeight: 30
                        }
                    }
                }
            }
        }

        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            implicitHeight: (testModel.count + 1) * 55
            TableView {
                id: tableView
                verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                anchors.fill: parent
                backgroundVisible: true
                selectionMode: SelectionMode.ExtendedSelection
                ListModel {
                    id: testModel
                    ListElement {
                        date: "2020-05-08 10:46:32"
                        logGroup: "CPU"
                        log: "cpu%%%"
                        pattern: "cpu"
                        parameter: "CPU"
                        comment: "[1] лицо"
                    }
                    ListElement {
                        date: "2020-05-08 11:38:33"
                        logGroup: "CPU"
                        log: "cpu%%%"
                        pattern: "cpu"
                        parameter: "CPU"
                        comment: "[2] лица"
                    }
                    ListElement {
                        date: "2020-05-08 12:42:15"
                        logGroup: "CPU"
                        log: "cpu%%%"
                        pattern: "cpu"
                        parameter: "CPU"
                        comment: "[3] лица"
                    }
                    ListElement {
                        date: "2020-05-08 13:26:53"
                        logGroup: "CPU"
                        log: "cpu%%%"
                        pattern: "cpu"
                        parameter: "CPU"
                        comment: "[4] лица"
                    }
                    ListElement {
                        date: "2020-05-08 13:27:02"
                        logGroup: "CPU"
                        log: "cpu%%%"
                        pattern: "cpu"
                        parameter: "CPU"
                        comment: "4 лица"
                    }
                    ListElement {
                        date: "2020-05-08 16:12:43"
                        logGroup: "MEMORY"
                        log: "mem%%%"
                        pattern: "mem"
                        parameter: "Working set"
                        comment: "Мониторинг памяти"
                    }
                }
                TableViewColumn {
                    role: "date"
                    title: "Дата сохранения"
                    width: rootArchiveWindow.width / 6
                    resizable: false
                    movable: false
                }
                TableViewColumn {
                    role: "logGroup"
                    title: "Группа журналов"
                    width: rootArchiveWindow.width / 6
                    resizable: false
                    movable: false
                }
                TableViewColumn {
                    role: "log"
                    title: "Журнал"
                    width: rootArchiveWindow.width / 6
                    resizable: false
                    movable: false
                }
                TableViewColumn {
                    role: "pattern"
                    title: "Шаблон"
                    width: rootArchiveWindow.width / 6
                    resizable: false
                    movable: false
                }
                TableViewColumn {
                    role: "parameter"
                    title: "Параметр"
                    width: rootArchiveWindow.width / 6
                    resizable: false
                    movable: false
                }
                TableViewColumn {
                    role: "comment"
                    title: "Комментарий"
                    width: rootArchiveWindow.width / 6
                    resizable: false
                    movable: false
                }
                model: testModel
                itemDelegate: Rectangle {
                    border.width: 1
                    color: styleData.selected ? "#A6AAAA" : "#e0e0e0"
                    CustomText {
                        text: styleData.value
                        anchors.centerIn: parent
                        color: "black"
                    }

                }
                rowDelegate: Item {
                    height: 55
                }

                headerDelegate: Rectangle {
                    height: 55
                    color: "#2b3136"
                    border.width: 1
                    CustomText {
                        text: styleData.value
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }
}

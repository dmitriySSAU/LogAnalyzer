import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.2

import "../../qmlStyles"

import "tools.js" as Tools

Rectangle {
    id: sideBarMenu
    property alias viewType: viewTypeCB.currentValue
    property alias paintColor: groupLogCB.currentValue
    property alias isPointsViewChecked: showPointsCB.checked
    property alias isAverageViewChecked: showAverageLineCB.checked
    width: 200
    color: "#2b3136"
    Layout.alignment: Qt.AlignTop
    Layout.fillHeight: true
    ColumnLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 10
        anchors.topMargin: 5
        CustomText {
            text: "Цвет"
        }
        CustomComboBox {
            id: groupLogCB
            Layout.fillHeight: false
            Layout.preferredWidth: width
            enabled: true
            currentIndex: 0
            model: ["red", "blue", "green", "yellow", "pink", "purple", "black"]
            onActivated: {
                if (viewType === "Диаграмма")
                {
                    var barSet = barSeriesView.at(0);
                    barSet.color = currentValue;
                }
            }
        }
        CustomText {
            text: "Вид"
        }
        CustomComboBox {
            id: viewTypeCB
            Layout.fillHeight: false
            Layout.preferredWidth: width
            enabled: true
            currentIndex: 0
            model: ["График", "Таблица", "Диаграмма", "Текст"]
            onActivated: {
                Tools.show(rootWindow.points)
            }
        }
        CheckBox {
            id: showAverageLineCB
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: -8
            CustomText {
                anchors.left: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: "Показывать среднюю"
            }
        }
        CheckBox {
            id: showPointsCB
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: -8
            CustomText {
                anchors.left: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: "Показывать точки"
            }
        }

        // отсекающая серая горизонтальная линия
        Rectangle {
            height: 1
            color: "#6f6f77"
            Layout.fillWidth: true
            Layout.topMargin: 20
            Layout.rightMargin: 10
        }
        CustomText {
            text: "Статистика"
        }
        CustomButton {
            id: showStatButton
            text: "Отобразить"
            visible: viewMode === "real-time" ? true : false
            onClicked: {
                rootWindow.points = [
                          {"X":   0,  "Y": 115},
                          {"X":  -30, "Y": 110},
                          {"X":  -60,  "Y": 99},
                          {"X":  -90, "Y": 83},
                          {"X":  -120, "Y": 75},
                          {"X":  -150, "Y": 70},
                          {"X": -180, "Y":  80},
                          {"X": -210, "Y":  96},
                          {"X": -240, "Y":  112},
                          {"X": -270, "Y":  115},
                          {"X": -300, "Y":  130},
                          {"X": -330, "Y":  150}]
                /* 1 Лицо rootWindow.points = [
                          {"X":   0,  "Y": 115},
                          {"X":  -30, "Y": 103},
                          {"X":  -60,  "Y": 99},
                          {"X":  -90, "Y": 83},
                          {"X":  -120, "Y": 75},
                          {"X":  -150, "Y": 70},
                          {"X": -180, "Y":  80},
                          {"X": -210, "Y":  96},
                          {"X": -240, "Y":  107},
                          {"X": -270, "Y":  105}
                         ] */
                 /* 2 Лица rootWindow.points = [
                          {"X":   0,  "Y": 184},
                          {"X":  -30, "Y": 179},
                          {"X":  -60,  "Y": 174},
                          {"X":  -90, "Y": 150},
                          {"X":  -120, "Y": 148},
                          {"X":  -150, "Y": 167},
                          {"X": -180, "Y":  171},
                          {"X": -210, "Y":  175},
                          {"X": -240, "Y":  173},
                          {"X": -270, "Y":  167}
                         ] */
                /* 4 Лица rootWindow.points = [
                         {"X":   0,  "Y": 367},
                         {"X":  -30, "Y": 361},
                         {"X":  -60,  "Y": 356},
                         {"X":  -90, "Y": 350},
                         {"X":  -120, "Y": 348},
                         {"X":  -150, "Y": 351},
                         {"X": -180, "Y":  349},
                         {"X": -210, "Y":  357},
                         {"X": -240, "Y":  362},
                         {"X": -270, "Y":  360}
                        ] */
                   /*rootWindow.points = [
                        {"X":  4, "Y": 356},
                        {"X":  3,  "Y": 266},
                        {"X":  2, "Y": 168},
                        {"X":   1,  "Y": 93}
                        ] */
                /* Прогноз rootWindow.points = [
                        {"X":  10, "Y": 886},
                        {"X":  9,  "Y": 797},
                       {"X":  8, "Y": 709},
                       {"X":  7,  "Y": 620},
                       {"X":  6, "Y": 531},
                       {"X":   5,  "Y": 443}
                       ] */
                Tools.show()
                viewMode = "stat"
                statInfo = "Всего: 6; Мин: 443; Макс: 886; Среднее: 664"
            }
        }
        Dialog {
            id: saveArhciveDialog
            visible: false
            title: "Сохранение статистики в архив"
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
                        text: "Введите комментарий"
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
                            text: "Сохранить"
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

        Dialog {
            id: showPredictDialog
            visible: false
            title: "Составление прогноза"
            contentItem: Rectangle {
                anchors.fill: parent
                implicitWidth: 320
                implicitHeight: 160
                color: "#2b3136"
                ColumnLayout {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right

                    anchors.leftMargin: 10
                    RowLayout {
                        ColumnLayout {
                            CustomText {
                                Layout.topMargin: 5
                                text: "Конечное значение"
                            }
                            SpinBox {
                                id: timeOutSpinBox
                                Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                                editable: true
                            }
                        }
                        ColumnLayout {
                            Layout.leftMargin: 15
                            CustomText {
                                Layout.topMargin: 5
                                text: "Шаг"
                            }
                            SpinBox {
                                id: timeOutSpinBox1
                                Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                                editable: true
                            }
                        }
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignRight
                        Layout.topMargin: 40
                        CustomButton {
                            text: "Составить"
                            implicitWidth: 90
                            implicitHeight: 30
                        }
                        CustomButton {
                            Layout.leftMargin: 10
                            Layout.rightMargin: 10
                            text: "Отмена"
                            implicitWidth: 90
                            implicitHeight: 30
                        }
                    }
                }
            }
        }

        CustomButton {
            id: saveArchiveButton
            text: "Сохранить в архив"
            visible: viewMode === "real-time" ? false : true
            onClicked: {
                saveArhciveDialog.open()
            }
        }

        CustomButton {
            id: showPredictButton
            text: "Спрогнозировать"
            visible: viewMode === "advanced-stat" ? true : false
            onClicked: {
                showPredictDialog.open()
            }
        }

        CustomButton {
            id: openRealTimeButton
            text: "Анализировать"
            visible: viewMode === "stat" ? true : false
            onClicked: {
                viewMode = "advanced-stat";
                analysisInfo = "Зависимость: линейная";
                equalization = "Уравнение: 88.7x - 1; R-квадрат: 99%"
            }
        }
    }
}

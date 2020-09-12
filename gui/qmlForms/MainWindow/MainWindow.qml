import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12

import DBEditor 1.0

import "../../qmlStyles"
import "../Components"
import "../DBEditor/tools.js" as Tools

Window {
    id: mainWindow
    width: 700
    height: 480
    minimumWidth: 700
    minimumHeight: 480
    maximumHeight: 480
    maximumWidth: 700
    color: "#2b3136"
    title: qsTr("Анализатор журналов")
    visible: true

    DBEditor {
		id: dbEditor
	}

    Loader {
        id: dbEditorMainWimdowLoader
        Connections {
        target: dbEditorMainWimdowLoader
        onSourceChanged: {
            //groupLogCB.model = dbEditor.get_log_groups()
        }
    }
    }
    // основная разметка окна
    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        property var newtest: "NEW"
        // верхнее главное меню
        TopBarMenu {
            id: mainMenu
            color: "#1e1f24"
            ListModel {
                id: barModel
                ListElement {
                    imgUsual: "../../images/patterns_usual.png"
                    imgHover: "../../images/patterns_hover.png"
                }
                ListElement {
                    imgUsual: "../../images/archive_usual.png"
                    imgHover: "../../images/archive_hover.png"
                }
                ListElement {
                    imgUsual: "../../images/settings_usual.png"
                    imgHover: "../../images/settings_hover.png"
                }
                ListElement {
                    imgUsual: "../../images/help_usual.png"
                    imgHover: "../../images/help_hover.png"
                }
            }

            Connections {
                target: mainMenu
                onElementClicked: {
                    if (index === 0)
                        dbEditorMainWimdowLoader.setSource("../DBEditor/DBEditorMainWindow.qml");
                    if (index === 1)
                        archiveWimdowLoader.setSource("../Tables/ArchiveWindow.qml");
                }
            }
        }
        // центральная разметка окна
        RowLayout {
            id: mainCentralRow
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop

            // ПЕРВАЯ КОЛОНКА
            // отображение колонки с настройками по выбору лога
            // и объекта анализа
            ColumnLayout {
                Layout.leftMargin: 10
                CustomText {
                    text: "Группа журналов"
                }
                RowLayout {
                    CustomComboBox {
                        id: groupLogCB
                        Layout.preferredWidth: width
                        currentIndex: -1
                        displayText: currentIndex > -1 ? currentText : "Выберите группу"
                        model: Tools.get_log_groups()
                        onActivated: {
                        }
                    }
                    Image {
                        id: logGroupDescription
                        sourceSize.height: 25
                        sourceSize.width: 25
                        ToolTip.visible: ma1.containsMouse ? true : false
                        //ToolTip.text: groupLogCB.currentValue == undefined ? "Здесь будет отображено описание выбранной группы журналов" : Tools.get_log_group_description(groupLogCB.currentValue)
                        source: ma1.containsMouse ? "../../images/help_hover.png" : "../../images/help_usual.png"
                        MouseArea {
                            id: ma1
                            hoverEnabled: true
                            anchors.fill: parent
                        }
                    }
                }
                CustomText {
                    text: "Журнал"
                }
                RowLayout {
                    CustomComboBox {
                        id: logCB
                        Layout.preferredWidth: width
                        enabled: groupLogCB.currentIndex > -1 ? true: false
                        currentIndex: -1
                        displayText: currentIndex > -1 ? currentText: "Выберите журнал"
                        model: ["cpu%%%"]
                        onActivated: {

                        }
                    }
                    Image {
                        sourceSize.height: 25
                        sourceSize.width: 25
                        ToolTip.visible: ma2.containsMouse ? true: false
                        ToolTip.text: "Индексируемый общий файл нагрузки на ЦП"
                        source: ma2.containsMouse ? "../../images/help_hover.png" : "../../images/help_usual.png"
                        MouseArea {
                            id: ma2
                            hoverEnabled: true
                            anchors.fill: parent
                        }
                    }
                }

                CustomText {
                    text: "Группа шаблонов"
                }
                RowLayout {
                    CustomComboBox {
                        id: analyzeObj
                        Layout.preferredWidth: width
                        enabled: logCB.currentIndex > -1 ? true : false
                        currentIndex: -1
                        displayText: currentIndex > -1 ? currentText: "Выберите группу"
                        model: ["Total cpu", "total", "who"]
                    }
                    Image {
                        sourceSize.height: 25
                        sourceSize.width: 25
                        ToolTip.visible: ma3.containsMouse ? true : false
                        ToolTip.text: "Общая нагрузка сервера на ЦП"
                        source: ma3.containsMouse ? "../../images/help_hover.png" : "../../images/help_usual.png"
                        MouseArea {
                            id: ma3
                            hoverEnabled: true
                            anchors.fill: parent
                        }
                    }
                }
                // Отображение шаблонов для выбранного объекта анализа
                CustomText {
                    id: patternsText
                    text: "Шаблоны"
                }
                ListModel {
                    id: patternsModel

                    ListElement {
                        name: "cpu"
                    }
                    ListElement {
                        name: "cpu1"
                    }



                }
                Rectangle {
                    width: 190
                    Layout.preferredWidth: width
                    height: 170
                    Layout.preferredHeight: height
                    color: "#e0e0e0"
                    ListView {
                        id: patternsListView
                        height: parent.height
                        width: parent.width
                        model: patternsModel
                        delegate: ElementsDelegate {
                            id: testDel
                            property var img1Hover: "../../images/edit_black_hover.png"
                            property var img1Usual: "../../images/edit_black_usual.png"
                            property var img2Hover: "../../images/delete_hover.png"
                            property var img2Usual: "../../images/delete_usual.png"
                            property var img3Hover: "../../images/help_black_hover.png"
                            property var img3Usual: "../../images/help_black_usual.png"
                            property var isPatterns: true
                            Connections {
                                target: ma5
                                onClicked: {
                                    if (isPatterns)
                                        patternsModel.remove(index)
                                }
                            }

                        }
                    }
                }
            }
            // отсекающая серая вертикальная линия
            Rectangle {
                height: 380
                width: 1
                color: "#6f6f77"
                Layout.alignment: Qt.AlignLeft
                Layout.topMargin: 20
                Layout.leftMargin: 10
            }

            // ВТОРАЯ КОЛОНКА
            // отображение панели по настройки запуска
            // выбранного лога и объекта анализа
            ColumnLayout {
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.leftMargin: 10


                CustomText {
                    text: "Продолжительность анализа"
                }
                ComboBox {
                    id: selectTime
                    width: 155
                    Layout.preferredWidth: width
                    font.pointSize: 10
                    font.family: "Times New Roman"
                    currentIndex: -1
                    displayText: currentIndex > -1 ? currentText: "Неограниченно"
                    model: ["30 мин", "1 час", "Неограниченно"]
                }
                RowLayout {
                    CustomButton {
                        text: "Запустить"
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Layout.preferredHeight: 40
                        Layout.topMargin: 23
                        onClicked: {
                            var component = Qt.createComponent("../Charts/RootWindow.qml");
                            var window = component.createObject(mainWindow)
                            window.show()
                        }
                    }
                }
                ListModel {
                    id: currentRunsModel
                    property var img1Hover: "../../images/delete_hover.png"
                    property var img1Usual: "../../images/delete_usual.png"
                    property var img2Hover: ""
                    property var img2Usual: ""
                    property var img3Hover: ""
                    property var img3Usual: ""
                    property var isPatterns: false


                }
                CustomText {
                    text: "Текущие запуски"

                }
                Rectangle {
                    width: 210
                    Layout.preferredWidth: width
                    height: 240
                    Layout.preferredHeight: height
                    color: "#e0e0e0"
                    ListView {
                        id: curentRunsListView
                        property var recWidth: parent.width
                        height: 100
                        width: parent.width
                        model: currentRunsModel
                        delegate: ElementsDelegate {}
                    }
                }
            }

            // отсекающая серая вертикальная линия
            Rectangle {
                height: 380
                width: 1
                color: "#6f6f77"
                Layout.alignment: Qt.AlignLeft
                Layout.topMargin: 20
                Layout.leftMargin: 10
            }

            // ТРЕТЬЯ КОЛОНКА
            // отображение панели с крайними запусками
            ColumnLayout {
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.leftMargin: 10
                CustomText {
                    text: "Крайние запуски"
                }

                ListModel {
                    id: lastRunsModel
                    property var img1Hover: "../../images/start_hover.png"
                    property var img1Usual: "../../images/start_usual.png"
                    property var img2Hover: "../../images/archive_black_hover.png"
                    property var img2Usual: "../../images/archive_black_usual.png"
                    property var img3Hover: "../../images/help_black_hover.png"
                    property var img3Usual: "../../images/help_black_usual.png"
                    property var isPatterns: false

                }
                Rectangle {
                    width: 210
                    Layout.preferredWidth: width
                    height: 170
                    Layout.preferredHeight: height
                    color: "#e0e0e0"
                    ListView {
                        id: lastRunsListView
                        property var recWidth: parent.width
                        height: 100
                        width: parent.width
                        model: lastRunsModel
                        delegate: ElementsDelegate {}
                    }
                }
            }
        }
    }
}

import QtQuick 2.14
import QtQuick.Window 2.13
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.1

import "../../qmlStyles"
import "tools.js" as Tools

Rectangle {
    id: logEditorWindow
    color: "#2b3136"

    property bool editModeLogGroup: false;
    property string currentName: "";

	Connections {
	    target: dbEditor
	    onLogGroupsChanged: {
            var log_groups = Tools.get_log_groups()
            logGroupCB.model = Tools.get_modify_log_groups(log_groups);
            groupLogCB.model = log_groups;
        }
	}

	MessageDialog {
	    id: messageDialog
	    title: ""
	    text: ""
	}

    // основная разметка окна
    RowLayout {
        // ПЕРВАЯ КОЛОНКА с выбором группы лога и лога
        ColumnLayout {
            Layout.alignment: Qt.AlignTop | Qt.AlignBottom
            Layout.topMargin: 10
            Layout.leftMargin: 10
            CustomText {
                text: "Группа журналов"
            }
            // комбобокс выбора группы логов с двумя кнопками
            RowLayout {
                CustomComboBox {
                    id: logGroupCB
                    Layout.preferredWidth: width
                    currentIndex: -1
                    displayText: currentIndex > -1 ? currentText: "Выберите группу"
                    model: Tools.get_modify_log_groups(Tools.get_log_groups())
                    editable: currentIndex == 0 || editModeLogGroup ? true : false
                }
                // кнопка редактирования группы лога
                Image {
                    sourceSize.height: 25
                    sourceSize.width: 25
                    visible: logGroupCB.currentIndex > 0 && editModeLogGroup == false ? true : false
                    ToolTip.visible: editLogGroupMA.containsMouse ? true : false
                    ToolTip.text: "Редактировать"
                    source: editLogGroupMA.containsMouse ? "../../images/edit_hover.png" : "../../images/edit_usual.png"
                    MouseArea {
                        id: editLogGroupMA
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked:  {
                            editModeLogGroup = true
                        }
                    }
                }
                // кнопка удаления группы лога
                Image {
                    sourceSize.height: 25
                    sourceSize.width: 25
                    visible: logGroupCB.currentIndex > 0 && editModeLogGroup == false ? true : false
                    ToolTip.visible: deleteLogGroupMA.containsMouse ? true : false
                    ToolTip.text: "Удалить"
                    source: deleteLogGroupMA.containsMouse ? "../../images/delete_bin_hover.png" : "../../images/delete_bin_usual.png"
                    MouseArea {
                        id: deleteLogGroupMA
                        hoverEnabled: true
                        anchors.fill: parent
                    }
                }
                // кнопка сохранения группы лога
                Image {
                    sourceSize.height: 25
                    sourceSize.width: 25
                    visible: logGroupCB.currentIndex == 0 || editModeLogGroup ? true : false
                    ToolTip.visible: saveLogGroupMA.containsMouse ? true : false
                    ToolTip.text: "Сохранить"
                    source: saveLogGroupMA.containsMouse ? "../../images/save_hover.png" : "../../images/save_usual.png"
                    MouseArea {
                        id: saveLogGroupMA
                        hoverEnabled: true
                        anchors.fill: parent
						onClicked: {
						    var code;
                            var currentIndex = logGroupCB.currentIndex;
						    if (editModeLogGroup)
						    {
                                code = dbEditor.edit_log_group_info(logGroupCB.currentValue, logGroupCB.editText, descriptionLogGroup.text);
                                logGroupCB.currentIndex = currentIndex;
                                editModeLogGroup = false;
						    }
						    else
						        code = dbEditor.create_log_group(logGroupCB.editText, descriptionLogGroup.text);
							messageDialog.title = "Редактирование БД";
							if (code == 0)
							    messageDialog.text = "Группа шаблонов успешно сохранена!";
							else if (code == -1)
							    messageDialog.text = "Группа шаблонов с таким именем уже существует!";
							messageDialog.visible = true;
						}
                    }
                }
            }
            CustomText {
                text: "Описание группы"
            }
            // поле для редактирования описания
            Rectangle {
                id: descriptionLogGroupField
                width: 215
                Layout.preferredWidth: width
                height: 100
                Layout.preferredHeight: height
                color: logGroupCB.currentIndex == 0 || editModeLogGroup ? "white" : "#e0e0e0"
                ScrollView {
                    width: parent.width
                    height: parent.height
                    anchors.fill: parent
                    TextArea  {
                        id: descriptionLogGroup
                        wrapMode: TextEdit.Wrap
                        font.pointSize: 12
                        font.family: "Times New Roman"
                        enabled: logGroupCB.currentIndex == 0 || editModeLogGroup ? true : false
                        text: logGroupCB.currentValue !== undefined && logGroupCB.currentValue !== "Создать группу" && editModeLogGroup == false ? Tools.get_log_group_description(logGroupCB.currentValue) : text
                    }
                }
            }

            // отсекающая серая горизонтальная линия
            Rectangle {
                height: 1
                width: recTextArea1.width
                color: "#6f6f77"
                Layout.alignment: Qt.AlignLeft
                Layout.topMargin: 20
            }

            CustomText {
                text: "Журнал"
            }
            // комбобокс выбора группы логов с двумя кнопками
            RowLayout {
                CustomComboBox {
                    id: editLogCB
                    Layout.preferredWidth: width
                    enabled: logGroupCB.currentIndex > 0 ? true : false
                    currentIndex: -1
                    displayText: currentIndex > -1 ? currentText: "Выберите лог"
                    model: ["Создать лог", "total", "cpu%%%", "ALL"]
                    onActivated: {
                        if (currentIndex == 0)
                        {
                            editLog.editable = true
                            descriptionLog.enabled = true
                            recTextArea2.color = "white"
                        } else {
                            descriptionLog.enabled = false
                            recTextArea2.color = "#e0e0e0"
                            editLog.editable = false
                        }
                    }
                }
                Image {
                    sourceSize.height: 25
                    sourceSize.width: 25
                    visible: editLog.currentIndex <= 0 ? false : true
                    ToolTip {
                        width: 87
                        visible: ma3.containsMouse ? true : false
                        text: "Редактировать"
                    }
                    source: ma3.containsMouse ? "../../images/edit_hover.png" : "../../images/edit_usual.png"
                    MouseArea {
                        id: ma3
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked:  {
                            editLog.editable = true
                            descriptionLog.enabled = true
                            recTextArea2.color = "white"
                        }

                    }
                }
                Image {
                    sourceSize.height: 25
                    sourceSize.width: 25
                    visible: editLog.currentIndex <= 0 ? false : true
                    ToolTip.visible: ma4.containsMouse ? true : false
                    ToolTip.text: "Удалить"
                    source: ma4.containsMouse ? "../../images/delete_bin_hover.png" : "../../images/delete_bin_usual.png"
                    MouseArea {
                        id: ma4
                        hoverEnabled: true
                        anchors.fill: parent
                    }
                }
                Image {
                    sourceSize.height: 25
                    sourceSize.width: 25
                    visible: editLog.currentIndex == 0 ? true : false
                    ToolTip.visible: ma11.containsMouse ? true : false
                    ToolTip.text: "Сохранить"
                    source: ma11.containsMouse ? "../../images/save_hover.png" : "../../images/save_usual.png"
                    MouseArea {
                        id: ma11
                        hoverEnabled: true
                        anchors.fill: parent
                    }
                }
            }
            Text {
                text: "Описание журнала"
                font.weight: Font.DemiBold
                style: Text.Sunken
                font.pointSize: 12
                font.family: "Times New Roman"
                color: "#ddd5d5"
            }
            // поле для редактирования описания
            Rectangle {
                id: recTextArea2
                width: 215
                Layout.preferredWidth: width
                height: 100
                Layout.preferredHeight: height
                color: "#e0e0e0"
                ScrollView {
                    anchors.fill: parent
                    TextArea  {
                        id: descriptionLog
                        wrapMode: TextEdit.Wrap
                        font.pointSize: 12
                        font.family: "Times New Roman"
                        enabled: false
                    }
                }
            }
        }

        // отсекающая серая вертикальная линия
        Rectangle {
            height: 410
            width: 1
            color: "#6f6f77"
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop | Qt.AlignBottom
            Layout.topMargin: 20
            Layout.leftMargin: 10
        }

        // ВТОРАЯ КОЛОНКА с информацией по файлу лога
        ColumnLayout {
            Layout.alignment: Qt.AlignTop | Qt.AlignBottom
            Layout.topMargin: 10
            Layout.leftMargin: 10
            RowLayout {
                ColumnLayout {
                    Text {
                        text: "Путь"
                        font.weight: Font.DemiBold
                        style: Text.Sunken
                        font.pointSize: 12
                        font.family: "Times New Roman"
                        color: "#ddd5d5"
                    }
                    Rectangle {
                        width: 190
                        Layout.preferredWidth: width
                        height: 30
                        Layout.preferredHeight: height
                        color: "#e0e0e0"
                        TextField {
                            anchors.fill: parent
                            text: ""
                            font.pointSize: 12
                            font.family: "Times New Roman"
                        }
                    }
                }
                ColumnLayout {
                    Layout.leftMargin: 20
                    Text {
                        text: "Расширение журнала"
                        font.weight: Font.DemiBold
                        style: Text.Sunken
                        font.pointSize: 12
                        font.family: "Times New Roman"
                        color: "#ddd5d5"
                    }
                    Rectangle {
                        width: 190
                        Layout.preferredWidth: width
                        height: 30
                        Layout.preferredHeight: height
                        color: "#e0e0e0"
                        TextField {
                            anchors.fill: parent
                            text: ""
                            font.pointSize: 12
                            font.family: "Times New Roman"
                            //displayText: "lol"

                        }
                    }
                }
            }
            Text {
                Layout.topMargin: 10
                text: "Режим записи"
                font.weight: Font.DemiBold
                style: Text.Sunken
                font.pointSize: 12
                font.family: "Times New Roman"
                color: "#ddd5d5"
            }
            RowLayout {
                RadioButton {
                    id: radioButtonChart
                    width: 25
                    height: 25
                    checked: true
                    Text {
                        text: "Мнгновенный"
                        font.weight: Font.DemiBold
                        style: Text.Sunken
                        font.pointSize: 12
                        font.family: "Times New Roman"
                        color: "#ddd5d5"
                        anchors.left: parent.right
                        anchors.leftMargin: 2
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                RadioButton {
                    id: radioButtonText
                    width: 25
                    height: 25
                    Layout.leftMargin: 110
                    Text {
                        text: "Постепенный"
                        font.weight: Font.DemiBold
                        style: Text.Sunken
                        font.pointSize: 12
                        font.family: "Times New Roman"
                        color: "#ddd5d5"
                        anchors.left: parent.right
                        anchors.leftMargin: 2
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            RowLayout {
                Layout.topMargin: 10
                CheckBox {
                    id: repeatAnalyzeCheckBox
                    Layout.alignment: Qt.AlignLeft
                }
                Text {
                    Layout.alignment: Qt.AlignLeft
                    text: "Повторять анализ"
                    color: "#ddd5d5"
                    font.pointSize: 12
                    font.family: "Times New Roman"
                    font.weight: Font.DemiBold
                }
                SpinBox {
                    id: timeOutSpinBox
                    Layout.alignment: Qt.AlignLeft
                    Layout.leftMargin: 30
                    editable: true
                    enabled: repeatAnalyzeCheckBox.checkState == Qt.Checked ? true : false
                }
                Image {
                    Layout.alignment: Qt.AlignLeft
                    sourceSize.height: 25
                    sourceSize.width: 25
                    ToolTip.visible: ma5.containsMouse ? true : false
                    ToolTip.text: "Таймаут повторного анализа в секундах"
                    source: ma5.containsMouse ? "../../images/help_hover.png" : "../../images/help_usual.png"
                    MouseArea {
                        id: ma5
                        hoverEnabled: true
                        anchors.fill: parent
                    }
                }
            }

            // отсекающая серая горизонтальная линия
            Rectangle {
                height: 1
                width: 407
                color: "#6f6f77"
                Layout.alignment: Qt.AlignLeft
                Layout.topMargin: 25
            }

            RowLayout {
                Layout.topMargin: 10
                CheckBox {
                    id: withIndexingCheckBox
                    Layout.alignment: Qt.AlignLeft
                }
                Text {
                    Layout.alignment: Qt.AlignLeft
                    text: "Индексирование"
                    color: "#ddd5d5"
                    font.pointSize: 12
                    font.family: "Times New Roman"
                    font.weight: Font.DemiBold
                }
                CheckBox {
                    id: indexCyclingCheckBox
                    Layout.alignment: Qt.AlignLeft
                    Layout.leftMargin: 20
                    enabled: withIndexingCheckBox.checkState == Qt.Checked ? true : false
                }
                Text {
                    Layout.alignment: Qt.AlignLeft
                    text: "Цикл"
                    color: "#ddd5d5"
                    font.pointSize: 12
                    font.family: "Times New Roman"
                    font.weight: Font.DemiBold
                }
            }

            RowLayout {
                ColumnLayout {
                    Text {
                        text: "Имя с индексом"
                        font.weight: Font.DemiBold
                        style: Text.Sunken
                        font.pointSize: 12
                        font.family: "Times New Roman"
                        color: "#ddd5d5"
                    }
                    Rectangle {
                        width: 190
                        Layout.preferredWidth: width
                        height: 30
                        Layout.preferredHeight: height
                        color: "#e0e0e0"
                        TextField {
                            anchors.fill: parent
                            text: ""
                            font.pointSize: 12
                            font.family: "Times New Roman"
                            enabled: withIndexingCheckBox.checkState == Qt.Checked ? true : false
                        }
                    }
                }
                ColumnLayout {
                    Layout.leftMargin: 20
                    Text {
                        text: "Формат индекса"
                        font.weight: Font.DemiBold
                        style: Text.Sunken
                        font.pointSize: 12
                        font.family: "Times New Roman"
                        color: "#ddd5d5"
                    }
                    Rectangle {
                        width: 190
                        Layout.preferredWidth: width
                        height: 30
                        Layout.preferredHeight: height
                        color: "#e0e0e0"
                        TextField {
                            anchors.fill: parent
                            text: ""
                            font.pointSize: 12
                            font.family: "Times New Roman"
                            enabled: withIndexingCheckBox.checkState == Qt.Checked ? true : false
                        }
                    }
                }
            }

            RowLayout {
                Layout.topMargin: 15
                ColumnLayout {
                    Text {
                        Layout.alignment: Qt.AlignLeft
                        text: "Начальное значение"
                        color: "#ddd5d5"
                        font.pointSize: 12
                        font.family: "Times New Roman"
                        font.weight: Font.DemiBold
                    }
                    SpinBox {
                        id: startValSpinBox
                        Layout.alignment: Qt.AlignLeft
                        //Layout.leftMargin: 30
                        editable: true
                        enabled: withIndexingCheckBox.checkState == Qt.Checked ? true : false
                    }
                }
                ColumnLayout {

                    Text {
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 70
                        text: "Конечное значение"
                        color: "#ddd5d5"
                        font.pointSize: 12
                        font.family: "Times New Roman"
                        font.weight: Font.DemiBold
                    }
                    SpinBox {
                        id: endValSpinBox
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 70
                        editable: true
                        enabled: withIndexingCheckBox.checkState == Qt.Checked ? true : false
                    }
                }
            }
        }
    }
}

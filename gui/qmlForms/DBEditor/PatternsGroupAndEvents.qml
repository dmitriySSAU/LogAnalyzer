import QtQuick 2.14
import QtQuick.Window 2.13
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12


Rectangle {
    id: patternGroupAndEventEditorWindow
    color: "#2b3136"

    // основная разметка окна
    RowLayout {
        // ПЕРВАЯ КОЛОНКА с выбором группы шаблонов
        ColumnLayout {
            Layout.alignment: Qt.AlignTop | Qt.AlignBottom
            Layout.topMargin: 10
            Layout.leftMargin: 10
            Text {
                text: "Группа шаблонов"
                font.weight: Font.DemiBold
                style: Text.Sunken
                font.pointSize: 12
                font.family: "Times New Roman"
                color: "#ddd5d5"
            }
            // комбобокс выбора группы шаблонов с двумя кнопками
            RowLayout {
                ComboBox {
                    id: editPatternGroup
                    width: 155
                    Layout.preferredWidth: width
                    font.pointSize: 10
                    font.family: "Times New Roman"
                    enabled: true
                    currentIndex: -1
                    displayText: currentIndex > -1 ? currentText: "Выберите группу"
                    model: ["Создать группу"]
                    onActivated: {
                        if (currentIndex == 0)
                        {
                            editPatternGroup.editable = true
                        } else {
                            editPatternGroup.editable = false
                        }
                    }
                }
                Image {
                    sourceSize.height: 25
                    sourceSize.width: 25
                    visible: editPatternGroup.currentIndex <= 0 ? false : true
                    ToolTip {
                        width: 87
                        visible: ma1.containsMouse ? true : false
                        text: "Редактировать"
                    }
                    source: ma1.containsMouse ? "../../images/edit_hover.png" : "../../images/edit_usual.png"
                    MouseArea {
                        id: ma1
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked:  {
                            editPatternGroup.editable = true
                            descriptionPatterGroup.enabled = true
                            recTextArea1.color = "white"
                        }

                    }
                }
                Image {
                    sourceSize.height: 25
                    sourceSize.width: 25
                    visible: editPatternGroup.currentIndex <= 0 ? false : true
                    ToolTip.visible: ma2.containsMouse ? true : false
                    ToolTip.text: "Удалить"
                    source: ma2.containsMouse ? "../../images/delete_bin_hover.png" : "../../images/delete_bin_usual.png"
                    MouseArea {
                        id: ma2
                        hoverEnabled: true
                        anchors.fill: parent
                    }
                }
                Image {
                    sourceSize.height: 25
                    sourceSize.width: 25
                    visible: editPatternGroup.currentIndex == 0 ? true : false
                    ToolTip.visible: ma10.containsMouse ? true : false
                    ToolTip.text: "Сохранить"
                    source: ma10.containsMouse ? "../../images/save_hover.png" : "../../images/save_usual.png"
                    MouseArea {
                        id: ma10
                        hoverEnabled: true
                        anchors.fill: parent
                    }
                }
            }
            Text {
                text: "Описание группы"
                font.weight: Font.DemiBold
                style: Text.Sunken
                font.pointSize: 12
                font.family: "Times New Roman"
                color: "#ddd5d5"
            }


            // поле для редактирования описания
            Rectangle {
                id: recTextArea1
                width: 215
                Layout.preferredWidth: width
                height: 100
                Layout.preferredHeight: height
                color: descriptionPatterGroup.enabled ? "white" : "#e0e0e0"
                ScrollView {
                    width: parent.width
                    height: parent.height
                    anchors.fill: parent
                    TextArea  {
                        id: descriptionPatterGroup
                        wrapMode: TextEdit.Wrap
                        font.pointSize: 12
                        font.family: "Times New Roman"
                        enabled: editPatternGroup.editable
                    }
                }
            }


            Text {
                text: "Шаблоны"
                font.weight: Font.DemiBold
                style: Text.Sunken
                font.pointSize: 12
                font.family: "Times New Roman"
                color: "#ddd5d5"
            }
            // комбобокс выбора шаблонов с двумя кнопками
            RowLayout {
                ComboBox {
                    id: listPatterns
                    width: 155
                    Layout.preferredWidth: width
                    font.pointSize: 10
                    font.family: "Times New Roman"
                    enabled: true
                    currentIndex: -1
                    displayText: currentIndex > -1 ? currentText: "Выберите шаблон"
                    model: ["cpu"]
                    onActivated: {
                        if (currentIndex == 0)
                        {

                        } else {

                        }
                    }
                }
                Image {
                    sourceSize.height: 25
                    sourceSize.width: 25
                    visible: listPatterns.currentIndex < 0 ? false : true
                    ToolTip {
                        width: 87
                        visible: ma5.containsMouse ? true : false
                        text: "Редактировать"
                    }
                    source: ma5.containsMouse ? "../../images/add_hover.png" : "../../images/add_usual.png"
                    MouseArea {
                        id: ma5
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked:  {
                        }

                    }
                }
                Image {
                    sourceSize.height: 25
                    sourceSize.width: 25
                    visible: false
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
                        }

                    }
                }

                Image {
                    sourceSize.height: 25
                    sourceSize.width: 25
                    visible: listPatterns.currentIndex < 0 ? false : true
                    ToolTip.visible: ma4.containsMouse ? true : false
                    ToolTip.text: "Описание шаблона"
                    source: ma4.containsMouse ? "../../images/help_hover.png" : "../../images/help_usual.png"
                    MouseArea {
                        id: ma4
                        hoverEnabled: true
                        anchors.fill: parent
                    }
                }
            }

            ListModel {
                id: stringsModel
                property var img1Hover: "../../images/edit_black_hover.png"
                property var img1Usual: "../../images/edit_black_usual.png"
                property var img2Hover: "../../images/delete_hover.png"
                property var img2Usual: "../../images/delete_usual.png"
                property var img3Hover: "../../images/help_black_hover.png"
                property var img3Usual: "../../images/help_black_usual.png"
                property var showCheckBox: false
                ListElement {
                    name: "cpu"
                }
            }
            Rectangle {
                Layout.topMargin: 10
                width: 215
                Layout.preferredWidth: width
                height: 125
                Layout.preferredHeight: height
                color: "#e0e0e0"
                ListView {
                    id: stringsListView
                    height: parent.height
                    width: parent.width
                    model: stringsModel
                    delegate: StringsDelegate {}
                }
            }
        }

        // отсекающая серая вертикальная линия
        Rectangle {
            height: 395
            width: 1
            color: "#6f6f77"
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop | Qt.AlignBottom
            Layout.topMargin: 20
            Layout.leftMargin: 10
        }
    }
}

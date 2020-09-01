import QtQuick 2.14
import QtQuick.Window 2.13
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12

Rectangle {
    id: patternEditorWindow
    color: "#2b3136"

    // основная разметка окна
    RowLayout {
        // ПЕРВАЯ КОЛОНКА с выбором шаблона
        ColumnLayout {
            Layout.alignment: Qt.AlignTop | Qt.AlignBottom
            Layout.topMargin: 10
            Layout.leftMargin: 10
            Text {
                text: "Шаблон"
                font.weight: Font.DemiBold
                style: Text.Sunken
                font.pointSize: 12
                font.family: "Times New Roman"
                color: "#ddd5d5"
            }
            // комбобокс выбора шаблона с двумя кнопками
            RowLayout {
                ComboBox {
                    id: editPattern
                    width: 155
                    Layout.preferredWidth: width
                    font.pointSize: 10
                    font.family: "Times New Roman"
                    enabled: true
                    currentIndex: -1
                    displayText: currentIndex > -1 ? currentText: "Выберите шаблон"
                    model: ["Создать шаблон", "cpu", "memory%%%", "memory_total"]
                    onActivated: {
                        if (currentIndex == 0)
                        {
                            descriptionPattern.enabled = true
                            recTextArea1.color = "white"
                            //recTextArea2.color = "white"
                            editPattern.editable = true
                        } else {
                            descriptionPattern.enabled = false
                            recTextArea1.color = "#e0e0e0"
                            //recTextArea2.color = "#e0e0e0"
                            editPattern.editable = false
                        }
                    }
                }
                Image {
                    sourceSize.height: 25
                    sourceSize.width: 25
                    visible: editPattern.currentIndex <= 0 ? false : true
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
                            editPattern.editable = true
                            descriptionPattern.enabled = true
                            recTextArea1.color = "white"
                        }
                    }
                }
                Image {
                    sourceSize.height: 25
                    sourceSize.width: 25
                    visible: editPattern.currentIndex <= 0 ? false : true
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
                    visible: editPattern.currentIndex == 0 ? true : false
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
                text: "Описание шаблона"
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
                color: "#e0e0e0"
                ScrollView {
                    width: parent.width
                    height: parent.height
                    anchors.fill: parent
                    TextArea  {
                        id: descriptionPattern
                        wrapMode: TextEdit.Wrap
                        font.pointSize: 12
                        font.family: "Times New Roman"
                        enabled: false
                    }
                }
            }

            Text {
                text: "Строки"
                font.weight: Font.DemiBold
                style: Text.Sunken
                font.pointSize: 12
                font.family: "Times New Roman"
                color: "#ddd5d5"
            }
            ListModel {
                id: stringsModel
                property var img1Hover: "../../images/delete_hover.png"
                property var img1Usual: "../../images/delete_usual.png"
                property var showCheckBox: true
                ListElement {
                    name: "SUMM CPU"
                }
            }
            Rectangle {
                width: 215
                Layout.preferredWidth: width
                height: 180
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

        // ВТОРАЯ КОЛОНКА с редактированием строк
        ColumnLayout {
            Layout.alignment: Qt.AlignTop | Qt.AlignBottom
            Layout.topMargin: 10
            Layout.leftMargin: 10
            Layout.rightMargin: 50
            RowLayout {
                ColumnLayout {
                    Layout.alignment: Qt.AlignTop
                    Layout.preferredWidth: 215
                    Text {
                        text: "Строки"
                        font.weight: Font.DemiBold
                        style: Text.Sunken
                        font.pointSize: 12
                        font.family: "Times New Roman"
                        color: "#ddd5d5"
                    }
                    RowLayout {
                        Layout.alignment: Qt.AlignTop
                        ComboBox {
                            id: editStrings
                            width: 155
                            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                            Layout.preferredWidth: width
                            font.pointSize: 10
                            font.family: "Times New Roman"
                            enabled: true
                            currentIndex: -1
                            displayText: currentIndex > -1 ? currentText: "Выберите строку"
                            model: ["Создать новую", "SUMM CPU", "Строка 2"]
                            onActivated: {
                                if (currentIndex == 0)
                                {
                                    editStrings.editable = true
                                } else {

                                }
                            }
                        }
                        Image {
                            sourceSize.height: 25
                            sourceSize.width: 25
                            visible: editStrings.currentIndex <= 0 ? false : true
                            ToolTip.visible: ma3.containsMouse ? true : false
                            ToolTip.text: "Описание строки"
                            source: ma3.containsMouse ? "../../images/edit_hover.png" : "../../images/edit_usual.png"
                            MouseArea {
                                id: ma3
                                hoverEnabled: true
                                anchors.fill: parent
                            }
                        }
                        Image {
                            sourceSize.height: 25
                            sourceSize.width: 25
                            visible: editStrings.currentIndex == 0 ? true : false
                            ToolTip.visible: ma12.containsMouse ? true : false
                            ToolTip.text: "Сохранить"
                            source: ma12.containsMouse ? "../../images/save_hover.png" : "../../images/save_usual.png"
                            MouseArea {
                                id: ma12
                                hoverEnabled: true
                                anchors.fill: parent
                            }
                        }

                    }
                    Button {
                        text: "Добавить в шаблон"
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Layout.topMargin: 25
                        Layout.preferredHeight: 40
                    }
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignTop
                    Text {
                        text: "Информация"
                        font.weight: Font.DemiBold
                        style: Text.Sunken
                        font.pointSize: 12
                        font.family: "Times New Roman"
                        color: "#ddd5d5"
                    }
                    ListModel {
                        id: infoModel
                        property var img1Hover: "../../images/delete_hover.png"
                        property var img1Usual: "../../images/delete_usual.png"
                        property var showCheckBox: false
                        ListElement {
                            name: "SUMM"
                        }

                    }
                    Rectangle {
                        width: 190
                        Layout.preferredWidth: width
                        height: 140
                        Layout.preferredHeight: height
                        color: "#e0e0e0"
                        ListView {
                            id: infoListView
                            height: parent.height
                            width: parent.width
                            model: infoModel
                            delegate: StringsDelegate {}
                        }
                    }
                }
            }

            // отсекающая серая горизонтальная линия
            Rectangle {
                height: 1
                width: 410
                color: "#6f6f77"
                Layout.alignment: Qt.AlignLeft
                Layout.topMargin: 25
            }
            Text {
                text: "Полезная информация"
                font.weight: Font.DemiBold
                style: Text.Sunken
                font.pointSize: 12
                font.family: "Times New Roman"
                color: "#ddd5d5"
            }
            RowLayout {
                Layout.alignment: Qt.AlignTop
                ComboBox {
                    id: editInfo
                    width: 155
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.preferredWidth: width
                    font.pointSize: 10
                    font.family: "Times New Roman"
                    enabled: true
                    currentIndex: -1
                    displayText: currentIndex > -1 ? currentText: "Выберите информацию"
                    model: ["Создать новую", "Информация 1", "Информация 2"]
                    onActivated: {
                        if (currentIndex == 0)
                        {
                            editInfo.editable = true
                        } else {
                            editInfo.editable = false
                        }
                    }
                }
                Image {
                    Layout.alignment: Qt.AlignLeft
                    sourceSize.height: 25
                    sourceSize.width: 25
                    visible: editInfo.currentIndex <= 0 ? false : true
                    ToolTip.visible: ma4.containsMouse ? true : false
                    ToolTip.text: "Описание информации"
                    source: ma4.containsMouse ? "../../images/edit_hover.png" : "../../images/edit_usual.png"
                    MouseArea {
                        id: ma4
                        hoverEnabled: true
                        anchors.fill: parent
                    }
                }
                Item {
                    width: 25
                    height: 25
                    Image {
                        //Layout.alignment: Qt.AlignLeft
                        sourceSize.height: 25
                        sourceSize.width: 25
                        visible: editInfo.currentIndex == 0 ? true : false
                        ToolTip.visible: ma13.containsMouse ? true : false
                        ToolTip.text: "Сохранить"
                        source: ma13.containsMouse ? "../../images/save_hover.png" : "../../images/save_usual.png"
                        MouseArea {
                            id: ma13
                            hoverEnabled: true
                            anchors.fill: parent
                        }
                    }
                }


                CheckBox {
                    id: isKeyWord
                    //enabled: false
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    Layout.leftMargin: 30
                }
                Text {
                    text: "Ключевое слово"
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    color: "#ddd5d5"
                    font.pointSize: 12
                    font.family: "Times New Roman"
                    font.weight: Font.DemiBold
                }

            }

            RowLayout {
                Layout.topMargin: 10
                ColumnLayout {
                    Text {
                        text: "Начало"
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
                            //enabled: false
                            anchors.fill: parent
                            font.pointSize: 12
                            font.family: "Times New Roman"
                        }
                    }
                }
                ColumnLayout {
                    Layout.leftMargin: 20
                    Text {
                        text: "Конец"
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
                            //enabled: false
                            anchors.fill: parent
                            font.pointSize: 12
                            font.family: "Times New Roman"

                        }
                    }
                }
            }

            Text {
                text: "Тип данных"
                font.weight: Font.DemiBold
                style: Text.Sunken
                font.pointSize: 12
                font.family: "Times New Roman"
                color: "#ddd5d5"
            }
            RowLayout {
                Layout.alignment: Qt.AlignTop
                ComboBox {
                    id: dataType
                    width: 155
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.preferredWidth: width
                    font.pointSize: 10
                    font.family: "Times New Roman"
                    //enabled: false
                    currentIndex: -1
                    displayText: currentIndex > -1 ? currentText: "Выберите тип данных"
                    model: ["int", "string"]
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
                    ToolTip.visible: ma5.containsMouse ? true : false
                    ToolTip.text: "Тип данных влияет на варианты отображения информации."
                    source: ma5.containsMouse ? "../../images/help_hover.png" : "../../images/help_usual.png"
                    MouseArea {
                        id: ma5
                        hoverEnabled: true
                        anchors.fill: parent
                    }
                }
                Button {
                    text: "Добавить в строку"
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.leftMargin: 25
                    Layout.preferredHeight: 40
                    //enabled: false
                }
            }
        }
    }
}


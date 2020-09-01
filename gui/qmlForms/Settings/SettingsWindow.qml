import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12

import "../../qmlStyles"

Window {
    id: mainWindow
    width: 700
    height: 480
    minimumWidth: 700
    minimumHeight: 480
    maximumHeight: 480
    maximumWidth: 700
    color: "#2b3136"
    title: qsTr("Настройки приложения")
    visible: true

    // основная разметка окна
    ColumnLayout {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.topMargin: 10
        CustomText {
            text: "Корневой путь к журналам"
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
        CustomText {
            text: "Автосохранение в архив"
        }
        CheckBox {
            id: withIndexingCheckBox
            Layout.alignment: Qt.AlignLeft
        }
        CustomButton {
            text: "Сохранить"
        }
    }
}

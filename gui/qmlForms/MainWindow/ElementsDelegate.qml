import QtQuick 2.0
import QtQuick.Layouts 1.3


// Компонент для отображения списка моделей
// с именем и тремя иконками
RowLayout {
    property alias ma5: ma5

    id: myRow
    anchors.left: parent.left
    anchors.right: parent.right
    Text  {
        id: patternText
        text: name
        font.pointSize: 10
        font.family: "Times New Roman"
        Layout.alignment: Qt.AlignVCenter
        Layout.leftMargin: 5
    }

    Row {
        Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        Image {
            id: patternEditImg
            sourceSize.height: 25
            sourceSize.width: 25
            source: ma4.containsMouse ? img1Hover : img1Usual
            MouseArea {
                id: ma4
                anchors.fill: parent
                hoverEnabled: true
            }
        }
        Image {
            id: patternDeleteImg
            sourceSize.height: 25
            sourceSize.width: 25
            source: ma5.containsMouse ? img2Hover : img2Usual
            MouseArea {
                id: ma5
                anchors.fill: parent
                hoverEnabled: true

            }
        }
        Image {
            id: patternHelpImg
            sourceSize.height: 25
            sourceSize.width: 25
            source: ma6.containsMouse ? img3Hover : img3Usual
            MouseArea {
                id: ma6
                anchors.fill: parent
                hoverEnabled: true
            }
        }
    }
}



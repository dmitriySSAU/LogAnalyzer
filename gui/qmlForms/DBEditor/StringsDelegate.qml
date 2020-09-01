import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12


RowLayout {
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
        CheckBox {
            id: repeatAnalyzeCheckBox
            indicator.width: 20
            indicator.height: 20
            visible: myRow.ListView.view.model.showCheckBox
        }

        Image {
            id: patternEditImg
            sourceSize.height: 25
            sourceSize.width: 25
            anchors.verticalCenter: parent.verticalCenter
            source: ma1.containsMouse ? myRow.ListView.view.model.img1Hover : myRow.ListView.view.model.img1Usual
            MouseArea {
                id: ma1
                anchors.fill: parent
                hoverEnabled: true
            }
        }
        Image {
            id: patternDeleteImg
            sourceSize.height: 25
            sourceSize.width: 25
            //anchors.right: patternHelpImg.left
            source: ma2.containsMouse ? myRow.ListView.view.model.img2Hover : myRow.ListView.view.model.img2Usual
            MouseArea {
                id: ma2
                anchors.fill: parent
                hoverEnabled: true
            }
        }
        Image {
            id: patternHelpImg
            sourceSize.height: 25
            sourceSize.width: 25
            //anchors.right: rootPatternImgItem.right
            source: ma3.containsMouse ? myRow.ListView.view.model.img3Hover : myRow.ListView.view.model.img3Usual
            MouseArea {
                id: ma3
                anchors.fill: parent
                hoverEnabled: true
            }
        }

    }
}


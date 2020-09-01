import QtQuick 2.0
import QtQuick.Layouts 1.3

Rectangle {
    signal elementClicked(var index)
    Layout.fillWidth: true
    height: 55
    color: "#1e1f24"
    Rectangle {
        height: 1
        color: "#6f6f77"
        transformOrigin: Item.Center
        anchors.top: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }

    ListView {
        anchors.fill: parent
        orientation: ListView.Horizontal
        model: barModel
        delegate: Image {
            sourceSize.height: 50
            sourceSize.width: 50
            source: ma1.containsMouse ? imgHover : imgUsual
            MouseArea {
                id: ma1
                hoverEnabled: true
                anchors.fill: parent
                onClicked: { elementClicked(index) }
            }
        }
    }
}

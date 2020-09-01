import QtQuick 2.0
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3


Window {
    id: logEditorWindow
    width: 680
    height: 500
    minimumWidth: 680
    minimumHeight: 500
    maximumHeight: 500
    maximumWidth: 680
    modality: Qt.ApplicationModal
    color: "#2b3136"
    title: qsTr("Окно редактирования базы данных")
	visible: true

	onClosing: {
	    //dbEditorMainWimdowLoader.source = ""
	}
	

    ColumnLayout {
        TabBar {
            id: tabBar
            width: logEditorWindow.width
            Layout.preferredWidth: logEditorWindow.width
            TabButton {
                id: control
                text: qsTr("Журналы")
            }
            TabButton {
                text: qsTr("Шаблоны")
            }
            TabButton {
                text: qsTr("Группы шаблонов")
            }

            onCurrentIndexChanged: {
                switch (currentIndex)
                {
                case 0:
                    loader.source = "LogEditor.qml"
                    break;
                case 1:
                    loader.source = "PatternEditor.qml"
                    break;
                case 2:
                    loader.source = "PatternsGroupAndEvents.qml"
                    break;
                }
            }
        }
        Loader {
            id: loader
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 1
            source: "LogEditor.qml"
        }
    }
}

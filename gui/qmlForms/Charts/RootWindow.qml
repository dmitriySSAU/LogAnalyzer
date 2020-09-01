import QtQuick 2.14
import QtCharts 2.3
import QtQuick.Window 2.13
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import "../../qmlStyles"

import "tools.js" as Tools

Window {
    id: rootWindow
    property var points: []
    property var viewMode: "real-time"
    property var infoName: "[CPU] cpu%%%: Total"
    property var statInfo: ""
    property var analysisInfo: ""
    property var equalization: ""
    width: 500
    height: 460
    color: "#1e1f24"
    title: "Отображение результатов"
    RowLayout {
        anchors.fill: parent

        SideBarMenu {
            id: sideBarMenu
            visible: false
            height: parent.height
        }
        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 10
            Layout.leftMargin: 5
            Layout.rightMargin: 0
            Image {
                sourceSize.height: 25
                sourceSize.width: 25
                source: settings_img_ma.containsMouse ? "../../images/settings_hover.png" : "../../images/settings_usual.png"
                MouseArea {
                    id: settings_img_ma
                    hoverEnabled: true
                    anchors.fill: parent
                    onClicked: {
                        if (sideBarMenu.visible)
                        {
                            rootWindow.width = rootWindow.width - sideBarMenu.width
                            sideBarMenu.visible = false
                        } else {
                            rootWindow.width = rootWindow.width + sideBarMenu.width
                            sideBarMenu.visible = true
                        }
                    }
                }
            }
            Image {
                sourceSize.height: 25
                sourceSize.width: 25
                source: resumeAnalyzeButton.containsMouse ? "../../images/pause_hover.png" : "../../images/pause_usual.png"
                //visible: viewMode === "real-time" ? false : true
                MouseArea {
                    id: resumeAnalyzeButton
                    hoverEnabled: true
                    anchors.fill: parent
                    onClicked: {
                        rootWindow.points = [
                                  {"X":   0,  "Y": 150},
                                  {"X":  -30, "Y": 180},
                                  {"X":  -60, "Y": 115},
                                  {"X":  -90, "Y": 112},
                                  {"X": -120, "Y":  96},
                                  {"X": -150, "Y":  80},
                                  {"X": -180, "Y":  30}]
                        Tools.show()
                        viewMode = "real-time"
                        statInfo = ""
                        analysisInfo = ""
                        equalization = ""
                    }
                }
            }
        }

        RootChart {
            id: rootChart
            Layout.fillHeight: parent.height
            Layout.fillWidth: parent.width
            visible: sideBarMenu.viewType === "Текст" || sideBarMenu.viewType === "Таблица" ? false : true

            CustomChartLineSeries {
                id: lineSeriesMainView
                visible: sideBarMenu.viewType === "График" ? true : false
                axisX: rootChart.axisX
                axisYRight: rootChart.axisY
                color: sideBarMenu.paintColor
            }

            CustomChartScatterSeries {
                id: pointsView
                color: sideBarMenu.paintColor
                visible: sideBarMenu.isPointsViewChecked && sideBarMenu.viewType === "График" ? true : false
            }

            CustomChartLineSeries {
                id: lineSeriesAverageView
                axisX: rootChart.axisX
                axisYRight: rootChart.axisY
                style: Qt.DashLine
                color: sideBarMenu.paintColor
                visible: sideBarMenu.isAverageViewChecked ? true : false
                XYPoint { x: -270; y: 103 }
                XYPoint { x: 0; y: 103 }
            }

            CustomChartBarSeries {
                id: barSeriesView
                visible: sideBarMenu.viewType === "Диаграмма" ? true : false
                axisX: rootChart.barAxisX
                axisY: rootChart.axisY
                labelsVisible: true
            }
        }

        // поле для редактирования описания
        Rectangle {
            id: recTextArea1
            Layout.fillHeight: parent.height
            Layout.fillWidth: parent.width
            Layout.topMargin: 10
            Layout.rightMargin: 10
            Layout.bottomMargin: 10
            visible: sideBarMenu.viewType === "Текст" ? true : false
            color: "#e0e0e0"
            ScrollView {
                width: parent.width
                height: parent.height
                anchors.fill: parent
                verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                TextArea  {
                    id: descriptionLogGroup
                    wrapMode: TextEdit.Wrap
                    width: recTextArea1.width
                    height: recTextArea1.height
                    text: "Время: 0; CPU: 70\nВремя: -30; CPU: 80\n" +
                          "Время: -60; CPU: 96\nВремя: -90; CPU: 112\n" +
                          "Время: -90; CPU: 112\nВремя: -120; CPU: 115\n" +
                          "Время: -120; CPU: 115\nВремя: -150; CPU: 150\n" +
                          "Время: -180; CPU: 130"
                    textColor: sideBarMenu.paintColor
                    font.pointSize: 12
                    font.family: "Times New Roman"
                    enabled: false

                }
            }
        }

        ListModel {
            id: testModel
            ListElement {
                x: "0"
                y: "70"
            }
            ListElement {
                x: "-30"
                y: "80"
            }
            ListElement {
                x: "-60"
                y: "96"
            }
            ListElement {
                x: "-90"
                y: "112"
            }
            ListElement {
                x: "-120"
                y: "115"
            }
            ListElement {
                x: "-150"
                y: "150"
            }
            ListElement {
                x: "-180"
                y: "130"
            }
        }

        Item {
            id: tableViewItem
            Layout.fillWidth: parent.width
            Layout.topMargin: 10
            Layout.rightMargin: 20
            Layout.alignment: Qt.AlignTop
            //Layout.bottomMargin: 10
            visible: sideBarMenu.viewType === "Таблица" ? true : false
            implicitHeight: (testModel.count + 1) * 55
            TableView {
                id: tableView
                verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
                anchors.fill: parent
                backgroundVisible: true
                selectionMode: SelectionMode.ExtendedSelection

                TableViewColumn {
                    role: "x"
                    title: "Время"
                    width: tableViewItem.width / 2
                    resizable: false
                    movable: false
                }
                TableViewColumn {
                    role: "y"
                    title: "CPU"
                    width: tableViewItem.width / 2
                    resizable: false
                    movable: false
                }
                model: testModel
                itemDelegate: Rectangle {
                    border.width: 1
                    color: styleData.selected ? "#A6AAAA" : "#e0e0e0"
                    CustomText {
                        text: styleData.value
                        anchors.centerIn: parent
                        color: sideBarMenu.paintColor
                    }

                }
                rowDelegate: Item {
                    height: 55
                }

                headerDelegate: Rectangle {
                    height: 55
                    color: "#2b3136"
                    border.width: 1
                    CustomText {
                        text: styleData.value
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }
    Component.onCompleted: {
        points = [
            {"X": 0, "Y":  70},
            {"X": -30, "Y":  80},
            {"X": -60, "Y":  96},
            {"X":  -90, "Y": 112},
            {"X":  -120, "Y": 115},
            {"X":  -150, "Y": 130},
            {"X":   -180,  "Y": 150}
        ]
        Tools.show()
    }
}

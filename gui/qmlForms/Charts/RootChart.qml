import QtQuick 2.0
import QtCharts 2.3
import QtQuick.Layouts 1.3

import "../../qmlStyles"


CustomChartView {
    property alias axisX: axisX
    property alias axisY: axisY
    property alias barAxisX: barAxisX
    title:  infoName + "<br><br> " + statInfo + "<br>" + analysisInfo + "<br>" + equalization

    CustomChartAxis {
        id: axisX
        min: -180
        max: 0
        visible: sideBarMenu.viewType === "График" ? true : false
        titleText: "<p style='font-family:Times new Roman; color: #ddd5d5; font-size: 14'>Время</p>"
    }

    CustomChartAxis {
        id: axisY
        min: 0
        max: 500
        titleText: "<p style='font-family:Times new Roman; color: #ddd5d5; font-size: 14'>CPU</p>"
        visible: sideBarMenu.viewType === "Диаграмма" || sideBarMenu.viewType === "График" ? true : false
    }

    CustomChartBarAxis {
        id: barAxisX
        visible: sideBarMenu.viewType === "Диаграмма" ? true : false
        titleText: "<p style='font-family:Times new Roman; color: #ddd5d5; font-size: 14'>Количество лиц</p>"
    }
}


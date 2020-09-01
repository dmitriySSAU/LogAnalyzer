import QtQuick 2.0
import QtCharts 2.3

ScatterSeries {
    color: "red"
    pointLabelsColor: "#ddd5d5"
    pointLabelsVisible: true
    pointLabelsFormat: "      @yPoint"
    pointLabelsClipping: false
    pointLabelsFont.family: "Times New Roman"
    pointLabelsFont.weight: Font.DemiBold
    pointLabelsFont.pointSize: 10
    markerSize: 10.0
}

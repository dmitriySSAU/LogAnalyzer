function show()
{
    if (sideBarMenu.viewType === "График")
    {
        showLineSeries()
        showScatterSeries()
    }
    if (sideBarMenu.viewType === "Диаграмма")
    {
        showBarSeries()
    }
    changeAxisInterval()
}

function showLineSeries()
{
    if (lineSeriesMainView.count !== 0)
        lineSeriesMainView.removePoints(0, lineSeriesMainView.count)

    rootWindow.points.forEach(function(point) {
        lineSeriesMainView.append(point['X'], point['Y'])
    });
}

function showScatterSeries()
{
    if (pointsView.count !== 0)
        pointsView.removePoints(0, pointsView.count)

    rootWindow.points.forEach(function(point) {
        pointsView.append(point['X'], point['Y'])
    });
}

function showBarSeries()
{
    var axisYValues = []
    var axisXValues = []
    rootWindow.points.forEach(function(point) {
        axisYValues.unshift(point['Y'])
        axisXValues.unshift(point['X'])
    });

    barSeriesView.clear();
    rootChart.barAxisX.categories = axisXValues;
    var barSet = barSeriesView.append("", axisYValues);
    barSet.color = sideBarMenu.paintColor;
}

function changeAxisInterval()
{
    if (rootWindow.points.count === 0)
        return;

    var minX = 0;
    var maxX = 0;
    var minY = 0;
    var maxY = 0;
    rootWindow.points.forEach(function(point) {
        if (point['X'] > maxX)
            maxX = point['X'];
        if (point['X'] < minX)
            minX = point['X'];
        if (point['Y'] > maxY)
            maxY = point['Y'];
        if (point['Y'] < minY)
            minY = point['Y'];
    });

    rootChart.axisX.min = minX;
    rootChart.axisX.max = maxX;
    //rootChart.axisY.min = minY;
    //rootChart.axisY.max = maxY;
}



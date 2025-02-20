import QtQuick 2.7
import QtCharts 2.0
import QtQuick.Controls 2.15

Item {
    width: 1024
    height: 343

    property var distance: distanceRaw
    property var plotdata: voltageRaw
    property int timestep: 0
    property double movetoleft: cursorleft

    onPlotdataChanged: {
        try {
            console.log("Extracted voltages:", plotdata);
            console.log("Extracted distances:", distance);

            if (plotdata && distance && plotdata.length === distance.length) {
                for (var i = 0; i < plotdata.length; i++) {
                    var Amplitude = plotdata[i];
                    var currentDistance = distance[i];

                    if (!isFinite(Amplitude) || !isFinite(currentDistance)) {
                        console.log("Invalid data at index:", i, "Amplitude:", Amplitude, "Distance:", currentDistance);
                        continue;
                    }
                    timestep++;
                    series1.append(currentDistance, Amplitude);
                }
                var validDistances = distance.filter(isFinite);
                if (validDistances.length > 0) {
                    axisX.min = Math.min.apply(null, validDistances);
                    axisX.max = Math.max.apply(null, validDistances);
                }

                var validPlotdata = plotdata.filter(isFinite);
                if (validPlotdata.length > 0) {
                    axisY.min = Math.min.apply(null, validPlotdata);
                    axisY.max = Math.max.apply(null, validPlotdata);
                }
            } else {
                console.log("Mismatch in data length or data is missing");
            }
        } catch (e) {
            console.log("Error:", e);
        }
    }

    ChartView {
        id: chartView
        anchors.fill: parent
        anchors.leftMargin: 0
        anchors.topMargin: 44
        anchors.bottomMargin: 0
        backgroundColor: "#000000"
        legend.labelColor: "white"
        ValueAxis {
            id: axisX
            min: 0
            max: 100
            tickCount: 10
            titleText: "<font color='#ffffff'>Distance (Km)<12>"
            titleFont.bold: true
            titleFont.pixelSize: 12
            labelsVisible: true
            gridVisible: false
            color: "#ffffff"
            labelsColor: "#ffffff"
            labelsFont.pixelSize: 10

        }
        ValueAxis {
            id: axisY
            min: 0
            max: 3000
            titleText: "<font color='#ffffff'>Voltage (mV)<12>"
            titleFont.bold: true
            titleFont.pixelSize: 12
            labelsVisible: true
            gridVisible: false
            color: "#ffffff"
            labelsColor: "#ffffff"
            labelsFont.pixelSize: 10
        }

        LineSeries {
            id: series1
            axisX: axisX
            axisY: axisY
            name: "Phase A"
            color: "#ff0000"
        }



    }
}

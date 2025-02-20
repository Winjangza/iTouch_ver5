import QtQuick 2.7
import QtCharts 2.0
import QtQuick.Controls 2.15

Item {
    width: 1024
    height: 600
    id: controlAndMonitor
    property var distanceA: distanceRawA //x
    property var plotdataA: voltageRawA //y
    property var distanceB: distanceRawB
    property var plotdataB: voltageRawB
    property var distanceC: distanceRawC
    property var plotdataC: voltageRawC
    property var distancepatternA: distancePatternA
    property var plotdatapatternA: voltagePatternA
    property var distancepatternB: distancePatternB
    property var plotdatapatternB: voltagePatternB
    property var distancepatternC: distancePatternC
    property var plotdatapatternC: voltagePatternC
    property int timestep: 0
    property double movetoleft: cursorleft
    property real pointerX: 0
    property double pointerY: 0
    property int globalNum: 0
    property int number: 0
//     สำหรับ RawDataA
    onPlotdataAChanged: {
        try {
            if (plotdataA && distanceA && plotdataA.length === distanceA.length) {
                seriesRawA.clear();
                 console.log("pointerY:",pointerY)
                for (var i = 0; i < plotdataA.length; i++) {
                    if (isFinite(plotdataA[i]) && isFinite(distanceA[i])) {
//                        console.log("Appending:", distanceA[i], plotdataA[i]); // Debug log
                        seriesRawA.append(distanceA[i], plotdataA[i]);
                    } else {
//                        console.log("Invalid point:", distanceA[i], plotdataA[i]); // Debug invalid points
                    }
                }
                adjustAxes(distanceA, [plotdataA]); // Adjust the axes
                axisY.min = 0;
            } else {
//                console.log("Data mismatch for plotdataA. Lengths:", plotdataA.length, distanceA.length);
            }
        } catch (e) {
//            console.log("Error in onPlotdataAChanged:", e);
        }
    }
//     สำหรับ RawDataB
    onPlotdataBChanged: {
        try {
            if (plotdataB && distanceB && plotdataB.length === distanceB.length) {
                seriesRawB.clear();
                for (var i = 0; i < plotdataB.length; i++) {
                    if (isFinite(plotdataB[i]) && isFinite(distanceB[i])) {
//                        console.log("Appending to series2:", distanceB[i], plotdataB[i]); // Debug log
                        seriesRawB.append(distanceB[i], plotdataB[i]);
                    } else {
//                        console.log("Invalid point for series2:", distanceB[i], plotdataB[i]); // Debug invalid points
                    }
                }
                adjustAxes(distanceB, [plotdataB]); // Adjust the axes for series2
                axisY.min = 0;
            } else {
//                console.log("Data mismatch for plotdataB. Lengths:", plotdataB.length, distanceB.length);
            }
        } catch (e) {
//            console.log("Error in onPlotdataBChanged:", e);
        }
    }
    // สำหรับ RawDataC
    onPlotdataCChanged: {
        try {
            if (plotdataC && distanceC && plotdataC.length === distanceC.length) {
                seriesRawC.clear();
                for (var i = 0; i < plotdataC.length; i++) {
                    if (isFinite(plotdataC[i]) && isFinite(distanceC[i])) {
//                        console.log("Appending to series3:", distanceC[i], plotdataC[i]); // Debug log
                        seriesRawC.append(distanceC[i], plotdataC[i]);
                    } else {
//                        console.log("Invalid point for series3:", distanceC[i], plotdataC[i]); // Debug invalid points
                    }
                }
                adjustAxes(distanceC, [plotdataC]); // Adjust the axes for series3
                axisY.min = 0;
            } else {
//                console.log("Data mismatch for plotdataC. Lengths:", plotdataC.length, distanceC.length);
            }
        } catch (e) {
//            console.log("Error in onPlotdataCChanged:", e);
        }
    }

    // สำหรับ distancepatternA
    onPlotdatapatternAChanged: {
        try {
            console.log("PlotdatapatternA changed, clearing graph");
            if (plotdatapatternA && distancepatternA && plotdatapatternA.length === distancepatternA.length) {
                series1.clear();
                console.log("Graph cleared, repopulating...");

                for (var i = 0; i < plotdatapatternA.length; i++) {
                    if (isFinite(plotdatapatternA[i]) && isFinite(distancepatternA[i])) {
                        series1.append(distancepatternA[i], plotdatapatternA[i]);
                    }
                }

                adjustAxes(distancepatternA, [plotdatapatternA]);
                axisY.min = 0;
                console.log("Graph updated successfully.");
            } else {
                console.log("Data mismatch or empty for plotdatapatternA");
            }
        } catch (e) {
            console.log("Error in onPlotdatapatternAChanged:", e);
        }
    }

    // สำหรับ distancepatternB
    onPlotdatapatternBChanged: {
        console.log("PlotdatapatternB plotting graph");
        try {
            console.log("PlotdataPatternB changed");
            if (plotdatapatternB && distancepatternB && plotdatapatternB.length === distancepatternB.length) {
                console.log("Clearing Series2...");
                series2.clear(); // Clear existing data for series2
                for (var i = 0; i < plotdatapatternB.length; i++) {
                    if (isFinite(plotdatapatternB[i]) && isFinite(distancepatternB[i])) {
                        series2.append(distancepatternB[i], plotdatapatternB[i]);
                    }
                }
                adjustAxes(distancepatternB, [plotdatapatternB]); // Adjust the axes
                axisY.min = 0;
                console.log("Series2 updated");
            } else {
                console.log("Data mismatch or empty for plotdatapatternB");
            }
        } catch (e) {
            console.log("Error in onPlotdatapatternBChanged:", e);
        }
    }

    // สำหรับ distancepatternC
    onPlotdatapatternCChanged: {
        console.log("PlotdatapatternC plotting graph");
        try {
            console.log("PlotdataPatternC changed");
            if (plotdatapatternC && distancepatternC && plotdatapatternC.length === distancepatternC.length) {
                console.log("Clearing Series3...");
                series3.clear(); // Clear existing data for series3
                for (var i = 0; i < plotdatapatternC.length; i++) {
                    if (isFinite(plotdatapatternC[i]) && isFinite(distancepatternC[i])) {
                        series3.append(distancepatternC[i], plotdatapatternC[i]);
                    }
                }
                adjustAxes(distancepatternC, [plotdatapatternC]); // Adjust the axes
                axisY.min = 0;
                console.log("Series3 updated");
            } else {
                console.log("Data mismatch or empty for plotdatapatternC");
            }
        } catch (e) {
            console.log("Error in onPlotdatapatternCChanged:", e);
        }
    }
//    //     สำหรับ RawDataA
//        function onPlotdataAChanged() {
//            try {
//                if (plotdataA && distanceA && plotdataA.length === distanceA.length) {
//                    seriesRawA.clear();
//                    console.log("pointerY:", pointerY);
//                    for (var i = 0; i < plotdataA.length; i++) {
//                        if (isFinite(plotdataA[i]) && isFinite(distanceA[i])) {
//                            seriesRawA.append(distanceA[i], plotdataA[i]);
//                        }
//                    }
//                    adjustAxes(distanceA, [plotdataA]);
//                    axisY.min = 0;
//                } else {
//                    console.log("Data mismatch for plotdataA. Lengths:", plotdataA.length, distanceA.length);
//                }
//            } catch (e) {
//                console.log("Error in onPlotdataAChanged:", e);
//            }
//        }

//    //     สำหรับ RawDataB
//        function onPlotdataBChanged() {
//            try {
//                if (plotdataB && distanceB && plotdataB.length === distanceB.length) {
//                    seriesRawB.clear();
//                    for (var i = 0; i < plotdataB.length; i++) {
//                        if (isFinite(plotdataB[i]) && isFinite(distanceB[i])) {
//                            seriesRawB.append(distanceB[i], plotdataB[i]);
//                        }
//                    }
//                    adjustAxes(distanceB, [plotdataB]);
//                    axisY.min = 0;
//                } else {
//                    console.log("Data mismatch for plotdataB. Lengths:", plotdataB.length, distanceB.length);
//                }
//            } catch (e) {
//                console.log("Error in onPlotdataBChanged:", e);
//            }
//        }

//    // สำหรับ RawDataC
//        function onPlotdataCChanged() {
//            try {
//                if (plotdataC && distanceC && plotdataC.length === distanceC.length) {
//                    seriesRawC.clear();
//                    for (var i = 0; i < plotdataC.length; i++) {
//                        if (isFinite(plotdataC[i]) && isFinite(distanceC[i])) {
//                            seriesRawC.append(distanceC[i], plotdataC[i]);
//                        }
//                    }
//                    adjustAxes(distanceC, [plotdataC]);
//                    axisY.min = 0;
//                } else {
//                    console.log("Data mismatch for plotdataC. Lengths:", plotdataC.length, distanceC.length);
//                }
//            } catch (e) {
//                console.log("Error in onPlotdataCChanged:", e);
//            }
//        }

    // ฟังก์ชันสำหรับปรับแกน
    function adjustAxes(distances, plotdataArrays) {
        var validDistances = distances.filter(isFinite);
        if (validDistances.length > 0) {
            axisX.min = Math.min.apply(null, validDistances);
            axisX.max = Math.max.apply(null, validDistances);
        }

        var validPlotdata = [];
        plotdataArrays.forEach(array => {
            validPlotdata = validPlotdata.concat(array.filter(isFinite));
        });

        if (validPlotdata.length > 0) {
            axisY.min = Math.min.apply(null, validPlotdata);
            axisY.max = Math.max.apply(null, validPlotdata);
        }
    }

    function clearGraphDataPhaseA() {
        distanceA = [];
        plotdataA = [];
    }
    function clearGraphDataPhaseB() {
        distanceB = [];
        plotdataB = [];
    }
    function clearGraphDataPhaseC() {
        distanceC = [];
        plotdataC = [];
    }
    function clearGraphPatternPhaseA() {
        distancepatternA = [];
        plotdatapatternA = [];
    }
    function clearGraphPatternPhaseB() {
        distancepatternB = [];
        plotdatapatternB = [];
    }
    function clearGraphPatternPhaseC() {
        distancepatternC = [];
        plotdatapatternC = [];
    }
    function replotDataA() {
        distanceA=distanceRawA
        plotdataA =voltageRawA
    }
    function replotDataB() {
        distanceB =distanceRawB
        plotdataB =voltageRawB
    }
    function replotDataC() {
        distanceC =distanceRawC
        plotdataC =voltageRawC
    }
    function replotPatternA() {
        distancepatternA = distancePatternA
        plotdatapatternA = voltagePatternA
    }
    function replotPatternB() {
        distancepatternB = distancePatternB
        plotdatapatternB = voltagePatternB
    }
    function replotPatternC() {
        distancepatternC = distancePatternC
        plotdatapatternC = voltagePatternC
    }
    function cleardisplay() {
        distanceA = [];
        plotdataA = [];
        distanceB = [];
        plotdataB = [];
        distanceC = [];
        plotdataC = [];
        distancepatternA = [];
        plotdatapatternA = [];
        distancepatternB = [];
        plotdatapatternB = [];
        distancepatternC = [];
        plotdatapatternC = [];
        if(distanceA.length === 0 || plotdataA.length === 0){
            distanceA.push(distanceRawA);
            plotdataA.push(voltageRawA);
        }
        if(distanceB.length === 0 || plotdataB.length === 0){
            distanceB.push(distanceRawB);
            plotdataB.push(voltageRawB);
        }
        if(distanceC.length === 0 || plotdataC.length === 0){
            distanceC.push(distanceRawC);
            plotdataC.push(voltageRawC);
        }
        if(distancepatternA.length === 0 || plotdatapatternA.length === 0){
            distancepatternA.push(distancePatternA);
            plotdatapatternA.push(voltagePatternA);
        }
        if(distancepatternB.length === 0 || plotdatapatternB.length === 0){
            distancepatternB.push(distancePatternB);
            plotdatapatternB.push(voltagePatternB);
        }
        if(distancepatternC.length === 0 || plotdatapatternC.length === 0){
            distancepatternC.push(distancePatternC);
            plotdatapatternC.push(voltagePatternC);
        }
    }
    function clearpattern() {
        distancepatternA = [];
        plotdatapatternA = [];
        distancepatternB = [];
        plotdatapatternB = [];
        distancepatternC = [];
        plotdatapatternC = [];
    }
    // กราฟ
    ChartView {
        id: chartView
        anchors.fill: parent
        anchors.topMargin: 44
        anchors.bottomMargin: 213
        backgroundColor: "#000000"
        legend.labelColor: "white"

        ValueAxis {
            id: axisX
            min: 0
            max: 100
            tickCount: 10
            titleText: "<font color='#ffffff'>Distance (Km)</font>"
            titleFont.bold: true
            titleFont.pixelSize: 16
            labelsVisible: true
            gridVisible: false
            color: "#ffffff"
            labelsColor: "#ffffff"
            labelsFont.pixelSize: 14
        }

        ValueAxis {
            id: axisY
            min: 0 // Ensure Y-axis starts at 0
            max: 4096
            titleText: "<font color='#ffffff'>Voltage (mV)</font>"
            titleFont.bold: true
            titleFont.pixelSize: 16
            labelsVisible: true
            gridVisible: false
            color: "#ffffff"
            labelsColor: "#ffffff"
            labelsFont.pixelSize: 14
        }

        // Phase A
        LineSeries {
            id: series1
            axisX: axisX
            axisY: axisY
            name: "Pattern A"
            color: "#f7cbac"
            width: 3

        }
        LineSeries {
            id: series2
            axisX: axisX
            axisY: axisY
            name: "Pattern B"
            color: "#bc9121"
            width: 3
        }
        // Phase C
        LineSeries {
            id: series3
            axisX: axisX
            axisY: axisY
            name: "Pattern C"
            color: "#bed6ed"
            width: 3
        }

        // Phase Data A
        LineSeries {
            id: seriesRawA
            axisX: axisX
            axisY: axisY
            name: "Data A"
            color: "#fd2d1d"
            width: 3
        }
        // Phase Data B
        LineSeries {
            id: seriesRawB
            axisX: axisX
            axisY: axisY
            name: "Data B"
            color: "#fcff3b"
            width: 3
        }
        // Phase Data C
        LineSeries {
            id: seriesRawC
            axisX: axisX
            axisY: axisY
            name: "Data C"
            color: "#0088ff"
            width: 3
        }

        Rectangle {
            id: cursor
            width: 1
            height: 20 // chartView.height
            color: "#ffffff"
            anchors.top: chartView.top
            anchors.bottom: chartView.bottom
            anchors.bottomMargin: 72
            x: chartView.width / 2
            y: chartView.height
            property double distance: 0.0
            property double voltage: 0.0 // แก้ไขการรับรู้ของค่า voltage

            Component.onCompleted: {
                cursor.distance = axisX.min + (cursor.x / chartView.width) * (axisX.max - axisX.min );
                cursor.voltage = axisY.min + (cursor.y / chartView.height) * (axisY.max - axisY.min ); // คำนวณค่า voltage
            }

            Timer {
                id: initialTimer
                interval: 100
                running: true
                repeat: false

                onTriggered: {
                    var initialPosition = '{"objectName":"distance", "distance": ' + cursor.distance.toFixed(2)+'}';
                    console.log("Initial Position Sent:", initialPosition);
                    qmlCommand(initialPosition);
                }
            }

            MouseArea {
                id: dragArea
                anchors.fill: parent
                anchors.topMargin: 0
                anchors.leftMargin: -25
                anchors.rightMargin: -25
                cursorShape: Qt.OpenHandCursor
                drag.target: cursor
                property double safeMargin: 0.0
                property double graphStartOffset: 0.0
                property double graphEndX: 0.0
                property double graphEndY: 0.0


                onPositionChanged: {
                    safeMargin = 41.53; // ถ้ามากขึ้น cursor จะขยับเข้ามาทางซ้าย
                    graphStartOffset = 95.25; // ถ้ามากขึ้นจะขยับเข้าใกล้ 0
                    graphEndX = chartView.width - safeMargin;
                    cursor.x = Math.max(graphStartOffset, Math.min(cursor.x, graphEndX - cursor.width));

                    // คำนวณค่า distance และ voltage จากแกน X และ Y
                    cursor.distance = axisX.min + ((cursor.x - graphStartOffset) / (graphEndX - graphStartOffset)) * (axisX.max - axisX.min);
                    cursor.voltage = axisY.min + ((cursor.y - chartView.top) / chartView.height) * (axisY.max - axisY.min); // คำนวณค่า voltage จากตำแหน่ง Y

                    // แสดงค่าใน console
                    console.log("Cursor position X:", cursor.x, " Distance (Km):", cursor.distance.toFixed(2),
                                " Y:", cursor.y, " Voltage (mV):", cursor.voltage.toFixed(2));

                    var positionDistance = '{"objectName":"distance", "distance": ' + cursor.distance.toFixed(2) +'}';
                    qmlCommand(positionDistance);
                }

                onReleased: {
                    console.log("Cursor moved to Distance (Km):", cursor.distance.toFixed(2), " Voltage (mV):", cursor.voltage.toFixed(2));
                }
            }
        }
    }

    Cursorcontrol {
        id: cursorcontrol
        anchors.fill: parent
        anchors.bottomMargin: 0
        anchors.leftMargin: 651
        anchors.topMargin: 380
    }

    DataStatusInfo {
        id: dataStatusInfo
        x: 0
        y: 380
        width: 650
        height: 220
    }

    Rectangle {
        id: datafilename
        color: "#f2f2f2"
        radius: 5
        border.color: "#9b9b9b"
        anchors.fill: parent
        anchors.rightMargin: 214
        anchors.bottomMargin: 510
        anchors.leftMargin: 615
        anchors.topMargin: 60

        Text {
            id: textdatafilename
            text: qsTr("Text")
            anchors.fill: parent
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Rectangle {
        id: patternfilename
        color: "#bfbfbf"
        radius: 5
        border.color: "#9b9b9b"
        anchors.fill: parent
        anchors.leftMargin: 816
        anchors.topMargin: 60
        anchors.rightMargin: 13
        anchors.bottomMargin: 510

        Text {
            id: textpatternfilename
            text: qsTr("Text")
            anchors.fill: parent
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}



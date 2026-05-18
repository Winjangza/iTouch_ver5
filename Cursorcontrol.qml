import QtQuick 2.0
import QtCharts 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.0
import QtQml 2.2
import QtQuick.VirtualKeyboard 2.4

Item {
    width: 369
    height: 220
    property double totalDecrease: distanceCursor
    property bool focustextInformation: inputPanel.visible
    property string textforinformation:  textInformation.text
    property double stepSize: 0.1

    onFocustextInformationChanged: {
        if(focustextInformation == false){
            rangeOfDistance.color = "#000000"
        }
    }
    // onTextforinformationChanged: {
    //     if(rangeOfDistance.color == "#ff0000"){
    //         rangeOfDistance.text = textforinformation
    //         console.log("onTextforinformationChanged",textforinformation)

    //     }
    // }
    onTextforinformationChanged: {
        if (currentField === "rangedistance" && rangeOfDistance.color === "#ff0000") {
            distanceCursorStr = textforinformation
        }
    }
    Rectangle {
        id: rectangle
        x: 0
        y: 0
        width: 369
        height: 220
        color: "#e2e2e2"
        border.color: "#c8595959"
        border.width: 1


        Text {
            id: text5
            text: qsTr("CURSOR(KM)")
            anchors.fill: parent
            font.pixelSize: 16
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.topMargin: 4
            anchors.rightMargin: 68
            anchors.leftMargin: 185
            anchors.bottomMargin: 195
        }




        RowLayout {
            x: 128
            y: 121
            width: 212
            height: 99

            RowLayout {
                x: 128
                y: 117
                width: 212
                height: 103

                ToolButton {
                    id: patterntest
                    text: qsTr("PATTERN \n TEST")
                    Layout.fillWidth: true
                    visible: currentUserLevel !== 3

                    property bool isPressed: false

                    contentItem: Image {
                        width: 90
                        height: 90
                        source: patterntest.isPressed ? "images/pattern_press_test.png" : "images/pattern_unpress_test.png"
                        sourceSize.height: 90
                        sourceSize.width: 90
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }

                    onClicked: {
                        isPressed = true;
                        patternResetTimer.restart();
                        var pattern = `{"objectName":"PatternTest", "patternNum": ${patternLevel}}`;
                        qmlCommand(pattern);
                        popupPatternPlot();
                    }

                    Timer {
                        id: patternResetTimer
                        interval: 3000
                        repeat: false
                        onTriggered: patterntest.isPressed = false
                    }
                }

            }

            ToolButton {
                id: manualtest
                text: qsTr("MANUAL \n TEST")
                Layout.fillWidth: true
                Layout.leftMargin: currentUserLevel === 3 ? -50 : 0

                property bool isPressed: false

                contentItem: Image {
                    height: 90
                    width: 103
                    source: {
                        if (currentUserLevel === 3) {
                            return manualtest.isPressed ? "images/manual_level3_press.png" : "images/manual_level3.png";
                        } else {
                            return manualtest.isPressed ? "images/manual_press_test.png" : "images/manual_unpress_test.png";
                        }
                    }
                    sourceSize.height: 90
                    sourceSize.width: 90
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }

                onClicked: {
                    isPressed = true;
                    manualResetTimer.restart();
                    var manual = '{"objectName":"ManualTest"}';
                    qmlCommand(manual);
                }

                Timer {
                    id: manualResetTimer
                    interval: 1000
                    repeat: false
                    onTriggered: manualtest.isPressed = false;
                }
            }



        }

        ColumnLayout {
            anchors.fill: parent
            anchors.rightMargin: 270

            ToolButton {
                id: clearalarm
                width: 90
                height: 90
//                visible: !(currentUserLevel=== 3)
                text: qsTr("CLEAR \n ALARM")
                Layout.fillHeight: true
                Layout.fillWidth: true
                font.pointSize: 9
                contentItem: Image {
                    width: 150
                    height: 150
                    source: "images/button_clear.png"
                    fillMode: Image.PreserveAspectFit
                    smooth: true

                    Text {
                        text: qsTr("CLEAR \n ALARM")
                        anchors.centerIn: parent
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                onClicked: {
//                    console.log("CLEAR ALARM button clicked");
                    clearAlarmLog();
//                    clearAlarmEventLog();
//                    var pattern = '{"objectName":"CLEAR_ALARM"}';
//                    qmlCommand(pattern);
                }
            }


            ToolButton {
                id: cleardisplay
                width: 90
                height: 90
                text: qsTr("CLEAR \n DISPLAY")
                Layout.fillHeight: true
                Layout.fillWidth: true
                font.pointSize: 9
                contentItem: Image {
                    width: 150
                    height: 150
                    source: "images/button_clear.png"
                    fillMode: Image.PreserveAspectFit
                    smooth: true

                    Text {
                        id: cleardisplaybutton
                        x: 8
                        y: 0
                        width: 74
                        height: 49
                        anchors.fill: parent
                        text: qsTr("CLEAR \n DISPLAY")
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                onClicked: {
                    contorlAndMonitor.cleardisplay();                    
                    // updataStatusOfButtonA = true
                    // updataStatusOfButtonB = true
                    // updataStatusOfButtonC = true
                    // updataStatusOfPatternA = true
                    // updataStatusOfPatternB = true
                    // updataStatusOfPatternC = true

                    // updataStatusOfButtonA = false
                    // updataStatusOfButtonB = false
                    // updataStatusOfButtonC = false
                    // updataStatusOfPatternA = false
                    // updataStatusOfPatternB = false
                    // updataStatusOfPatternC = false
                }
            }

            ToolButton {
                id: clearpattern
                width: 90
                height: 90
                text: qsTr("CLEAR \n PATTERN")
                Layout.fillHeight: true
                Layout.fillWidth: true
                font.pointSize: 9
                visible: !(currentUserLevel === 3)
                contentItem: Image {
                    width: 150
                    height: 150
                    source: "images/button_clear.png"
                    fillMode: Image.PreserveAspectFit
                    smooth: true

                    Text {
                        id: clearPatternbutton
                        x: 0
                        y: 0
                        width: 82
                        height: 58
                        anchors.fill: parent
                        text: qsTr("CLEAR \n PATTERN")
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                onClicked: {
                    contorlAndMonitor.clearpattern();
                }
            }
        }

        ColumnLayout {
            x: 105
            y: 27
            width: 256
            height: 94

            RowLayout {

                ToolButton {
                    id: cursorLeft
                    Layout.preferredHeight: 58
                    Layout.preferredWidth: 76
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    contentItem: Image {
                        anchors.fill: parent
                        source: "images/arrowLeft.png"
                        sourceSize.width: 237
                    }

                    Timer {
                        id: holdTimerLeft
                        interval: 100
                        repeat: true
                        onTriggered: {
                            moveCursorLeft();
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onPressed: holdTimerLeft.start()
                        onReleased: holdTimerLeft.stop()
                        onClicked: moveCursorLeft
                    }


                }
                TextField {
                    id: rangeOfDistance
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    text: (currentField === "rangedistance" && distanceCursorStr !== "")
                          ? distanceCursorStr
                          : cursor.initdistance.toFixed(2)

                    onAccepted: {
                        let val = parseFloat(rangeOfDistance.text)
                        if (!isNaN(val)) {
                            controlAndMonitor.updateCursorFromExternal(val)
                        }
                        Qt.inputMethod.hide()
                        rangeOfDistance.focus = false
                    }

                    onEditingFinished: {
                        let val = parseFloat(rangeOfDistance.text)
                        if (!isNaN(val)) {
                            controlAndMonitor.updateCursorFromExternal(val)
                        }
                        Qt.inputMethod.hide()
                        rangeOfDistance.focus = false
                    }

                    onFocusChanged: {
                        if (focus) {
                            Qt.inputMethod.show()
                            currentField = "rangedistance"
                            inputPanel.visible = true
                            textInformation.visible = true
                            distanceCursorStr = cursor.initdistance.toFixed(2)
                            textInformation.text = distanceCursorStr
                            textInformation.focus = true
                            textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly
                            rangeOfDistance.color = "#ff0000"
                        } else {
                            rangeOfDistance.color = "#000000"
                            distanceCursorStr = ""
                        }
                    }
                }

//                TextField {
//                    id: rangeOfDistance
//                    Layout.fillHeight: true
//                    Layout.fillWidth: true
//                    text: distanceCursor? cursor.initdistance.toFixed(2) : distanceCursor

//                    onFocusChanged: {
//                        if (focus) {

//                            Qt.inputMethod.show();
//                            currentField = "rangedistance";
//                            inputPanel.visible = true;
//                            textInformation.visible = true;
//                            textInformation.text = "";
//                            textInformation.focus = true;
//                            textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
//                            rangeOfDistance.color = "#ff0000";
//                        }
//                    }
//                }

                // TextField {
                //        id: rangeOfDistance
                //        Layout.fillHeight: true
                //        Layout.fillWidth: true
                //        placeholderText: distanceCursor ? cursor.distance.toFixed(1) : distanceCursor

                //        onFocusChanged: {
                //             if (focus) {
                //                 Qt.inputMethod.show();
                //                 rangeOfDistance.focus = false;
                //                 currentField = "rangedistance";
                //                 inputPanel.visible = true;
                //                 textInformation.visible = true;
                //                 textInformation.text = "";
                //                 textInformation.focus = true;
                //                 textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                //                 rangeOfDistance.color = "#ff0000";
                //             }
                //         }
                //    }

                ToolButton {
                    id: cursorRight
                    Layout.preferredHeight: 58
                    Layout.preferredWidth: 76
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    contentItem: Image {
                        anchors.fill: parent
                        source: "images/arrowRigth.png"
                    }

                    Timer {
                        id: holdTimer2
                        interval: 100
                        repeat: true
                        onTriggered: {
                            moveCursorRight();
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onPressed: holdTimer2.start()
                        onReleased: holdTimer2.stop()
                        onClicked: moveCursorRight
                    }
                }
            }

            Rectangle {
                id: basePattern
                color: "#ffffff"
                border.color: "#ffffff"
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 31
                Layout.preferredWidth: 280
                visible: !(currentUserLevel === 3)


                property int patternLevel: 1
                height: 30

                Slider {
                    id: sliderDACLevels
                    anchors.fill: parent
                    anchors.rightMargin: 108
                    anchors.bottomMargin: 0
                    anchors.topMargin: 0
                    anchors.leftMargin: 0
                    stepSize: 1
                    Layout.preferredHeight: 55
                    Layout.preferredWidth: 130
                    rotation: 0
                    to: 20
                    from: 1
                    layer.textureMirroring: ShaderEffectSource.MirrorVertically
                    value: patternLevel

                    onValueChanged: {
                        patternLevel = value.toFixed(0);
                    }
                }

                SpinBox {
                    id: spinBoxDACLevel
                    x: 670
                    y: 16
                    anchors.fill: parent
                    anchors.bottomMargin: 0
                    anchors.topMargin: -8
                    anchors.rightMargin: -7
                    anchors.leftMargin: 131
                    value: patternLevel
                    to: 20
                    from: 1
                    layer.textureMirroring: ShaderEffectSource.MirrorVertically
                    rotation: 0

                    onValueChanged: {
                        patternLevel = Math.max(value, 1); // อัปเดตค่า buffer
                    }
                }
            }
        }
        
    }

//    function moveCursorRight() {
//        let stepSize = 0.1;
//        let newDistance = cursor.initdistance + stepSize;
//        newDistance = Math.min(newDistance, axisX.max);

//        cursor.initdistance = newDistance;

//        let plotX = chartView.plotArea.x;
//        let plotW = chartView.plotArea.width;
//        let percent = (cursor.initdistance - axisX.min) / (axisX.max - axisX.min);
//        cursor.x = plotX + percent * plotW;

//        let payload = `{"objectName":"increaseValue","increaseValue": ${cursor.initdistance.toFixed(2)}}`;
//        qmlCommand(payload);

//        console.log("Moved Right: distance =", cursor.initdistance.toFixed(2), "→ X =", cursor.x.toFixed(2));
//    }

    function moveCursorLeft() {
        let step = 0.01; // ระยะที่จะเลื่อน (เช่น 1 km)
        let newDistance = cursor.initdistance - step;
        newDistance = Math.max(minAxisX, newDistance); // อย่าให้น้อยกว่าแกนซ้ายสุด
        cursor.setCursorToDistance(newDistance);
        console.log("Cursor moved left to", newDistance);
    }
    function moveCursorRight() {
        let step = 0.01;
        let newDistance = cursor.initdistance + step;
        newDistance = Math.min(maxAxisX, newDistance);
        cursor.setCursorToDistance(newDistance);
        console.log("Cursor moved right to", newDistance);
    }

//    function moveCursorLeft() {
//        let stepSize = 0.1;
//        let newDistance = cursor.initdistance - stepSize;
//        newDistance = Math.max(newDistance, axisX.min);

//        cursor.initdistance = newDistance;

//        let plotX = chartView.plotArea.x;
//        let plotW = chartView.plotArea.width;
//        let percent = (cursor.initdistance - axisX.min) / (axisX.max - axisX.min);
//        cursor.x = plotX + percent * plotW;

//        let payload = `{"objectName":"decreaseValue","decreaseValue": ${cursor.initdistance.toFixed(2)}}`;
//        qmlCommand(payload);

//        console.log("Moved Left: distance =", cursor.initdistance.toFixed(2), "→ X =", cursor.x.toFixed(2));
//    }

    function popupPatternPlot(){
        remotepopUp.remoteMessage = "PATTERN START"
        remotePopup.open();
    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:2}
}
##^##*/

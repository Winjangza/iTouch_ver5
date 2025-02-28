import QtQuick 2.0
import QtCharts 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.0
import QtQml 2.2

Item {
    id: _item
    width: 369
    height: 220
    property double totalDecrease: 0.0
    property bool focustextInformation: inputPanel.visible
    property string textforinformation:  textInformation.text

    onFocustextInformationChanged: {
        if(focustextInformation == false){
            rangeOfDistance.color = "#000000"
        }
    }
    onTextforinformationChanged: {
        if(rangeOfDistance.color == "#ff0000"){
            rangeOfDistance.text = textforinformation
        }
        console.log("onTextforinformationChanged",textforinformation)
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
                ToolButton {
                    id: patterntest
                    visible: !(userLevelGlobalVars.get(0).userLevel === 3)
                    text: qsTr("PATTERN \n TEST")
                    contentItem: Image {
                        anchors.fill: parent
                        anchors.leftMargin: 6
                        anchors.topMargin: 10
                        anchors.bottomMargin: 10
                        source: "images/pattern_unpress_test.png"
                        sourceSize.height: 90
                        sourceSize.width: 90
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                    onClicked: {
                        console.log("Pattern Test Clicked. Sending DAC Level:", patternLevel);
                        var pattern = `{"objectName":"PatternTest", "patternNum": ${patternLevel}}`;
                        qmlCommand(pattern);
                    }
                }

                ToolButton {
                    id: manualtest
                    Layout.fillWidth: userLevelGlobalVars.get(0).userLevel === 3
                    width: userLevelGlobalVars.get(0).userLevel === 3 ? undefined : 103
                    text: qsTr("MANUAL \n TEST")
                    flat: true
                    highlighted: false
                    contentItem: Image {
                        anchors.fill: parent
                        anchors.leftMargin: 6
                        anchors.topMargin: 10
                        anchors.bottomMargin: 10
                        source: "images/manual_unpress_test.png"
                        sourceSize.height: 90
                        sourceSize.width: 90
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                    onClicked: {
                        console.log("Manual Test");
                        var manual = '{"objectName":"ManualTest"}';
                        qmlCommand(manual);
                    }
                }
            }

        }

        ColumnLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.rightMargin: 270
            anchors.bottomMargin: 0

            ToolButton {
                id: clearalarm
                width: 90
                height: 90
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
                    console.log("CLEAR ALARM button clicked");
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
                    id: image
                    width: 150
                    height: 150
                    source: "images/button_clear.png"
                    fillMode: Image.PreserveAspectFit
                    smooth: true

                    Text {
                        id: cleardisplaybutton
                        x: 8
                        width: 74
                        text: qsTr("CLEAR \n DISPLAY")
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.topMargin: 9
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                onClicked: {
                    console.log("CLEAR ALARM")
                    contorlAndMonitor.cleardisplay();
                    //                    var pattern = '{"objectName":"cleardisplay"}';
                    //                    qmlCommand(pattern);
                }
            }

            ToolButton {
                id: clearpattern
                width: 90
                height: 90
                visible: !(userLevelGlobalVars.get(0).userLevel === 3)
                text: qsTr("CLEAR \n PATTERN")
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
                    console.log("CLEAR ALARM")
                    contorlAndMonitor.clearpattern();
                    //                    var pattern = '{"objectName":"clearpattern"}';
                    //                    qmlCommand(pattern);
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
                    highlighted: false
                    flat: false
                    Layout.preferredHeight: 58
                    //            icon.source: "images/leftArrow.png"
                    //            icon.width: 45
                    //            icon.height: 45
                    Layout.preferredWidth: 76
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    contentItem: Image {
                        anchors.fill: parent
                        source: "images/arrowLeft.png"
                        sourceSize.width: 237
                    }


                    Timer {
                        id: holdTimer
                        interval: 100
                        repeat: true
                        property double decrease: 0.1
                        property double safeMargin: 41.53
                        property double graphStartOffset: 95.25
                        property double graphEndX: chartView.width - safeMargin
                        property double totalDecrease: 0.0
                        onTriggered: {
                            cursor.distance = Math.max(axisX.min, cursor.distance - decrease);
                            cursor.x = graphStartOffset + ((cursor.distance - axisX.min) / (axisX.max - axisX.min)) * (graphEndX - graphStartOffset);

                            totalDecrease += decrease;

                            var decreaseValue = '{"objectName":"decreaseValue","decreaseValue": ' + cursor.distance.toFixed(2) + '}';
                            console.log("decreaseValue:", cursor.distance.toFixed(2), cursor.x.toFixed(2), decreaseValue);
                            qmlCommand(decreaseValue);
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onPressed: {
                            holdTimer.start();
                        }
                        onReleased: {
                            holdTimer.stop();
                            console.log("Total decrease during hold:", totalDecrease.toFixed(2));
                            totalDecrease = 0.0;
                        }
                    }
                }

                TextField {
                    id: rangeOfDistance
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    placeholderText: cursorposition ? cursor.distance.toFixed(2) : updateNewDistance

                    onFocusChanged: {
                        if (focus) {
                            Qt.inputMethod.show();
                            rangeOfDistance.focus = false;
                            currentField = "rangedistance";
                            inputPanel.visible = true;
                            textInformation.visible = true;
                            textInformation.text = "";
                            textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                            textInformation.focus = true;
                            rangeOfDistance.color = "#ff0000";
                        }
                    }
                }

                ToolButton {
                    id: cursorRight
                    Layout.preferredHeight: 58
                    //            icon.source: "images/rightArrow.png"
                    //            icon.width: 45
                    //            icon.height: 45
                    Layout.preferredWidth: 76
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    property bool isRight: false
                    contentItem: Image {
                        anchors.fill: parent
                        source: "images/arrowRigth.png"
                    }
                    Timer {
                        id: holdTimer2
                        interval: 100
                        repeat: true
                        property double decrease: 0.1
                        property double safeMargin: 41.53
                        property double graphStartOffset: 95.25
                        property double graphEndX: chartView.width - safeMargin
                        onTriggered: {
                            cursor.distance = Math.max(axisX.min, cursor.distance + decrease);
                            cursor.x = graphStartOffset + ((cursor.distance - axisX.min) / (axisX.max - axisX.min)) * (graphEndX - graphStartOffset);

                            totalDecrease += decrease;

                            var increaseValue = '{"objectName":"increaseValue","increaseValue": ' + cursor.distance.toFixed(2) + '}';
                            console.log("decreaseValue:", cursor.distance.toFixed(2), cursor.x.toFixed(2), increaseValue);
                            qmlCommand(increaseValue);
                        }
                    }

                    MouseArea {
                        y: 19
                        anchors.fill: parent
                        onPressed: {
                            holdTimer2.start();
                        }
                        onReleased: {
                            holdTimer2.stop();
                            console.log("Total decrease during hold:", totalDecrease.toFixed(2));
                            totalDecrease = 0.0;
                        }
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
                visible: !(userLevelGlobalVars.get(0).userLevel === 3)
                // ตัวแปรเก็บค่า DAC Level
                property int patternLevel: 1
                height: 30  // ค่าเริ่มต้น

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
                    to: 30
                    from: 1
                    layer.textureMirroring: ShaderEffectSource.MirrorVertically
                    value: patternLevel // ใช้ค่า buffer แทน

                    onValueChanged: {
                        patternLevel = value.toFixed(0); // อัปเดตค่า buffer
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
                    value: patternLevel // ใช้ค่า buffer
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




}

/*##^##
Designer {
    D{i:0;formeditorZoom:4}D{i:6}D{i:8}D{i:15}
}
##^##*/

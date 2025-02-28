import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.15

Item {
    width: 650
    height: 220
    property bool isGreenA: false // สถานะเริ่มต้น
    property bool isGreenB: false // สถานะเริ่มต้น
    property bool isGreenC: false // สถานะเริ่มต้น
    property bool isGreenฺButA: false // สถานะเริ่มต้น
    property bool isGreenButB: false // สถานะเริ่มต้น
    property bool isGreenButC: false // สถานะเริ่มต้น detailwireInformation
    property var voltageDataA: dataPointA
    property string detailwire: detailwireInformation
    property double realDistanceA_Measure: realDistanceA
    property double realDistanceB_Measure: realDistanceB
    property double realDistanceC_Measure: realDistanceC
    property string modeUserMasterandSlave: remoteMonitor

    property bool isMasterMode: true
    property string userModeSelect: userMode
    Rectangle {
        id: mainDataInfo
        x: 0
        y: 0
        width: 650
        height: 220
        color: "#f2f2f2"
        border.color: "#f2f2f2"
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 29
            anchors.bottomMargin: 156

            Text {
                id: dataline
                text: qsTr("DATA")
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            Text {
                id: pattern
                text: qsTr("PATTERN")
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.leftMargin: 4
                Layout.fillHeight: true
                Layout.fillWidth: false
            }

            Text {
                id: phasetext
                text: qsTr("PHASE")
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.leftMargin: 10
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            Text {
                id: datastatus
                text: qsTr("DATA")
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.leftMargin: 10
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            Text {
                id: patternstatus
                text: qsTr("PATTERN")
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            Text {
                id: phasetext1
                text: qsTr("DISTANCE(KM)")
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            Text {
                id: structurenum
                text: qsTr("STRUCTURE NO")
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.margins: 0
                Layout.leftMargin: 0
                Layout.preferredWidth: -1
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.topMargin: 57

            ColumnLayout {
                id: datacolor
                Layout.leftMargin: 3
                Layout.rightMargin: 0
                Layout.fillWidth: true
                Layout.preferredHeight: 156
                Layout.preferredWidth: 45

                Rectangle {
                    id: rectangle1
                    color: "#fd2d1d"
                    Layout.preferredHeight: 6
                    Layout.preferredWidth: 50

                }

                Rectangle {
                    id: rectangle2
                    color: "#fcff3b"
                    Layout.preferredHeight: 6
                    Layout.preferredWidth: 50

                }

                Rectangle {
                    id: rectangle3
                    color: "#0088ff"
                    Layout.preferredHeight: 5
                    Layout.preferredWidth: 50

                }
            }

            ColumnLayout {
                id: patterncolor
                Layout.fillWidth: true
                Layout.preferredHeight: 156
                Layout.preferredWidth: 50

                Rectangle {
                    id: patternAphase
                    color: "#f7cbac"
                    Layout.preferredHeight: 6
                    Layout.preferredWidth: 50

                }

                Rectangle {
                    id: patternBphase
                    color: "#bc9121"
                    Layout.preferredHeight: 6
                    Layout.preferredWidth: 50

                }

                Rectangle {
                    id: patternCphase
                    color: "#bed6ed"
                    Layout.preferredHeight: 5
                    Layout.preferredWidth: 50
                }
            }

            ColumnLayout {
                id: phaseName
                Layout.leftMargin: 20
                Layout.fillWidth: true
                Layout.preferredHeight: 156
                Layout.preferredWidth: 40
                Text {
                    id: textA
                    text: qsTr("A")
                    font.pixelSize: 24
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    Layout.preferredWidth: 40
                    font.bold: true
                }

                Text {
                    id: textB
                    text: qsTr("B")
                    font.pixelSize: 24
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    Layout.preferredWidth: 40
                    font.bold: true
                }

                Text {
                    id: textC
                    text: qsTr("C")
                    font.pixelSize: 23
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    Layout.preferredWidth: 40
                    font.bold: true
                }
            }

            ColumnLayout {
                id: databutton
                Layout.leftMargin: 20
                Layout.fillWidth: true

                ToolButton {
                    id: databuttonPhaseA
                    topPadding: 6
                    Layout.preferredHeight: 50
                    Layout.fillWidth: false
                    contentItem: Image {
                        width: 50
                        height: 50
                        source: isGreenฺButA ?  "images/grayButton.png" : "images/GreenButton2.png"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                    Layout.preferredWidth: 50
                    Layout.fillHeight: false
                    onClicked: {
                        isGreenฺButA = !isGreenฺButA;
                        console.log("Button clicked. Current state isGreen:", isGreenฺButA ? "Green" : "Gray");

                        if (!isGreenฺButA) {
                            var getdataPhaseA = '{"objectName":"getDatabuttonPhaseA","rawdataA": "getdataA"}';
                            //                            qmlCommand(getdataPhaseA);
                            console.log("Sent cleardataPhaseA command");
                            controlAndMonitor.replotDataA();
                        } else {
                            var cleardataPhaseA = '{"objectName":"clearDatabuttonPhaseA","rawdataA": "cleardataA"}';
                            //                            qmlCommand(cleardataPhaseA);
                            console.log("Sent getdataPhaseA command");
                            controlAndMonitor.clearGraphDataPhaseA();
                        }
                    }
                    background: Rectangle {
                        color: "#00000000"
                        border.color: "#00000000"
                    }
                }

                ToolButton {
                    id: databuttonPhaseB
                    topPadding: 6
                    Layout.preferredHeight: 50
                    Layout.fillWidth: false
                    contentItem: Image {
                        width: 50
                        height: 50
                        source: isGreenButB ?  "images/grayButton.png" : "images/GreenButton2.png"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                    Layout.preferredWidth: 50
                    Layout.fillHeight: false
                    onClicked: {
                        isGreenButB = !isGreenButB;
                        console.log("Button clicked. Current state isGreen:", isGreenButB ? "Green" : "Gray");

                        if (!isGreenButB) {
                            var getdataPhaseB = '{"objectName":"getDatabuttonPhaseB","patternB": "getdataB"}';
                            //                            qmlCommand(getdataPhaseB);
                            console.log("Sent cleardataPhaseB command");
                            controlAndMonitor.replotDataB();
                        } else {
                            var cleardataPhaseB = '{"objectName":"clearDatabuttonPhaseB","patternB": "cleardataB"}';
                            //                            qmlCommand(cleardataPhaseB);
                            console.log("Sent getdataPhaseB command");
                            controlAndMonitor.clearGraphDataPhaseB();
                        }
                    }
                    background: Rectangle {
                        color: "#00000000"
                        border.color: "#00000000"
                    }
                }

                ToolButton {
                    id: databuttonPhaseC
                    topPadding: 6
                    Layout.preferredHeight: 50
                    Layout.fillWidth: false
                    contentItem: Image {
                        width: 50
                        height: 50
                        source: isGreenButC ?  "images/grayButton.png" : "images/GreenButton2.png"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                    Layout.preferredWidth: 50
                    Layout.fillHeight: false
                    onClicked: {
                        isGreenButC = !isGreenButC;
                        console.log("Button clicked. Current state isGreen:", isGreenButC ? "Green" : "Gray");

                        if (!isGreenButC) {
                            var getdataPhaseC = '{"objectName":"getDatabuttonPhaseC","patternC": "getdataC"}';
                            //                            qmlCommand(getdataPhaseC);
                            console.log("Sent cleardataPhaseC command");
                            controlAndMonitor.replotDataC();
                        } else {
                            var cleardataPhaseC = '{"objectName":"clearDatabuttonPhaseC","patternC": "cleardataC"}';
                            //                            qmlCommand(cleardataPhaseC);
                            console.log("Sent getdataPhaseC command");
                            controlAndMonitor.clearGraphDataPhaseC();
                        }
                    }
                    background: Rectangle {
                        color: "#00000000"
                        border.color: "#00000000"
                    }
                }
            }

            ColumnLayout {
                id: patternButton
                Layout.leftMargin: 20
                Layout.fillWidth: true
                Layout.preferredHeight: 161
                Layout.preferredWidth: 50

                ToolButton {
                    id: patternButtonPhaseA
                    topPadding: 6
                    Layout.preferredHeight: 50
                    Layout.fillWidth: false
                    contentItem: Image {
                        width: 50
                        height: 50
                        source: isGreenA ?   "images/grayButton.png" : "images/GreenButton2.png"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                    Layout.preferredWidth: 50
                    Layout.fillHeight: false
                    onClicked: {
                        isGreenA = !isGreenA;
                        console.log("Button clicked. Current state isGreen:", isGreenA ? "Green" : "Gray");

                        if (!isGreenA) {
                            var clearPatternPhaseA = '{"objectName":"ClearDisplayPhaseA","patternA": "clearpatternA"}';
                            //                            qmlCommand(clearPatternPhaseA);
                            console.log("Sent clearpatternPhaseA command");
                            controlAndMonitor.replotPatternA();
                        } else {
                            var getPatternPhaseA = '{"objectName":"getpatternPhaseA","patternA": "getpatternA"}';
                            //                            qmlCommand(getPatternPhaseA);
                            console.log("Sent getpatternPhaseA command");
                            controlAndMonitor.clearGraphPatternPhaseA();
                        }
                    }
                    background: Rectangle {
                        color: "#00000000"
                        border.color: "#00000000"
                    }
                }

                ToolButton {
                    id: patternButtonPhaseB
                    Layout.preferredHeight: 50
                    Layout.fillWidth: false
                    contentItem: Image {
                        width: 50
                        height: 50
                        source: isGreenB ? "images/grayButton.png" : "images/GreenButton2.png"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                    Layout.preferredWidth: 50
                    Layout.fillHeight: false
                    onClicked: {
                        isGreenB = !isGreenB;
                        console.log("Button clicked. Current state isGreen:", isGreenB ? "Green" : "Gray");

                        if (!isGreenB) {
                            var clearPatternPhaseB = '{"objectName":"ClearDisplayPhaseB","patternB": "clearpatternB"}';
                            //                            qmlCommand(clearPatternPhaseB);
                            console.log("Sent clearpatternPhaseB command");
                            controlAndMonitor.replotPatternB();
                        } else {
                            var getPatternPhaseB = '{"objectName":"getpatternPhaseB","patternB": "getpatternB"}';
                            //                            qmlCommand(getPatternPhaseB);
                            console.log("Sent getpatternPhaseB command");
                            controlAndMonitor.clearGraphPatternPhaseB();
                        }
                    }
                    background: Rectangle {
                        color: "#00000000"
                        border.color: "#00000000"
                    }
                }

                ToolButton {
                    id: patternButtonPhaseC
                    bottomPadding: 6
                    leftPadding: 6
                    Layout.preferredHeight: 50
                    Layout.fillWidth: false
                    contentItem: Image {
                        width: 50
                        height: 50
                        source: isGreenC ? "images/grayButton.png" : "images/GreenButton2.png"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }
                    Layout.preferredWidth: 50
                    Layout.fillHeight: false
                    onClicked: {
                        isGreenC = !isGreenC;
                        console.log("Button clicked. Current state isGreen:", isGreenC ? "Green" : "Gray");

                        if (!isGreenC) {
                            var clearPatternPhaseC = '{"objectName":"ClearDisplayPhaseC","patternC": "clearpatternC"}';
                            //                            qmlCommand(clearPatternPhaseC);
                            console.log("Sent clearpatternPhaseC command");
                            controlAndMonitor.replotPatternC();
                        } else {
                            var getPatternPhaseC = '{"objectName":"getpatternPhaseC","patternC": "getpatternC"}';
                            //                            qmlCommand(getPatternPhaseC);
                            console.log("Sent getpatternPhaseC command");
                            controlAndMonitor.clearGraphPatternPhaseC();
                        }
                    }
                    background: Rectangle {
                        color: "#00000000"
                        border.color: "#00000000"
                    }
                }
            }

            ColumnLayout {
                width: 70
                Layout.leftMargin: 20
                Layout.preferredHeight: 156
                Layout.preferredWidth: 69

                Rectangle {
                    id: firstPhaseData
                    color: "#ffffff"
                    radius: 5
                    border.color: "#a6a6a6"
                    border.width: 2
                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 70
                    Text {
                        id: distancephase1
                        text: realDistanceA_Measure.toFixed(2)
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.leftMargin: 0
                        font.pixelSize: 13
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.rightMargin: 0
                        anchors.topMargin: 0
                        anchors.bottomMargin: 0
                    }
                }

                Rectangle {
                    id: secondPhaseData
                    color: "#ffffff"
                    radius: 5
                    border.color: "#a6a6a6"
                    border.width: 2
                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 70
                    Text {
                        id: distancephase2
                        text: realDistanceB_Measure.toFixed(2)
                        anchors.fill: parent
                        font.pixelSize: 13
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Rectangle {
                    id: thirdPhaseData
                    color: "#ffffff"
                    radius: 5
                    border.color: "#a6a6a6"
                    border.width: 2
                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 70
                    Text {
                        id: distancephase3
                        text: realDistanceC_Measure.toFixed(2)
                        anchors.fill: parent
                        font.pixelSize: 13
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            ColumnLayout {
                Layout.preferredHeight: 156
                Layout.preferredWidth: 70

                Rectangle {
                    id: firstPhaseVoltage
                    color: "#e7e6e6"
                    radius: 5
                    border.color: "#ffffff"
                    border.width: 2
                    visible: !(userLevelGlobalVars.get(0).userLevel === 3)
                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 70
                    Text {
                        id: vlotagephase1
                        x: 0
                        y: 0
                        width: 70
                        height: 30
                        text: qsTr("Text")
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.rightMargin: 0
                        anchors.bottomMargin: 0
                        anchors.leftMargin: 0
                        anchors.topMargin: 0
                    }


                }

                Rectangle {
                    id: secondPhaseVoltage
                    color: "#e7e6e6"
                    radius: 5
                    border.color: "#ffffff"
                    border.width: 2
                    visible: !(userLevelGlobalVars.get(0).userLevel === 3)
                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 70
                    Text {
                        id: vlotagephase2
                        x: 0
                        y: 0
                        width: 70
                        height: 30
                        text: qsTr("Text")
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Rectangle {
                    id: thirdPhaseVoltage
                    color: "#e7e6e6"
                    radius: 5
                    border.color: "#ffffff"
                    border.width: 2
                    visible: !(userLevelGlobalVars.get(0).userLevel === 3)
                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 70
                    Text {
                        id: vlotagephase3
                        x: 0
                        y: 0
                        width: 70
                        height: 30
                        text: qsTr("Text")
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            ColumnLayout {
                Layout.preferredHeight: 156
                Layout.preferredWidth: 19
                visible: !(userLevelGlobalVars.get(0).userLevel === 3)
                Text {
                    id: unitmVlotage1
                    text: qsTr("mV")
                    font.pixelSize: 12
                }

                Text {
                    id: unitmVlotage2
                    text: qsTr("mV")
                    font.pixelSize: 12
                }

                Text {
                    id: unitmVlotage3
                    text: qsTr("mV")
                    font.pixelSize: 12
                }
            }

            ColumnLayout {
                Layout.preferredHeight: 156
                Layout.preferredWidth: 70

                Rectangle {
                    id: strucNo1
                    color: "#e7e6e6"
                    radius: 5
                    border.color: "#ffffff"
                    border.width: 2
                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 70
                    Text {
                        id: textstrucNo1
                        x: 0
                        y: 0
                        width: 70
                        height: 30
                        text: qsTr("Text")
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Rectangle {
                    id: strucNo2
                    color: "#e7e6e6"
                    radius: 5
                    border.color: "#ffffff"
                    border.width: 2
                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 70
                    Text {
                        id: textstrucNo2
                        x: 0
                        y: 0
                        width: 70
                        height: 30
                        text: qsTr("Text")
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Rectangle {
                    id: strucNo3
                    color: "#e7e6e6"
                    radius: 5
                    border.color: "#ffffff"
                    border.width: 2
                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 70
                    Text {
                        id: textstrucNo3
                        x: 0
                        y: 0
                        width: 70
                        height: 30
                        text: qsTr("Text")
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }

    RowLayout {
        x: 8
        y: 0
        width: 634
        height: 38

        Rectangle {
            id: detailofwire
            color: "#ffffff"
            radius: 4
            border.color: "#509d9d9d"
            border.width: 2
            Layout.preferredHeight: 29
            Layout.preferredWidth: 200

            Text {
                id: detailInfor
                text: detailwire
                anchors.fill: parent
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

        }

        Rectangle {
            id: progressContainer
            x: 23
            y: 46
            width: 184
            height: 23
            radius: height / 2
            border.color: "#E0E0E0"
            color: "#E1E1E1"
            clip: true
            property bool isVisible: true
                           opacity: isVisible ? 1 : 0

                           Behavior on opacity {
                               NumberAnimation { duration: 300 }
                           }

                           Rectangle {
                               id: progressIndicator
                               x: 0
                               width: 100
                               height: parent.height
                               radius: height / 2
                               border.color: "#E0E0E0"
                               gradient: Gradient {
                                   GradientStop { position: 0.0; color: "#3BC425" }
                                   GradientStop { position: 1.0; color: "#3BC425" }
                               }
                               anchors.verticalCenter: parent.verticalCenter

                               SequentialAnimation on x {
                                   running: progressContainer.isVisible
                                   loops: Animation.Infinite
                                   PropertyAnimation { from: -progressIndicator.width; to: progressContainer.width; duration: 800; easing.type: Easing.InOutQuad }
                               }
                               y: -46
                           }
        }

        ToolButton {
            id: toolButton2
            text: ""
            Layout.fillWidth: true
            Layout.preferredHeight: 38
            Layout.preferredWidth: 174
            font.pointSize: 10

            contentItem: Item {
                width: 180
                height: 60

                Image {
                    id: remoteImage
                    anchors.fill: parent
                    source: "images/remoteButton.png"
                    anchors.leftMargin: 0
                    anchors.topMargin: -13
                    anchors.bottomMargin: -13
                    anchors.rightMargin: 0
                    fillMode: Image.PreserveAspectFit
                    smooth: true

                    Text {
                        id: remoteText
                        text: userModeSelect === "MASTER" ? qsTr("REMOTE TO SLAVE") : qsTr("REMOTE TO MASTER")
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.leftMargin: -14
                        anchors.topMargin: 8
                        anchors.bottomMargin: 9
                        anchors.rightMargin: -24
                        font.pointSize: 7
                        font.bold: true
                        color: "#000000"
                    }
                }
            }

            background: Rectangle {
                color: "#00000000"
                border.color: "#00000000"
            }

            onClicked: {
//                if (userModeSelect === "MASTER") {
//                    userModeSelect = "SLAVE";
                    console.log("Switching to SLAVE...");
                    qmlCommand("CHANGE");
//                } else if(userModeSelect === "SLAVE") {
////                    userModeSelect = "MASTER";
//                    console.log("Switching to MASTER...");
//                    qmlCommand("CHANGETOMASTER");
//                }
            }
        }

    }

    //    ToolButton {
    //        id: phaseAButton
    //        x: 223
    //        y: 200
    //        Layout.preferredHeight: 58
    //        icon.source: "images/greenbuttonOn.png"
    //        icon.width: 40
    //        icon.height: 40
    //        Layout.preferredWidth: 58
    //        Layout.fillHeight: false
    //        Layout.fillWidth: false
    //        property bool isOnSettingPage: false
    //        visible: true
    //        onClicked: {

    //        }
    //    }

}



/*##^##
Designer {
    D{i:0;formeditorZoom:2}D{i:45}D{i:47}D{i:49}
}
##^##*/

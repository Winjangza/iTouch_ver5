import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.15

Item {
    width: 1000
    height: 475
    property bool focustextInformation: inputPanel.visible
    property string textforinformation:  textInformation.text
    visible: userLevelGlobalVars.count > 0 && (userLevelGlobalVars.get(0).userLevel >= 1 && userLevelGlobalVars.get(0).userLevel <= 3)

    onFocustextInformationChanged: {
        if(focustextInformation == false){
            textPhaseA.color = "#000000"
            textPhaseB.color = "#000000"
            textPhaseC.color = "#000000"
        }
    }
    onTextforinformationChanged: {
        if(textPhaseA.color == "#ff0000"){
            textPhaseA.text = textforinformation
        }
        if(textPhaseB.color == "#ff0000"){
            textPhaseB.text = textforinformation
        }
        if(textPhaseC.color == "#ff0000"){
            textPhaseC.text = textforinformation
        }
        console.log("onTextforinformationChanged",textforinformation)
    }

    Rectangle {
        id: rectangle
        color: "#f2f2f2"
        border.color: "#ffffff"
        border.width: 2
        anchors.fill: parent

        Text {
            id: thresholdsetting
            text: qsTr("THRESHOLD SETTING")
            anchors.fill: parent
            font.pixelSize: 18
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            anchors.topMargin: 8
            anchors.bottomMargin: 431
        }

        Text {
            id: text1
            text: "MARGIN SETTING: each margin cover FULL DISTANCE divided by MARGIN"
            anchors.fill: parent
            font.pixelSize: 15
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 96
            anchors.bottomMargin: 356
            font.underline: false
            font.pointSize: 20
        }

        RowLayout {
            anchors.fill: parent
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.bottomMargin: 8
            anchors.topMargin: 144

            ParameterPhaseA {
                id: parameterPhaseA
                height: 300
                Layout.fillHeight: false
                Layout.fillWidth: true
                Layout.preferredHeight: 305
                Layout.preferredWidth: 275
            }

            ParameterPhaseB {
                id: parameterPhaseB
                height: 300
                Layout.fillHeight: false
                Layout.fillWidth: true
                Layout.preferredHeight: 305
                Layout.preferredWidth: 283
            }

            ParameterPhaseC {
                id: parameterPhaseC
                width: 330
                height: 300
                Layout.fillHeight: false
                Layout.fillWidth: true
                Layout.preferredHeight: 305
                Layout.preferredWidth: 283
            }
        }

        RowLayout {
            x: 8
            y: 50
            width: 984
            height: 40

            RowLayout {

                Text {
                    id: phaseA
                    text: qsTr("PHASE A")
                    font.pixelSize: 16
                }

                TextField {
                    id: textPhaseA
                    Layout.preferredHeight: 40
                    Layout.preferredWidth: 120
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    placeholderText: qsTr("Text Field") ? valueThresholdA : qsTr("Text Field")
                    readOnly: (userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
                    background: Rectangle {
                        color: (userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
                               ? "#d3d3d3"
                               : "#ffffff"
                    border.color: "#bcbcbc"
                    radius: 5
                    }
                    focus: false
                    onFocusChanged: {
                        if (focus && !textTime.readOnly) {
                            textPhaseA.focus = false
                            currentField = "textPhaseA";
                            inputPanel.visible = true;
                            textInformation.visible = true;
                            textInformation.placeholderText = qsTr("Enter textPhaseA");
                            textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                            textInformation.text = "";
                            textInformation.focus = true;
                            textPhaseA.color = "#ff0000"
                        }
                    }
                }

                Text {
                    id: unitPhaseA
                    text: qsTr("mV")
                    font.pixelSize: 16
                }
            }

            RowLayout {

                Text {
                    id: phaseB
                    text: qsTr("PHASE B")
                    font.pixelSize: 16
                }

                TextField {
                    id: textPhaseB
                    Layout.preferredHeight: 40
                    Layout.preferredWidth: 120
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    placeholderText: qsTr("Text Field") ?valueThresholdB : qsTr("Text Field")
                    readOnly: (userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
                    background: Rectangle {
                        color: (userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
                               ? "#d3d3d3"
                               : "#ffffff"
                    border.color: "#bcbcbc"
                    radius: 5
                    }
                    focus: false
                    onFocusChanged: {
                        if (focus && !textTime.readOnly) {
                            textPhaseB.focus = false
                            currentField = "textPhaseB";
                            inputPanel.visible = true;
                            textInformation.visible = true;
                            textInformation.placeholderText = qsTr("Enter textPhaseB");
                            textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                            textInformation.text = "";
                            textInformation.focus = true;
                            textPhaseB.color = "#ff0000"
                        }
                    }
                }

                Text {
                    id: unitPhaseB
                    text: qsTr("mV")
                    font.pixelSize: 16
                }
            }

            RowLayout {

                Text {
                    id: phaseC
                    text: qsTr("PHASE C")
                    font.pixelSize: 16
                }

                TextField {
                    id: textPhaseC
                    Layout.preferredHeight: 40
                    Layout.preferredWidth: 120
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    placeholderText: qsTr("Text Field")? valueThresholdC :qsTr("Text Field")
                    readOnly: (userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
                    background: Rectangle {
                        color: (userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
                               ? "#d3d3d3"
                               : "#ffffff"
                    border.color: "#bcbcbc"
                    radius: 5
                    }
                    focus: false
                    onFocusChanged: {
                        if (focus && !textTime.readOnly ) {
                            textPhaseC.focus = false
                            currentField = "textPhaseC";
                            inputPanel.visible = true;
                            textInformation.visible = true;
                            textInformation.placeholderText = qsTr("Enter textPhaseC");
                            textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                            textInformation.text = "";
                            textInformation.focus = true;
                            textPhaseC.color = "#ff0000"
                        }
                    }
                }

                Text {
                    id: unitPhaseC
                    text: qsTr("mV")
                    font.pixelSize: 16
                }
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.rightMargin: 8
            anchors.leftMargin: 8
            anchors.bottomMargin: 332
            anchors.topMargin: 125

            Text {
                id: text2
                text: qsTr("PHASE A")
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 24
                Layout.preferredWidth: 51
            }

            Text {
                id: text3
                text: qsTr("PHASE B")
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredHeight: 24
                Layout.preferredWidth: 51
            }

            Text {
                id: text4
                text: qsTr("PHASE C")
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredHeight: 24
                Layout.preferredWidth: 51
            }
        }
    }


}

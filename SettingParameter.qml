import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.15

Item {
    id:rootSettingPara
    width: 1000
    height: 475
//    property bool focustextInformation: inputPanel.visible
//    property string textforinformation:  textInformation.text
    property var inputPanelRef: null
    property var textInformationRef: null
    property bool focustextInformation: inputPanelRef ? inputPanelRef.visible : false
    property string textforinformation: textInformationRef ? textInformationRef.text : ""
//    visible: userLevelGlobalVars.count > 0 && (userLevelGlobalVars.get(0).userLevel >= 1 && userLevelGlobalVars.get(0).userLevel <= 3)

    onFocustextInformationChanged: {
        if (!focustextInformation) {
            textPhaseA.color = "#000000"
            textPhaseB.color = "#000000"
            textPhaseC.color = "#000000"
        }
    }
    onTextforinformationChanged: {
        if (currentField === "textPhaseA") {
            textPhaseA.text = textforinformation
        } else if (currentField === "textPhaseB") {
            textPhaseB.text = textforinformation
        } else if (currentField === "textPhaseC") {
            textPhaseC.text = textforinformation
        }

        console.log("onTextforinformationChanged",
                    textforinformation,
                    "currentField=", currentField)
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
            anchors.topMargin: 91
            anchors.bottomMargin: 361
            font.underline: false
            font.pointSize: 20
        }

        RowLayout {
            anchors.fill: parent
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.bottomMargin: 20
            anchors.topMargin: 138

            ParameterPhaseA {
                id: parameterPhaseA
                height: 300
                Layout.fillHeight: false
                Layout.fillWidth: true
                Layout.preferredHeight: 305
                Layout.preferredWidth: 275
//                inputPanelRef: rootSettingPara.inputPanelRef
//                textInformationRef: rootSettingPara.textInformationRef
            }

            ParameterPhaseB {
                id: parameterPhaseB
                height: 300
                Layout.fillHeight: false
                Layout.fillWidth: true
                Layout.preferredHeight: 305
                Layout.preferredWidth: 283
//                inputPanelRef: rootSettingPara.inputPanelRef
//                textInformationRef: rootSettingPara.textInformationRef
            }

            ParameterPhaseC {
                id: parameterPhaseC
                width: 330
                height: 300
                Layout.fillHeight: false
                Layout.fillWidth: true
                Layout.preferredHeight: 305
                Layout.preferredWidth: 283
//                inputPanelRef: rootSettingPara.inputPanelRef
//                textInformationRef: rootSettingPara.textInformationRef
            }
        }

        RowLayout {
            x: 8
            y: 45
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
                    placeholderText: valueThresholdA || qsTr("Text Field")
                    readOnly: userLevelGlobalVars.count === 0 ||
                              userLevelGlobalVars.get(0).userLevel !== 1
                    color: (userLevelGlobalVars.count > 0 &&
                            userLevelGlobalVars.get(0).userLevel !== 1)
                           ? "#808080" : "#000000"

                    background: Rectangle {
                        color: textPhaseA.readOnly ? "#d3d3d3" : "#ffffff"
                        border.color: "#bcbcbc"
                        radius: 5
                    }

                    focus: false
                    activeFocusOnTab: false

                    onFocusChanged: {
                        if (focus && !textPhaseA.readOnly) {
                            Qt.callLater(function() {
                                textPhaseA.focus = false
                                currentField = "textPhaseA"

                                if (inputPanelRef)
                                    inputPanelRef.visible = true

                                if (textInformationRef) {
                                    textInformationRef.visible = true
                                    textInformationRef.placeholderText = qsTr("Enter textPhaseA")
                                    textInformationRef.inputMethodHints = Qt.ImhFormattedNumbersOnly
                                    textInformationRef.text = ""
                                    textInformationRef.forceActiveFocus()
                                }

                                textPhaseA.color = "#ff0000"

                                Qt.callLater(function() {
                                    Qt.inputMethod.show()
                                })
                            })
                        } else if (!focus) {
                            textPhaseA.color = "#000000"
                        }
                    }
                }

//                TextField {
//                    id: textPhaseA
//                    Layout.preferredHeight: 40
//                    Layout.preferredWidth: 120
//                    inputMethodHints: Qt.ImhFormattedNumbersOnly
//                    placeholderText: valueThresholdA || qsTr("Text Field")
//                    readOnly: userLevelGlobalVars.count === 0 ||
//                              userLevelGlobalVars.get(0).userLevel !== 1
//                    color: (userLevelGlobalVars.count > 0 &&
//                            userLevelGlobalVars.get(0).userLevel !== 1)
//                           ? "#808080" : "#000000"
//                    background: Rectangle {
//                        color: textPhaseA.readOnly ? "#d3d3d3" : "#ffffff"
//                        border.color: "#bcbcbc"
//                        radius: 5
//                    }
//                    focus: false
//                    activeFocusOnTab: false
//                    onFocusChanged: {
//                        if (focus && !textPhaseA.readOnly) {
//                            Qt.callLater(function() {
//                                textPhaseA.focus = false;
//                                currentField = "textPhaseA";
//                                inputPanel.visible = true;
//                                textInformation.visible = true;
//                                textInformation.placeholderText = qsTr("Enter textPhaseA");
//                                textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
//                                textInformation.text = "";
////                                textInformation.focus = true;
//                                textPhaseA.color = "#ff0000";
//                            });
//                        }
//                    }
//                }

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
                    placeholderText: valueThresholdB || qsTr("Text Field")
                    readOnly: userLevelGlobalVars.count === 0 ||
                              userLevelGlobalVars.get(0).userLevel !== 1
                    color: (userLevelGlobalVars.count > 0 &&
                            userLevelGlobalVars.get(0).userLevel !== 1)
                           ? "#808080" : "#000000"

                    background: Rectangle {
                        color: textPhaseB.readOnly ? "#d3d3d3" : "#ffffff"
                        border.color: "#bcbcbc"
                        radius: 5
                    }

                    focus: false
                    activeFocusOnTab: false

                    onFocusChanged: {
                        if (focus && !textPhaseB.readOnly) {
                            Qt.callLater(function() {
                                textPhaseB.focus = false
                                currentField = "textPhaseB"

                                if (inputPanelRef)
                                    inputPanelRef.visible = true

                                if (textInformationRef) {
                                    textInformationRef.visible = true
                                    textInformationRef.placeholderText = qsTr("Enter textPhaseB")
                                    textInformationRef.inputMethodHints = Qt.ImhFormattedNumbersOnly
                                    textInformationRef.text = ""
                                    textInformationRef.forceActiveFocus()
                                }

                                textPhaseB.color = "#ff0000"

                                Qt.callLater(function() {
                                    Qt.inputMethod.show()
                                })
                            })
                        } else if (!focus) {
                            textPhaseB.color = "#000000"
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
                    placeholderText: valueThresholdC || qsTr("Text Field")
                    readOnly: userLevelGlobalVars.count === 0 ||
                              userLevelGlobalVars.get(0).userLevel !== 1
                    color: (userLevelGlobalVars.count > 0 &&
                            userLevelGlobalVars.get(0).userLevel !== 1)
                           ? "#808080" : "#000000"

                    background: Rectangle {
                        color: textPhaseC.readOnly ? "#d3d3d3" : "#ffffff"
                        border.color: "#bcbcbc"
                        radius: 5
                    }

                    focus: false
                    activeFocusOnTab: false

                    onFocusChanged: {
                        if (focus && !textPhaseC.readOnly) {
                            Qt.callLater(function() {
                                textPhaseC.focus = false
                                currentField = "textPhaseC"

                                if (inputPanelRef)
                                    inputPanelRef.visible = true

                                if (textInformationRef) {
                                    textInformationRef.visible = true
                                    textInformationRef.placeholderText = qsTr("Enter textPhaseC")
                                    textInformationRef.inputMethodHints = Qt.ImhFormattedNumbersOnly
                                    textInformationRef.text = ""
                                    textInformationRef.forceActiveFocus()
                                }

                                textPhaseC.color = "#ff0000"

                                Qt.callLater(function() {
                                    Qt.inputMethod.show()
                                })
                            })
                        } else if (!focus) {
                            textPhaseC.color = "#000000"
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
            anchors.bottomMargin: 337
            anchors.topMargin: 120

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

/*##^##
Designer {
    D{i:0;formeditorZoom:0.66}
}
##^##*/

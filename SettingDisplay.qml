import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtWebSockets 1.0
import QtQuick.Extras 1.4
import QtQuick.VirtualKeyboard 2.15
import QtQuick.VirtualKeyboard.Styles 2.15
import QtQuick.VirtualKeyboard.Settings 2.15
import QtQuick3D 1.15
Item {
    width: 1000
    height: 475
    property bool focustextInformation: inputPanel.visible
    property string textforinformation:  textInformation.text
    visible: userLevelGlobalVars.count > 0 && (userLevelGlobalVars.get(0).userLevel >= 1 && userLevelGlobalVars.get(0).userLevel <= 3)

    onFocustextInformationChanged: {
        if(focustextInformation == false){
            sagText.color = "#000000"
            samplingText.color = "#000000"
            distancetostartText.color = "#000000"
            distancetoshowText.color = "#000000"
            fulldistanceText.color = "#000000"
        }
    }
    onTextforinformationChanged: {
        if(sagText.color == "#ff0000"){
            sagText.text = textforinformation
        }
        if(samplingText.color == "#ff0000"){
            samplingText.text = textforinformation
        }
        if(distancetostartText.color == "#ff0000"){
            distancetostartText.text = textforinformation
        }
        if(distancetoshowText.color == "#ff0000"){
            distancetoshowText.text = textforinformation
        }
        if(fulldistanceText.color == "#ff0000"){
            fulldistanceText.text = textforinformation
        }
        console.log("onTextforinformationChanged",textforinformation)
    }


    Rectangle {
        id: rectangle
        color: "#f2f2f2"
        anchors.fill: parent

        Datatagging {
            id: datatagging
            anchors.fill: parent
            anchors.topMargin: 47
            anchors.leftMargin: 302
        }
    }

    Rectangle {
        id: rectangle1
        color: "#f2f2f2"
        border.width: 0
        anchors.fill: parent
        anchors.rightMargin: 715

        ColumnLayout {
            x: 8
            y: 49
            width: 175
            height: 360

            Text {
                id: sag
                text: qsTr("SAG")
                font.pixelSize: 17
                Layout.fillWidth: true
            }

            Text {
                id: samplingrate
                text: qsTr("SAMPLING RATE(m/sampling)")
                font.pixelSize: 17
                Layout.fillWidth: true
            }

            Text {
                id: distancestart
                text: qsTr("DISTANCE TO START(KM)")
                font.pixelSize: 17
                Layout.fillWidth: true
            }

            Text {
                id: distanceshow
                text: qsTr("DISTANCE TO SHOW(KM)")
                font.pixelSize: 17
                Layout.fillWidth: true
            }

            Text {
                id: fulldistance
                text: qsTr("FULL DISTANCE(KM)")
                font.pixelSize: 17
                Layout.fillWidth: true
            }
        }

        ColumnLayout {
            height: 365
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 8
            anchors.rightMargin: 77
            anchors.topMargin: 77
            TextField {
                id: sagText
                Layout.fillWidth: true
                placeholderText: (typeof sagfactor !== "undefined" && sagfactor !== null) ? sagfactor : qsTr("Enter Sag")
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
                        sagText.focus = false;
                        currentField = "sagText";
                        inputPanel.visible = true;
                        textInformation.visible = true;
                        textInformation.placeholderText = qsTr("Enter Sag");
                        textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                        textInformation.text = "";
                        textInformation.focus = true;
                        sagText.color = "#ff0000";
                    }
                }
            }

            TextField {
                id: samplingText
                Layout.fillWidth: true
                placeholderText: (typeof sampling !== "undefined" && sampling !== null) ? sampling : qsTr("Enter Sampling")
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
                        samplingText.focus = false;
                        currentField = "samplingText";
                        inputPanel.visible = true;
                        textInformation.visible = true;
                        textInformation.placeholderText = qsTr("Enter Sampling");
                        textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                        textInformation.text = "";
                        textInformation.focus = true;
                        samplingText.color = "#ff0000";
                    }
                }
            }

            TextField {
                id: distancetostartText
                Layout.fillWidth: true
                placeholderText: (typeof displayStart !== "undefined" && displayStart !== null) ? displayStart : qsTr("Enter Dist. Start")
                focus: false
                onFocusChanged: {
                    if (focus) {
                        distancetostartText.focus = false;
                        currentField = "distancetostartText";
                        inputPanel.visible = true;
                        textInformation.visible = true;
                        textInformation.placeholderText = qsTr("Enter Dist. Start");
                        textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                        textInformation.text = "";
                        textInformation.focus = true;
                        distancetostartText.color = "#ff0000";
                    }
                }
            }

            TextField {
                id: distancetoshowText
                Layout.fillWidth: true
                placeholderText: (typeof displayShow !== "undefined" && displayShow !== null) ? displayShow : qsTr("Enter Dist. Show")
                focus: false
                onFocusChanged: {
                    if (focus) {
                        distancetoshowText.focus = false;
                        currentField = "distancetoshowText";
                        inputPanel.visible = true;
                        textInformation.visible = true;
                        textInformation.placeholderText = qsTr("Enter Dist. Show");
                        textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                        textInformation.text = "";
                        textInformation.focus = true;
                        distancetoshowText.color = "#ff0000";
                    }
                }
            }

            TextField {
                id: fulldistanceText
                Layout.fillWidth: true
                placeholderText: (typeof fulldistances !== "undefined" && fulldistances !== null) ? fulldistances : qsTr("Enter Full Dist")
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
                        fulldistanceText.focus = false;
                        currentField = "fulldistanceText";
                        inputPanel.visible = true;
                        textInformation.visible = true;
                        textInformation.placeholderText = qsTr("Enter Full Dist.");
                        textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                        textInformation.text = "";
                        textInformation.focus = true;
                        fulldistanceText.color = "#ff0000";
                    }
                }
            }
        }

    }

    RowLayout {
        x: 8
        y: 0
        width: 575
        height: 46

        Text {
            id: displaysetting1
            text: qsTr("DISPLAY SETTING")
            font.pixelSize: 18
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: text2
            text: qsTr("DATA TAGGING")
            font.pixelSize: 18
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
    }

    Item {
        id: __materialLibrary__
    }
    //    InputPanel {
    //        id: inputPanel
    //        y: 244
    //        height: 231
    //        visible: false
    //        anchors.left: parent.left
    //        anchors.right: parent.right
    //        anchors.rightMargin: 0
    //        anchors.leftMargin: 0

    //        Component.onCompleted: {
    //            visible = false;
    //            textInformation.visible = false;
    //        }

    //        TextField {
    //            id: textInformation
    //            anchors.fill: parent
    //            anchors.rightMargin: 0
    //            anchors.bottomMargin: 293
    //            anchors.leftMargin: 0
    //            anchors.topMargin: -104
    //            placeholderText: qsTr("Text Field")
    //            visible: false
    //            inputMethodHints: Qt.ImhFormattedNumbersOnly
    //            font.pointSize: 12

    //            Component.onCompleted: {
    //                focus = false;
    //            }

    //            Keys.onReturnPressed: {
    //                if (text.trim() !== "") {
    //                    if (currentField === "sagText") {
    //                        sagText.text = text;
    //                        var Sag = '{"objectName":"sagText","sagText": '+sagText.text+'}'
    //                        qmlCommand(Sag);
    //                        console.log("Sag Entered:", text, Sag);
    //                    } else if (currentField === "samplingText") {
    //                        samplingText.text = text;
    //                        var Sampling = '{"objectName":"samplingText","samplingText": '+samplingText.text+'}'
    //                        qmlCommand(Sampling);
    //                        console.log("Sampling Entered:", text,Sampling);
    //                    } else if (currentField === "distancetostartText") {
    //                        distancetostartText.text = text;
    //                        var distancetostart = '{"objectName":"distancetostartText","distancetostartText": '+distancetostartText.text+'}'
    //                        qmlCommand(distancetostart);
    //                        console.log("Dist. Start Entered:", text,distancetostart);
    //                    } else if (currentField === "distancetoshowText") {
    //                        distancetoshowText.text = text;
    //                        var distancetoshow = '{"objectName":"distancetoshowText","distancetoshowText": '+distancetoshowText.text+'}'
    //                        qmlCommand(distancetoshow);
    //                        console.log("Dist. Show Entered:", text,distancetoshow);
    //                    }else if (currentField === "fulldistanceText") {
    //                        fulldistanceText.text = text;
    //                        var fulldistance = '{"objectName":"fulldistanceText","fulldistanceText": '+fulldistanceText.text+'}'
    //                        qmlCommand(fulldistance);
    //                        console.log("Full Dist. Entered:", text,fulldistance);
    //                    }
    //                }
    //                inputPanel.visible = false;
    //                visible = false;
    //            }
    //        }
    //    }
}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}D{i:10}
}
##^##*/

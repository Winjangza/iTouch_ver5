//import QtQuick 2.15
//import QtQuick.Controls 2.15
//import QtQuick.Layouts 1.15
//import QtQuick.VirtualKeyboard 2.15


//Item {
//    width: 300
//    height: 380

//    property int marginCountB: updateMarginB ? listMarginB : updateMarginB
//    property bool focustextInformation: inputPanel.visible
//    property string textforinformation:  textInformation.text
//    property var updateValueMarginB : updateMarginB
//    property bool isReadOnly: userLevelGlobalVars.count === 0 || userLevelGlobalVars.get(0).userLevel !== 1
//    property int valueMarginVoltageBauto: autoValueVoltageB

//    onFocustextInformationChanged: {
//        if(focustextInformation == false){
//            textFieldMarginNumber.color = "#000000"
//        }
//        if(valueVoltage == false){
//            valueVoltage.color = "#000000"
//        }
//    }
//    onTextforinformationChanged: {
//        if(textFieldMarginNumber.color == "#ff0000"){
//            textFieldMarginNumber.text = textforinformation
//        }
//        if(valueVoltage.color == "#ff0000"){
//            valueVoltage.text = textforinformation
//        }
//        if(focusIndex >= 0){
//            newlistMarginB.setProperty(focusIndex,"valueMarginB",textforinformation)
//            console.log("newlistMarginB:",newlistMarginB.get(focusIndex).valueMarginB,"focusIndex:",focusIndex)
//        }

//        console.log("onTextforinformationChanged:",textforinformation, "valueVoltage:",valueVoltage.text,"focusIndex:",focusIndex)

//    }
//    Rectangle {
//        id: rectangle
//        color: "#f2f2f2"
//        border.color: "#c7c7c7"
//        border.width: 2
//        anchors.fill: parent
//        anchors.bottomMargin: -30

//        RowLayout {
//            id: rowLayout
//            y: 3
//            height: 33
//            anchors.leftMargin: 8
//            anchors.rightMargin: 8
//            anchors.left: parent.left
//            anchors.right: parent.right
//            anchors.topMargin: -25
//            spacing: 10

//            Text {
//                id: text2
//                color: "#244d77"
//                text: qsTr("MARGIN")
//                font.pixelSize: 15
//            }

//            TextField {
//                id: textFieldMarginNumber
//                horizontalAlignment: Text.AlignHCenter
//                font.pointSize: 10
//                Layout.fillWidth: true
//                Layout.fillHeight: true
//                Layout.preferredHeight: 33
//                Layout.preferredWidth: 60

//                text: marginCountB
//                readOnly: isReadOnly
//                inputMethodHints: Qt.ImhFormattedNumbersOnly
//                color: isReadOnly ? "#808080" : "#000000"

//                background: Rectangle {
//                    color: isReadOnly ? "#d3d3d3" : "#ffffff"
//                    border.color: "#bcbcbc"
//                    radius: 5
//                }

//                Keys.onReturnPressed: Qt.inputMethod.hide()

//                onAccepted: {
//                    let value = updateValueMarginB;
//                    if (!isNaN(value) && value >= 0) {
//                        marginCountB = value;
//                    }
//                }

//                onFocusChanged: {
//                    if (focus && !readOnly) {
//                        Qt.inputMethod.show();
//                        textFieldMarginNumber.focus = false;
//                        currentField = "marginNumberB";
//                        inputPanel.visible = true;
//                        textInformation.visible = true;
//                        textInformation.text = "";
//                        textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
//                        textInformation.focus = true;
//                        textFieldMarginNumber.color = "#ff0000";
//                    } else {
//                        textFieldMarginNumber.color = "#000000";
//                    }
//                }
//                Component.onCompleted: {
//                    Qt.callLater(() => {
//                        // ปิด keyboard ทันทีเมื่อหน้าถูกโหลด
//                        Qt.inputMethod.hide();
//                        inputPanel.visible = false;
//                        textInformation.visible = false;
//                        textInformation.focus = false;
//                    });
//                }

//            }

//            TextField {
//                id: valueVoltage
//                horizontalAlignment: Text.AlignHCenter
//                inputMethodHints: Qt.ImhFormattedNumbersOnly
//                Layout.fillWidth: true
//                Layout.fillHeight: true
//                Layout.preferredWidth: 80
//                Layout.preferredHeight: 33
//                font.pointSize: 10
//                text: valueMarginVoltageBauto

//                readOnly: isReadOnly
//                color: isReadOnly ? "#808080" : "#000000"

//                background: Rectangle {
//                    color: isReadOnly ? "#d3d3d3" : "#ffffff"
//                    border.color: "#bcbcbc"
//                    radius: 5
//                }

//                onFocusChanged: {
//                    if (focus && !readOnly) {
//                        Qt.inputMethod.show();
//                        currentField = "valueVoltageB";
//                        inputPanel.visible = true;
//                        textInformation.visible = true;
//                        textInformation.text = "";
//                        textInformation.focus = true;
//                        valueVoltage.color = "#ff0000";
//                    } else {
//                        valueVoltage.color = "#000000";
//                    }
//                }
//                Component.onCompleted: {
//                    Qt.callLater(() => {
//                        // ปิด keyboard ทันทีเมื่อหน้าถูกโหลด
//                        Qt.inputMethod.hide();
//                        inputPanel.visible = false;
//                        textInformation.visible = false;
//                        textInformation.focus = false;
//                    });
//                }

//                Keys.onReturnPressed: {
//                    Qt.inputMethod.hide();
//                }
//            }

//            ToolButton {
//                id: auto
//                width: 55
//                height: 27
//                text: qsTr("Auto")
//                Layout.minimumWidth: 50
//                font.pointSize: 10
//                Layout.fillWidth: true
//                Layout.fillHeight: true

//                enabled: !isReadOnly

//                Keys.onReturnPressed: Qt.inputMethod.hide()

//                onClicked: {
//                    var voltageValue = parseInt(valueVoltage.text); // Read `valueVoltage`

//                    if (!isNaN(voltageValue)) {
//                        console.log("Updating all valueMarginB to:", voltageValue);

//                        for (let i = 0; i < newlistMarginB.count; i++) {
//                            newlistMarginB.setProperty(i, "valueMarginB", voltageValue);
//                        }

//                        var autoCMD = '{"objectName":"autoSetValueMarginB", "autoValueVoltage":' + valueVoltage.text + ', "rangeofmargin":' + textFieldMarginNumber.text + ' , "PHASE": "B"}';
//                        console.log("Sending Auto Command:", autoCMD);
//                        qmlCommand(autoCMD);
//                    } else {
//                        console.log("Invalid voltage value. Please enter a valid number in valueVoltage.");
//                    }
//                }
//            }
//        }

//        ScrollView {
//            id: scrollView
//            anchors.top: rowLayout.bottom
//            anchors.bottom: parent.bottom
//            anchors.left: parent.left
//            anchors.right: parent.right
//            anchors.margins: 10
//            anchors.topMargin: 6
//            anchors.bottomMargin: 8
//            anchors.rightMargin: 8
//            anchors.leftMargin: 8
//            clip: true

//            contentHeight: columnContainer.height

//            Column {
//                id: columnContainer
//                spacing: 10
//                width: scrollView.width

//                Repeater {
//                    id: repeaternewlistMarginB
//                    model: newlistMarginB

//                    delegate: RowLayout {
//                        width: parent.width
//                        spacing: 10

//                        Text {
//                            id: textMargin
//                            text: model.list_marginB
//                            font.pixelSize: 18
//                        }

//                        TextField {
//                            id: textFieldMargin
//                            Layout.preferredHeight: 33
//                            Layout.preferredWidth: 101
//                            inputMethodHints: Qt.ImhFormattedNumbersOnly
//                            placeholderText: qsTr("Value")
//                            text: model.valueMarginB

//                            readOnly: userLevelGlobalVars.count === 0 ||
//                                      userLevelGlobalVars.get(0).userLevel !== 1

//                            color: (userLevelGlobalVars.count > 0 &&
//                                    userLevelGlobalVars.get(0).userLevel !== 1)
//                                   ? "#808080" : "#000000"

//                            background: Rectangle {
//                                color: textFieldMargin.readOnly ? "#d3d3d3" : "#ffffff"
//                                border.color: "#bcbcbc"
//                                radius: 5
//                            }

//                            onFocusChanged: {
//                                if (focus && !readOnly) {
//                                    Qt.inputMethod.show();
//                                    currentField = "cheangeValueofVoltageB";
//                                    inputPanel.visible = true;
//                                    textInformation.visible = true;
//                                    textInformation.text = "";
//                                    textInformation.focus = true;
//                                    textFieldMargin.color = "#ff0000";
//                                    focusIndex = model.voltageIndex;
//                                    console.log("focusIndex_onchange:", focusIndex, model.voltageIndex, model.list_marginB, textFieldMarginNumber.text);
//                                } else {
//                                    textFieldMargin.color = "#000000";
//                                }
//                            }

//                            Keys.onReturnPressed: {
//                                Qt.inputMethod.hide();
//                                focusIndex = -1;
//                                console.log("KeysonReturnPressed:", focusIndex, model.voltageIndex, model.list_marginB);
//                            }
//                        }


//                        Text {
//                            id: voltageUnit
//                            text: "mV"/*model.unitMaginB*/
//                            font.pixelSize: 18
//                        }
//                    }
//                }
//            }
//        }
//    }

//}

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.VirtualKeyboard 2.15

Item {
    id: rootParameterB
    width: 300
    height: 380
    focus: false
    activeFocusOnTab: false

    property int marginCountB: updateMarginB ? listMarginB : updateMarginB
    property bool focustextInformation: inputPanel.visible
    property string textforinformation: textInformation.text
    property var updateValueMarginB: updateMarginB
    property bool isReadOnly: userLevelGlobalVars.count === 0 || userLevelGlobalVars.get(0).userLevel !== 1
    property int valueMarginVoltageBauto: autoValueVoltageB

    // ✅ กัน keyboard เด้งเอง
    property bool allowKeyboardPopup: false

    function resetKeyboardState() {
        allowKeyboardPopup = false
        Qt.inputMethod.hide()
        inputPanel.visible = false
        textInformation.visible = false
        textInformation.focus = false

        textFieldMarginNumber.focus = false
        valueVoltageB.focus = false
        focusIndex = -1
    }

    Component.onCompleted: {
        Qt.callLater(function() {
            resetKeyboardState()
        })
    }

    onVisibleChanged: {
        if (!visible)
            resetKeyboardState()
    }

    onFocustextInformationChanged: {
        if (focustextInformation === false) {
            textFieldMarginNumber.color = "#000000"
            valueVoltageB.color = "#000000"
            allowKeyboardPopup = false
        }
    }

    onTextforinformationChanged: {
        if (textFieldMarginNumber.color === "#ff0000") {
            textFieldMarginNumber.text = textforinformation
        }
        if (valueVoltageB.color === "#ff0000") {
            valueVoltageB.text = textforinformation
        }
        if (focusIndex >= 0) {
            newlistMarginB.setProperty(focusIndex, "valueMarginB", textforinformation)
            console.log("onTextforinformationChanged:",
                        textforinformation,
                        "valueVoltage:", valueVoltageB.text,
                        "focusIndex:", focusIndex)
        }

        console.log("onTextforinformationChanged:",
                    textforinformation,
                    "valueVoltage:", valueVoltageB.text,
                    "focusIndex:", focusIndex)
    }

    Rectangle {
        id: rectangle
        color: "#f2f2f2"
        border.color: "#c7c7c7"
        border.width: 2
        anchors.fill: parent
        anchors.bottomMargin: -30

        RowLayout {
            id: rowLayoutB
            y: 3
            height: 33
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: -25
            spacing: 10

            Text {
                id: text2
                color: "#244d77"
                text: qsTr("MARGIN")
                font.pixelSize: 15
            }

            TextField {
                id: textFieldMarginNumber
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 10
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 33
                Layout.preferredWidth: 60
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                placeholderText: marginCountB || qsTr("Text Field")
                readOnly: userLevelGlobalVars.count === 0 ||
                          userLevelGlobalVars.get(0).userLevel !== 1
                color: (userLevelGlobalVars.count > 0 &&
                        userLevelGlobalVars.get(0).userLevel !== 1)
                       ? "#808080" : "#000000"

                background: Rectangle {
                    color: textFieldMarginNumber.readOnly ? "#d3d3d3" : "#ffffff"
                    border.color: "#bcbcbc"
                    radius: 5
                }

                focus: false
                activeFocusOnTab: false

                onFocusChanged: {
                    if (focus && !textFieldMarginNumber.readOnly) {
                        textFieldMarginNumber.focus = false
                        currentField = "marginNumberB"

                        if (inputPanelRef)
                            inputPanelRef.visible = true

                        if (textInformationRef) {
                            textInformationRef.visible = true
                            textInformationRef.text = ""
                            textInformationRef.inputMethodHints = Qt.ImhFormattedNumbersOnly
                            textInformationRef.forceActiveFocus()
                        }

                        textFieldMarginNumber.color = "#ff0000"

                        Qt.callLater(function() {
                            Qt.inputMethod.show()
                        })
                    } else if (!focus) {
                        textFieldMarginNumber.color = "#000000"
                    }
                }
            }
            TextField {
                id: valueVoltageB
                Layout.preferredHeight: 40
                Layout.preferredWidth: 120
                inputMethodHints: Qt.ImhFormattedNumbersOnly

                text: valueMarginVoltageBauto !== undefined && valueMarginVoltageBauto !== null
                      ? String(valueMarginVoltageBauto) : ""
                placeholderText: qsTr("Text Field")

                readOnly: userLevelGlobalVars.count === 0 ||
                          userLevelGlobalVars.get(0).userLevel !== 1
                color: (userLevelGlobalVars.count > 0 &&
                        userLevelGlobalVars.get(0).userLevel !== 1)
                       ? "#808080" : "#000000"

                background: Rectangle {
                    color: valueVoltageB.readOnly ? "#d3d3d3" : "#ffffff"
                    border.color: "#bcbcbc"
                    radius: 5
                }

                focus: false
                activeFocusOnTab: false

                onFocusChanged: {
                    if (focus && !valueVoltageB.readOnly) {
                        Qt.callLater(function() {
                            valueVoltageB.focus = false
                            currentField = "valueVoltageB"

                            if (inputPanelRef)
                                inputPanelRef.visible = true

                            if (textInformationRef) {
                                textInformationRef.visible = true
                                textInformationRef.placeholderText = qsTr("Enter valueVoltageB")
                                textInformationRef.inputMethodHints = Qt.ImhFormattedNumbersOnly
                                textInformationRef.text = valueVoltageB.text
                                textInformationRef.forceActiveFocus()
                            }

                            valueVoltageB.color = "#ff0000"

                            Qt.callLater(function() {
                                Qt.inputMethod.show()
                            })
                        })
                    } else if (!focus) {
                        valueVoltageB.color = "#000000"
                    }
                }
            }
            ToolButton {
                id: auto
                width: 55
                height: 27
                text: qsTr("Auto")
                Layout.minimumWidth: 50
                font.pointSize: 10
                Layout.fillWidth: true
                Layout.fillHeight: true

                enabled: !isReadOnly

                Keys.onReturnPressed: {
                    resetKeyboardState()
                }

                onClicked: {
                    let rangeValue = parseInt(textFieldMarginNumber.text, 10)
                    if (isNaN(rangeValue))
                        rangeValue = 0

                    let voltageValue = parseInt(valueVoltageB.text, 10)
                    if (isNaN(voltageValue))
                        voltageValue = 0
                    for (let i = 0; i < newlistMarginB.count; i++) {
                        newlistMarginB.setProperty(i, "valueMarginB", voltageValue)
                    }
                    var autoCMD = JSON.stringify({
                        objectName: "autoSetValueMarginB",
                        autoValueVoltage: voltageValue,
                        rangeofmargin: rangeValue,
                        PHASE: "B"
                    })

                    console.log("Sending Auto Command:", autoCMD)
                    qmlCommand(autoCMD)
//                    resetKeyboardState()

//                    var voltageValue = parseInt(valueVoltageB.text)

//                    if (!isNaN(voltageValue)) {
//                        console.log("Updating all valueMarginB to:", voltageValue)

//                        for (let i = 0; i < newlistMarginB.count; i++) {
//                            newlistMarginB.setProperty(i, "valueMarginB", voltageValue)
//                        }

//                        var autoCMD = '{"objectName":"autoSetValueMarginB", "autoValueVoltage":' +
//                                      valueVoltage.text +
//                                      ', "rangeofmargin":' +
//                                      textFieldMarginNumber.text +
//                                      ' , "PHASE": "B"}'
//                        console.log("Sending Auto Command:", autoCMD)
//                        qmlCommand(autoCMD)
//                    } else {
//                        console.log("Invalid voltage value. Please enter a valid number in valueVoltage.")
//                    }
                }
            }
        }

        ScrollView {
            id: scrollViewB
            anchors.top: rowLayoutB.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            clip: true
            focus: false

            contentHeight: columnContainerB.height

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                propagateComposedEvents: true
                onPressed: {
                    rootParameterB.resetKeyboardState()
                    mouse.accepted = false
                }
            }

            Column {
                id: columnContainerB
                spacing: 10
                width: scrollViewB.width

                Repeater {
                    model: newlistMarginB

                    delegate: RowLayout {
                        width: parent.width
                        spacing: 10

                        Text {
                            text: model.list_marginB
                            font.pixelSize: 18
                        }

                        TextField {
                            id: textFieldMarginB
                            text: model.valueMarginB
                            Layout.preferredHeight: 33
                            Layout.preferredWidth: 101
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                            placeholderText: qsTr("Value")
                            readOnly: userLevelGlobalVars.count === 0 ||
                                      userLevelGlobalVars.get(0).userLevel !== 1
                            focus: false
                            activeFocusOnTab: false

                            color: (userLevelGlobalVars.count > 0 &&
                                    userLevelGlobalVars.get(0).userLevel !== 1)
                                   ? "#808080" : "#000000"

                            background: Rectangle {
                                color: textFieldMarginB.readOnly ? "#d3d3d3" : "#ffffff"
                                border.color: "#bcbcbc"
                                radius: 5
                            }

                            onFocusChanged: {
                                if (!focus) {
                                    textFieldMarginB.color = "#000000"
                                }
                            }

                            Keys.onReturnPressed: {
                                resetKeyboardState()
                            }

                            TapHandler {
                                enabled: !(userLevelGlobalVars.count === 0 ||
                                           userLevelGlobalVars.get(0).userLevel !== 1)

                                onTapped: {
                                    currentField = "cheangeValueofVoltageB"
                                    focusIndex = model.voltageIndex
                                    rootParameterB.allowKeyboardPopup = true
                                    textFieldMarginB.color = "#ff0000"

                                    if (inputPanelRef)
                                        inputPanelRef.visible = true

                                    if (textInformationRef) {
                                        textInformationRef.visible = true
                                        textInformationRef.text = textFieldMarginB.text
                                        textInformationRef.inputMethodHints = Qt.ImhFormattedNumbersOnly
                                        textInformationRef.forceActiveFocus()
                                    }

                                    Qt.callLater(function() {
                                        Qt.inputMethod.show()
                                    })
                                }
                            }
                        }

                        Text {
                            text: "mV"
                            font.pixelSize: 18
                        }
                    }
                }
            }
        }
    }
}

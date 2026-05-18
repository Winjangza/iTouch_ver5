//import QtQuick 2.15
//import QtQuick.Controls 2.15
//import QtQuick.Layouts 1.15
//import QtQuick.VirtualKeyboard 2.15

//Item {
//    width: 300
//    height: 380

//    property int marginCountA: updateMarginA ? listMarginA : updateMarginA
//    property bool focustextInformation: inputPanel.visible
//    property string textforinformation: textInformation.text
//    property var updateValueMarginA: updateMarginA
//    property bool isReadOnly: userLevelGlobalVars.count === 0 || userLevelGlobalVars.get(0).userLevel !== 1
//    property int valueMarginVoltageAauto: autoValueVoltageA

//    onFocustextInformationChanged: {
//        if (!focustextInformation) {
//            textFieldMarginNumber.color = "#000000"
//        }
//        if (!valueVoltageA.focus) {
//            valueVoltageA.color = "#000000"
//        }
//    }

//    onTextforinformationChanged: {
//        if (textFieldMarginNumber.color === "#ff0000")
//            textFieldMarginNumber.text = textforinformation
//        if (valueVoltageA.color === "#ff0000")
//            valueVoltageA.text = textforinformation
//        if (focusIndex >= 0)
//            newlistMarginA.setProperty(focusIndex, "valueMarginA", textforinformation)

//        console.log("onTextforinformationChanged:", textforinformation, "valueVoltage:", valueVoltageA.text, "focusIndex:", focusIndex)
//    }

//    Rectangle {
//        color: "#f2f2f2"
//        border.color: "#c7c7c7"
//        border.width: 2
//        anchors.fill: parent
//        anchors.bottomMargin: -30

//        RowLayout {
//            id: rowLayoutA
//            y: 3
//            height: 33
//            anchors.left: parent.left
//            anchors.right: parent.right
//            anchors.leftMargin: 8
//            anchors.rightMargin: 8
//            anchors.topMargin: -25
//            spacing: 10

//            Text {
//                text: qsTr("MARGIN")
//                color: "#244d77"
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

//                text: marginCountA
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
//                    let value = updateValueMarginA;
//                    if (!isNaN(value) && value >= 0) {
//                        marginCountA = value;
//                    }
//                }

//                onFocusChanged: {
//                    if (focus && !readOnly) {
//                        Qt.inputMethod.show();
//                        textFieldMarginNumber.focus = false;
//                        currentField = "marginNumberA";
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

////            TextField {
////                id: textFieldMarginNumber
////                text: marginCountA
////                horizontalAlignment: Text.AlignHCenter
////                font.pointSize: 10
////                Layout.preferredHeight: 33
////                Layout.preferredWidth: 60
////                Layout.fillWidth: true
////                Layout.fillHeight: true

////                property bool hasClicked: false

////                readOnly: isReadOnly
////                inputMethodHints: Qt.ImhFormattedNumbersOnly
////                color: readOnly ? "#808080" : "#000000"

////                background: Rectangle {
////                    color: readOnly ? "#d3d3d3" : "#ffffff"
////                    border.color: "#bcbcbc"
////                    radius: 5
////                }

////                MouseArea {
////                    anchors.fill: parent
////                    onClicked: {
////                        textFieldMarginNumber.hasClicked = true;
////                        Qt.callLater(() => {
////                            currentField = "marginNumberA";
////                            inputPanel.visible = true;
////                            textInformation.visible = true;
////                            textInformation.text = "";
////                            textInformation.placeholderText = qsTr("Enter margin");
////                            textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
////                            textInformation.focus = true;
////                        });
////                    }
////                }

////                onAccepted: {
////                    let value = updateValueMarginA;
////                    if (!isNaN(value) && value >= 0)
////                        marginCountA = value;
////                }

////                Keys.onReturnPressed: Qt.inputMethod.hide()

////                onFocusChanged: {
////                    if (focus && !readOnly && hasClicked) {
////                        textFieldMarginNumber.color = "#ff0000";
////                    } else {
////                        textFieldMarginNumber.color = "#000000";
////                    }
////                }

////                Component.onCompleted: {
////                    Qt.callLater(() => {
////                        Qt.inputMethod.hide();
////                        inputPanel.visible = false;
////                        textInformation.visible = false;
////                        textInformation.focus = false;
////                    });
////                }
////            }

//            TextField {
//                id: valueVoltageA
//                horizontalAlignment: Text.AlignHCenter
//                inputMethodHints: Qt.ImhFormattedNumbersOnly
//                Layout.fillWidth: true
//                Layout.fillHeight: true
//                Layout.preferredWidth: 80
//                Layout.preferredHeight: 33
//                font.pointSize: 10
//                text: valueMarginVoltageAauto

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
//                        currentField = "valueVoltageA";
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

////            TextField {
////                id: valueVoltageA
////                horizontalAlignment: Text.AlignHCenter
////                Layout.preferredWidth: 80
////                Layout.preferredHeight: 33
////                Layout.fillWidth: true
////                Layout.fillHeight: true
////                font.pointSize: 10
////                text: valueMarginVoltageAauto

////                property bool hasClicked: false

////                readOnly: isReadOnly || !hasClicked
////                inputMethodHints: Qt.ImhFormattedNumbersOnly
////                color: readOnly ? "#808080" : "#000000"

////                background: Rectangle {
////                    color: readOnly ? "#d3d3d3" : "#ffffff"
////                    border.color: "#bcbcbc"
////                    radius: 5
////                }

////                MouseArea {
////                    anchors.fill: parent
////                    onClicked: {
////                        valueVoltageA.hasClicked = true;
////                        valueVoltageA.forceActiveFocus();
////                    }
////                }

////                onFocusChanged: {
////                    if (focus && !readOnly && hasClicked) {
////                        currentField = "valueVoltageA";
////                        inputPanel.visible = true;
////                        textInformation.visible = true;
////                        textInformation.text = "";
////                        textInformation.focus = true;
////                        valueVoltageA.color = "#ff0000";
////                    } else {
////                        valueVoltageA.color = "#000000";
////                    }
////                }

////                Keys.onReturnPressed: Qt.inputMethod.hide()

////                Component.onCompleted: {
////                    Qt.callLater(() => {
////                        Qt.inputMethod.hide();
////                        inputPanel.visible = false;
////                        textInformation.visible = false;
////                        textInformation.focus = false;
////                    });
////                }
////            }


//            ToolButton {
//                text: qsTr("Auto")
//                Layout.minimumWidth: 50
//                Layout.preferredWidth: 55
//                Layout.preferredHeight: 27
//                Layout.fillWidth: true
//                Layout.fillHeight: true
//                font.pointSize: 10

//                enabled: !isReadOnly

//                Keys.onReturnPressed: Qt.inputMethod.hide()

//                onClicked: {
//                    var voltageValue = parseInt(valueVoltageA.text);

//                    if (!isNaN(voltageValue)) {
//                        console.log("Updating all valueMarginA to:", voltageValue);

//                        for (let i = 0; i < newlistMarginA.count; i++) {
//                            newlistMarginA.setProperty(i, "valueMarginA", voltageValue);
//                        }

//                        var autoCMD = '{"objectName":"autoSetValueMarginA", "autoValueVoltage":' + voltageValue + ', "rangeofmargin":' + textFieldMarginNumber.text + ', "PHASE": "A"}';
//                        console.log("Sending Auto Command:", autoCMD);
//                        qmlCommand(autoCMD);
//                    } else {
//                        console.log("Invalid voltage value.");
//                    }
//                }
//            }

//        }

//        ScrollView {
//            id: scrollViewA
//            anchors.top: rowLayoutA.bottom
//            anchors.bottom: parent.bottom
//            anchors.left: parent.left
//            anchors.right: parent.right
//            anchors.margins: 10
//            clip: true

//            contentHeight: columnContainerA.height

//            Column {
//                id: columnContainerA
//                spacing: 10
//                width: scrollViewA.width

//                Repeater {
//                    model: newlistMarginA

//                    delegate: RowLayout {
//                        width: parent.width
//                        spacing: 10

//                        Text {
//                            text: model.list_marginA
//                            font.pixelSize: 18
//                        }

//                        TextField {
//                            id: textFieldMarginA
//                            text: model.valueMarginA
//                            Layout.preferredHeight: 33
//                            Layout.preferredWidth: 101
//                            inputMethodHints: Qt.ImhFormattedNumbersOnly
//                            placeholderText: qsTr("Value")
//                            readOnly: userLevelGlobalVars.count === 0 ||
//                                      userLevelGlobalVars.get(0).userLevel !== 1
////                            color: isReadOnly ? "#808080" : "#000000"
//                            color: (userLevelGlobalVars.count > 0 &&
//                                    userLevelGlobalVars.get(0).userLevel !== 1)
//                                   ? "#808080" : "#000000"
//                            background: Rectangle {
//                                color: textFieldMarginA.readOnly ? "#d3d3d3" : "#ffffff"
//                                border.color: "#bcbcbc"
//                                radius: 5
//                            }

//                            onFocusChanged: {
//                                if (focus && !readOnly) {
//                                    Qt.inputMethod.show();
//                                    currentField = "cheangeValueofVoltageA";
//                                    inputPanel.visible = true;
//                                    textInformation.visible = true;
//                                    textInformation.text = "";
//                                    textInformation.focus = true;
//                                    textFieldMarginA.color = "#ff0000";
//                                    focusIndex = model.voltageIndex;
//                                } else {
//                                    textFieldMarginA.color = "#000000";
//                                }
//                            }

//                            Keys.onReturnPressed: {
//                                Qt.inputMethod.hide();
//                                focusIndex = -1;
//                            }
//                        }

//                        Text {
//                            text: "mV" // Or model.unitMarginA if available
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
    id: rootParameterA
    width: 300
    height: 380
    focus: false
    activeFocusOnTab: false

    property int marginCountA: updateMarginA ? listMarginA : updateMarginA
    property bool focustextInformation: inputPanel.visible
    property string textforinformation: textInformation.text
    property var updateValueMarginA: updateMarginA
    property bool isReadOnly: userLevelGlobalVars.count === 0 || userLevelGlobalVars.get(0).userLevel !== 1
    property int valueMarginVoltageAauto: autoValueVoltageA

    // ✅ NEW: กัน keyboard เด้งเอง
    property bool allowKeyboardPopup: false

    function resetKeyboardState() {
        allowKeyboardPopup = false
        Qt.inputMethod.hide()
        inputPanel.visible = false
        textInformation.visible = false
        textInformation.focus = false

        textFieldMarginNumber.focus = false
        valueVoltageA.focus = false
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
        if (!focustextInformation) {
            textFieldMarginNumber.color = "#000000"
            valueVoltageA.color = "#000000"
            allowKeyboardPopup = false
        }
    }

    onTextforinformationChanged: {
        if (textFieldMarginNumber.color === "#ff0000")
            textFieldMarginNumber.text = textforinformation
        if (valueVoltageA.color === "#ff0000")
            valueVoltageA.text = textforinformation
        if (focusIndex >= 0)
            newlistMarginA.setProperty(focusIndex, "valueMarginA", textforinformation)

        console.log("onTextforinformationChanged:",
                    textforinformation,
                    "valueVoltage:", valueVoltageA.text,
                    "focusIndex:", focusIndex)
    }

    Rectangle {
        color: "#f2f2f2"
        border.color: "#c7c7c7"
        border.width: 2
        anchors.fill: parent
        anchors.bottomMargin: -30

        RowLayout {
            id: rowLayoutA
            y: 3
            height: 33
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            anchors.topMargin: -25
            spacing: 10

            Text {
                text: qsTr("MARGIN")
                color: "#244d77"
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
                placeholderText: marginCountA || qsTr("Text Field")
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
                    currentField = "marginNumberA"

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
                id: valueVoltageA
                Layout.preferredHeight: 40
                Layout.preferredWidth: 120
                inputMethodHints: Qt.ImhFormattedNumbersOnly

                text: valueMarginVoltageAauto !== undefined && valueMarginVoltageAauto !== null
                      ? String(valueMarginVoltageAauto) : ""
                placeholderText: qsTr("Text Field")

                readOnly: userLevelGlobalVars.count === 0 ||
                          userLevelGlobalVars.get(0).userLevel !== 1
                color: (userLevelGlobalVars.count > 0 &&
                        userLevelGlobalVars.get(0).userLevel !== 1)
                       ? "#808080" : "#000000"

                background: Rectangle {
                    color: valueVoltageA.readOnly ? "#d3d3d3" : "#ffffff"
                    border.color: "#bcbcbc"
                    radius: 5
                }

                focus: false
                activeFocusOnTab: false

                onFocusChanged: {
                    if (focus && !valueVoltageA.readOnly) {
                        Qt.callLater(function() {
                            valueVoltageA.focus = false
                            currentField = "valueVoltageA"

                            if (inputPanelRef)
                                inputPanelRef.visible = true

                            if (textInformationRef) {
                                textInformationRef.visible = true
                                textInformationRef.placeholderText = qsTr("Enter valueVoltageA")
                                textInformationRef.inputMethodHints = Qt.ImhFormattedNumbersOnly
                                textInformationRef.text = valueVoltageA.text
                                textInformationRef.forceActiveFocus()
                            }

                            valueVoltageA.color = "#ff0000"

                            Qt.callLater(function() {
                                Qt.inputMethod.show()
                            })
                        })
                    } else if (!focus) {
                        valueVoltageA.color = "#000000"
                    }
                }
            }

            ToolButton {
                text: qsTr("Auto")
                Layout.minimumWidth: 50
                Layout.preferredWidth: 55
                Layout.preferredHeight: 27
                Layout.fillWidth: true
                Layout.fillHeight: true
                font.pointSize: 10

                enabled: !isReadOnly

                Keys.onReturnPressed: {
                    resetKeyboardState()
                }

                onClicked: {

                    let rangeValue = parseInt(textFieldMarginNumber.text, 10)
                    if (isNaN(rangeValue))
                        rangeValue = 0

                    let voltageValue = parseInt(valueVoltageA.text, 10)
                    if (isNaN(voltageValue))
                        voltageValue = 0
                    for (let i = 0; i < newlistMarginA.count; i++) {
                        newlistMarginA.setProperty(i, "valueMarginA", voltageValue)
                    }
                    var autoCMD = JSON.stringify({
                        objectName: "autoSetValueMarginA",
                        autoValueVoltage: voltageValue,
                        rangeofmargin: rangeValue,
                        PHASE: "A"
                    })

                    console.log("Sending Auto Command:", autoCMD)
                    qmlCommand(autoCMD)
//                    if (!isNaN(voltageValue)) {
//                        console.log("Updating all valueMarginA to:", voltageValue)

//                        for (let i = 0; i < newlistMarginA.count; i++) {
//                            newlistMarginA.setProperty(i, "valueMarginA", voltageValue)
//                        }

//                        var autoCMD = '{"objectName":"autoSetValueMarginA", "autoValueVoltage":' + voltageValue + ', "rangeofmargin":' + textFieldMarginNumber.text + ', "PHASE": "A"}'
//                        console.log("Sending Auto Command:", autoCMD)
//                        qmlCommand(autoCMD)
//                    } else {
//                        console.log("Invalid voltage value.")
//                    }
                }
            }
        }

        ScrollView {
            id: scrollViewA
            anchors.top: rowLayoutA.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            clip: true
            focus: false

            contentHeight: columnContainerA.height

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                propagateComposedEvents: true
                onPressed: {
                    root.resetKeyboardState()
                    mouse.accepted = false
                }
            }

            Column {
                id: columnContainerA
                spacing: 10
                width: scrollViewA.width

                Repeater {
                    model: newlistMarginA

                    delegate: RowLayout {
                        width: parent.width
                        spacing: 10

                        Text {
                            text: model.list_marginA
                            font.pixelSize: 18
                        }

                        TextField {
                            id: textFieldMarginA
                            text: model.valueMarginA
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
                                color: textFieldMarginA.readOnly ? "#d3d3d3" : "#ffffff"
                                border.color: "#bcbcbc"
                                radius: 5
                            }

                            onFocusChanged: {
                                if (!focus) {
                                    textFieldMarginA.color = "#000000"
                                }
                            }

                            Keys.onReturnPressed: {
                                resetKeyboardState()
                            }

                            TapHandler {
                                enabled: !(userLevelGlobalVars.count === 0 ||
                                           userLevelGlobalVars.get(0).userLevel !== 1)

                                onTapped: {
                                    currentField = "cheangeValueofVoltageA"
                                    focusIndex = model.voltageIndex
                                    rootParameterA.allowKeyboardPopup = true
                                    textFieldMarginA.color = "#ff0000"

                                    if (inputPanelRef)
                                        inputPanelRef.visible = true

                                    if (textInformationRef) {
                                        textInformationRef.visible = true
                                        textInformationRef.text = textFieldMarginA.text
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

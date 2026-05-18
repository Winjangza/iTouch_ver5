////import QtQuick 2.15
////import QtQuick.Controls 2.15
////import QtQuick.Layouts 1.15
////import QtQuick.VirtualKeyboard 2.15

////Item {
////    width: 300
////    height: 380

////    property int marginCountC: updateMarginC ? listMarginC : updateMarginC
////    property bool focustextInformation: inputPanel.visible
////    property string textforinformation:  textInformation.text
////    property var updateValueMarginC : updateMarginC
////    property bool isReadOnly: userLevelGlobalVars.count === 0 || userLevelGlobalVars.get(0).userLevel !== 1
////    property int valueMarginVoltageCauto: autoValueVoltageC

////    onFocustextInformationChanged: {
////        if(focustextInformation == false){
////            textFieldMarginNumber.color = "#000000"
////        }
////        if(valueVoltage == false){
////            valueVoltage.color = "#000000"
////        }
////    }
////    onTextforinformationChanged: {
////        if(textFieldMarginNumber.color == "#ff0000"){
////            textFieldMarginNumber.text = textforinformation
////        }
////        if(valueVoltage.color == "#ff0000"){
////            valueVoltage.text = textforinformation
////        }
////        if(focusIndex >= 0){
////            newlistMarginC.setProperty(focusIndex,"valueMarginC",textforinformation)
////            console.log("newlistMarginC:",newlistMarginC.get(focusIndex).valueMarginC,"focusIndex:",focusIndex)
////        }

////        console.log("onTextforinformationChanged:",textforinformation, "valueVoltage:",valueVoltage.text,"focusIndex:",focusIndex)

////    }
////    Rectangle {
////        id: rectangle
////        color: "#f2f2f2"
////        border.color: "#c7c7c7"
////        border.width: 2
////        anchors.fill: parent
////        anchors.bottomMargin: -30

////        RowLayout {
////            id: rowLayout
////            y: 3
////            height: 33
////            anchors.leftMargin: 8
////            anchors.rightMargin: 8
////            anchors.left: parent.left
////            anchors.right: parent.right
////            anchors.topMargin: -25
////            spacing: 10

////            Text {
////                id: text2
////                color: "#244d77"
////                text: qsTr("MARGIN")
////                font.pixelSize: 15
////            }

////            TextField {
////                id: textFieldMarginNumber
////                text: marginCountC
////                horizontalAlignment: Text.AlignHCenter
////                font.pointSize: 10
////                Layout.fillWidth: true
////                Layout.fillHeight: true
////                Layout.preferredHeight: 33
////                Layout.preferredWidth: 60
////                readOnly: isReadOnly
////                inputMethodHints: Qt.ImhFormattedNumbersOnly
////                color: isReadOnly ? "#808080" : "#000000"

////                background: Rectangle {
////                    color: isReadOnly ? "#d3d3d3" : "#ffffff"
////                    border.color: "#bcbcbc"
////                    radius: 5
////                }

////                Keys.onReturnPressed: Qt.inputMethod.hide()

////                onAccepted: {
////                    let value = updateValueMarginC;
////                    if (!isNaN(value) && value >= 0) {
////                        marginCountC = value;
////                    }
////                }

////                onFocusChanged: {
////                    if (focus && !readOnly) {
////                        Qt.inputMethod.show();
////                        textFieldMarginNumber.focus = false;
////                        currentField = "marginNumberC";
////                        inputPanel.visible = true;
////                        textInformation.visible = true;
////                        textInformation.text = "";
////                        textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
////                        textInformation.focus = true;
////                        textFieldMarginNumber.color = "#ff0000";
////                    } else {
////                        textFieldMarginNumber.color = "#000000";
////                    }
////                }
////                Component.onCompleted: {
////                    Qt.callLater(() => {
////                        // ปิด keyboard ทันทีเมื่อหน้าถูกโหลด
////                        Qt.inputMethod.hide();
////                        inputPanel.visible = false;
////                        textInformation.visible = false;
////                        textInformation.focus = false;
////                    });
////                }

////            }

////            TextField {
////                id: valueVoltage
////                horizontalAlignment: Text.AlignHCenter
////                inputMethodHints: Qt.ImhFormattedNumbersOnly
////                Layout.fillWidth: true
////                Layout.fillHeight: true
////                Layout.preferredWidth: 80
////                Layout.preferredHeight: 33
////                font.pointSize: 10
////                text: valueMarginVoltageCauto

////                readOnly: isReadOnly
////                color: isReadOnly ? "#808080" : "#000000"

////                background: Rectangle {
////                    color: isReadOnly ? "#d3d3d3" : "#ffffff"
////                    border.color: "#bcbcbc"
////                    radius: 5
////                }

////                onFocusChanged: {
////                    if (focus && !readOnly) {
////                        Qt.inputMethod.show();
////                        currentField = "valueVoltageC";
////                        inputPanel.visible = true;
////                        textInformation.visible = true;
////                        textInformation.text = valueVoltage.text;
////                        textInformation.focus = true;
////                        valueVoltage.color = "#ff0000";
////                    } else {
////                        valueVoltage.color = "#000000";
////                    }
////                }
////                Component.onCompleted: {
////                    Qt.callLater(() => {
////                        // ปิด keyboard ทันทีเมื่อหน้าถูกโหลด
////                        Qt.inputMethod.hide();
////                        inputPanel.visible = false;
////                        textInformation.visible = false;
////                        textInformation.focus = false;
////                    });
////                }

////                Keys.onReturnPressed: {
////                    Qt.inputMethod.hide();
////                }
////            }

////            ToolButton {
////                id: auto
////                width: 55
////                height: 27
////                text: qsTr("Auto")
////                Layout.minimumWidth: 50
////                font.pointSize: 10
////                Layout.fillWidth: true
////                Layout.fillHeight: true

////                enabled: !isReadOnly

////                Keys.onReturnPressed: Qt.inputMethod.hide()

////                onClicked: {
////                    var voltageValue = parseInt(valueVoltage.text); // Read `valueVoltage`

////                    if (!isNaN(voltageValue)) {
////                        console.log("Updating all valueMarginC to:", voltageValue);

////                        for (let i = 0; i < newlistMarginC.count; i++) {
////                            newlistMarginC.setProperty(i, "valueMarginC", voltageValue);
////                        }

////                        var autoCMD = '{"objectName":"autoSetValueMarginC", "autoValueVoltage":' + valueVoltage.text + ', "rangeofmargin":' + textFieldMarginNumber.text + ' , "PHASE": "C"}';
////                        console.log("Sending Auto Command:", autoCMD);
////                        qmlCommand(autoCMD);
////                    } else {
////                        console.log("Invalid voltage value. Please enter a valid number in valueVoltage.");
////                    }
////                }
////            }
////        }

////        ScrollView {
////            id: scrollView
////            anchors.top: rowLayout.bottom
////            anchors.bottom: parent.bottom
////            anchors.left: parent.left
////            anchors.right: parent.right
////            anchors.margins: 10
////            anchors.topMargin: 6
////            anchors.bottomMargin: 8
////            anchors.rightMargin: 8
////            anchors.leftMargin: 8
////            clip: true

////            contentHeight: columnContainer.height

////            Column {
////                id: columnContainer
////                spacing: 10
////                width: scrollView.width

////                Repeater {
////                    id: repeaternewlistMarginC
////                    model: newlistMarginC

////                    delegate: RowLayout {
////                        width: parent.width
////                        spacing: 10

////                        Text {
////                            id: textMargin
////                            text: model.list_marginC
////                            font.pixelSize: 18
////                        }

////                        TextField {
////                            id: textFieldMargin
////                            Layout.preferredHeight: 33
////                            Layout.preferredWidth: 101
////                            inputMethodHints: Qt.ImhFormattedNumbersOnly
////                            placeholderText: qsTr("Value")
////                            text: model.valueMarginC

////                            readOnly: userLevelGlobalVars.count === 0 ||
////                                      userLevelGlobalVars.get(0).userLevel !== 1

////                            color: (userLevelGlobalVars.count > 0 &&
////                                    userLevelGlobalVars.get(0).userLevel !== 1)
////                                   ? "#808080" : "#000000"

////                            background: Rectangle {
////                                color: textFieldMargin.readOnly ? "#d3d3d3" : "#ffffff"
////                                border.color: "#bcbcbc"
////                                radius: 5
////                            }

////                            onFocusChanged: {
////                                if (focus && !readOnly) {
////                                    Qt.inputMethod.show();
////                                    currentField = "cheangeValueofVoltageC";
////                                    inputPanel.visible = true;
////                                    textInformation.visible = true;
////                                    textInformation.text = "";
////                                    textInformation.focus = true;
////                                    textFieldMargin.color = "#ff0000";
////                                    focusIndex = model.voltageIndex;
////                                    console.log("focusIndex_onchange:", focusIndex, model.voltageIndex, model.list_marginC, textFieldMarginNumber.text);
////                                } else {
////                                    textFieldMargin.color = "#000000";
////                                }
////                            }

////                            Keys.onReturnPressed: {
////                                Qt.inputMethod.hide();
////                                focusIndex = -1;
////                                console.log("KeysonReturnPressed:", focusIndex, model.voltageIndex, model.list_marginC);
////                            }
////                        }

////                        Text {
////                            id: voltageUnit
////                            text: "mV"/*model.unitMaginC*/
////                            font.pixelSize: 18
////                        }
////                    }
////                }
////            }
////        }
////    }
////}
//import QtQuick 2.15
//import QtQuick.Controls 2.15
//import QtQuick.Layouts 1.15
//import QtQuick.VirtualKeyboard 2.15

//Item {
//    id: root
//    width: 300
//    height: 380
//    focus: false
//    activeFocusOnTab: false

//    property int marginCountC: updateMarginC ? listMarginC : updateMarginC
//    property bool focustextInformation: inputPanel.visible
//    property string textforinformation: textInformation.text
//    property var updateValueMarginC: updateMarginC
//    property bool isReadOnly: userLevelGlobalVars.count === 0 || userLevelGlobalVars.get(0).userLevel !== 1
//    property int valueMarginVoltageCauto: autoValueVoltageC

//    property string activeEditor: ""
//    property int activeVoltageIndex: -1

//    function closeKeyboardAndEditor() {
//        activeEditor = ""
//        activeVoltageIndex = -1
//        focusIndex = -1

//        Qt.inputMethod.hide()

//        inputPanel.visible = false
//        textInformation.visible = false
//        textInformation.focus = false

//        textFieldMarginNumber.focus = false
//        valueVoltage.focus = false
//    }

//    function openEditor(fieldName, hints, initialText, voltageIndex) {
//        if (isReadOnly)
//            return

//        activeEditor = fieldName
//        activeVoltageIndex = (typeof voltageIndex === "number") ? voltageIndex : -1
//        focusIndex = activeVoltageIndex
//        currentField = fieldName

//        inputPanel.visible = true
//        textInformation.visible = true
//        textInformation.inputMethodHints = hints
//        textInformation.text = initialText === undefined || initialText === null ? "" : String(initialText)
//        textInformation.forceActiveFocus()

//        textFieldMarginNumber.color = (fieldName === "marginNumberC") ? "#ff0000" : "#000000"
//        valueVoltage.color = (fieldName === "valueVoltageC") ? "#ff0000" : "#000000"

//        Qt.callLater(function() {
//            Qt.inputMethod.show()
//        })
//    }

//    Component.onCompleted: {
//        Qt.callLater(function() {
//            closeKeyboardAndEditor()
//        })
//    }

//    onVisibleChanged: {
//        if (!visible)
//            closeKeyboardAndEditor()
//    }

//    onFocustextInformationChanged: {
//        if (!focustextInformation) {
//            textFieldMarginNumber.color = "#000000"
//            valueVoltage.color = "#000000"
//        }
//    }

//    onTextforinformationChanged: {
//        if (currentField === "marginNumberC") {
//            textFieldMarginNumber.text = textforinformation
//        } else if (currentField === "valueVoltageC") {
//            valueVoltage.text = textforinformation
//        } else if (currentField === "cheangeValueofVoltageC" && activeVoltageIndex >= 0) {
//            newlistMarginC.setProperty(activeVoltageIndex, "valueMarginC", textforinformation)
//        } else {
//            return
//        }

//        console.log("ParameterPhaseC onTextforinformationChanged:",
//                    textforinformation,
//                    "currentField:", currentField,
//                    "focusIndex:", focusIndex,
//                    "activeVoltageIndex:", activeVoltageIndex)
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
//                text: marginCountC
//                horizontalAlignment: Text.AlignHCenter
//                font.pointSize: 10
//                Layout.fillWidth: true
//                Layout.fillHeight: true
//                Layout.preferredHeight: 33
//                Layout.preferredWidth: 60

//                readOnly: true
//                focus: false
//                activeFocusOnTab: false
//                inputMethodHints: Qt.ImhFormattedNumbersOnly
//                color: isReadOnly ? "#808080" : "#000000"

//                background: Rectangle {
//                    color: isReadOnly ? "#d3d3d3" : "#ffffff"
//                    border.color: "#bcbcbc"
//                    radius: 5
//                }

//                Keys.onReturnPressed: root.closeKeyboardAndEditor()

//                onAccepted: {
//                    let value = updateValueMarginC
//                    if (!isNaN(value) && value >= 0) {
//                        marginCountC = value
//                    }
//                }

//                TapHandler {
//                    enabled: !isReadOnly
//                    onTapped: {
//                        root.openEditor("marginNumberC",
//                                        Qt.ImhFormattedNumbersOnly,
//                                        textFieldMarginNumber.text,
//                                        -1)
//                    }
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
//                text: valueMarginVoltageCauto

//                readOnly: true
//                focus: false
//                activeFocusOnTab: false
//                color: isReadOnly ? "#808080" : "#000000"

//                background: Rectangle {
//                    color: isReadOnly ? "#d3d3d3" : "#ffffff"
//                    border.color: "#bcbcbc"
//                    radius: 5
//                }

//                Keys.onReturnPressed: root.closeKeyboardAndEditor()

//                TapHandler {
//                    enabled: !isReadOnly
//                    onTapped: {
//                        root.openEditor("valueVoltageC",
//                                        Qt.ImhFormattedNumbersOnly,
//                                        valueVoltage.text,
//                                        -1)
//                    }
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
//                Keys.onReturnPressed: root.closeKeyboardAndEditor()

//                onClicked: {
//                    root.closeKeyboardAndEditor()

//                    var voltageValue = parseInt(valueVoltage.text)

//                    if (!isNaN(voltageValue)) {
//                        console.log("Updating all valueMarginC to:", voltageValue)

//                        for (let i = 0; i < newlistMarginC.count; i++) {
//                            newlistMarginC.setProperty(i, "valueMarginC", voltageValue)
//                        }

//                        var autoCMD = '{"objectName":"autoSetValueMarginC", "autoValueVoltage":' +
//                                      valueVoltage.text +
//                                      ', "rangeofmargin":' +
//                                      textFieldMarginNumber.text +
//                                      ' , "PHASE": "C"}'
//                        console.log("Sending Auto Command:", autoCMD)
//                        qmlCommand(autoCMD)
//                    } else {
//                        console.log("Invalid voltage value. Please enter a valid number in valueVoltage.")
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
//            focus: false

//            contentHeight: columnContainer.height

//            MouseArea {
//                anchors.fill: parent
//                acceptedButtons: Qt.LeftButton
//                propagateComposedEvents: true
//                onPressed: {
//                    root.closeKeyboardAndEditor()
//                    mouse.accepted = false
//                }
//            }

//            Column {
//                id: columnContainer
//                spacing: 10
//                width: scrollView.width

//                Repeater {
//                    id: repeaternewlistMarginC
//                    model: newlistMarginC

//                    delegate: RowLayout {
//                        width: parent.width
//                        spacing: 10

//                        Text {
//                            id: textMargin
//                            text: model.list_marginC
//                            font.pixelSize: 18
//                        }

//                        TextField {
//                            id: textFieldMargin
//                            Layout.preferredHeight: 33
//                            Layout.preferredWidth: 101
//                            inputMethodHints: Qt.ImhFormattedNumbersOnly
//                            placeholderText: qsTr("Value")
//                            text: model.valueMarginC

//                            readOnly: true
//                            focus: false
//                            activeFocusOnTab: false

//                            color: (userLevelGlobalVars.count > 0 &&
//                                    userLevelGlobalVars.get(0).userLevel !== 1)
//                                   ? "#808080" : "#000000"

//                            background: Rectangle {
//                                color: (userLevelGlobalVars.count === 0 ||
//                                        userLevelGlobalVars.get(0).userLevel !== 1)
//                                       ? "#d3d3d3" : "#ffffff"
//                                border.color: "#bcbcbc"
//                                radius: 5
//                            }

//                            Keys.onReturnPressed: {
//                                root.closeKeyboardAndEditor()
//                                focusIndex = -1
//                                console.log("KeysonReturnPressed:",
//                                            focusIndex,
//                                            model.voltageIndex,
//                                            model.list_marginC)
//                            }

//                            TapHandler {
//                                enabled: !(userLevelGlobalVars.count === 0 ||
//                                           userLevelGlobalVars.get(0).userLevel !== 1)
//                                onTapped: {
//                                    root.openEditor("cheangeValueofVoltageC",
//                                                    Qt.ImhFormattedNumbersOnly,
//                                                    textFieldMargin.text,
//                                                    model.voltageIndex)
//                                    textFieldMargin.color = "#ff0000"
//                                    console.log("focusIndex_onchange:",
//                                                model.voltageIndex,
//                                                model.voltageIndex,
//                                                model.list_marginC,
//                                                textFieldMarginNumber.text)
//                                }
//                            }

//                            onTextChanged: {
//                                if (root.activeEditor !== "cheangeValueofVoltageC" ||
//                                    root.activeVoltageIndex !== model.voltageIndex) {
//                                    textFieldMargin.color = "#000000"
//                                }
//                            }
//                        }

//                        Text {
//                            id: voltageUnit
//                            text: "mV"
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
    id: rootParameterC
    width: 300
    height: 380
    focus: false
    activeFocusOnTab: false

    property int marginCountC: updateMarginC ? listMarginC : updateMarginC
    property bool focustextInformation: inputPanel.visible
    property string textforinformation: textInformation.text
    property var updateValueMarginC: updateMarginC
    property bool isReadOnly: userLevelGlobalVars.count === 0 || userLevelGlobalVars.get(0).userLevel !== 1
    property int valueMarginVoltageCauto: autoValueVoltageC

    // ✅ กัน keyboard เด้งเอง
    property bool allowKeyboardPopup: false

    function resetKeyboardState() {
        allowKeyboardPopup = false
        Qt.inputMethod.hide()
        inputPanel.visible = false
        textInformation.visible = false
        textInformation.focus = false

        textFieldMarginNumber.focus = false
        valueVoltageC.focus = false
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
            valueVoltageC.color = "#000000"
            allowKeyboardPopup = false
        }
    }

    onTextforinformationChanged: {
        if (textFieldMarginNumber.color === "#ff0000") {
            textFieldMarginNumber.text = textforinformation
        }
        if (valueVoltageC.color === "#ff0000") {
            valueVoltageC.text = textforinformation
        }
        if (focusIndex >= 0) {
            newlistMarginC.setProperty(focusIndex, "valueMarginC", textforinformation)
            console.log("onTextforinformationChanged:",
                        textforinformation,
                        "valueVoltage:", valueVoltageC.text,
                        "focusIndex:", focusIndex)
        }

        console.log("onTextforinformationChanged:",
                    textforinformation,
                    "valueVoltage:", valueVoltageC.text,
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
            id: rowLayoutC
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
                placeholderText: marginCountC || qsTr("Text Field")
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
                        currentField = "marginNumberC"

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
                id: valueVoltageC
                Layout.preferredHeight: 40
                Layout.preferredWidth: 120
                inputMethodHints: Qt.ImhFormattedNumbersOnly

                text: valueMarginVoltageCauto !== undefined && valueMarginVoltageCauto !== null
                      ? String(valueMarginVoltageCauto) : ""
                placeholderText: qsTr("Text Field")

                readOnly: userLevelGlobalVars.count === 0 ||
                          userLevelGlobalVars.get(0).userLevel !== 1
                color: (userLevelGlobalVars.count > 0 &&
                        userLevelGlobalVars.get(0).userLevel !== 1)
                       ? "#808080" : "#000000"

                background: Rectangle {
                    color: valueVoltageC.readOnly ? "#d3d3d3" : "#ffffff"
                    border.color: "#bcbcbc"
                    radius: 5
                }

                focus: false
                activeFocusOnTab: false

                onFocusChanged: {
                    if (focus && !valueVoltageC.readOnly) {
                        Qt.callLater(function() {
                            valueVoltageC.focus = false
                            currentField = "valueVoltageC"

                            if (inputPanelRef)
                                inputPanelRef.visible = true

                            if (textInformationRef) {
                                textInformationRef.visible = true
                                textInformationRef.placeholderText = qsTr("Enter valueVoltageC")
                                textInformationRef.inputMethodHints = Qt.ImhFormattedNumbersOnly
                                textInformationRef.text = valueVoltageC.text
                                textInformationRef.forceActiveFocus()
                            }

                            valueVoltageC.color = "#ff0000"

                            Qt.callLater(function() {
                                Qt.inputMethod.show()
                            })
                        })
                    } else if (!focus) {
                        valueVoltageC.color = "#000000"
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

                    let voltageValue = parseInt(valueVoltageC.text, 10)
                    if (isNaN(voltageValue))
                        voltageValue = 0
                    for (let i = 0; i < newlistMarginC.count; i++) {
                        newlistMarginC.setProperty(i, "valueMarginC", voltageValue)
                    }
                    var autoCMD = JSON.stringify({
                        objectName: "autoSetValueMarginC",
                        autoValueVoltage: voltageValue,
                        rangeofmargin: rangeValue,
                        PHASE: "C"
                    })

                    console.log("Sending Auto Command:", autoCMD)
                    qmlCommand(autoCMD)
//                    resetKeyboardState()

//                    var voltageValue = parseInt(valueVoltageC.text)

//                    if (!isNaN(voltageValue)) {
//                        console.log("Updating all valueMarginC to:", voltageValue)

//                        for (let i = 0; i < newlistMarginC.count; i++) {
//                            newlistMarginC.setProperty(i, "valueMarginC", voltageValue)
//                        }

//                        var autoCMD = '{"objectName":"autoSetValueMarginC", "autoValueVoltage":' +
//                                      valueVoltageC.text +
//                                      ', "rangeofmargin":' +
//                                      textFieldMarginNumber.text +
//                                      ' , "PHASE": "C"}'
//                        console.log("Sending Auto Command:", autoCMD)
//                        qmlCommand(autoCMD)
//                    } else {
//                        console.log("Invalid voltage value. Please enter a valid number in valueVoltage.")
//                    }
                }
            }
        }

        ScrollView {
            id: scrollViewC
            anchors.top: rowLayoutC.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            clip: true
            focus: false

            contentHeight: columnContainerC.height

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                propagateComposedEvents: true
                onPressed: {
                    rootParameterC.resetKeyboardState()
                    mouse.accepted = false
                }
            }

            Column {
                id: columnContainerC
                spacing: 10
                width: scrollViewC.width

                Repeater {
                    model: newlistMarginC

                    delegate: RowLayout {
                        width: parent.width
                        spacing: 10

                        Text {
                            text: model.list_marginC
                            font.pixelSize: 18
                        }

                        TextField {
                            id: textFieldMarginC
                            text: model.valueMarginC
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
                                color: textFieldMarginC.readOnly ? "#d3d3d3" : "#ffffff"
                                border.color: "#bcbcbc"
                                radius: 5
                            }

                            onFocusChanged: {
                                if (!focus) {
                                    textFieldMarginC.color = "#000000"
                                }
                            }

                            Keys.onReturnPressed: {
                                resetKeyboardState()
                            }

                            TapHandler {
                                enabled: !(userLevelGlobalVars.count === 0 ||
                                           userLevelGlobalVars.get(0).userLevel !== 1)

                                onTapped: {
                                    currentField = "cheangeValueofVoltageC"
                                    focusIndex = model.voltageIndex
                                    rootParameterC.allowKeyboardPopup = true
                                    textFieldMarginC.color = "#ff0000"

                                    if (inputPanelRef)
                                        inputPanelRef.visible = true

                                    if (textInformationRef) {
                                        textInformationRef.visible = true
                                        textInformationRef.text = textFieldMarginC.text
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

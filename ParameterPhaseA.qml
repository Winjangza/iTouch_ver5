import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.VirtualKeyboard 2.15



Item {
    width: 300
    height: 380

    property int marginCountA: updateMarginA
    property bool focustextInformation: inputPanel.visible
    property string textforinformation:  textInformation.text


    onFocustextInformationChanged: {
        if(focustextInformation == false){
            textFieldMarginNumber.color = "#000000"
        }
        if(valueVoltage == false){
            valueVoltage.color = "#000000"
        }
    }
    onTextforinformationChanged: {
        if(textFieldMarginNumber.color == "#ff0000"){
            textFieldMarginNumber.text = textforinformation
        }
        if(valueVoltage.color == "#ff0000"){
            valueVoltage.text = textforinformation
        }
        if(focusIndex >= 0){
            newlistMarginA.setProperty(focusIndex,"valueMarginA",textforinformation)
            console.log("newlistMarginA:",newlistMarginA.get(focusIndex).valueMarginA,"focusIndex:",focusIndex)
        }

        console.log("onTextforinformationChanged:",textforinformation, "valueVoltage:",valueVoltage.text,"focusIndex:",focusIndex)

    }
    Rectangle {
        id: rectangle
        color: "#f2f2f2"
        border.color: "#c7c7c7"
        border.width: 2
        anchors.fill: parent
        anchors.bottomMargin: -30

        RowLayout {
            id: rowLayout
            y: 3
            height: 33
//            anchors.top: text1.bottom
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
                text: marginCountA
                inputMethodHints: Qt.ImhDigitsOnly
                Keys.onReturnPressed: Qt.inputMethod.hide();
                onAccepted: {
                    let value = parseInt(text);
                    if (!isNaN(value) && value >= 0) {
                        marginCountA = value;
                    }
                }
                onFocusChanged: {
                    if (focus) {
                        Qt.inputMethod.show();
                        textFieldMarginNumber.focus = false;
                        currentField = "marginNumberA";
                        inputPanel.visible = true;
                        textInformation.visible = true;
                        textInformation.text = "";
                        textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                        textInformation.focus = true;
                        textFieldMarginNumber.color = "#ff0000";
                    }
                }
            }


            TextField {
                id: valueVoltage
                horizontalAlignment: Text.AlignHCenter
                inputMethodHints: Qt.ImhDigitsOnly
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 80
                Layout.preferredHeight: 33
//                placeholderText: qsTr("Enter Voltage")
                font.pointSize: 10

                onFocusChanged: {
                    if (focus) {
                        Qt.inputMethod.show();
                        currentField = "valueVoltageA"; 
                        inputPanel.visible = true; 
                        textInformation.visible = true; 
                        textInformation.text = ""; 
                        textInformation.focus = true; 
                        valueVoltage.color = "#ff0000"; 

                    } else {
                        valueVoltage.color = "#000000";
                    }
                }

                Keys.onReturnPressed: {
                    Qt.inputMethod.hide(); 
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
                Keys.onReturnPressed: Qt.inputMethod.hide();

                onClicked: {
                    var voltageValue = parseInt(valueVoltage.text); // Read `valueVoltage`

                    if (!isNaN(voltageValue)) {
                        console.log("Updating all valueMarginA to:", voltageValue);

                        for (let i = 0; i < newlistMarginA.count; i++) {
                            newlistMarginA.setProperty(i, "valueMarginA", voltageValue);
                        }

                        var autoCMD = '{"objectName":"autoSetValueMarginA", "autoValueVoltage":' + valueVoltage.text + ', "rangeofmargin":' + textFieldMarginNumber.text + ' , "PHASE": "A"}';
                        console.log("Sending Auto Command:", autoCMD);
                        qmlCommand(autoCMD);
                    } else {
                        console.log("Invalid voltage value. Please enter a valid number in valueVoltage.");
                    }
                }
            }

        }

        ScrollView {
            id: scrollView
            anchors.top: rowLayout.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            anchors.topMargin: 6
            anchors.bottomMargin: 8
            anchors.rightMargin: 8
            anchors.leftMargin: 8
            clip: true

            contentHeight: columnContainer.height

            Column {
                id: columnContainer
                spacing: 10
                width: scrollView.width

                Repeater {
                    id: repeaternewlistMarginA
                    model: newlistMarginA

                    delegate: RowLayout {
                        width: parent.width
                        spacing: 10

                        Text {
                            id: textMargin
                            text: model.list_marginA
                            font.pixelSize: 18
                        }

                        TextField {
                            id: textFieldMargin
                            Layout.preferredHeight: 33
                            Layout.preferredWidth: 101
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                            placeholderText: qsTr("Value")
                            text: model.valueMarginA

                            onFocusChanged: {
                                if (focus) {
                                    Qt.inputMethod.show();
                                    currentField = "changeValueofVoltageA";
                                    inputPanel.visible = true;
                                    textInformation.visible = true;
                                    textInformation.text = "";
                                    textInformation.focus = true;
                                    textFieldMargin.color = "#ff0000";
                                    focusIndex = model.voltageIndex
                                    console.log("focusIndex_onchange:",focusIndex,model.voltageIndex,model.list_marginA, textFieldMarginNumber.text)
                                } else {
                                    textFieldMargin.color = "#000000";

                                }
                            }

                            Keys.onReturnPressed: {
                                Qt.inputMethod.hide();
                                focusIndex = -1
                                console.log("KeysonReturnPressed:",focusIndex,model.voltageIndex,model.list_marginA)
                            }
                        }

                        Text {
                            id: voltageUnit
                            text: "mV"/*model.unitMaginA*/
                            font.pixelSize: 18
                        }
                    }
                }
            }
        }
    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.1}
}
##^##*/

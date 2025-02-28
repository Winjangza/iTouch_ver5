import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtWebSockets 1.0
import QtQuick.Extras 1.4
import QtQuick.VirtualKeyboard 2.15
import QtQuick.VirtualKeyboard.Styles 2.15
import QtQuick.VirtualKeyboard.Settings 2.15
Item {
    width: 1000
    height: 475
    property string currentField: ""
    property bool focustextInformation: inputPanel.visible
    property string textforinformation:  textInformation.text
    property string ip_address_Network: ip_address
    property string ip_gateway_Network: ip_gateway
    property string ip_snmp_Network: ip_snmp
    property string ip_timeserver_Network: ip_timeserver

    onFocustextInformationChanged: {
        if(focustextInformation == false){
            editsSNMPServer.color = "#000000"
            editTimeSyncServer.color = "#000000"
            settingIPaddress.color = "#000000"
            settinggateway.color = "#000000"
        }
    }
    onTextforinformationChanged: {
        if(editsSNMPServer.color == "#ff0000"){
            editsSNMPServer.text = textforinformation
        }
        if(editTimeSyncServer.color == "#ff0000"){
            editTimeSyncServer.text = textforinformation
        }
        if(settingIPaddress.color == "#ff0000"){
            settingIPaddress.text = textforinformation
        }
        if(settinggateway.color == "#ff0000"){
            settinggateway.text = textforinformation
        }
        console.log("onTextforinformationChanged",textforinformation)
    }
    Rectangle {
        id: rectangle
        color: "#f2f2f2"
        anchors.fill: parent

        ColumnLayout {
            x: 8
            y: 0
            width: 126
            height: 475
            Layout.fillWidth: true

            Text {
                id: text1
                text: qsTr("NETWORK SETTING")
                font.pixelSize: 18
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                Layout.bottomMargin: -18
            }

            Text {
                id: text6
                text: qsTr("SNMP SETTING")
                font.pixelSize: 18
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                Layout.bottomMargin: 17
            }
        }

        Text {
            id: text7
            x: 0
            y: 281
            text: qsTr("SNMP SERVER IP")
            font.pixelSize: 14
        }

        Text {
            id: text8
            x: 0
            y: 370
            text: qsTr("TIME SYCHONIZATION SERVER")
            font.pixelSize: 14
        }

        RowLayout {
            x: 84
            y: 304
            width: 430
            height: 45

            TextField {
                id: currentSNMP
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredWidth: 148
                Layout.preferredHeight: 40
                placeholderText: qsTr("Current SNMP Server")
                Layout.fillWidth: true
                text: ip_snmp_Network
                readOnly: true // ป้องกันการแก้ไขโดยตรง
            }

            TextField {
                id: editsSNMPServer
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredWidth: 148
                Layout.preferredHeight: 40
                placeholderText: qsTr("Edit SNMP Server")
                Layout.fillWidth: true
                focus: false

                onTextChanged: {
                    // เมื่อแก้ไขค่าใน editsSNMPServer จะอัปเดต currentSNMP ทันที
                    currentSNMP.text = text
                }

                onFocusChanged: {
                    if (focus) {
                        editsSNMPServer.focus = false;
                        currentField = "editsSNMPServer";
                        inputPanel.visible = true;
                        textInformation.visible = true;
                        textInformation.placeholderText = qsTr("Enter SNMP Server Address");
                        textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                        textInformation.text = "";
                        textInformation.focus = true;
                        editsSNMPServer.color = "#ff0000"
                    }
                }
            }

            ToolButton {
                id: setSNMPServerIP
                text: qsTr("SET")
                font.pointSize: 9
                Layout.preferredHeight: 35
                onClicked: {
                    var setSNMPData = '{"objectName":"editSetSNMPServerIP", "editsSNMPServer":"'+editsSNMPServer.text+'"}';
                    console.log(setSNMPData)
                    qmlCommand(setSNMPData);

                }
            }
        }

        RowLayout {
            x: 84
            y: 399
            width: 430
            height: 46

            TextField {
                id: currentTimeSyncServer
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredWidth: 148
                Layout.preferredHeight: 40
                placeholderText: qsTr("Current Time Sync Server")
                Layout.fillWidth: true
                text: ip_timeserver_Network
                readOnly: true
            }
            TextField {
                id: editTimeSyncServer
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredWidth: 148
                Layout.preferredHeight: 40
                placeholderText: qsTr("Edit Time Sync Server")
                Layout.fillWidth: true
                focus: false

                onTextChanged: {
                    currentTimeSyncServer.text = text
                }

                onFocusChanged: {
                    if (focus) {
                        editTimeSyncServer.focus = false;
                        currentField = "editTimeSyncServer";
                        inputPanel.visible = true;
                        textInformation.visible = true;
                        textInformation.placeholderText = qsTr("Enter Time Sync Server Address");
                        textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                        textInformation.text = "";
                        textInformation.focus = true;
                        editTimeSyncServer.color = "#ff0000"
                    }
                }
            }
            ToolButton {
                id: timesyncServer
                text: qsTr("SET")
                font.pointSize: 9
                Layout.preferredHeight: 35
                onClicked: {
                    var setTimeServerData = '{"objectName":"editTimesyncServer", "editsTimeSyncServer":"'+editTimeSyncServer.text+'"}';
                    console.log(setTimeServerData);
                    qmlCommand(setTimeServerData);

                }
            }
        }

        SNMPtraps {
            id: sNMPtraps
            x: 570
            y: 8
            width: 422
            height: 460
        }

        ToolButton {
            id: setIPandGateway
            x: 474
            y: 153
            width: 52
            height: 40
            text: qsTr("SET")
            font.pointSize: 12
            Layout.preferredHeight: 35
            onClicked: {
                var setIPAddressGateway = '{"objectName":"editSettingNetwork", "editsIPAddress":"'+settingIPaddress.text+'", "editsGateWays":"'+settinggateway.text+'"}';
                console.log(setIPAddressGateway)
                qmlCommand(setIPAddressGateway)
            }
            Layout.fillWidth: false
        }

        RowLayout {
            x: 100
            y: 85
            width: 283
            height: 16

            Text {
                id: text2
                text: qsTr("CURRENT")
                font.pixelSize: 13
                Layout.fillHeight: false
                Layout.leftMargin: 30
                Layout.fillWidth: false
            }

            Text {
                id: text4
                text: qsTr("SETTING")
                font.pixelSize: 13
                Layout.fillWidth: false
                Layout.rightMargin: 10
                Layout.leftMargin: 100
            }
        }

        RowLayout {
            x: 0
            y: 107
            width: 462
            height: 40

            Text {
                id: ipAddress
                text: qsTr("IP ADDRESS")
                font.pixelSize: 14
                Layout.fillWidth: false
            }

            TextField {
                id: currentIPaddress
                text: ip_address_Network
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
                Layout.leftMargin: 3
                Layout.rightMargin: 1
                Layout.preferredWidth: 148
                Layout.preferredHeight: 40
                readOnly: true
                placeholderText: qsTr("Current IP Address")
            }

            TextField {
                id: settingIPaddress
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredWidth: 148
                focus: false
                onTextChanged: {
                    currentIPaddress.text = text
                }
                Layout.preferredHeight: 40
                onFocusChanged: {
                    if (focus) {
                        settingIPaddress.focus = false;
                        currentField = "settingIPaddress";
                        inputPanel.visible = true;
                        textInformation.visible = true;
                        textInformation.placeholderText = qsTr("Enter IP address");
                        textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                        textInformation.text = "";
                        textInformation.focus = true;
                        settingIPaddress.color = "#ff0000"

                    }
                }
                placeholderText: qsTr("Setting IP")
                Layout.fillWidth: true
            }
        }

        RowLayout {
            x: 0
            y: 153
            width: 462
            height: 40

            Text {
                id: ipGateways
                text: qsTr("IP GATEWAY")
                font.pixelSize: 14
                Layout.fillWidth: false
            }

            TextField {
                id: currentgateway
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredWidth: 148
                Layout.preferredHeight: 40
                placeholderText: qsTr("Current GateWay")
                Layout.fillWidth: true
                text: ip_gateway_Network
                readOnly: true // เพื่อป้องกันการเปลี่ยนแปลงค่าจากผู้ใช้
            }

            TextField {
                id: settinggateway
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredWidth: 148
                Layout.preferredHeight: 40
                placeholderText: qsTr("Setting GateWays")
                Layout.fillWidth: true
                focus: false
                onTextChanged: {
                    currentgateway.text = text
                }

                onFocusChanged: {
                    if (focus) {
                        settinggateway.focus = false;
                        currentField = "settinggateway";
                        inputPanel.visible = true;
                        textInformation.visible = true;
                        textInformation.placeholderText = qsTr("Enter GateWays");
                        textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                        textInformation.text = "";
                        textInformation.focus = true;
                        settinggateway.color = "#ff0000"

                    }
                }
            }
        }
    }


    //    InputPanel {
    //        id: inputPanel
    //        y: 244
    //        height: 232
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
    //            anchors.bottomMargin: 285
    //            anchors.leftMargin: 0
    //            anchors.topMargin: -96
    //            placeholderText: qsTr("Text Field")
    //            visible: false
    //            inputMethodHints: Qt.ImhFormattedNumbersOnly
    //            font.pointSize: 12

    //            Component.onCompleted: {
    //                focus = false;
    //            }

    //            Keys.onReturnPressed: {
    //                if (text.trim() !== "") {
    //                    if (currentField === "currentIPaddress") {
    //                        currentIPaddress.text = text;
    //                        var IpAddress = '{"objectName":"currentIPaddress","currentIPaddress": '+currentIPaddress.text+'}'
    //                        qmlCommand(IpAddress);
    //                        console.log("Sag Entered:", text, IpAddress);
    //                    } else if (currentField === "detailField") {
    //                        detailField.text = text;
    //                        var Detail = '{"objectName":"detailField","detailField": '+detailField.text+'}'
    //                        qmlCommand(Detail);
    //                        console.log("Sampling Entered:", text,Detail);
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
    D{i:0;formeditorZoom:1.1}D{i:21}D{i:25}
}
##^##*/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.0
import QtWebSockets 1.0
import QtQuick.Extras 1.4
import QtQml 2.2
import QtQuick.VirtualKeyboard 2.15
import QtQuick.VirtualKeyboard.Styles 2.15
import QtQuick.VirtualKeyboard.Settings 2.15
import QtQuick3D 1.15
import QtQuick.Controls.Material 2.4
Item {
    id: settingGeneralRoot
    width: 1000
    height: 475
    property string generalMasterSelect: userTypeMaster
    property string generalSlaveSelect: userTypeSlave
    property bool checkUser
    property bool checkAct
    property string voltageValue: ""
    property string substationValue: ""
    property string directionValue: ""
    property string periodicValue: ""
    property string lineNoValue: ""
    property bool selectMonday : updateMonday
    property bool selectTuesday : updateTuesday
    property bool selectWednesday : updateWednesday
    property bool selectThursday : updateThursday
    property bool selectFriday : updateFriday
    property bool selectSaturday : updateSaturday
    property bool selectSunday : updateSunday
    property bool focustextInformation: inputPanel.visible
    property string textforinformation:  textInformation.text
    property bool handwritingInputPanelActive: false
    property bool lflFail: statusLFLFails
    property bool lflOperate: statusLFLOperates

    property double voltageInfoSetting: voltageInfo
    property string substationInfoSetting: substationInfo
    property string directionInfoSetting: directionInfo
    property string linenoInfoSetting: linenoInfo

    property string userModeSelect: userMode

    property bool isReadOnlyLevel: userLevelGlobalVars.count === 0 || userLevelGlobalVars.get(0).userLevel !== 1
    property var numpointofLFL: numPointOfLFL
    property bool isReadOnly: currentUserLevel !== 1
//    property bool isReadOnly: currentUserLevel === 1 || currentUserLevel === 2 || currentUserLevel === 3
//    onUserModeSelectChanged: {
//        userModeSelect = userMode
//        console.log("onUserModeSelectChanged",userMode,userModeSelect)

//    }
//    visible: userLevelGlobalVars.count > 0 && (currentUserLevel >= 1 && currentUserLevel <= 3)

    onFocustextInformationChanged: {
        if(focustextInformation == false){
            valueVoltage.color = "#000000"
            valueSubstation.color = "#000000"
            valueDirection.color = "#000000"
            valueLineNo.color = "#000000"
            textTime.color = "#000000"        }
    }
    onTextforinformationChanged: {
        if(valueVoltage.color == "#ff0000"){
            valueVoltage.text = textforinformation
        }
        if(valueSubstation.color == "#ff0000"){
            valueSubstation.text = textforinformation
        }
        if(valueDirection.color == "#ff0000"){
            valueDirection.text = textforinformation
        }
        if(valueLineNo.color == "#ff0000"){
            valueLineNo.text = textforinformation
        }
        if(textTime.color == "#ff0000"){
            textTime.text = textforinformation
        }
        console.log("onTextforinformationChanged",textforinformation,valueVoltage.text,valueVoltage.color,substationInfoSetting)
    }

    Rectangle {
        id: rectangle
        color: "#f2f2f2"
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
    }

//    // เพิ่ม PopupWarningPeriodic
//    PopupWarningPeriodic {
//        id: warningPopup
//        anchors.centerIn: parent
//        popupinterlockPeriodic: interlockPeriodic  // รับค่าจาก main.qml
//    }

//    // ฟังก์ชันสำหรับเรียก Popup จากภายนอก
//    function showWarningPopup(message) {
//        warningPopup.show(message)
//    }

    Rectangle {
        id: modesetting
        color: "#00f2f2f2"
        border.color: "#00ffffff"
        border.width: 1
        anchors.fill: parent
        anchors.rightMargin: 840
        anchors.topMargin: 15

        ColumnLayout {
            id: modeSelector
            x: 14
            y: 47
            spacing: 10

            // Mode selection rectangles (Master, Slave, Standalone)
            Rectangle {
                id: selectMaster
                radius: 5
                border.color: "#b7b7b7"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40

                color: settingGeneralRoot.isReadOnly
                       ? (settingGeneralRoot.userModeSelect === "MASTER" ? "#d3d3d3" : "#f2f2f2")
                       : (settingGeneralRoot.userModeSelect === "MASTER" ? "#00FF00" : "#f2f2f2")

                MouseArea {
                    anchors.fill: parent
                    preventStealing: true
                    propagateComposedEvents: false
                    enabled: !settingGeneralRoot.isReadOnly
                    onClicked: {
                        if (settingGeneralRoot.userModeSelect !== "MASTER") {
                            settingGeneralRoot.userModeSelect = "MASTER"
                            var SelectMasterPLC = '{"objectName":"selectUsers","userType":"MASTER"}'
                            var SelectMasterLocal = '{"menuID":"updateUserMode","userType":"MASTER"}'
                            console.log("selectMaster:", SelectMasterPLC, SelectMasterLocal)
                            qmlCommand(SelectMasterPLC)
                        }
                    }
                }
            }

            Rectangle {
                id: selectSlaves
                radius: 5
                border.color: "#a6a6a6"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40

                color: settingGeneralRoot.isReadOnly
                       ? (settingGeneralRoot.userModeSelect === "SLAVE" ? "#d3d3d3" : "#f2f2f2")
                       : (settingGeneralRoot.userModeSelect === "SLAVE" ? "#00FF00" : "#f2f2f2")

                MouseArea {
                    anchors.fill: parent
                    preventStealing: true
                    propagateComposedEvents: false
                    enabled: !settingGeneralRoot.isReadOnly
                    onClicked: {
                        if (settingGeneralRoot.userModeSelect !== "SLAVE") {
                            settingGeneralRoot.userModeSelect = "SLAVE"
                            var SelectSlavePLC = '{"objectName":"selectUsers","userType":"SLAVE"}'
                            var SelectSlaveLocal = '{"menuID":"updateUserMode","userType":"SLAVE"}'
                            console.log("selectSlave:", SelectSlavePLC, SelectSlaveLocal)
                            qmlCommand(SelectSlavePLC)
                        }
                    }
                }
            }

            Rectangle {
                id: selectStandAlone
                radius: 5
                border.color: "#a6a6a6"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40

                color: settingGeneralRoot.isReadOnly
                       ? (settingGeneralRoot.userModeSelect === "STANDALONE" ? "#d3d3d3" : "#f2f2f2")
                       : (settingGeneralRoot.userModeSelect === "STANDALONE" ? "#00FF00" : "#f2f2f2")

                MouseArea {
                    anchors.fill: parent
                    preventStealing: true
                    propagateComposedEvents: false
                    enabled: !settingGeneralRoot.isReadOnly
                    onClicked: {
                        if (settingGeneralRoot.userModeSelect !== "STANDALONE") {
                            settingGeneralRoot.userModeSelect = "STANDALONE"
                            var SelectStandalonePLC = '{"objectName":"selectUsers","userType":"STANDALONE"}'
                            var SelectStandaloneLocal = '{"menuID":"updateUserMode","userType":"STANDALONE"}'
                            console.log("selectStandalone:", SelectStandalonePLC, SelectStandaloneLocal)
                            qmlCommand(SelectStandalonePLC)
                        }
                    }
                }
            }

//            // เพิ่มส่วน Storage ใต้ mode selection
//            Rectangle {
//                id: storageContainer
//                Layout.preferredHeight: 60
//                Layout.preferredWidth: 140
//                Layout.topMargin: 20
//                color: "transparent"

//                ColumnLayout {
//                    anchors.fill: parent
//                    spacing: 5

//                    // Text "Storage"
//                    Text {
//                        text: qsTr("Storage")
//                        font.pixelSize: 13
//                        font.bold: true
//                        color: "#333333"
//                    }

//                    // Container สำหรับแถบ storage
//                    Rectangle {
//                        Layout.preferredHeight: 30
//                        Layout.preferredWidth: 140
//                        color: "#e0e0e0"
//                        radius: 4
//                        border.color: "#b0b0b0"
//                        border.width: 1

//                        // แถบแสดงพื้นที่ที่ใช้ไป (สีฟ้า)
//                        Rectangle {
//                            id: storageUsedBar
//                            height: parent.height
//                            width: parent.width * storageUsedPercentage // เช่น 0.75 สำหรับ 75%
//                            color: "#2196F3"
//                            radius: 3

//                            // ค่าเปอร์เซ็นต์พื้นที่ใช้ (ตัวอย่าง - ควรเชื่อมกับข้อมูลจริง)
//                            property real storageUsedPercentage: 0.65 // 65% (ตัวอย่าง)
//                        }

//                        // ข้อความแสดงพื้นที่ใช้/ทั้งหมด
//                        Text {
//                            anchors.centerIn: parent
//                            text: storageUsedText
//                            font.pixelSize: 11
//                            font.bold: true
//                            color: "#000000"

//                            // ข้อความตัวอย่าง (ควรเชื่อมกับข้อมูลจริง)
//                            property string storageUsedText: "32.5/50.0 GB"
//                        }
//                    }

//                    // หรืออีกแบบ: แยกเป็นสองบรรทัด
//                    Text {
//                        text: storageDetailText
//                        font.pixelSize: 11
//                        color: "#666666"

//                        // ข้อความตัวอย่างแบบสองบรรทัด (ใช้ \n เพื่อขึ้นบรรทัดใหม่)
//                        property string storageDetailText: "used: 32.5 GB\nfull: 50.0 GB"
//                    }
//                }
//            }
        }

        ColumnLayout {
            x: 62
            y: 47
            width: 50
            height: 140

            Text {
                id: mastertext
                text: qsTr("MASTER")
                font.pixelSize: 13
            }

            Text {
                id: slavetext
                text: qsTr("SLAVE")
                font.pixelSize: 13
            }

            Text {
                id: standalonetext
                text: qsTr("STANDALONE")
                font.pixelSize: 13
            }
        }
    }
//    Rectangle {
//        id: modesetting
//        color: "#00f2f2f2"
//        border.color: "#00ffffff"
//        border.width: 1
//        anchors.fill: parent
//        anchors.rightMargin: 840
//        anchors.topMargin: 15
//        ColumnLayout {
//            id: modeSelector
//            x: 14
//            y: 47
//            spacing: 10

//            // ❌ ลบ property ซ้ำออก
//            // property string userModeSelect: "MASTER"
//            // property bool isReadOnly: false

//            Rectangle {
//                id: selectMaster
//                radius: 5
//                border.color: "#b7b7b7"
//                border.width: 1
//                Layout.preferredHeight: 40
//                Layout.preferredWidth: 40

//                // ✅ binding สีตรง ๆ ไม่ต้อง handler
//                color: settingGeneralRoot.isReadOnly
//                       ? (settingGeneralRoot.userModeSelect === "MASTER" ? "#d3d3d3" : "#f2f2f2")
//                       : (settingGeneralRoot.userModeSelect === "MASTER" ? "#00FF00" : "#f2f2f2")

//                MouseArea {
//                    anchors.fill: parent
//                    preventStealing: true
//                    propagateComposedEvents: false
//                    enabled: !settingGeneralRoot.isReadOnly
//                    onClicked: {
//                        if (settingGeneralRoot.userModeSelect !== "MASTER") {
//                            settingGeneralRoot.userModeSelect = "MASTER"

//                            var SelectMasterPLC = '{"objectName":"selectUsers","userType":"MASTER"}'
//                            var SelectMasterLocal = '{"menuID":"updateUserMode","userType":"MASTER"}'

//                            console.log("selectMaster:", SelectMasterPLC,SelectMasterLocal)
//                            qmlCommand(SelectMasterPLC)

//                        }
//                    }
//                }
//            }

//            Rectangle {
//                id: selectSlaves
//                radius: 5
//                border.color: "#a6a6a6"
//                border.width: 1
//                Layout.preferredHeight: 40
//                Layout.preferredWidth: 40

//                color: settingGeneralRoot.isReadOnly
//                       ? (settingGeneralRoot.userModeSelect === "SLAVE" ? "#d3d3d3" : "#f2f2f2")
//                       : (settingGeneralRoot.userModeSelect === "SLAVE" ? "#00FF00" : "#f2f2f2")

//                MouseArea {
//                    anchors.fill: parent
//                    preventStealing: true
//                    propagateComposedEvents: false
//                    enabled: !settingGeneralRoot.isReadOnly
//                    onClicked: {
//                        if (settingGeneralRoot.userModeSelect !== "SLAVE") {
//                            settingGeneralRoot.userModeSelect = "SLAVE"

//                            var SelectSlavePLC = '{"objectName":"selectUsers","userType":"SLAVE"}'
//                            var SelectSlaveLocal = '{"menuID":"updateUserMode","userType":"SLAVE"}'

//                            console.log("selectSlave:", SelectSlavePLC,SelectSlaveLocal)
//                            qmlCommand(SelectSlavePLC)


//                        }
//                    }
//                }
//            }

//            Rectangle {
//                id: selectStandAlone
//                radius: 5
//                border.color: "#a6a6a6"
//                border.width: 1
//                Layout.preferredHeight: 40
//                Layout.preferredWidth: 40

//                color: settingGeneralRoot.isReadOnly
//                       ? (settingGeneralRoot.userModeSelect === "STANDALONE" ? "#d3d3d3" : "#f2f2f2")
//                       : (settingGeneralRoot.userModeSelect === "STANDALONE" ? "#00FF00" : "#f2f2f2")

//                MouseArea {
//                    anchors.fill: parent
//                    preventStealing: true
//                    propagateComposedEvents: false
//                    enabled: !settingGeneralRoot.isReadOnly
//                    onClicked: {
//                        if (settingGeneralRoot.userModeSelect !== "STANDALONE") {
//                            settingGeneralRoot.userModeSelect = "STANDALONE"
//                            var SelectStandalonePLC = '{"objectName":"selectUsers","userType":"STANDALONE"}'
//                            var SelectStandaloneLocal = '{"menuID":"updateUserMode","userType":"STANDALONE"}'

//                            console.log("selectStandalone:", SelectStandalonePLC,SelectStandaloneLocal)
//                            qmlCommand(SelectStandalonePLC)


//                        }
//                    }
//                }
//            }

//        }
////        ColumnLayout {
////            x: 14
////            y: 47
////            Rectangle {
////                id: selectMaster
////                color: isReadOnly
////                       ? (userModeSelect === "MASTER" ? "#d3d3d3" : "#f2f2f2")
////                       : (userModeSelect === "MASTER" ? "#00FF00" : "#f2f2f2")
////                radius: 5
////                border.color: "#b7b7b7"
////                border.width: 1
////                Layout.preferredHeight: 40
////                Layout.preferredWidth: 40

////                MouseArea {
////                    anchors.fill: parent
////                    preventStealing: true
////                    propagateComposedEvents: false
////                    enabled: !isReadOnly
////                    onClicked: {
////                        if (userModeSelect !== "MASTER") {
////                            userModeSelect = "MASTER";
////                            var SelectMaster = '{"objectName":"selectUsers","userType": "MASTER"}';
////                            console.log("selectMaster:", SelectMaster);
////                            qmlCommand(SelectMaster);
////                        }
////                    }
////                }
////            }

////            Rectangle {
////                id: selectSlaves
////                color: isReadOnly
////                       ? (userModeSelect === "SLAVE" ? "#d3d3d3" : "#f2f2f2")
////                       : (userModeSelect === "SLAVE" ? "#00FF00" : "#f2f2f2")
////                radius: 5
////                border.color: "#a6a6a6"
////                border.width: 1
////                Layout.preferredHeight: 40
////                Layout.preferredWidth: 40

////                MouseArea {
////                    anchors.fill: parent
////                    preventStealing: true
////                    propagateComposedEvents: false
////                    enabled: !isReadOnly
////                    onClicked: {
////                        if (userModeSelect !== "SLAVE") {
////                            userModeSelect = "SLAVE";
////                            var SelectSlave = '{"objectName":"selectUsers","userType": "SLAVE"}';
////                            console.log("selectSlave:", SelectSlave);
////                            qmlCommand(SelectSlave);
////                        }
////                    }
////                }
////            }
////        }


//        ColumnLayout {
//            x: 62
//            y: 47
//            width: 50
//            height: 140

//            Text {
//                id: mastertext
//                text: qsTr("MASTER")
//                font.pixelSize: 13
//            }

//            Text {
//                id: slavetext
//                text: qsTr("SLAVE")
//                font.pixelSize: 13
//            }

//            Text {
//                id: standalonetext
//                text: qsTr("STANDALONE")
//                font.pixelSize: 13
//            }
//        }
//    }

    Rectangle {
        id: infosetting
        color: "#00f2f2f2"
        border.width: 0
        anchors.fill: parent
        anchors.bottomMargin: 8
        anchors.leftMargin: 230
        anchors.topMargin: 15

        TextField {
            id: valueVoltage
            y: 76
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 8
            anchors.rightMargin: 50
            horizontalAlignment: Text.AlignHCenter
            Layout.fillHeight: false
            Layout.fillWidth: true
            font.pointSize: 11
            placeholderText:  voltageInfoSetting || qsTr("Enter Voltage")
            readOnly: !(currentUserLevel === 1)
            background: Rectangle {
                color: ( currentUserLevel === 3)
                       ? "#d3d3d3"
                       : "#ffffff"
                border.color: "#bcbcbc"
                radius: 5
            }
            // inputMethodHints: Qt.ImhFormattedNumbersOnly
            focus: false
            activeFocusOnTab: false
            onFocusChanged: {
                if (focus && !valueVoltage.readOnly) {
                    focus = false
                    currentField = "valueVoltages"
                    inputPanel.visible = true
                    textInformation.visible = true
                    textInformation.placeholderText = qsTr("Enter Voltage")
                    textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly
                    textInformation.text = ""
                    textInformation.focus = true
                    valueVoltage.color = "#ff0000"
                }
            }
        }

        Text {
            id: substation
            x: 8
            y: 130
            text: qsTr("SUBSTATION")
            font.pixelSize: 13
        }

        TextField {
            id: valueSubstation
            y: 159
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 8
            anchors.rightMargin: 50
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            font.pointSize: 11
            placeholderText: substationInfoSetting || qsTr("Enter Substation")
            readOnly: !(currentUserLevel === 1)
            background: Rectangle {
                color: ( currentUserLevel === 3)
                       ? "#d3d3d3"
                       : "#ffffff"
                border.color: "#bcbcbc"
                radius: 5
            }
            // inputMethodHints: Qt.ImhFormattedNumbersOnly
            focus: false
            activeFocusOnTab: false
            onFocusChanged: {
                if (focus && !valueSubstation.readOnly) {
                    Qt.callLater(function() {
                        focus = false
                        currentField = "valueSubstation"
                        inputPanel.visible = true
                        textInformation.visible = true
                        textInformation.placeholderText = qsTr("Enter Substation")
                        textInformation.inputMethodHints = Qt.ImhPreferUppercase
                        textInformation.text = ""
                        textInformation.focus = true
                        valueSubstation.color = "#ff0000"
                    })
                }
            }
        }

        Text {
            id: direction
            x: 8
            y: 213
            text: qsTr("DIRECTION")
            font.pixelSize: 13
        }

        TextField {
            id: valueDirection
            y: 243
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 8
            anchors.rightMargin: 50
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            font.pointSize: 11
            placeholderText: directionInfoSetting || qsTr("Enter DIRECTION")
            readOnly: !(currentUserLevel === 1)
            background: Rectangle {
                color: ( currentUserLevel === 3)
                       ? "#d3d3d3"
                       : "#ffffff"
                border.color: "#bcbcbc"
                radius: 5
            }
            // inputMethodHints: Qt.ImhFormattedNumbersOnly
            focus: false
            activeFocusOnTab: false
            onFocusChanged: {
                if (focus && !valueDirection.readOnly) {
                    Qt.callLater(function() {
                        focus = false
                        currentField = "valueDirection"
                        inputPanel.visible = true
                        textInformation.visible = true
                        textInformation.placeholderText = qsTr("Enter Direction")
                        textInformation.inputMethodHints = Qt.ImhPreferUppercase
                        textInformation.text = ""
                        textInformation.focus = true
                        valueDirection.color = "#ff0000"
                    })
                }
            }
        }

        Text {
            id: lineno
            x: 8
            y: 297
            text: qsTr("LINE NO.")
            font.pixelSize: 13
        }

        TextField {
            id: valueLineNo
            y: 327
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 8
            anchors.rightMargin: 50
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            font.pointSize: 11
            placeholderText: linenoInfoSetting === "" ? qsTr("Enter Number") : linenoInfoSetting
            readOnly: currentUserLevel !== 1
            background: Rectangle {
                color: currentUserLevel === 3 ? "#d3d3d3" : "#ffffff"
                border.color: "#bcbcbc"
                radius: 5
            }

            focus: false
            activeFocusOnTab: false
            onFocusChanged: {
                if (focus && !valueLineNo.readOnly) {
                    Qt.callLater(function() {
                        focus = false
                        currentField = "valueLineNo"
                        inputPanel.visible = true
                        textInformation.visible = true
                        textInformation.placeholderText = qsTr("Enter Number")
                        textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly
                        textInformation.text = ""
                        textInformation.focus = true
                        valueLineNo.color = "#ff0000"
                    })
                }
            }
        }


        Text {
            id: substation1
            x: 8
            y: 54
            text: qsTr("VOLTAGE")
            font.pixelSize: 13
        }

        ColumnLayout {
        }
        anchors.rightMargin: 600
    }

    Rectangle {
        id: periodicsettingdaily
        color: "#00f2f2f2"
        border.width: 0
        anchors.fill: parent
        anchors.bottomMargin: 8
        anchors.leftMargin: 442
        anchors.topMargin: 15

        ColumnLayout {
            y: 102
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 8
            anchors.rightMargin: 262
            Rectangle {
                id: checkMonday
                color: isReadOnlyLevel
                       ? (isActive ? "#d3d3d3" : "#f2f2f2")
                       : (isActive ? "#00FF00" : "#f2f2f2")
                radius: 5
                border.color: "#bcbcbc"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40

                property bool isActive: selectMonday

                MouseArea {
                    anchors.fill: parent
                    enabled: !isReadOnlyLevel
                    onClicked: {
                        checkMonday.isActive = !checkMonday.isActive;
                        var SelectDate = '{"objectName":"date", "Monday": ' + checkMonday.isActive + '}';
                        qmlCommand(SelectDate); // Send the updated state
                        console.log("Current UserType: " + SelectDate, selectMonday);
                    }
                }

                Component.onCompleted: {
                    console.log("Initial state: isActive =", isActive, ", selectMonday =", selectMonday);
                }
            }



            Rectangle {
                id: checkTuesday
                color: isReadOnlyLevel
                       ? (isActive ? "#d3d3d3" : "#f2f2f2")
                       : (isActive ? "#00FF00" : "#f2f2f2")
                radius: 5
                border.color: "#bcbcbc"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: selectTuesday
                MouseArea {
                    anchors.fill: parent
                    enabled: !isReadOnlyLevel
                    onClicked: {
                        checkTuesday.isActive = !checkTuesday.isActive;
                        var SelectDate = '{"objectName":"date", "Tuesday": ' + checkTuesday.isActive + '}';
                        qmlCommand(SelectDate);
                        console.log("Current UserType: " + SelectDate, selectTuesday);
                    }
                }
                Component.onCompleted: {
                    console.log("Initial state: isActive =", isActive, ", selectTuesday =", selectTuesday);
                }
            }

            Rectangle {
                id: checkWednesday
                color: isReadOnlyLevel
                       ? (isActive ? "#d3d3d3" : "#f2f2f2")
                       : (isActive ? "#00FF00" : "#f2f2f2")
                radius: 5
                border.color: "#bcbcbc"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: selectWednesday
                MouseArea {
                    anchors.fill: parent
                    enabled: !isReadOnlyLevel
                    onClicked: {
                        checkWednesday.isActive = !checkWednesday.isActive;
                        var SelectDate = '{"objectName":"date", "Wednesday": ' + checkWednesday.isActive + '}';
                        qmlCommand(SelectDate);
                        console.log("Current UserType: " + SelectDate, selectWednesday);
                    }
                }
                Component.onCompleted: {
                    console.log("Initial state: isActive =", isActive, ", selectWednesday =", selectWednesday);
                }
            }

            Rectangle {
                id: checkThursday
                color: isReadOnlyLevel
                       ? (isActive ? "#d3d3d3" : "#f2f2f2")
                       : (isActive ? "#00FF00" : "#f2f2f2")
                radius: 5
                border.color: "#bcbcbc"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: selectThursday
                MouseArea {
                    anchors.fill: parent
                    enabled: !isReadOnlyLevel
                    onClicked: {
                        checkThursday.isActive = !checkThursday.isActive;
                        var SelectDate = '{"objectName":"date", "Thursday": ' + checkThursday.isActive + '}';
                        qmlCommand(SelectDate);
                        console.log("Current UserType: " + SelectDate, selectThursday);
                    }
                }
                Component.onCompleted: {
                    console.log("Initial state: isActive =", isActive, ", selectThursday =", selectThursday);
                }
            }

            Rectangle {
                id: checkFriday
                color: isReadOnlyLevel
                       ? (isActive ? "#d3d3d3" : "#f2f2f2")
                       : (isActive ? "#00FF00" : "#f2f2f2")
                radius: 5
                border.color: "#bcbcbc"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: selectFriday
                MouseArea {
                    anchors.fill: parent
                    enabled: !isReadOnlyLevel
                    onClicked: {
                        checkFriday.isActive = !checkFriday.isActive;
                        var SelectDate = '{"objectName":"date", "Friday": ' + checkFriday.isActive + '}';
                        qmlCommand(SelectDate);
                        console.log("Current UserType: " + SelectDate, selectFriday);
                    }
                }
                Component.onCompleted: {
                    console.log("Initial state: isActive =", isActive, ", selectFriday =", selectFriday);
                }
            }

            Rectangle {
                id: checkSaturday
                color: isReadOnlyLevel
                       ? (isActive ? "#d3d3d3" : "#f2f2f2")
                       : (isActive ? "#00FF00" : "#f2f2f2")
                radius: 5
                border.color: "#bcbcbc"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: selectSaturday
                MouseArea {
                    anchors.fill: parent
                    enabled: !isReadOnlyLevel
                    onClicked: {
                        checkSaturday.isActive = !checkSaturday.isActive;
                        var SelectDate = '{"objectName":"date", "Saturday": ' + checkSaturday.isActive + '}';
                        qmlCommand(SelectDate);
                        console.log("Current UserType: " + SelectDate, selectSaturday);
                    }
                }
                Component.onCompleted: {
                    console.log("Initial state: isActive =", isActive, ", selectSaturday =", selectSaturday);
                }
            }

            Rectangle {
                id: checkSunday
                color: isReadOnlyLevel
                       ? (isActive ? "#d3d3d3" : "#f2f2f2")
                       : (isActive ? "#00FF00" : "#f2f2f2")
                radius: 5
                border.color: "#bcbcbc"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: selectSunday
                MouseArea {
                    anchors.fill: parent
                    enabled: !isReadOnlyLevel
                    onClicked: {
                        checkSunday.isActive = !checkSunday.isActive;
                        var SelectDate = '{"objectName":"date", "Sunday": ' + checkSunday.isActive + '}';
                        qmlCommand(SelectDate);
                        console.log("Current UserType: " + SelectDate,selectSunday);
                    }
                }
                Component.onCompleted: {
                    console.log("Initial state: isActive =", isActive, ", selectSunday =", selectSunday);
                }
            }
        }

        ColumnLayout {
            y: 102
            height: 310
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 54
            anchors.rightMargin: 149

            Text {
                id: monday
                text: qsTr("MONDAY")
                font.pixelSize: 18
            }

            Text {
                id: tuesday
                text: qsTr("TUESDAY")
                font.pixelSize: 18
            }

            Text {
                id: wednesday
                text: qsTr("WEDNESDAY")
                font.pixelSize: 18
            }

            Text {
                id: thursday
                text: qsTr("THURSDAY")
                font.pixelSize: 18
            }

            Text {
                id: friday
                text: qsTr("FRIDAY")
                font.pixelSize: 18
            }

            Text {
                id: saturday
                text: qsTr("SATURDAY")
                font.pixelSize: 18
            }

            Text {
                id: sunday
                text: qsTr("SUNDAY")
                font.pixelSize: 18
            }
        }

        RowLayout {
            y: 47
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 8
            anchors.rightMargin: 100

            Text {
                id: timeText
                text: qsTr("TIME")
                font.pixelSize: 13
            }

            TextField {
                id: textTime
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredHeight: 35
                Layout.preferredWidth: 100
                text: time
                placeholderText: qsTr("Enter Time")
                readOnly:currentUserLevel !== 1
                background: Rectangle {
                    color: (userLevelGlobalVars.count > 0 &&
                            (currentUserLevel === 2 ||
                             currentUserLevel === 3))
                           ? "#d3d3d3"
                           : "#ffffff"
                    border.color: "#bcbcbc"
                    radius: 5
                }
                focus: false
                activeFocusOnTab: false
                onFocusChanged: {
                    if (focus && !textTime.readOnly) {
                        Qt.callLater(function() {
                            textTime.focus = false;
                            currentField = "textTime";
                            inputPanel.visible = true;
                            textInformation.visible = true;
                            textInformation.placeholderText = qsTr("Enter Time");
                            textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                            textInformation.text = textTime.text;
                            textInformation.focus = true;
                            color = "#ff0000";
                        })
                    }
                }
            }

        }
        anchors.rightMargin: 310
    }

    Rectangle {
        id: modesetting2
        color: "#00f2f2f2"
        border.width: 0
        anchors.fill: parent
        anchors.bottomMargin: 8
        anchors.leftMargin: 700
        anchors.topMargin: 15

        ColumnLayout {
            y: 100
            height: 85
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 10
            anchors.rightMargin: 241
            // color: (currentUserLevel === 2 || currentUserLevel === 3)
            //        ? (userModeSelect === "MASTER" ? "#d3d3d3" : "#f2f2f2")
            //        : (userModeSelect === "MASTER" ? "#00FF00" : "#f2f2f2")
            Rectangle {
                id: checklflfail
                color:(currentUserLevel === 3)?( statusLFLFails ? "#d3d3d3" : "#f2f2f2"):( statusLFLFails ? "#00FF00" : "#f2f2f2")
                radius: 5
                border.color: "#b7b7b7"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: lflFail
                property bool lflFail: false

                MouseArea {
                    anchors.fill: parent
                    anchors.leftMargin: -4
                    anchors.rightMargin: 4
                    anchors.topMargin: 0
                    anchors.bottomMargin: 0
                    enabled: currentUserLevel !== 3
                    onClicked: {
                        console.log("Before Click | isActive:", checklflfail.isActive, "| lflFail:", lflFail, "statusLFLFails:", statusLFLFails);

                        statusLFLFails = !statusLFLFails;
                        // lflFail = checklflfail.isActive;

                        console.log("After Click | isActive:", checklflfail.isActive, "| lflFail:", lflFail, "color:", color);

                        var CheckStatusFail = '{"objectName":"statusFail","LFLFAIL":' + statusLFLFails + '}';
                        qmlCommand(CheckStatusFail);
                    }
                }
            }

            Rectangle {
                id: checkoperate
                color: (currentUserLevel === 3)
                       ? (statusLFLOperates ? "#d3d3d3" : "#f2f2f2")
                       : (statusLFLOperates ? "#00FF00" : "#f2f2f2")
                radius: 5
                border.color: "#a6a6a6"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: lflOperate
                property bool lflOperate: false

                MouseArea {
                    anchors.fill: parent
                    enabled: currentUserLevel !== 3
                    onClicked: {
                        console.log("Before Click | isActive:", checkoperate.isActive, "| lflOperate:", lflOperate);

                        statusLFLOperates = !statusLFLOperates;

                        console.log("After Click | isActive:", checkoperate.isActive, "| lflOperate:", lflOperate);

                        var CheckStatusOperate = '{"objectName":"statusOperate","LFLOPERATE":' + statusLFLOperates + '}';
                        qmlCommand(CheckStatusOperate);
                    }
                }
            }
        }

        ColumnLayout {
            y: 100
            height: 85
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 65
            anchors.rightMargin: 10

            Text {
                id: textlflfail
                text: qsTr("LFL FAIL")
                font.pixelSize: 19
                Layout.preferredHeight: 23
                Layout.preferredWidth: 73
            }

            Text {
                id: textoperate
                text: qsTr("LFL OPERATE")
                font.pixelSize: 19
                Layout.preferredHeight: 23
                Layout.preferredWidth: 73
            }
        }

        Rectangle {
            id: lflConfigBox
            width: 241
            height: 177
            color: isReadOnly ? "#f2f2f2" : "#ffffff"
            radius: 8
            border.color: isReadOnly ? "#d3d3d3" : "#a6a6a6"
            border.width: 1
            property bool isReadOnly: typeof currentUserLevel !== "undefined" &&
                                      (currentUserLevel === 2 || currentUserLevel === 3)
            x: 0
            y: 247

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12

                Text {
                    id: rangeOfLFLText
                    text: qsTr("CONFIGURATION OF LFL")
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    font.bold: false
                    Layout.fillHeight: true
                }

                SpinBox {
                    id: rangeOfLFL
                    from: 1
                    to: 10
                    value: numpointofLFL
                    enabled: !isReadOnlyLevel
                }

                Button {
                    id: buttonSentLFL
                    text: qsTr("Point of LFL")
                    enabled: !isReadOnlyLevel
                    onClicked: {
                        var rangeoflfl = '{"objectName":"LineFail","rangeoflfl": '+rangeOfLFL.value +'}';
                        qmlCommand(rangeoflfl);
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                enabled: false
            }
        }

        anchors.rightMargin: 0
    }

    RowLayout {
        height: 46
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 8
        anchors.rightMargin: 0
        anchors.topMargin: 10

        Text {
            id: text1
            text: qsTr("MODE SETTING")
            font.pixelSize: 16
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
        }

        Text {
            id: textInfoSetting
            text: qsTr("INFO SETTING")
            font.pixelSize: 16
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: false
            Layout.fillHeight: true
        }

        Text {
            id: periodicsettingtext
            text: qsTr("PERIODIC SETTING")
            font.pixelSize: 16
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
        }

        Text {
            id: relayactivated
            text: qsTr("AUXILIARY RELAY \n ACTIVATED")
            font.pixelSize: 16
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
        }
    }

    Item {
        id: __materialLibrary__
    }

}





/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}
}
##^##*/

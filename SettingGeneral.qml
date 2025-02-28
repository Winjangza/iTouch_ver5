import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.0
import QtWebSockets 1.0
import QtQuick.Extras 1.4
import QtQml 2.2
import QtQuick.VirtualKeyboard 2.15
import QtQuick.VirtualKeyboard.Styles 2.15
import QtQuick.VirtualKeyboard.Settings 2.15
import QtQuick3D 1.15
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
    property bool lflFail: false
    property bool lflOperate: false

    property double voltageInfoSetting: voltageInfo
    property string substationInfoSetting: substationInfo
    property string directionInfoSetting: directionInfo
    property int linenoInfoSetting: linenoInfo

    property string userModeSelect: userMode

    visible: userLevelGlobalVars.count > 0 && (userLevelGlobalVars.get(0).userLevel >= 1 && userLevelGlobalVars.get(0).userLevel <= 3)

    onFocustextInformationChanged: {
        if(focustextInformation == false){
            valueVoltage.color = "#000000"
            valueSubstation.color = "#000000"
            valueDirection.color = "#000000"
            valueLineNo.color = "#000000"
            textTime.color = "#000000"
        }
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

    Rectangle {
        id: modesetting
        color: "#00f2f2f2"
        border.color: "#00ffffff"
        border.width: 1
        anchors.fill: parent
        anchors.rightMargin: 840
        anchors.topMargin: 15

        ColumnLayout {
            x: 14
            y: 47

            Rectangle {
                id: selectMaster
                color: (userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
                       ? (userModeSelect === "MASTER" ? "#d3d3d3" : "#f2f2f2")
                       : (userModeSelect === "MASTER" ? "#00FF00" : "#f2f2f2")
                radius: 5
                border.color: "#b7b7b7"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40

                MouseArea {
                    anchors.fill: parent
                    preventStealing: true
                    propagateComposedEvents: false
                    enabled: !(userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
                    onClicked: {
                        if (userModeSelect !== "MASTER") {
                            userModeSelect = "MASTER";
                            var SelectMaster = '{"objectName":"selectUsers","userType": "MASTER"}';
                            console.log("selectMaster:", SelectMaster);
                            qmlCommand(SelectMaster);
                        }
                    }
                }
            }

            Rectangle {
                id: selectSlaves
                color: (userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
                       ? (userModeSelect === "SLAVE" ? "#d3d3d3" : "#f2f2f2")
                       : (userModeSelect === "SLAVE" ? "#00FF00" : "#f2f2f2")
                radius: 5
                border.color: "#a6a6a6"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40

                MouseArea {
                    anchors.fill: parent
                    preventStealing: true
                    propagateComposedEvents: false
                    enabled: !(userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
                    onClicked: {
                        if (userModeSelect !== "SLAVE") {
                            userModeSelect = "SLAVE";
                            var SelectSlave = '{"objectName":"selectUsers","userType": "SLAVE"}';
                            console.log("selectSlave:", SelectSlave);
                            qmlCommand(SelectSlave);
                        }
                    }
                }
            }
        }


        ColumnLayout {
            x: 62
            y: 47
            width: 50
            height: 85

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
        }
    }

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
            placeholderText: qsTr("Enter Voltage") ? voltageInfoSetting : qsTr("Enter Voltage")
            readOnly: (userLevelGlobalVars.get(0).userLevel === 3)
            background: Rectangle {
                color: ( userLevelGlobalVars.get(0).userLevel === 3)
                       ? "#d3d3d3"
                       : "#ffffff"
            border.color: "#bcbcbc"
            radius: 5
            }
            // inputMethodHints: Qt.ImhFormattedNumbersOnly
            focus: false
            onFocusChanged: {
                if (focus && !textTime.readOnly ) {
                    valueVoltage.focus = false
                    currentField = "valueVoltage";
                    inputPanel.visible = true;
                    textInformation.visible = true;
                    textInformation.placeholderText = qsTr("Enter Voltage");
                    textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                    textInformation.text = "";
                    textInformation.focus = true;
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
            placeholderText: qsTr("Enter Substation") ? substationInfoSetting : qsTr("Enter Substation")
            readOnly: (userLevelGlobalVars.get(0).userLevel === 3)
            background: Rectangle {
                color: ( userLevelGlobalVars.get(0).userLevel === 3)
                       ? "#d3d3d3"
                       : "#ffffff"
            border.color: "#bcbcbc"
            radius: 5
            }
            // inputMethodHints: Qt.ImhFormattedNumbersOnly
            focus: false
            onFocusChanged: {
                if (focus  && !textTime.readOnly) {
                    valueSubstation.focus = false
                    currentField = "valueSubstation";
                    inputPanel.visible = true;
                    textInformation.visible = true;
                    textInformation.placeholderText = qsTr("Enter Substation");
                    textInformation.inputMethodHints = Qt.ImhPreferUppercase;
                    textInformation.text = "";
                    textInformation.focus = true;
                    valueSubstation.color = "#ff0000"
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
            placeholderText: qsTr("Enter DIRECTION") ? directionInfoSetting :  qsTr("Enter DIRECTION")
            readOnly: (userLevelGlobalVars.get(0).userLevel === 3)
            background: Rectangle {
                color: ( userLevelGlobalVars.get(0).userLevel === 3)
                       ? "#d3d3d3"
                       : "#ffffff"
            border.color: "#bcbcbc"
            radius: 5
            }
            // inputMethodHints: Qt.ImhFormattedNumbersOnly
            focus: false
            onFocusChanged: {
                if (focus && !textTime.readOnly) {
                    valueDirection.focus = false
                    currentField = "valueDirection";
                    inputPanel.visible = true;
                    textInformation.visible = true;
                    textInformation.placeholderText = qsTr("Enter Direction");
                    textInformation.inputMethodHints = Qt.ImhPreferUppercase;
                    textInformation.text = "";
                    textInformation.focus = true;
                    valueDirection.color = "#ff0000"
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
            placeholderText: qsTr("Enter Number") ? linenoInfoSetting : qsTr("Enter Number")
            readOnly: (userLevelGlobalVars.get(0).userLevel === 3)
            background: Rectangle {
                color: ( userLevelGlobalVars.get(0).userLevel === 3)
                       ? "#d3d3d3"
                       : "#ffffff"
            border.color: "#bcbcbc"
            radius: 5
            }
            // inputMethodHints: Qt.ImhFormattedNumbersOnly
            focus: false
            onFocusChanged: {
                if (focus && !textTime.readOnly) {
                    valueLineNo.focus = false
                    currentField = "valueLineNo";
                    inputPanel.visible = true;
                    textInformation.visible = true;
                    textInformation.placeholderText = qsTr("Enter Number");
                    textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                    textInformation.text = "";
                    textInformation.focus = true;
                    valueLineNo.color = "#ff0000"

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
                color:(userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
                    ?( isActive ? "#d3d3d3" : "#f2f2f2")
                    :( isActive ? "#00FF00" : "#f2f2f2")
                radius: 5
                border.color: "#bcbcbc"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40

                property bool isActive: selectMonday

                MouseArea {
                    anchors.fill: parent
                    enabled: !(userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
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
                color:(userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
                    ?( isActive ? "#d3d3d3" : "#f2f2f2")
                    :( isActive ? "#00FF00" : "#f2f2f2")
                radius: 5
                border.color: "#bcbcbc"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: selectTuesday
                MouseArea {
                    anchors.fill: parent
                    enabled: !(userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
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
                color:(userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
                    ?( isActive ? "#d3d3d3" : "#f2f2f2")
                    :( isActive ? "#00FF00" : "#f2f2f2")
                radius: 5
                border.color: "#bcbcbc"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: selectWednesday
                MouseArea {
                    anchors.fill: parent
                    enabled: !(userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
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
                color:(userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
                    ?( isActive ? "#d3d3d3" : "#f2f2f2")
                    :( isActive ? "#00FF00" : "#f2f2f2")
                radius: 5
                border.color: "#bcbcbc"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: selectThursday
                MouseArea {
                    anchors.fill: parent
                    enabled: !(userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
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
                color:(userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
                    ?( isActive ? "#d3d3d3" : "#f2f2f2")
                    :( isActive ? "#00FF00" : "#f2f2f2")
                radius: 5
                border.color: "#bcbcbc"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: selectFriday
                MouseArea {
                    anchors.fill: parent
                    enabled: !(userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
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
                color:(userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
                    ?( isActive ? "#d3d3d3" : "#f2f2f2")
                    :( isActive ? "#00FF00" : "#f2f2f2")
                radius: 5
                border.color: "#bcbcbc"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: selectSaturday
                MouseArea {
                    anchors.fill: parent
                    enabled: !(userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
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
                color:(userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
                    ?( isActive ? "#d3d3d3" : "#f2f2f2")
                    :( isActive ? "#00FF00" : "#f2f2f2")
                radius: 5
                border.color: "#bcbcbc"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: selectSunday
                MouseArea {
                    anchors.fill: parent
                    enabled: !(userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
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
                placeholderText: qsTr("Text Time")
                readOnly: (userLevelGlobalVars.count > 0 &&
                           (userLevelGlobalVars.get(0).userLevel === 2 ||
                            userLevelGlobalVars.get(0).userLevel === 3))
                background: Rectangle {
                    color: (userLevelGlobalVars.count > 0 &&
                            (userLevelGlobalVars.get(0).userLevel === 2 ||
                             userLevelGlobalVars.get(0).userLevel === 3))
                           ? "#d3d3d3"  // ถ้า userLevel 2 หรือ 3 ให้พื้นหลังสีเทา
                           : "#ffffff"  // กรณีอื่นให้พื้นหลังสีขาว
                    border.color: "#bcbcbc"
                    radius: 5
                }
                focus: false
                onFocusChanged: {
                    if (focus && !textTime.readOnly) {
                        textTime.focus = false;
                        currentField = "textTime";
                        inputPanel.visible = true;
                        textInformation.visible = true;
                        textInformation.placeholderText = qsTr("Enter Time");
                        textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                        textInformation.text = textTime.text;
                        textInformation.focus = true;
                        color = "#ff0000";
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
            // color: (userLevelGlobalVars.get(0).userLevel === 2 || userLevelGlobalVars.get(0).userLevel === 3)
            //        ? (userModeSelect === "MASTER" ? "#d3d3d3" : "#f2f2f2")
            //        : (userModeSelect === "MASTER" ? "#00FF00" : "#f2f2f2")
            Rectangle {
                id: checklflfail
                color: (userLevelGlobalVars.get(0).userLevel === 3)
                        ? (checklflfail.isActive ? "#d3d3d3" : "#f2f2f2")
                        : (checklflfail.isActive ? "#00FF00" : "#f2f2f2")
                radius: 5
                border.color: "#b7b7b7"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: false
                property bool lflFail: false
                MouseArea {
                    anchors.fill: parent
                    anchors.leftMargin: -4
                    anchors.rightMargin: 4
                    anchors.topMargin: 0
                    anchors.bottomMargin: 0
                    enabled: !(userLevelGlobalVars.get(0).userLevel === 3)
                    onClicked: {
                        console.log("Before Click | isActive:", checklflfail.isActive, "| lflFail:", lflFail);

                        checklflfail.isActive = !checklflfail.isActive;
                        lflFail = checklflfail.isActive;

                        console.log("After Click | isActive:", checklflfail.isActive, "| lflFail:", lflFail);

                        var CheckStatusFail = '{"objectName":"statusFail","LFLFAIL":'+checklflfail.isActive+'}';
                        qmlCommand(CheckStatusFail);
                    }
                }
            }

            Rectangle {
                id: checkoperate
                color: (userLevelGlobalVars.get(0).userLevel === 3)
                        ? (checkoperate.isActive  ? "#d3d3d3" : "#f2f2f2")
                        : (checkoperate.isActive  ? "#00FF00" : "#f2f2f2")
                radius: 5
                border.color: "#a6a6a6"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: false
                property bool lflOperate: false

                MouseArea {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 0
                    anchors.rightMargin: 40
                    anchors.topMargin: 0
                    anchors.bottomMargin: 40
                    rotation: -132.797
                    enabled: !(userLevelGlobalVars.get(0).userLevel === 3)
                    onClicked: {
                        console.log("Before Click | isActive:", checkoperate.isActive, "| lflOperate:", lflOperate);

                        checkoperate.isActive = !checkoperate.isActive;
                        lflOperate = checkoperate.isActive;

                        console.log("After Click | isActive:", checkoperate.isActive, "| lflOperate:", lflOperate);

                        var CheckStatusOperate = '{"objectName":"statusOperate","LFLOPERATE":'+checkoperate.isActive+'}';
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
    //                    if (currentField === "valueVoltage") {
    //                        valueVoltage.text = text;
    //                        var Voltage = '{"objectName":"valueVoltage","Voltage": '+valueVoltage.text+'}'
    //                        qmlCommand(Voltage);
    //                        console.log("Voltage Entered:", text, Voltage);
    //                    } else if (currentField === "valueSubstation") {
    //                        valueSubstation.text = text;
    //                        var Substation = '{"objectName":"valueSubstation","Substation": '+valueSubstation.text+'}'
    //                        qmlCommand(Substation);
    //                        console.log("Substation Entered:", text,Substation);
    //                    } else if (currentField === "valueDirection") {
    //                        valueDirection.text = text;
    //                        var Direction = '{"objectName":"valueDirection","Direction": '+valueDirection.text+'}'
    //                        qmlCommand(Direction);
    //                        console.log("Direction Entered:", text,Direction);
    //                    } else if (currentField === "valueLineNo") {
    //                        valueLineNo.text = text;
    //                        var LineNo = '{"objectName":"valueLineNo","LineNo": '+valueLineNo.text+'}'
    //                        qmlCommand(LineNo);
    //                        console.log("Line No Entered:", text,LineNo);
    //                    }else if (currentField === "textTime") {
    //                        textTime.text = text;
    //                        var Time = '{"objectName":"textTime","Time": '+textTime.text+'}'
    //                        qmlCommand(Time);
    //                        console.log("Time Entered:", text,Time);
    //                    }
    //                }
    //                inputPanel.visible = false;
    //                visible = false;
    //            }
    //        }
    //    }

}



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
        anchors.rightMargin: 731

        ColumnLayout {
            x: 14
            y: 47

            Rectangle {
                id: selectMaster
                color: isActive ? "#00FF00" : "#f2f2f2"
                radius: 5
                border.color: "#b7b7b7"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: true

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        selectMaster.isActive = true
                        selectSlaves.isActive = false
                        checkUser = true
                        var SelectMaster = '{"objectName":"UserSelectM","userType": "Master" ,"userStatusMaster":'+selectMaster.isActive+'}'
                        console.log("selectMaster:",SelectMaster)
                        qmlCommand(SelectMaster)
                    }
                }
            }

            Rectangle {
                id: selectSlaves
                color: isActive ? "#00FF00" : "#f2f2f2"
                radius: 5
                border.color: "#a6a6a6"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: false

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        selectSlaves.isActive = true
                        selectMaster.isActive = false
                        checkUser = false
                        var SelectSlave = '{"objectName":"UserSelectS","userType": "Slave" ,"userStatusSlave":'+selectMaster.isActive+'}'
                        console.log("selectSlave:",SelectSlave)
                        qmlCommand(SelectSlave)
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
        anchors.leftMargin: 181
        anchors.topMargin: -8

        TextField {
            id: valueVoltage
            x: 8
            y: 76
            horizontalAlignment: Text.AlignHCenter
            Layout.fillHeight: false
            Layout.fillWidth: true
            font.pointSize: 11
            placeholderText: qsTr("Enter Voltage") ? voltageInfoSetting : qsTr("Enter Voltage")
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            focus: false
            onFocusChanged: {
                if (focus) {
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
            x: 8
            y: 159
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            font.pointSize: 11
            placeholderText: qsTr("Enter Substation") ? substationInfoSetting : qsTr("Enter Substation")
            focus: false
            onFocusChanged: {
                if (focus) {
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
            x: 8
            y: 243
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            font.pointSize: 11
            placeholderText: qsTr("Enter DIRECTION") ? directionInfoSetting :  qsTr("Enter DIRECTION")
            focus: false
            onFocusChanged: {
                if (focus) {
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
            x: 8
            y: 327
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            font.pointSize: 11
            placeholderText: qsTr("Enter Number") ? linenoInfoSetting : qsTr("Enter Number")
            focus: false
            onFocusChanged: {
                if (focus) {
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
        anchors.rightMargin: 500
    }

    Rectangle {
        id: periodicsettingdaily
        color: "#00f2f2f2"
        border.width: 0
        anchors.fill: parent
        anchors.bottomMargin: -8
        anchors.leftMargin: 442
        anchors.topMargin: 8

        ColumnLayout {
            x: 8
            y: 102

            Rectangle {
                id: checkMonday
                color: isActive ? "#00FF00" : "#ffffff"
                radius: 5
                border.color: "#bcbcbc"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40

                property bool isActive: selectMonday

                MouseArea {
                    anchors.fill: parent
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
                color: isActive ? "#00FF00" : "#ffffff"
                radius: 5
                border.color: "#bcbcbc"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: selectTuesday
                MouseArea {
                    anchors.fill: parent
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
                color: isActive ? "#00FF00" : "#ffffff"
                radius: 5
                border.color: "#bcbcbc"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: selectWednesday
                MouseArea {
                    anchors.fill: parent
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
                color: isActive ? "#00FF00" : "#ffffff"
                radius: 5
                border.color: "#bcbcbc"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: selectThursday
                MouseArea {
                    anchors.fill: parent
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
                color: isActive ? "#00FF00" : "#ffffff"
                radius: 5
                border.color: "#bcbcbc"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: selectFriday
                MouseArea {
                    anchors.fill: parent
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
                color: isActive ? "#00FF00" : "#ffffff"
                radius: 5
                border.color: "#bcbcbc"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: selectSaturday
                MouseArea {
                    anchors.fill: parent
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
                color: isActive ? "#00FF00" : "#ffffff"
                radius: 5
                border.color: "#bcbcbc"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: selectSunday
                MouseArea {
                    anchors.fill: parent
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
            x: 54
            y: 102
            width: 107
            height: 310

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
            x: 8
            y: 47

            Text {
                id: timeText
                text: qsTr("TIME")
                font.pixelSize: 13
            }

            TextField {
                id: textTime
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredHeight: 35
                Layout.preferredWidth: 97
                placeholderText: qsTr("Text Time")? time :  qsTr("Text Time")
                focus: false
                //                text:textforinformation
                onFocusChanged: {
                    if (focus) {
                        textTime.focus = false
                        currentField = "textTime";
                        inputPanel.visible = true;
                        textInformation.visible = true;
                        textInformation.placeholderText = qsTr("Enter Time");
                        textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                        textInformation.text = "";
                        textInformation.focus = true;
                        color = "#ff0000"

                    }
                }
            }
        }
        anchors.rightMargin: 248
    }

    Rectangle {
        id: modesetting2
        color: "#00f2f2f2"
        border.width: 0
        anchors.fill: parent
        anchors.bottomMargin: 0
        anchors.leftMargin: 690
        anchors.topMargin: 0

        ColumnLayout {
            x: 8
            y: 100

            Rectangle {
                id: checklflfail
                color: isActive ? "#00FF00" : "#f2f2f2"
                radius: 5
                border.color: "#b7b7b7"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: lflFail

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        checklflfail.isActive = !checklflfail.isActive
//                        checkoperate.isActive = false
//                        checkAct = true
                        var CheckStatusFail = '{"objectName":"statusFail","LFLFAIL":'+checklflfail.isActive+'}'
                        qmlCommand(CheckStatusFail)
                    }
                }
            }

            Rectangle {
                id: checkoperate
                color: isActive ? "#00FF00" : "#f2f2f2"
                radius: 5
                border.color: "#a6a6a6"
                border.width: 1
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
                property bool isActive: lflOperate

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        checkoperate.isActive = !checkoperate.isActive
//                        checklflfail.isActive = false
//                        checkAct = false
                        var CheckStatusOperate = '{"objectName":"statusOperate","LFLOPERATE":'+checkoperate.isActive+'}'
                        qmlCommand(CheckStatusOperate)
                    }
                }
            }
        }

        ColumnLayout {
            x: 54
            y: 100
            width: 73
            height: 85

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
        x: 8
        y: 0
        width: 992
        height: 46

        Text {
            id: text1
            text: qsTr("MODE SETTING")
            font.pixelSize: 16
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: textInfoSetting
            text: qsTr("INFO SETTING")
            font.pixelSize: 16
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: periodicsettingtext
            text: qsTr("PERIODIC SETTING")
            font.pixelSize: 16
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: relayactivated
            text: qsTr("AUXILIARY RELAY \n ACTIVATED")
            font.pixelSize: 16
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
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



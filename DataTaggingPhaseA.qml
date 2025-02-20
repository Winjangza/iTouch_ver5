import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtWebSockets 1.0
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.VirtualKeyboard 2.15
import QtQuick.VirtualKeyboard.Styles 2.15
import QtQuick.VirtualKeyboard.Settings 2.15
import QtGraphicalEffects 1.0

Item {
    width: 630
    height: 400
    property var rowsData: []
    property int selectedRow: -1
    property bool keyboardVisible: false
    property int currentNo: 1
    property var dataList: []
    property int originalY: 325
    property bool focustextInformation: inputPanel.visible
    property string textforinformation:  textInformation.text
    property bool tablestatus: statusA
    property int tablenumber: numberA
    property double tabledistance: distanceA
    property string tabledetail: detailA
    property string tablephase: phaseA
    property int tablenumlist: num_listA
    property int selectedRowIndex: -1
//    property var checkedStates: false

    onFocustextInformationChanged: {
        if(focustextInformation == false){
            distanceField.color = "#000000"
            detailField.color = "#000000"
        }
    }
    onTextforinformationChanged: {
        if(distanceField.color == "#ff0000"){
            distanceField.text = textforinformation
        }
        if(detailField.color == "#ff0000"){
            detailField.text = textforinformation
        }
        console.log("onTextforinformationChanged",textforinformation)
    }

    function adjustPosition() {
        if (keyboardVisible) {
            textFieldContainer.y = originalY - 150;
        } else {
            textFieldContainer.y = originalY;
        }
    }


    Rectangle {
        id: rectangle
        color: "#e7e6e6"
        border.color: "#ffffff"
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        TableView {
            id: recordDatabase
            anchors.fill: parent
            anchors.rightMargin: 0
            anchors.topMargin: 0
            anchors.bottomMargin: 140
            clip: true
            model: newlistdatatebleA
            TableViewColumn { role: "list_statusA"; title: "SELECT"; width: 100;
                delegate: Rectangle {
                    id: checkBoxDelegate
                    color: "#00000000"
                    property bool isChecked: false
                    width: parent.width
                    height: parent.height
                    Rectangle {
                        id: colorBox
                        width: 35
                        height: width
                        border.width: 3
                        radius: 3
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: checkBoxDelegate.isChecked ? "#90cf59":"#ffffff"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                checkBoxDelegate.isChecked = !checkBoxDelegate.isChecked
                                console.log("checkBox ",checkBoxDelegate.isChecked , newlistdatatebleA.num_listA, newlistdatatebleA.numberA,numberA, tablenumber )
                                setpropertyCheckA(checkBoxDelegate.isChecked)
                                taggingpoint(newlistdatatebleA.num_listA, checkBoxDelegate.isChecked)
                            }
                        }
                    }
                }
            }
            TableViewColumn { role: "list_numberA"; title: "NO."; width: 80 }
            TableViewColumn { role: "list_distanceA"; title: "DISTANCE"; width: 150 }
            TableViewColumn { role: "list_detailA"; title: "DETAIL"; width: 300}
            // TableViewColumn { role: "num_list"; title: "Number"; width: 150}

            onClicked: {
                console.log("TableView",newlistdatatebleA.get(row).num_listA)
                setpropertyIDTableA(newlistdatatebleA.get(row).num_listA)
            }
        }
    }

    Row {
        x: 8
        y: 299

        Column {

            Text { id: distanceText ; text: "DISTANCE(KM)" }

            TextField {
                id: distanceField
                property color color: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                font.pointSize: 11
                placeholderText: qsTr("Enter DISTANCE")
                width: 150
                height: 35
                focus: false
                onFocusChanged: {
                    if (focus) {
                        distanceField.focus = true;
                        currentField = "distanceField";
                        inputPanel.visible = true;
                        textInformation.visible = true;
                        textInformation.text = qsTr("Enter DISTANCE") ? editDistanceA : qsTr("Enter DISTANCE");
                        textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                        textInformation.focus = true;
                        distanceField.color = "#ff0000";
                    }
                }
            }
        }

        Column {

            Text { id: detailText; text: "DETAIL" }

            TextField {
                id: detailField
                property color color: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                font.pointSize: 11
                placeholderText: qsTr("Enter DETAIL")
                width: 300
                height: 35
                focus: false
                onFocusChanged: {
                    if (focus) {
                        detailField.focus = true;
                        currentField = "detailField";
                        inputPanel.visible = true;
                        textInformation.visible = true;
                        textInformation.text = qsTr("Enter DETAIL") ? editDetailA : qsTr("Enter DETAIL");
                        textInformation.inputMethodHints = Qt.ImhPreferUppercase;
                        textInformation.text = "";
                        textInformation.focus = true;
                        detailField.color = "#ff0000";
                    }
                }
            }
        }
    }

    RowLayout {
        x: 8
        y: 367

        Button {
            text: "NEW"
            onClicked: {
                console.log("Type of distanceField.text:", typeof distanceField.text);
                console.log("Type of detailField.text:", typeof detailField.text);

                var distanceValue = parseFloat(distanceField.text);
                var detailValue = detailField.text;

                if (isNaN(distanceValue)) {
                    console.log("Invalid Distance input");
                } else {
                    console.log("Valid Distance input");
                }

                var dataTagging = '{"objectName":"getDistanceDetailA","Distance": ' + distanceValue + ',"Detail": "' + detailValue + '", "PHASE": "A"}';
                console.log("getDistanceDetail:", dataTagging);
                qmlCommand(dataTagging);
            }
        }

        Button {
            text: "EDIT"
            onClicked: {
                console.log("edit:", checkedStates, newlistdatatebleA.num_listA,num_listA,numberA);
                if (checkedStates === true) {
                    var numListA = num_listA;
                    var editPhaseA = '{"objectName":"editDataPhaseA","checkedStates":'+checkedStates +', "num_listA":'+newlistdatatebleA.num_listA +', "PHASE": "A"}';
                    console.log("editDataPhaseA", editPhaseA, num_listA);
                    qmlCommand(editPhaseA);
                }
            }
        }

        Button {
            text: "SAVE"
            onClicked: console.log("Save button clicked.")
        }

        Button {
            text: "DELETE"
            onClicked: {
                console.log("Deleted:", checkedStates, newlistdatatebleA.num_listA, num_listA, numberA);
                if (checkedStates === true) {
                    // var numList = parseInt(newlistdatateble.num_list);
                    var numListA = num_listA;
                    var delectmySQL = '{"objectName":"delectmysqlA","checkedStates":'+checkedStates +',"num_listA":'+newlistdatatebleA.num_listA +'}';
                    console.log("delectmySQLA", delectmySQL, numListA);
                    //                    qmlCommand(delectmySQL);
                }
            }
        }
    }
  }

/*##^##
Designer {
    D{i:0;formeditorZoom:1.33}
}
##^##*/

import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
//import QtWebSockets 1.0
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
    property bool tablestatus: statusC
    property int tablenumber: numberC
    property double tabledistance: distanceC
    property string tabledetail: detailC
    property string tablephase: phaseC
    property int tablenumlist: num_listC

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
            model: newlistdatatebleC
            TableViewColumn { role: "list_status"; title: "SELECT"; width: 100;
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
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: checkBoxDelegate.isChecked ? "#90cf59":"#ffffff"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                checkBoxDelegate.isChecked = !checkBoxDelegate.isChecked
                                console.log("checkBox ",checkBoxDelegate.isChecked ,newlistdatatebleC.list_number, newlistdatatebleC.list_number )
                                setpropertyCheck(checkBoxDelegate.isChecked)
                            }
                        }
                    }
                }
            }
            TableViewColumn { role: "list_number"; title: "NO."; width: 80 }
            TableViewColumn { role: "list_distance"; title: "DISTANCE"; width: 150 }
            TableViewColumn { role: "list_detail"; title: "DETAIL"; width: 300}
            // TableViewColumn { role: "num_list"; title: "Number"; width: 150}

            onClicked: {
                console.log("TableView",newlistdatatebleC.get(row).num_list)
                setpropertyIDTable(newlistdatatebleC.get(row).num_list)
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

                var dataTagging = '{"objectName":"getDistanceDetailC","Distance": ' + distanceValue + ',"Detail": "' + detailValue + '", "PHASE": "C"}';
                console.log("getDistanceDetail:", dataTagging);
                qmlCommand(dataTagging);
                var tableTaggingPhaseC = '{"objectName":"TaggingPhaseC", "tableTaggingPhaseC": "TaggingPhaseC"}'
                qmlCommand(tableTaggingPhaseC);
            }
        }


        Button {
            text: "EDIT"
            onClicked: console.log("Edit button clicked.")
        }

        Button {
            text: "SAVE"
            onClicked: console.log("Save button clicked.")
        }

        Button {
            text: "DELETE"
            onClicked: {
                console.log("Deleted:", checkedStates, newlistdatatebleC.num_list,num_list);
                if (checkedStates === true) {
                    // var numList = parseInt(newlistdatatebleC.num_list);
                    var numList = num_list;
                    var delectmySQL = '{"objectName":"delectmysqlC","checkedStates":'+checkedStates +',"num_list":'+num_list +'}';
                    console.log("delectmySQL", delectmySQL, numList);
                    qmlCommand(delectmySQL);
                    var updatetablePhaseC = '{"objectName":"UpdatePhaseC", "updatetablePhaseC": "dataPhaseC"}'
                    qmlCommand(updatetablePhaseC);
                }
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
                        distanceField.focus = false;
                        currentField = "distanceField";
                        inputPanel.visible = true;
                        textInformation.visible = true;
                        textInformation.placeholderText = qsTr("Enter DISTANCE");
                        textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly;
                        textInformation.text = "";
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
                placeholderText: "Enter DETAIL"
                width: 300
                height: 35
                focus: false
                onFocusChanged: {
                    if (focus) {
                        currentField = "detailField";
                        inputPanel.visible = true;
                        textInformation.visible = true;
                        textInformation.placeholderText = qsTr("Enter DETAIL");
                        textInformation.inputMethodHints = Qt.ImhPreferUppercase;
                        textInformation.text = "";
                        textInformation.focus = true; // Allow this to take focus
                        detailField.color = "#ff0000";
                    }
                }
            }
        }
    }
    //    Rectangle {
    //        id: rectangle
    //        color: "#e7e6e6"
    //        anchors.fill: parent
    //        anchors.rightMargin: 0
    //        anchors.leftMargin: 0
    //        anchors.topMargin: 0
    //        anchors.bottomMargin: 0

    //        Rectangle {
    //            id: rectangle1
    //            color: "#f2f2f2"
    //            border.color: "#ffffff"
    //            border.width: 1
    //            anchors.fill: parent
    //            anchors.rightMargin: 56
    //            anchors.leftMargin: 21
    //            anchors.topMargin: 8
    //            anchors.bottomMargin: 347

    //            Text {
    //                id: notext
    //                text: qsTr("NO.")
    //                anchors.fill: parent
    //                font.pixelSize: 12
    //                horizontalAlignment: Text.AlignHCenter
    //                verticalAlignment: Text.AlignVCenter
    //                anchors.rightMargin: 511
    //            }
    //            Text {
    //                id: distanceText
    //                text: qsTr("DISTANCE(KM)")
    //                anchors.fill: parent
    //                font.pixelSize: 12
    //                horizontalAlignment: Text.AlignHCenter
    //                verticalAlignment: Text.AlignVCenter
    //                anchors.bottomMargin: 0
    //                anchors.leftMargin: 111
    //                anchors.topMargin: 0
    //                anchors.rightMargin: 352
    //            }
    //            Text {
    //                id: detailText
    //                text: qsTr("DETAIL")
    //                anchors.fill: parent
    //                font.pixelSize: 12
    //                horizontalAlignment: Text.AlignHCenter
    //                verticalAlignment: Text.AlignVCenter
    //                anchors.bottomMargin: 0
    //                anchors.leftMargin: 351
    //                anchors.topMargin: 0
    //                anchors.rightMargin: 112
    //            }
    //        }
    //        Rectangle {
    //            id: rectangledetailDistance
    //            anchors.fill: parent
    //            anchors.rightMargin: 20
    //            anchors.bottomMargin: 120
    //            anchors.leftMargin: 20
    //            anchors.topMargin: 60
    //            color: "#e7e6e6"
    //            border.width: 2

    //            Flickable {
    //                id: scrollArea
    //                anchors.fill: parent
    //                contentWidth: parent.width
    //                contentHeight: columnContent.implicitHeight
    //                clip: true

    //                Column {
    //                    id: columnContent
    //                    spacing: 5
    //                    width: scrollArea.width

    //                    Repeater {
    //                        model: rowsData
    //                        RowLayout {
    //                            spacing: 10

    //                            Rectangle {
    //                                id: checklistbox
    //                                color: modelData.selected ? "green" : "#ffffff"
    //                                radius: 5
    //                                border.color: "#a6a6a6"
    //                                Layout.preferredHeight: 40
    //                                Layout.preferredWidth: 40
    //                                MouseArea {
    //                                    anchors.fill: parent
    //                                    onClicked: {
    //                                        rowsData[index].selected = !rowsData[index].selected
    //                                        selectedRow = rowsData[index].selected ? index : -1
    //                                    }
    //                                }
    //                            }

    //                            Text {
    //                                text: index + 1
    //                                font.pixelSize: 18
    //                                Layout.preferredHeight: 40
    //                                Layout.preferredWidth: 30
    //                                horizontalAlignment: Text.AlignHCenter
    //                                verticalAlignment: Text.AlignVCenter
    //                            }

    //                            TextField {
    //                                text: modelData.distance
    //                                Layout.preferredHeight: 40
    //                                Layout.preferredWidth: 150
    //                                enabled: modelData.selected
    //                            }

    //                            TextField {
    //                                text: modelData.detail
    //                                Layout.preferredHeight: 40
    //                                Layout.preferredWidth: 300
    //                                enabled: modelData.selected
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //        }

    //        RowLayout {
    //            x: 20
    //            y: 368

    //            ToolButton {
    //                text: qsTr("NEW")
    //                onClicked: {
    //                    rowsData.push({ selected: false, distance: "New Distance", detail: "New Detail" });
    //                }
    //            }

    //            ToolButton {
    //                text: qsTr("EDIT")
    //                onClicked: {
    //                    if (selectedRow !== -1) {
    //                        rowsData[selectedRow].selected = true;
    //                    }
    //                }
    //            }

    //            ToolButton {
    //                text: qsTr("SAVE")
    //                onClicked: {
    //                    if (selectedRow !== -1) {
    //                        console.log("Row " + (selectedRow + 1) + " saved with data:",
    //                                    rowsData[selectedRow].distance, rowsData[selectedRow].detail);
    //                    }
    //                }
    //            }

    //            ToolButton {
    //                text: qsTr("DELETE")
    //                onClicked: {
    //                    if (selectedRow !== -1) {
    //                        rowsData.splice(selectedRow, 1);
    //                        selectedRow = -1;
    //                    }
    //                }
    //            }
    //        }


    //        RowLayout {
    //            x: 20
    //            y: 306
    //            width: 227
    //            height: 19

    //            Text {
    //                id: text5
    //                text: qsTr("DISTANCE(KM)")
    //                font.pixelSize: 16
    //            }

    //            Text {
    //                id: text6
    //                text: qsTr("DETAIL")
    //                font.pixelSize: 16
    //            }
    //        }

    //        RowLayout {
    //            x: 20
    //            y: 331

    //            TextField {
    //                id: distance
    //                Layout.preferredHeight: 40
    //                Layout.preferredWidth: 110
    //                placeholderText: qsTr("Distance")
    //            }

    //            TextField {
    //                id: detail
    //                Layout.preferredHeight: 40
    //                Layout.preferredWidth: 200
    //                placeholderText: qsTr("Detail")
    //            }
    //        }
    //    }
    //    InputPanel {
    //        id: inputPanel
    //        y: 168
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
    //            anchors.bottomMargin: 234
    //            anchors.leftMargin: 0
    //            anchors.topMargin: -45
    //            placeholderText: qsTr("Text Field")
    //            visible: false
    //            inputMethodHints: Qt.ImhFormattedNumbersOnly
    //            font.pointSize: 12

    //            Component.onCompleted: {
    //                focus = false;
    //            }

    //            Keys.onReturnPressed: {
    //                if (text.trim() !== "") {
    //                    if (currentField === "distanceField") {
    //                        distanceField.text = text;
    //                        var Distance = '{"objectName":"distanceField","distanceField": '+distanceField.text+'}'
    //                        qmlCommand(Distance);
    //                        console.log("Sag Entered:", text, Distance);
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
    D{i:0;formeditorZoom:1.1}
}
##^##*/

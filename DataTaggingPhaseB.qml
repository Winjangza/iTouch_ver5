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
    id: item1
    width: 630
    height: 400
    property alias rectangle: rectangle
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
    property bool checked: statusA

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
        anchors.bottomMargin: 134
        anchors.leftMargin: 0
        anchors.topMargin: 34

        ListView {
            id: listViewTaggingB
            model: newlistdatatebleA
            anchors.fill: parent
            anchors.bottomMargin: 0

            delegate: CheckBoxTagging {
                width: listViewTaggingB.width
                height: (model.list_phaseA ?? "") === "B" ? 50 : 0
                visible: (model.list_phaseA ?? "") === "B"
                phase:model.list_phaseA
                taggingID: model.list_numberA ?? 0
                                                 checked: model.list_statusA ?? false
                                                                                distance: model.list_distanceA ?? 0.0
                                                                                                                  detail: model.list_detailA ?? ""
                                                                                                                                                listIndex: model.num_listA
            }
        }
    }



    RowLayout {
        x: 8
        y: 348

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
                var dataTagging = '{"objectName":"getDistanceDetailB","Distance": '+ distanceInfoSetting+',"Detail": "'+detailInfoSetting+'", "PHASE": "B"}';
                console.log("getDistanceDetail:", dataTagging);
                qmlCommand(dataTagging);
            }
        }

        Button {
            text: "EDIT"
            enabled: selectedRowIndex !== -1
            onClicked: {
                var rowIndex = getSelectedModelIndexB()
                if (rowIndex !== -1 && newlistdatatebleA.count > rowIndex) {
                    var selectedItem = newlistdatatebleA.get(rowIndex)
                    var selectedDistance = selectedItem.list_distanceA
                    var selectedDetail = selectedItem.list_detailA

                    console.log("✏️ Editing Row B: dbNo =", selectedRowIndex,
                                "modelIndex =", rowIndex,
                                "Distance:", selectedDistance,
                                "Detail:", selectedDetail)

                    distanceField.text = selectedDistance.toString()
                    detailField.text = selectedDetail
                } else {
                    console.warn("⚠️ No valid row selected for edit! dbNo =", selectedRowIndex)
                }
            }
        }


        Button {
            text: "SAVE"
            enabled: selectedRowIndex !== -1 && distanceField.text.trim() !== "" && detailField.text.trim() !== ""
            onClicked: {
                var rowIndex = getSelectedModelIndexB()
                if (rowIndex !== -1 && distanceField.text.trim() !== "" && detailField.text.trim() !== "") {
                    var selectedItem = newlistdatatebleA.get(rowIndex)
                    var saveData = JSON.stringify({
                        objectName: "saveDataTaging",
                        num_listA: selectedItem.num_listA,
                        Distance: distanceField.text,
                        Detail: detailField.text,
                        PHASE: "B"
                    })
                    console.log("SAVE Data B:", saveData)
                    qmlCommand(saveData)
                } else {
                    console.warn("No valid row selected or missing required fields!")
                }
            }
        }



        Button {
            text: "DELETE"
            enabled: selectedRowIndex !== -1
            onClicked: {
                if (selectedRowIndex !== -1) {
                    deletedMytaggingB(selectedRowIndex)
                    selectedRowIndex = -1
                } else {
                    console.warn("⚠️ No row selected for deletion!")
                }
            }
        }

    }


    RowLayout {
        anchors.fill: parent
        spacing: 0
        anchors.bottomMargin: 367

        Rectangle {
            id: rectangle1
            color: "#ffffff"
            radius: 0
            border.width: 1
            Layout.fillHeight: true
            Layout.fillWidth: true
            Text {
                id: name1
                text: qsTr("SELECT")
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                anchors.leftMargin: 8
            }
        }

        Rectangle {
            id: rectangle2
            color: "#ffffff"
            border.width: 1
            Layout.fillHeight: true
            Layout.fillWidth: true
            Text {
                id: name2
                text: qsTr("NO")
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                anchors.leftMargin: 8
            }
        }

        Rectangle {
            id: rectangle3
            color: "#ffffff"
            border.width: 1
            Layout.fillHeight: true
            Layout.fillWidth: true
            Text {
                id: name3
                text: qsTr("DISTANCE")
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                anchors.leftMargin: 8
                anchors.bottomMargin: 0
            }
        }

        Rectangle {
            id: rectangle4
            color: "#ffffff"
            border.width: 1
            Layout.fillHeight: true
            Layout.fillWidth: true
            Text {
                id: name4
                text: qsTr("DETAIL")
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                anchors.leftMargin: 8
            }
        }
    }

    Column {
        x: 0
        y: 272
        width: 233
        height: 80

        Text { id: distanceText ; text: "DISTANCE(KM)" }

        TextField {
            id: distanceField
            y: 76
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 8
            anchors.rightMargin: 50
            horizontalAlignment: Text.AlignHCenter
            Layout.fillHeight: false
            Layout.fillWidth: true
            font.pointSize: 11
            placeholderText: distanceInfoSetting || qsTr("Enter DISTANCE")
            readOnly: !(currentUserLevel === 1)

            background: Rectangle {
                color: (currentUserLevel === 3)
                       ? "#d3d3d3"
                       : "#ffffff"
                border.color: "#bcbcbc"
                radius: 5
            }

            focus: false
            activeFocusOnTab: false

            onFocusChanged: {
                if (focus && !distanceField.readOnly) {
                    focus = false
                    currentField = "distanceFieldTagging"
                    inputPanel.visible = true
                    textInformation.visible = true
                    textInformation.placeholderText = qsTr("Enter DISTANCE")
                    textInformation.inputMethodHints = Qt.ImhFormattedNumbersOnly
                    textInformation.text = ""
                    textInformation.focus = true
                    distanceField.color = "#ff0000"
                }
            }
        }
    }

    Column {
        x: 239
        y: 272
        width: 340
        height: 80

        Text { id: detailText; text: "DETAIL" }

        TextField {
            id: detailField
            y: 126
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            horizontalAlignment: Text.AlignHCenter
            Layout.fillHeight: false
            Layout.fillWidth: true
            Layout.preferredWidth: 400
            font.pointSize: 11
            placeholderText: detailInfoSetting || qsTr("Enter DETAIL")
            readOnly: !(currentUserLevel === 1)

            background: Rectangle {
                color: (currentUserLevel === 3)
                       ? "#d3d3d3"
                       : "#ffffff"
                border.color: "#bcbcbc"
                radius: 5
            }

            focus: false
            activeFocusOnTab: false

            onFocusChanged: {
                if (focus && !detailField.readOnly) {
                    focus = false
                    currentField = "detailFieldTagging"
                    inputPanel.visible = true
                    textInformation.visible = true
                    textInformation.placeholderText = qsTr("Enter DETAIL")
                    textInformation.inputMethodHints = Qt.ImhPreferUppercase
                    textInformation.text = ""
                    textInformation.focus = true
                    detailField.color = "#ff0000"
                }
            }
        }
    }
    function getSelectedModelIndexB() {
        if (selectedRowIndex === -1)
            return -1
        return getDeviceIndexByPhase(selectedRowIndex, "B")
    }
    Component.onCompleted: {
        lockPageWhileTagging = true
        console.log("Tagging page entered -> lockPageWhileTagging = true")
    }

    Component.onDestruction: {
        lockPageWhileTagging = false
        console.log("Tagging page left -> lockPageWhileTagging = false")
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.66}
}
##^##*/

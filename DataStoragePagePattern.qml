import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtWebSockets 1.0
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.VirtualKeyboard 2.15
import QtQuick.VirtualKeyboard.Styles 2.15
import QtQuick.VirtualKeyboard.Settings 2.15
import QtQuick.Controls 2.13
// import QtQuick.Controls.Material 2.4
import QtQuick.Shapes 1.15
import QtQuick.Controls.Material 2.4

Item {
    id: _item
    width: 920
    height: 475
    // Material.theme: Material.Dark
    // Material.accent: "#E91E63"
    property bool focustextInformation: inputPanel.visible
    property string textforinformation:  textInformation.text



    property string selectedFilename: ""
    property string selectedEventDatetime: ""

    onFocustextInformationChanged: {
        if(focustextInformation == false){
            fileNamePattern.color = "#000000"
        }
    }
    onTextforinformationChanged: {
        if(fileNamePattern.color == "#ff0000"){
            fileNamePattern.text = textforinformation
        }
        console.log("onTextforinformationChanged",textforinformation)

    }


    // Column {
    //     anchors.top: progressContainer.bottom
    //     anchors.horizontalCenter: parent.horizontalCenter
    //     spacing: 10

    //     Button {
    //         text: "Show ProgressBar"
    //         visible: !progressContainer.isVisible
    //         onClicked: progressContainer.isVisible = true
    //     }

    //     Button {
    //         text: "Hide ProgressBar"
    //         visible: progressContainer.isVisible
    //         onClicked: progressContainer.isVisible = false
    //     }
    // }



    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: rectangle
            color: "#00ffffff"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 386
            Layout.preferredHeight: 475

            Rectangle {
                id: progressContainer
                x: 23
                y: 46
                width: 184
                height: 23
                radius: height / 2
                border.color: "#E0E0E0"
                color: "#E1E1E1"
                clip: true

                property bool isVisible: true
                opacity: isVisible ? 1 : 0

                Behavior on opacity {
                    NumberAnimation { duration: 300 }
                }

                Rectangle {
                    id: progressIndicator
                    x: 0
                    width: 100
                    height: parent.height
                    radius: height / 2
                    border.color: "#E0E0E0"
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#3BC425" }
                        GradientStop { position: 1.0; color: "#3BC425" }
                    }
                    anchors.verticalCenter: parent.verticalCenter

                    SequentialAnimation on x {
                        running: progressContainer.isVisible
                        loops: Animation.Infinite
                        PropertyAnimation { from: -progressIndicator.width; to: progressContainer.width; duration: 800; easing.type: Easing.InOutQuad }
                    }
                    y: -46
                }
            }

            RowLayout {
                y: 90
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                spacing: 1
                ToolButton {
                    id: toolButtonNew
                    text: qsTr("NEW")
                    Layout.preferredWidth: 85
                    onClicked: {
                        if (selectedFilename !== "" && selectedEventDatetime !== "") {
                            var ButtonpatternData = JSON.stringify({
                                objectName: "ButtonPattern",
                                category : "Pattern",
                                Onclicked: toolButtonNew.text,
                                filename: selectedFilename,
                                event_datetime: selectedEventDatetime
                            });
                            dataStoragePagePatternSearch.clearTableRequested();
                            console.log(ButtonpatternData);
                            qmlCommand(ButtonpatternData);
                        } else {
                            console.log("No row selected!");
                        }
                    }
                    contentItem: Image {
                        width: 40
                        height: 20
                        source: "images/button.png"
                        Text {
                            id: _text
                            text: qsTr("NEW")
                            anchors.fill: parent
                            anchors.rightMargin: 0
                            anchors.bottomMargin: 0
                            font.pixelSize: 17
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text {
                            id: _text2
                            text: qsTr("NEW")
                            anchors.fill: parent
                            anchors.rightMargin: 0
                            anchors.bottomMargin: 0
                            font.pixelSize: 17
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Layout.preferredHeight: 47
                    Layout.fillWidth: true
                }

                ToolButton {
                    id: toolButtonOpen
                    text: qsTr("OPEN")
                    Layout.preferredWidth: 85
                    onClicked: {
                        if (selectedFilename !== "" && selectedEventDatetime !== "") {
                            var ButtonpatternData = JSON.stringify({
                                objectName: "ButtonPattern",
                                category : "Pattern",
                                Onclicked: toolButtonOpen.text,
                                filename: selectedFilename,
                                event_datetime: selectedEventDatetime
                            });
                            // dataStoragePagePatternSearch.clearTableRequested();
                            console.log(ButtonpatternData);
                            qmlCommand(ButtonpatternData);
                        } else {
                            console.log("No row selected!");
                        }
                    }
                    contentItem: Image {
                        width: 40
                        height: 20
                        source: "images/button.png"
                        Text {
                            id: _text1
                            text: qsTr("OPEN")
                            anchors.fill: parent
                            anchors.rightMargin: 0
                            anchors.bottomMargin: 0
                            font.pixelSize: 17
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Layout.preferredHeight: 47
                    Layout.fillWidth: true
                }

                ToolButton {
                    id: toolButtonSave
                    text: qsTr("SAVE")
                    Layout.preferredWidth: 85
                    onClicked: {
                        if (selectedFilename !== "" && selectedEventDatetime !== "") {
                            var ButtonpatternData = JSON.stringify({
                                objectName: "ButtonPattern",
                                category : "Pattern",
                                Onclicked: toolButtonSave.text,
                                filename: selectedFilename,
                                event_datetime: selectedEventDatetime
                            });
                            dataStoragePagePatternSearch.clearTableRequested();
                            console.log(ButtonpatternData);
                            qmlCommand(ButtonpatternData);
                        } else {
                            console.log("No row selected!");
                        }
                    }
                    contentItem: Image {
                        width: 40
                        height: 20
                        source: "images/button.png"
                        Text {
                            id: _text3
                            text: qsTr("SAVE")
                            anchors.fill: parent
                            anchors.rightMargin: 0
                            anchors.bottomMargin: 0
                            font.pixelSize: 17
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Layout.preferredHeight: 47
                    Layout.fillWidth: true
                }

                ToolButton {
                    id: toolButtonDelete
                    text: qsTr("DELETE")
                    Layout.preferredWidth: 85
                    onClicked: {
                        if (selectedFilename !== "" && selectedEventDatetime !== "") {
                            var ButtonpatternData = JSON.stringify({
                                objectName: "ButtonPattern",
                                category : "Pattern",
                                Onclicked: toolButtonDelete.text,
                                filename: selectedFilename,
                                event_datetime: selectedEventDatetime
                            });
                            dataStoragePagePatternSearch.clearTableRequested();
                            console.log(ButtonpatternData);
                            qmlCommand(ButtonpatternData);
                        } else {
                            console.log("No row selected!");
                        }
                    }
                    contentItem: Image {
                        width: 40
                        height: 20
                        source: "images/button.png"
                        Text {
                            id: _text4
                            text: qsTr("DELETE")
                            anchors.fill: parent
                            anchors.rightMargin: 0
                            anchors.bottomMargin: 0
                            font.pixelSize: 17
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Layout.preferredHeight: 47
                    Layout.fillWidth: true
                }
            }

            TextField {
                id: fileNamePattern
                height: 40
                width: parent.width - 100
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 160

                font.pixelSize: 18
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                selectionColor: "#403e3e"
                hoverEnabled: false
                placeholderText: "File Name"
                placeholderTextColor: "#797676"
                color: "#000000"

                background: Rectangle {
                    radius: 8
                    color: "#F5F5F5"
                    border.color: "#000"
                    border.width: 2
                }

                onFocusChanged: {
                    if (focus) {
                        Qt.inputMethod.show();
                        fileNamePattern.background.border.color = "#000";
                        fileNamePattern.focus = false;
                        currentField = "newFileNamePattern";
                        inputPanel.visible = true;
                        textInformation.visible = true;
                        textInformation.text = "";
                        textInformation.inputMethodHints = Qt.ImhPreferUppercase;
                        textInformation.focus = true;
                        fileNamePattern.color = "#ff0000";
                    }
                }
            }
        }
        DataStoragePagePatternSearch {
            id: dataStoragePagePatternSearch
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 530

            onRowSelected: (filename, event_datetime) => {
                selectedFilename = filename;
                selectedEventDatetime = event_datetime;
                console.log("Selected:", selectedFilename, selectedEventDatetime);
            }
        }

    }
}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}D{i:1}
}
##^##*/

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
    width: 1024
    height: 600
    property bool focustextInformation: inputPanel.visible
    property string textforinformation:  textInformation.text

    onFocustextInformationChanged: {
        if(focustextInformation == false){
            textUserName.color = "#000000"
            textPassword.color = "#000000"
        }
    }
    onTextforinformationChanged: {
        if(textUserName.color == "#ff0000"){
            textUserName.text = textforinformation
        }
        if(textPassword.color == "#ff0000"){
            textPassword.text = textforinformation
        }
        console.log("onTextforinformationChanged",textforinformation)
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.rightMargin: 284
        anchors.bottomMargin: 355
        anchors.leftMargin: 284
        anchors.topMargin: 156

        RowLayout {
            Layout.preferredHeight: 45
            Layout.preferredWidth: 363

            Text {
                id: userName
                text: qsTr("USER NAME")
                font.pixelSize: 18
            }

            TextField {
                id: textUserName
                property color color: "#ffffff"
                Layout.fillHeight: true
                Layout.fillWidth: true
                placeholderText: qsTr("Enter Username")
                focus: false
                onFocusChanged: {
                    if (focus) {
                        textUserName.focus = true;
                        currentField = "textUserName";
                        inputPanel.visible = true;
                        textInformation.visible = true;
                        textInformation.text = qsTr("Enter UserName");
                        textInformation.inputMethodHints = Qt.ImhPreferUppercase;
                        textInformation.text = "";
                        textInformation.focus = true;
                        textUserName.color = "#ff0000";
                    }
                }
            }
        }

        RowLayout {
            Layout.preferredHeight: 45
            Layout.preferredWidth: 363

            Text {
                id: password
                text: qsTr("PASSWORD")
                font.pixelSize: 18
                Layout.rightMargin: 4
                Layout.fillWidth: false
            }

            TextField {
                id: textPassword
                property color color: "#ffffff"
                Layout.fillHeight: true
                Layout.fillWidth: true
                placeholderText: qsTr("Enter Password")
                focus: false
                onFocusChanged: {
                    if (focus) {
                        textPassword.focus = true;
                        currentField = "textPassword";
                        inputPanel.visible = true;
                        textInformation.visible = true;
                        textInformation.text = qsTr("Enter Password");
                        textInformation.inputMethodHints = Qt.ImhPreferUppercase;
                        textInformation.text = "";
                        textInformation.focus = true;
                        textPassword.color = "#ff0000";
                    }
                }
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.bottomMargin: 275
        anchors.leftMargin: 284
        anchors.rightMargin: 284
        anchors.topMargin: 275

        ToolButton {
            id: logOutButton
            text: qsTr("LOG-OUT")
            Layout.fillHeight: true
            Layout.fillWidth: true

        }

        ToolButton {
            id: logInButton
            text: qsTr("LOG-IN")
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                var userLogIn = '{"objectName":"userLogIn","userName":'+textUserName.text +',"password":'+textPassword.text +'}';
                console.log("delectmySQLA", userLogIn);
                qmlCommand(userLogIn)
            }
        }
    }

}

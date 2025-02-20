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
// import "main.qml" as Globals
// import QtQuick 2.0
// import QtQuick.Controls 2.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: _item
    objectName: "LoginPage"
    width: 1024
    height: 600
    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 331
        anchors.rightMargin: 329
        anchors.topMargin: 156
        anchors.bottomMargin: 329
        spacing: 20

        RowLayout {
            Layout.preferredWidth: 363

            Text {
                text: qsTr("USER NAME")
                font.pixelSize: 18
                Layout.preferredWidth: 120
            }

            TextField {
                id: textUserName
                Layout.fillWidth: true
                Layout.preferredWidth: 243
                placeholderText: qsTr("Enter Username")
            }
        }

        RowLayout {
            Layout.preferredWidth: 363

            Text {
                text: qsTr("PASSWORD")
                font.pixelSize: 18
                Layout.preferredWidth: 120
            }

            TextField {
                id: textPassword
                Layout.fillWidth: true
                Layout.preferredWidth: 193
                placeholderText: qsTr("Enter Password")
                echoMode: TextInput.Password
            }

            Button {
                id: togglePasswordButton
                Layout.preferredWidth: 50
                Layout.preferredHeight: 30
                text: ""

                icon.source: textPassword.echoMode === TextInput.Password ? "qrc:/images/invisible.png" : "qrc:/images/show.png"
                icon.width: 24
                icon.height: 24

                onClicked: {
                    textPassword.echoMode = textPassword.echoMode === TextInput.Password ? TextInput.Normal : TextInput.Password;
                    togglePasswordButton.icon.source = textPassword.echoMode === TextInput.Password ? "qrc:/images/invisible.png" : "qrc:/images/show.png";
                }
            }

        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Button {
                text: "Log In"
                Layout.fillWidth: true
                onClicked: {
                    var username = textUserName.text;
                    var password = textPassword.text;
                    var login = JSON.stringify({
                        "objectName": "login",
                        "username": username,
                        "password": password
                    });

                    console.log("Login JSON:", login);

                    qmlCommand(login);
                    // userLevelGlobalVars.clear();
                 // var mockResponse = JSON.stringify({ "level": (username === "admin" ? 1 : username === "manager" ? 2 : username === "user" ? 3 : 0) });
                 //    userLevelHandler(mockResponse);

                    if (userLevelGlobalVars.count > 0 && userLevelGlobalVars.get(0).userLevel > 0) {
                        stackView.push("qrc:/Mainpage.qml")
                        currentPage = "Mainpage"
                        eventsalarms.visible = false
                        backtoMainpage.visible = true
                        dataStorage.visible = true
                        imageSetting.visible = true
                        imageUnlock.visible = true
                        console.log("Navigated to Eventspage")
                    }
                }
            }

            Button {
                text: "Log Out"
                Layout.fillWidth: true
                onClicked: {
                    console.log("User logged out");
                    userLevelGlobalVars.clear(); // เคลียร์ Model
                }
            }
        }

        // Text {
        //     text: "Current User Level: " + (userLevelGlobalVars.count > 0 ? userLevelGlobalVars.get(0).userLevel : "None")
        //     color: "blue"
        //     font.pixelSize: 18
        // }
    }
}



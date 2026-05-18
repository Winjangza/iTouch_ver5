import QtQuick 2.0
//import QtQuick.Controls 2.15
//import QtQuick.Layouts 1.15
import QtWebSockets 1.0
import QtQuick.Extras 1.4
//import QtQuick.Controls 1.4
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
//    property string currentPage:""
    property bool loginInProgress: false
    property bool focustextInformation: inputPanel.visible
    property string textforinformation:  textInformation.text
    signal userLoggedOut()

    id: _item
    objectName: "LoginPage"
    width: 1024
    height: 600

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
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 331
        anchors.rightMargin: 329
        anchors.topMargin: 156
        anchors.bottomMargin: 248
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
                Keys.onReturnPressed: Qt.inputMethod.hide();
                activeFocusOnTab: false
                onFocusChanged: {
                    if (focus) {
                        Qt.callLater(function() {
                            textUserName.focus = false;
                            currentField = "UserLevelName";
                            inputPanel.visible = true;
                            textInformation.visible = true;
                            textInformation.placeholderText = qsTr("Enter UserName");
                            textInformation.inputMethodHints = Qt.ImhPreferLowercase;
                            textInformation.focus = true;
                            textUserName.color = "#ff0000";
                        })
                    }
                }
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
                activeFocusOnTab: false
                onFocusChanged: {
                    if (focus && currentField !== "PasswordLevelName") {
                        Qt.callLater(function() {
                            textPassword.focus = false
                            currentField = "PasswordLevelName"
                            inputPanel.visible = true
                            textInformation.visible = true
                            textInformation.placeholderText = qsTr("Enter Password")
                            textInformation.inputMethodHints = Qt.ImhPreferLowercase
                            textInformation.focus = true
                            textPassword.color = "#ff0000"
                        })
                    }
                }

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
                function hideKeyboard() {
                    currentField = ""
                    userEditing = false

                    // ตัด focus จากทุกตัว
                    textPassword.focus = false
                    textUserName.focus = false
                    textInformation.focus = false

                    // ปิด input method จริง ๆ
                    Qt.inputMethod.hide()

                    // ซ่อน panel
                    inputPanel.visible = false
                }
                onClicked: {
                    loginInProgress = true

                    var username = textUserName.text
                    var password = textPassword.text

                    var login = JSON.stringify({
                        objectName: "login",
                        username: username,
                        password: password
                    })

                    console.log("Login JSON:", login)
                    qmlCommand(login)

                    Qt.callLater(function() {
                        hideKeyboard()

                        if (userLevelGlobalVars.count > 0 &&
                            userLevelGlobalVars.get(0).userLevel > 0) {

                            // สำคัญ:
                            // ตั้งค่า object อื่น ๆ ก่อนเปลี่ยน currentPage
                            // เพราะ currentPage อาจทำให้บาง component reload/unload
                            safeSetMainBarIndex(-1)

                            if (typeof Eventspage !== "undefined")
                                safeSetVisible(Eventspage, "eventsalarms", false)

                            if (typeof DataStoragePage !== "undefined")
                                safeSetVisible(DataStoragePage, "dataStorage", true)

                            if (typeof SettingPage !== "undefined")
                                safeSetVisible(SettingPage, "imageSetting", true)

                            if (typeof LoginPage !== "undefined")
                                safeSetVisible(LoginPage, "imageUnlock", true)

                            currentPage = "MainPage"

                            console.log("Navigated to MainPage")
                        } else {
                            console.warn("Login failed or userLevel is invalid.",
                                         "count=", userLevelGlobalVars.count)
                        }

                        loginInProgress = false
                    })
                }
            }



            Button {
                text: "Log Out"
                Layout.fillWidth: true
                function hideKeyboard() {
                    currentField = ""
                    userEditing = false

                    // ตัด focus จากทุกตัว
                    textPassword.focus = false
                    textUserName.focus = false
                    textInformation.focus = false

                    // ปิด input method จริง ๆ
                    Qt.inputMethod.hide()

                    // ซ่อน panel
                    inputPanel.visible = false
                }
                onClicked: {
                    console.log("User logged out");

                    currentUserLevel = 3
                    currentPage = "MainPage"
                    mainBar.mainListView.currentIndex = -1

                    userLoggedOut()

                    hideKeyboard()   // ⭐ สำคัญมาก
                    textPassword.color = "#000000"

                    var logout = JSON.stringify({"objectName": "logout"});
                    var logoutDefaultUser = JSON.stringify({
                        objectName: "DefaultUserLevel",
                        usertype: "VIEWER",
                        loginby: "LOCKED\nBY VIEWER"
                    });

                    qmlCommand(logout)
                    qmlCommand(logoutDefaultUser)
                }
            }

        }

        // Text {
        //     text: "Current User Level: " + (userLevelGlobalVars.count > 0 ? userLevelGlobalVars.get(0).userLevel : "incorrect")
        //     color: "blue"
        //     font.pixelSize: 18
        // }
    }
    function safeSetVisible(obj, childName, visibleValue) {
        if (obj === undefined || obj === null) {
            console.warn("safeSetVisible skip: parent object is undefined:", childName)
            return false
        }

        if (obj[childName] === undefined || obj[childName] === null) {
            console.warn("safeSetVisible skip: child object is undefined:", childName)
            return false
        }

        obj[childName].visible = visibleValue
        return true
    }

    function safeSetMainBarIndex(indexValue) {
        if (typeof mainBar === "undefined" || mainBar === null) {
            console.warn("mainBar is undefined")
            return
        }

        if (mainBar.mainListView === undefined || mainBar.mainListView === null) {
            console.warn("mainBar.mainListView is undefined")
            return
        }

        mainBar.mainListView.currentIndex = indexValue
    }
}



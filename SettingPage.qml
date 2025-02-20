import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtWebSockets 1.0
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    visible: true
    width: 1024
    height: 600
    TabView {
        anchors.fill: parent
        anchors.bottomMargin: 0
        anchors.rightMargin: 8
        anchors.leftMargin: 8
        anchors.topMargin: 60
        Tab {
            title: "GENERAL"
            Rectangle { color: "#e7e6e6" }
            SettingGeneral {
                id: settingGeneral
                x: 0
                y: 0
                anchors.fill: parent
            }
        }
        Tab {
            title: "DISPLAY"
            Rectangle { color: "#e7e6e6" }
            SettingDisplay {
                id: settingDisplay
                x: 40
                y: 79
                anchors.fill: parent
            }

        }
        Tab {
            title: "PARAMETER"
            Rectangle { color: "#e7e6e6" }
            SettingParameter {
                id: settingParameter
                x: 40
                y: 92
                anchors.fill: parent
            }
        }
        Tab {
            title: "NETWORK"
            Rectangle { color: "#e7e6e6" }
            SettingNetwork {
                id: settingNetwork
                x: 40
                y: 92
                anchors.fill: parent
            }

        }
        style: TabViewStyle {
            tab: Rectangle {
                implicitWidth: 252
                implicitHeight: 65
                color: styleData.selected ? "white" : "#d3d3d3"
                border.color: "black"
                radius: 5
                Text {
                    text: styleData.title
                    anchors.centerIn: parent
//                    font.bold: true
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: styleData.selected ? "black" : "#555"
                }
            }
        }
    }




}




//import QtQuick 2.0
//import QtQuick.Controls 2.15
//import QtQuick.Layouts 1.15

//Item {
//    visible: true
//    width: 1024
//    height: 600

//        TabBar {
//            id: tabBar
//            x: 39
//            y: 90
//            width: 941
//            height: 55
//            Layout.preferredHeight: 60

//            TabButton {
//                width: 175
//                height: 60
//                text: qsTr("GENERAL")
//                font.pointSize: 9
//                onClicked: {
//                }
//            }

//            TabButton {
//                width: 175
//                height: 60
//                text: qsTr("DISPLAY")
//                font.pointSize: 9
//                onClicked: {
//                }
//            }

//            TabButton {
//                width: 175
//                height: 60
//                text: qsTr("PARAMETER")
//                font.pointSize: 9
//                onClicked: {
//                }
//            }

//            TabButton {
//                width: 175
//                height: 60
//                text: qsTr("NETWORK")
//                font.pointSize: 9
//                onClicked: {

//                }
//            }
//        }


//}



/*##^##
Designer {
    D{i:0;formeditorZoom:1.33}
}
##^##*/

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
import QtQuick.Controls.Styles 1.4

Item {
    visible: true
    width: 1024
    height: 600



    TabView {
        x: 0
        y: 65
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.topMargin: 62

        Tab {
            title: "EVENT & ALARM"
            height: 10
            width: 20
            Flickable {
                id: flickable
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                Rectangle {
                    id: viewsLogEvent
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
                        anchors.bottomMargin: 0
                        clip: true
                        model: eventAlarmLog
                        TableViewColumn { role: "datetEventandAlram"; title: "DATE"; width: 150;}
                        TableViewColumn { role: "timeEventandAlram"; title: "TIME"; width: 160 }
                        TableViewColumn { role: "logDetail"; title: "ALARM/EVENT"; width: 440 }
                        TableViewColumn { role: "statusEventandAlram"; title: "STATUS"; width: 300}
                    }
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                }
            }
        }
        Tab {
            title: "EVENT & ALARM \n HISTORY"
            Rectangle { color: "#e7e6e6" }
            Flickable {
                id: flickableHistory
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                Rectangle {
                    id: viewsLogEventHistory
                    color: "#e7e6e6"
                    border.color: "#ffffff"
                    anchors.fill: parent
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 0
                    anchors.topMargin: 0
                    TableView {
                        id: recordDatabaseHistory
                        anchors.fill: parent
                        anchors.rightMargin: 0
                        anchors.topMargin: 0
                        anchors.bottomMargin: 0
                        clip: true
                        model: eventAlarmHistoryLog
                        TableViewColumn { role: "datetEventandAlram"; title: "DATE"; width: 150;}
                        TableViewColumn { role: "timeEventandAlram"; title: "TIME"; width: 160 }
                        TableViewColumn { role: "logDetail"; title: "ALARM/EVENT"; width: 440 }
                        TableViewColumn { role: "statusEventandAlram"; title: "STATUS"; width: 300}
                    }
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                }
            }

        }
        style: TabViewStyle {
            tab: Rectangle {
                implicitWidth: 200
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
    Rectangle {
        id: rectangle
        x: 408
        y: 64
        width: 609
        height: 60
        color: "#e7e6e6"
        radius: 10
        border.width: 2
        Rectangle {
            id: filterCheck
            color: "#f2f2f2"
            radius: 5
            border.color: "#abaaaa"
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.topMargin: 16
            anchors.rightMargin: 562
            anchors.bottomMargin: 16
            property bool isActive: false

            MouseArea {
                anchors.fill: parent
                anchors.topMargin: 0
                anchors.rightMargin: 0
                onClicked: {
                    filterCheck.isActive = !filterCheck.isActive
                    filterCheck.color = filterCheck.isActive ? "#00FF00" : "#f2f2f2"
                    if (!filterCheck.isActive) {
                        fliterrelay.isActive = false
                        fliterrelay.color = "#f2f2f2"

                        fliterperiodics.isActive = false
                        fliterperiodics.color = "#f2f2f2"

                        flitermanual.isActive = false
                        flitermanual.color = "#f2f2f2"
                    }
                }
            }
        }

        Rectangle {
            id: fliterrelay
            color: fliterrelay.isActive ? "#00FF00" : "#f2f2f2"
            radius: 5
            border.color: "#abaaaa"
            anchors.fill: parent
            anchors.topMargin: 16
            anchors.rightMargin: 471
            anchors.bottomMargin: 16
            anchors.leftMargin: 107
            property bool isActive: false
            enabled: filterCheck.isActive
            MouseArea {
                anchors.fill: parent
                anchors.rightMargin: 0
                enabled: filterCheck.isActive
                onClicked: {
                    fliterrelay.isActive = !fliterrelay.isActive;
                    fliterrelay.color = fliterrelay.isActive ? "#00FF00" : "#f2f2f2";
                    fliterRelayStart(fliterrelay.isActive);
                }
            }
        }

        Rectangle {
            id: fliterperiodics
            color: fliterperiodics.isActive ? "#00FF00" : "#f2f2f2"
            radius: 5
            border.color: "#a6a6a6"
            anchors.fill: parent
            anchors.topMargin: 16
            anchors.rightMargin: 245
            anchors.bottomMargin: 16
            anchors.leftMargin: 333
            property bool isActive: false

            enabled: filterCheck.isActive

            MouseArea {
                anchors.fill: parent
                enabled: filterCheck.isActive
                onClicked: {
                    fliterperiodics.isActive = !fliterperiodics.isActive;
                    fliterperiodics.color = fliterperiodics.isActive ? "#00FF00" : "#f2f2f2";
                    fliterPeriodicStart(fliterperiodics.isActive);
                }
            }
        }

        Rectangle {
            id: flitermanual
            color: flitermanual.isActive ? "#00FF00" : "#f2f2f2"
            radius: 5
            border.color: "#a9a9a9"
            anchors.fill: parent
            anchors.topMargin: 16
            anchors.rightMargin: 116
            anchors.bottomMargin: 16
            anchors.leftMargin: 465
            property bool isActive: false

            enabled: filterCheck.isActive

            MouseArea {
                anchors.fill: parent
                enabled: filterCheck.isActive
                onClicked: {
                    flitermanual.isActive = !flitermanual.isActive;
                    flitermanual.color = flitermanual.isActive ? "#00FF00" : "#f2f2f2";
                    fliterManualStart(flitermanual.isActive);
                }
            }
        }

        Rectangle {
            id: flitersurageStart
            color: flitersurageStart.isActive ? "#00FF00" : "#f2f2f2"
            radius: 5
            border.color: "#a9a9a9"
            anchors.fill: parent
            anchors.topMargin: 16
            anchors.rightMargin: 361
            anchors.bottomMargin: 16
            anchors.leftMargin: 217
            property bool isActive: false

            enabled: filterCheck.isActive

            MouseArea {
                anchors.fill: parent
                enabled: filterCheck.isActive
                onClicked: {
                    flitersurageStart.isActive = !flitersurageStart.isActive;
                    flitersurageStart.color = flitersurageStart.isActive ? "#00FF00" : "#f2f2f2";
                    fliterSurageStart(flitersurageStart.isActive);
                }
            }
        }


        Image {
            id: image
            x: 53
            y: 12
            anchors.fill: parent
            source: "images/filter.png"
            anchors.leftMargin: 53
            anchors.topMargin: 12
            anchors.bottomMargin: 12
            anchors.rightMargin: 519
            fillMode: Image.PreserveAspectFit
        }

        RowLayout {
            anchors.fill: parent
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.topMargin: 0
            anchors.leftMargin: 144

            Text {
                id: text1
                text: qsTr("RELAY START")
                font.pixelSize: 11
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: false
            }

            Text {
                id: text4
                text: qsTr("SURAGE TEST")
                font.pixelSize: 11
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
            }

            Text {
                id: text2
                text: qsTr("PERIODIC START")
                font.pixelSize: 11
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: false
            }

            Text {
                id: text3
                text: qsTr("MANUAL TEST")
                font.pixelSize: 11
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
            }

        }

    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:2}D{i:38}
}
##^##*/


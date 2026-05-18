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
                        TableViewColumn { role: "datetEventandAlram"; title: "DATE"; width: 140;}
                        TableViewColumn { role: "timeEventandAlram"; title: "TIME"; width: 290 }
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
                        TableViewColumn { role: "datetEventandAlram"; title: "DATE"; width: 140;}
                        TableViewColumn { role: "timeEventandAlram"; title: "TIME"; width: 290 }
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


        RowLayout {
            anchors.fill: parent
            spacing: 0

            Item {
                id: filterCheckITem
                Layout.preferredWidth: 103
                Layout.fillHeight: true
                Layout.fillWidth: false
                Rectangle {
                    id: filterCheck
                    color: "#f2f2f2"
                    radius: 5
                    border.color: "#abaaaa"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    property bool isActive: false
                    width: 32
                    height: 32


                }

                Image {
                    id: image
                    width: 48
                    height: 48
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    source: "images/filter.png"
                    anchors.rightMargin: 8
                    sourceSize.height: 48
                    sourceSize.width: 48
                    fillMode: Image.PreserveAspectFit
                }
                MouseArea {
                    anchors.fill: parent
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

                            flitersurageStart.isActive = false
                            flitersurageStart.color = "#f2f2f2"
                        }

                        syncFilterStateToMain()
                        applyEventFilters()
                    }
                }
            }

            Item {
                id: fliterrelayITem
                Layout.preferredWidth: 120
                Layout.fillWidth: false
                Layout.fillHeight: true

                Rectangle {
                    id: fliterrelay
                    color: fliterrelay.isActive ? "#00FF00" : "#f2f2f2"
                    radius: 5
                    border.color: "#abaaaa"
                    anchors.verticalCenter: parent.verticalCenter
                    property bool isActive: false
                    width: 32
                    height: 32
                    enabled: filterCheck.isActive
                }
                Text {
                    id: rELAYSTART
                    x: 37
                    y: 7
                    text: qsTr("RELAY START")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.rightMargin: 8
                    Layout.fillWidth: false
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.rightMargin: 0
                    enabled: filterCheck.isActive
                    onClicked: {
                        fliterrelay.isActive = !fliterrelay.isActive
                        fliterrelay.color = fliterrelay.isActive ? "#00FF00" : "#f2f2f2"
                        syncFilterStateToMain()
                        applyEventFilters()
                    }
                }

            }

            Item {
                id: flitersurageStartITem
                Layout.preferredWidth: 120
                Layout.fillWidth: false
                Layout.fillHeight: true

                Rectangle {
                    id: flitersurageStart
                    color: flitersurageStart.isActive ? "#00FF00" : "#f2f2f2"
                    radius: 5
                    border.color: "#a9a9a9"
                    anchors.verticalCenter: parent.verticalCenter
                    property bool isActive: false
                    y: 0
                    width: 32
                    height: 32
                    enabled: filterCheck.isActive
                }


                Text {
                    id: sURAGETEST
                    x: 35
                    y: 6
                    text: qsTr("SURAGE TEST")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.rightMargin: 8
                    Layout.fillWidth: true
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: filterCheck.isActive
                    onClicked: {
                        flitersurageStart.isActive = !flitersurageStart.isActive
                        flitersurageStart.color = flitersurageStart.isActive ? "#00FF00" : "#f2f2f2"
                        syncFilterStateToMain()
                        applyEventFilters()
                    }
                }
            }

            Item {
                id: fliterperiodicsITem
                Layout.fillWidth: true
                Layout.fillHeight: true
                Rectangle {
                    id: fliterperiodics
                    color: fliterperiodics.isActive ? "#00FF00" : "#f2f2f2"
                    radius: 5
                    border.color: "#a6a6a6"
                    anchors.verticalCenter: parent.verticalCenter
                    property bool isActive: false
                    width: 32
                    height: 32

                    enabled: filterCheck.isActive


                }


                Text {
                    id: pERIODICSTART
                    x: 36
                    y: 8
                    text: qsTr("PERIODIC START")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.rightMargin: 8
                    Layout.fillWidth: false
                }


                MouseArea {
                    anchors.fill: parent
                    enabled: filterCheck.isActive
                    onClicked: {
                        fliterperiodics.isActive = !fliterperiodics.isActive
                        fliterperiodics.color = fliterperiodics.isActive ? "#00FF00" : "#f2f2f2"
                        syncFilterStateToMain()
                        applyEventFilters()
                    }
                }
            }

            Item {
                id: flitermanualITem
                Layout.fillWidth: true
                Layout.fillHeight: true
                Rectangle {
                    id: flitermanual
                    color: flitermanual.isActive ? "#00FF00" : "#f2f2f2"
                    radius: 5
                    border.color: "#a9a9a9"
                    anchors.verticalCenter: parent.verticalCenter
                    property bool isActive: false
                    width: 32
                    height: 32
                    enabled: filterCheck.isActive
                }
                Text {
                    id: mANUALTEST
                    x: 30
                    y: 7
                    width: 81
                    height: 14
                    text: qsTr("MANUAL TEST")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.rightMargin: 8
                    Layout.fillWidth: true
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: filterCheck.isActive
                    onClicked: {
                        flitermanual.isActive = !flitermanual.isActive
                        flitermanual.color = flitermanual.isActive ? "#00FF00" : "#f2f2f2"
                        syncFilterStateToMain()
                        applyEventFilters()
                    }
                }

            }
        }

    }
    function syncFilterStateToMain() {
        eventFilterEnabled = filterCheck.isActive
        eventFilterRelayActive = fliterrelay.isActive
        eventFilterPeriodicActive = fliterperiodics.isActive
        eventFilterManualActive = flitermanual.isActive
        eventFilterSurgeActive = flitersurageStart.isActive
    }
    Component.onCompleted: {
        syncFilterStateToMain()
        applyEventFilters()
    }

    Component.onDestruction: {
        console.log("[Eventspage] onDestruction -> clear view models only")
        clearEventPageModelsOnly()
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}D{i:37}D{i:25}
}
##^##*/

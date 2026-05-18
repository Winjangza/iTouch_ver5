import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.15

Item {
    id: rootSnmp
    width: 400
    height: 460   
    property int snmpUserLevel: userLevelGlobalVars.count > 0 ? userLevelGlobalVars.get(0).userLevel : 3
    property bool canEditSnmp: snmpUserLevel === 1 || snmpUserLevel === 2
    property bool isReadOnlyLevel: !canEditSnmp
    property bool selectPLCDoError      :plc_do_error
    property bool selectPLCDiError      :plc_di_error
    property bool selectPhaseAError     :internal_phase_A_error
    property bool selectPhaseBError     :internal_phase_B_error
    property bool selectPhaseCError     :internal_phase_C_error
    property bool selectModbusErrorA    :module_hi_speed_phase_A_error
    property bool selectModbusErrorB    :module_hi_speed_phase_B_error
    property bool selectModbusErrorC    :module_hi_speed_phase_C_error
    property bool selectGPSModule       :gps_module_fail
    property bool selectSystemInit      :system_initial
    property bool selectCommuError      :communication_error
    property bool selectRelayStart      :relay_start_event
    property bool selectSurageStart     :surage_start_event
    property bool selectPeriodicStart   :periodic_test_event
    property bool selectManualTest      :manual_test_event
    property bool selectLFLfail         :lfl_fail
    property bool selectLFLOperate      :lfl_operate
//    property bool isReadOnlyLevel: userLevelGlobalVars.count === 0 ||
//                                   userLevelGlobalVars.get(0).userLevel === 2 ||
//                                   userLevelGlobalVars.get(0).userLevel === 3
//    property bool isReadOnlyLevel: {
//        if (userLevelGlobalVars.count <= 0)
//            return true
//        const lvl = userLevelGlobalVars.get(0).userLevel
//        return lvl === 3
//    }
    function snmpBoxColor(isActive) {
        if (!canEditSnmp)
            return "#b7b7b7"
        return isActive ? "#00FF00" : "#ffffff"
    }

    function toggleSnmp(rectItem, keyName) {
        if (!canEditSnmp)
            return

        rectItem.isActive = !rectItem.isActive

        var payload = { "objectName": "SNMPenable" }
        payload[keyName] = rectItem.isActive

        var json = JSON.stringify(payload)
        qmlCommand(json)
        console.log("Current status SNMP:", json, "userLevel =", snmpUserLevel)
    }

    Rectangle {
        id: rectangle
        color: "#e7e6e6"
        border.color: "#ffffff"
        border.width: 2
        anchors.fill: parent
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.rightMargin: 0
        anchors.bottomMargin: 0

        Rectangle {
            id: rectangle1
            color: "#00ffffff"
            border.color: "#000000"
            anchors.fill: parent
            anchors.bottomMargin: 0
            anchors.rightMargin: 0
            anchors.topMargin: 40
            ScrollView {
                id: scrollView
                width: 400
                height: 452
                clip: true
                anchors.fill: parent
                anchors.rightMargin: 8
                anchors.topMargin: 8
                anchors.leftMargin: 8
                anchors.bottomMargin: 8
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AlwaysOn

                ColumnLayout {
                    anchors.fill: parent
                    anchors.bottomMargin: 263
                    anchors.rightMargin: -92
                    id: contentContainer

                    RowLayout {
                        Rectangle {
                            id: plcDoError
                            color: rootSnmp.snmpBoxColor(isActive)
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectPLCDoError

                            MouseArea {
                                anchors.fill: parent
                                enabled: rootSnmp.canEditSnmp
                                onClicked: rootSnmp.toggleSnmp(plcDoError, "plcDoError")
                            }
                        }

                        Text {
                            text: qsTr("PLC DO ERROR")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {
                        Rectangle {
                            id: plcDiError
                            color: rootSnmp.snmpBoxColor(isActive)
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectPLCDiError

                            MouseArea {
                                anchors.fill: parent
                                enabled: rootSnmp.canEditSnmp
                                onClicked: rootSnmp.toggleSnmp(plcDiError, "plcDiError")
                            }
                        }

                        Text {
                            text: qsTr("PLC DI ERROR")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {
                        Rectangle {
                            id: hispeedPhaseA
                            color: rootSnmp.snmpBoxColor(isActive)
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectModbusErrorA

                            MouseArea {
                                anchors.fill: parent
                                enabled: rootSnmp.canEditSnmp
                                onClicked: rootSnmp.toggleSnmp(hispeedPhaseA, "hispeedPhaseA")
                            }
                        }

                        Text {
                            text: qsTr("MODULE HI-SPEED PHASE A ERROR")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {
                        Rectangle {
                            id: hispeedPhaseB
                            color: rootSnmp.snmpBoxColor(isActive)
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectModbusErrorB

                            MouseArea {
                                anchors.fill: parent
                                enabled: rootSnmp.canEditSnmp
                                onClicked: rootSnmp.toggleSnmp(hispeedPhaseB, "hispeedPhaseB")
                            }
                        }

                        Text {
                            text: qsTr("MODULE HI-SPEED PHASE B ERROR")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {
                        Rectangle {
                            id: hispeedPhaseC
                            color: rootSnmp.snmpBoxColor(isActive)
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectModbusErrorC

                            MouseArea {
                                anchors.fill: parent
                                enabled: rootSnmp.canEditSnmp
                                onClicked: rootSnmp.toggleSnmp(hispeedPhaseC, "hispeedPhaseC")
                            }
                        }

                        Text {
                            text: qsTr("MODULE HI-SPEED PHASE C ERROR")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {
                        Rectangle {
                            id: commuPhaseA
                            color: rootSnmp.snmpBoxColor(isActive)
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectPhaseAError

                            MouseArea {
                                anchors.fill: parent
                                enabled: rootSnmp.canEditSnmp
                                onClicked: rootSnmp.toggleSnmp(commuPhaseA, "commuPhaseA")
                            }
                        }

                        Text {
                            text: qsTr("INTERNAL COMMUNICATION PHASE A ERROR")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {
                        Rectangle {
                            id: commuPhaseB
                            color: rootSnmp.snmpBoxColor(isActive)
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectPhaseBError

                            MouseArea {
                                anchors.fill: parent
                                enabled: rootSnmp.canEditSnmp
                                onClicked: rootSnmp.toggleSnmp(commuPhaseB, "commuPhaseB")
                            }
                        }

                        Text {
                            text: qsTr("INTERNAL COMMUNICATION PHASE B ERROR")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {
                        Rectangle {
                            id: commuPhaseC
                            color: rootSnmp.snmpBoxColor(isActive)
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectPhaseCError

                            MouseArea {
                                anchors.fill: parent
                                enabled: rootSnmp.canEditSnmp
                                onClicked: rootSnmp.toggleSnmp(commuPhaseC, "commuPhaseC")
                            }
                        }

                        Text {
                            text: qsTr("INTERNAL COMMUNICATION PHASE C ERROR")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {
                        Rectangle {
                            id: gpsModule
                            color: rootSnmp.snmpBoxColor(isActive)
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectGPSModule

                            MouseArea {
                                anchors.fill: parent
                                enabled: rootSnmp.canEditSnmp
                                onClicked: rootSnmp.toggleSnmp(gpsModule, "gpsModule")
                            }
                        }

                        Text {
                            text: qsTr("GPS MODULE FAIL")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {
                        Rectangle {
                            id: systemInti
                            color: rootSnmp.snmpBoxColor(isActive)
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectSystemInit

                            MouseArea {
                                anchors.fill: parent
                                enabled: rootSnmp.canEditSnmp
                                onClicked: rootSnmp.toggleSnmp(systemInti, "systemInti")
                            }
                        }

                        Text {
                            text: qsTr("SYSTEM INITIAL")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {
                        Rectangle {
                            id: commuError
                            color: rootSnmp.snmpBoxColor(isActive)
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectCommuError

                            MouseArea {
                                anchors.fill: parent
                                enabled: rootSnmp.canEditSnmp
                                onClicked: rootSnmp.toggleSnmp(commuError, "commuError")
                            }
                        }

                        Text {
                            text: qsTr("COMMUNICATION ERROR")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {
                        Rectangle {
                            id: relayStart
                            color: rootSnmp.snmpBoxColor(isActive)
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectRelayStart

                            MouseArea {
                                anchors.fill: parent
                                enabled: rootSnmp.canEditSnmp
                                onClicked: rootSnmp.toggleSnmp(relayStart, "relayStart")
                            }
                        }

                        Text {
                            text: qsTr("RELAY START EVENT")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {
                        Rectangle {
                            id: surageStart
                            color: rootSnmp.snmpBoxColor(isActive)
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectSurageStart

                            MouseArea {
                                anchors.fill: parent
                                enabled: rootSnmp.canEditSnmp
                                onClicked: rootSnmp.toggleSnmp(surageStart, "surageStart")
                            }
                        }

                        Text {
                            text: qsTr("SURGE START EVENT")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {
                        Rectangle {
                            id: preiodicStart
                            color: rootSnmp.snmpBoxColor(isActive)
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectPeriodicStart

                            MouseArea {
                                anchors.fill: parent
                                enabled: rootSnmp.canEditSnmp
                                onClicked: rootSnmp.toggleSnmp(preiodicStart, "preiodicStart")
                            }
                        }

                        Text {
                            text: qsTr("PERIODIC TEST EVENT")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {
                        Rectangle {
                            id: manualTest
                            color: rootSnmp.snmpBoxColor(isActive)
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectManualTest

                            MouseArea {
                                anchors.fill: parent
                                enabled: rootSnmp.canEditSnmp
                                onClicked: rootSnmp.toggleSnmp(manualTest, "manualTest")
                            }
                        }

                        Text {
                            text: qsTr("MANUAL TEST EVENT")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {
                        Rectangle {
                            id: lflfail
                            color: rootSnmp.snmpBoxColor(isActive)
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectLFLfail

                            MouseArea {
                                anchors.fill: parent
                                enabled: rootSnmp.canEditSnmp
                                onClicked: rootSnmp.toggleSnmp(lflfail, "lflfail")
                            }
                        }

                        Text {
                            text: qsTr("LFL FAIL")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {
                        Rectangle {
                            id: lfloperate
                            color: rootSnmp.snmpBoxColor(isActive)
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectLFLOperate

                            MouseArea {
                                anchors.fill: parent
                                enabled: rootSnmp.canEditSnmp
                                onClicked: rootSnmp.toggleSnmp(lfloperate, "lfloperate")
                            }
                        }

                        Text {
                            text: qsTr("LFL OPERATE")
                            font.pixelSize: 14
                        }
                    }
                }
            }

        }

        Text {
            id: text1
            x: 8
            y: 8
            text: qsTr("SNMP TRAPS ENABLING")
            font.pixelSize: 18
        }
    }

}



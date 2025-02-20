import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.15

Item {
    width: 400
    height: 460
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
                            color: isActive ? "#00FF00" : "#ffffff"
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectPLCDoError
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    plcDoError.isActive = !plcDoError.isActive;
                                    var SelectSNMP = '{"objectName":"SNMPenable", "plcDoError": ' + plcDoError.isActive + '}';
                                    qmlCommand(SelectSNMP);
                                    console.log("Current status SNMP: " + SelectSNMP, selectPLCDoError);
                                }
                            }
                        }

                        Text {
                            id: plcDo
                            text: qsTr("PLC DO ERROR")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {

                        Rectangle {
                            id: plcDiError
                            color: isActive ? "#00FF00" : "#ffffff"
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectPLCDiError  // ใช้ selectPhaseAError ให้เป็นค่าของ isActive
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    plcDiError.isActive = !plcDiError.isActive;
                                    var SelectSNMP = '{"objectName":"SNMPenable", "plcDiError": ' + plcDiError.isActive + '}';
                                    qmlCommand(SelectSNMP);
                                    console.log("Current status SNMP: " + SelectSNMP, selectPhaseAError);
                                }
                            }
                        }

                        Text {
                            id: plcDi
                            text: qsTr("PLC DI ERROR")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {

                        Rectangle {
                            id: hispeedPhaseA
                            color: isActive ? "#00FF00" : "#ffffff"
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectModbusErrorA
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    hispeedPhaseA.isActive = !hispeedPhaseA.isActive;
                                    var SelectSNMP = '{"objectName":"SNMPenable", "hispeedPhaseA": ' + hispeedPhaseA.isActive + '}';
                                    qmlCommand(SelectSNMP);
                                    console.log("Current status SNMP: " + SelectSNMP, selectModbusErrorA);
                                }
                            }
                        }

                        Text {
                            id: text3
                            text: qsTr("MODULE HI-SPEED PHASE A ERROR")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {

                        Rectangle {
                            id: hispeedPhaseB
                            color: isActive ? "#00FF00" : "#ffffff"
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectModbusErrorB
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    hispeedPhaseB.isActive = !hispeedPhaseB.isActive;
                                    var SelectSNMP = '{"objectName":"SNMPenable", "hispeedPhaseB": ' + hispeedPhaseB.isActive + '}';
                                    qmlCommand(SelectSNMP);
                                    console.log("Current status SNMP: " + SelectSNMP, selectModbusErrorB);
                                }
                            }
                        }

                        Text {
                            id: text4
                            text: qsTr("MODULE HI-SPEED PHASE B ERROR")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {

                        Rectangle {
                            id: hispeedPhaseC
                            color: isActive ? "#00FF00" : "#ffffff"
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectModbusErrorC
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    hispeedPhaseC.isActive = !hispeedPhaseC.isActive;
                                    var SelectSNMP = '{"objectName":"SNMPenable", "hispeedPhaseC": ' + hispeedPhaseC.isActive + '}';
                                    qmlCommand(SelectSNMP);
                                    console.log("Current status SNMP: " + SelectSNMP, selectModbusErrorC);
                                }
                            }
                        }

                        Text {
                            id: text5
                            text: qsTr("MODULE HI-SPEED PHASE C ERROR")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {

                        Rectangle {
                            id: commuPhaseA
                            color: isActive ? "#00FF00" : "#ffffff"
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectPhaseAError
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    commuPhaseA.isActive = !commuPhaseA.isActive;
                                    var SelectSNMP = '{"objectName":"SNMPenable", "commuPhaseA": ' + commuPhaseA.isActive + '}';
                                    qmlCommand(SelectSNMP);
                                    console.log("Current status SNMP: " + SelectSNMP, selectPhaseAError);
                                }
                            }
                        }

                        Text {
                            id: text15
                            text: qsTr("INTERNAL COMMUNICATION PHASE A ERROR")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {

                        Rectangle {
                            id: commuPhaseB
                            color: isActive ? "#00FF00" : "#ffffff"
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectPhaseBError
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    commuPhaseB.isActive = !commuPhaseB.isActive;
                                    var SelectSNMP = '{"objectName":"SNMPenable", "commuPhaseB": ' + commuPhaseB.isActive + '}';
                                    qmlCommand(SelectSNMP);
                                    console.log("Current status SNMP: " + SelectSNMP, selectPhaseBError);
                                }
                            }
                        }

                        Text {
                            id: text16
                            text: qsTr("INTERNAL COMMUNICATION PHASE B ERROR")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {

                        Rectangle {
                            id: commuPhaseC
                            color: isActive ? "#00FF00" : "#ffffff"
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectPhaseCError
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    commuPhaseC.isActive = !commuPhaseC.isActive;
                                    var SelectSNMP = '{"objectName":"SNMPenable", "commuPhaseC": ' + commuPhaseC.isActive + '}';
                                    qmlCommand(SelectSNMP);
                                    console.log("Current status SNMP: " + SelectSNMP, selectPhaseCError);
                                }
                            }
                        }

                        Text {
                            id: text17
                            text: qsTr("INTERNAL COMMUNICATION PHASE C ERROR")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {

                        Rectangle {
                            id: gpsModule
                            color: isActive ? "#00FF00" : "#ffffff"
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectGPSModule
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    gpsModule.isActive = !gpsModule.isActive;
                                    var SelectSNMP = '{"objectName":"SNMPenable", "gpsModule": ' + gpsModule.isActive + '}';
                                    qmlCommand(SelectSNMP);
                                    console.log("Current status SNMP: " + SelectSNMP, selectGPSModule);
                                }
                            }
                        }

                        Text {
                            id: text6
                            text: qsTr("GPS MODULE FAIL")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {

                        Rectangle {
                            id: systemInti
                            color: isActive ? "#00FF00" : "#ffffff"
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectSystemInit
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    systemInti.isActive = !systemInti.isActive;
                                    var SelectSNMP = '{"objectName":"SNMPenable", "systemInti": ' + systemInti.isActive + '}';
                                    qmlCommand(SelectSNMP);
                                    console.log("Current status SNMP: " + SelectSNMP, selectGPSModule);
                                }
                            }
                        }

                        Text {
                            id: text7
                            text: qsTr("SYSTEM INITIAL")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {

                        Rectangle {
                            id: commuError
                            color: isActive ? "#00FF00" : "#ffffff"
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectCommuError
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    commuError.isActive = !commuError.isActive;
                                    var SelectSNMP = '{"objectName":"SNMPenable", "commuError": ' + commuError.isActive + '}';
                                    qmlCommand(SelectSNMP);
                                    console.log("Current status SNMP: " + SelectSNMP, commuError);
                                }
                            }
                        }

                        Text {
                            id: text8
                            text: qsTr("COMMUNICATION ERROR")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {

                        Rectangle {
                            id: relayStart
                            color: isActive ? "#00FF00" : "#ffffff"
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectRelayStart
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    relayStart.isActive = !relayStart.isActive;
                                    var SelectSNMP = '{"objectName":"SNMPenable", "relayStart": ' + relayStart.isActive + '}';
                                    qmlCommand(SelectSNMP);
                                    console.log("Current status SNMP: " + SelectSNMP, relayStart);
                                }
                            }
                        }

                        Text {
                            id: text10
                            text: qsTr("RELAY START EVENT")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {

                        Rectangle {
                            id: surageStart
                            color: isActive ? "#00FF00" : "#ffffff"
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectSurageStart
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    surageStart.isActive = !surageStart.isActive;
                                    var SelectSNMP = '{"objectName":"SNMPenable", "surageStart": ' + surageStart.isActive + '}';
                                    qmlCommand(SelectSNMP);
                                    console.log("Current status SNMP: " + SelectSNMP, selectSurageStart);
                                }
                            }
                        }

                        Text {
                            id: text11
                            text: qsTr("SURGE START EVENT")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {

                        Rectangle {
                            id: preiodicStart
                            color: isActive ? "#00FF00" : "#ffffff"
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectPeriodicStart
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    preiodicStart.isActive = !preiodicStart.isActive;
                                    var SelectSNMP = '{"objectName":"SNMPenable", "preiodicStart": ' + preiodicStart.isActive + '}';
                                    qmlCommand(SelectSNMP);
                                    console.log("Current status SNMP: " + SelectSNMP, selectPeriodicStart);
                                }
                            }
                        }

                        Text {
                            id: text9
                            text: qsTr("PERIODIC TEST EVENT")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {

                        Rectangle {
                            id: manualTest
                            color: isActive ? "#00FF00" : "#ffffff"
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectManualTest
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    manualTest.isActive = !manualTest.isActive;
                                    var SelectSNMP = '{"objectName":"SNMPenable", "manualTest": ' + manualTest.isActive + '}';
                                    qmlCommand(SelectSNMP);
                                    console.log("Current status SNMP: " + SelectSNMP, selectManualTest);
                                }
                            }
                        }

                        Text {
                            id: text13
                            text: qsTr("MANUAL TEST EVENT")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {

                        Rectangle {
                            id: lflfail
                            color: isActive ? "#00FF00" : "#ffffff"
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectLFLfail
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    lflfail.isActive = !lflfail.isActive;
                                    var SelectSNMP = '{"objectName":"SNMPenable", "lflfail": ' + lflfail.isActive + '}';
                                    qmlCommand(SelectSNMP);
                                    console.log("Current status SNMP: " + SelectSNMP, selectLFLfail);
                                }
                            }
                        }

                        Text {
                            id: text14
                            text: qsTr("LFL FAIL")
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {

                        Rectangle {
                            id: lfloperate
                            color: isActive ? "#00FF00" : "#ffffff"
                            radius: 3
                            border.width: 1
                            Layout.preferredHeight: 35
                            Layout.preferredWidth: 35
                            property bool isActive: selectLFLOperate
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    lfloperate.isActive = !lfloperate.isActive;
                                    var SelectSNMP = '{"objectName":"SNMPenable", "lfloperate": ' + lfloperate.isActive + '}';
                                    qmlCommand(SelectSNMP);
                                    console.log("Current status SNMP: " + SelectSNMP, selectLFLOperate);
                                }
                            }
                        }

                        Text {
                            id: text12
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



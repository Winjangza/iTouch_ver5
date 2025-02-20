import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtWebSockets 1.0
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4

Item {
    width: 1024
    height: 600
    TabView {
        anchors.fill: parent
        anchors.bottomMargin: 0
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 59
        Tab{
            title: "PATTERN"
            Rectangle { color: "#e7e6e6" }
            DataStoragePagePattern {
                id: dataStoragePagePattern
                x: 141
                y: 107
                anchors.fill: parent
            }

        }
        Tab{
            title: "RELAY START"
            Rectangle { color: "#e7e6e6" }
            DataStoragePageRelayStart {
                id: dataStoragePageRelayStart
                x: 128
                y: 127
                anchors.fill: parent
            }
        }
        Tab{
            title: "SURGE START"
            Rectangle { color: "#e7e6e6" }

            DataStoragePageSurge {
                id: dataStoragePageSurge
                x: 452
                y: 259
                anchors.fill: parent

            }
        }
        Tab{
            title: "PERIODIC START"
            Rectangle { color: "#e7e6e6" }
            DataStoragePagePeriodic {
                id: dataStoragePagePeriodic
                x: 194
                y: 665
                anchors.fill: parent
            }
        }
    }


}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}
}
##^##*/

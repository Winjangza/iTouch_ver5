import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
//import QtWebSockets 1.0
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
Item {
width: 684
height: 475

    Rectangle {
        id: rectangle
        color: "#00e7e6e6"
        border.color: "#ffffff"
        border.width: 1
        anchors.fill: parent

        TabView {
            anchors.fill: parent
            Tab {
                title: "PHASE A"
                Rectangle { color: "#e7e6e6" }

                DataTaggingPhaseA {
                    id: dataTaggingPhaseA
                    anchors.fill: parent
                }

            }
            Tab {
                title: "PHASE B"
                Rectangle { color: "#e7e6e6" }
                DataTaggingPhaseB {
                    id: dataTaggingPhaseB
                }

            }
            Tab {
                title: "PHASE C"
                Rectangle { color: "#e7e6e6" }
                DataTaggingPhaseC {
                    id: dataTaggingPhaseC
                    anchors.fill: parent
                }

            }
        }
    }




}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.66}
}
##^##*/

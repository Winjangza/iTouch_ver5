import QtQuick 2.0
import QtQuick.Layouts 1.0

Item {
    width: 52
    height: 150
    Rectangle {
        id: ledstatusdata
        x: 0
        y: 0
        width: 52
        height: 150
        color: "#f2f2f2"


        Text {
            id: datastatus
            text: qsTr("DATA")
            anchors.fill: parent
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.rightMargin: 0
            anchors.bottomMargin: 131
        }

        ColumnLayout {
            x: 8
            y: 25

            LedStatus {
                id: ledStatus
                Layout.preferredHeight: 37
                Layout.preferredWidth: 36
            }

            LedStatus {
                id: ledStatus1
                Layout.preferredHeight: 37
                Layout.preferredWidth: 36

            }

            LedStatus {
                id: ledStatus2
            }
        }
    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:3}D{i:2}D{i:1}
}
##^##*/

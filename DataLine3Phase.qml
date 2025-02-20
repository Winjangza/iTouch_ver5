import QtQuick 2.0
import QtQuick.Layouts 1.0

Item {
    width: 52
    height: 150

    Rectangle {
        id: rectangle
        x: 0
        y: 0
        width: 52
        height: 150
        color: "#f2f2f2"

        Text {
            id: text1
            text: qsTr("DATA")
            anchors.fill: parent
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.bottomMargin: 131
        }
        Rectangle {
            id: rectangle1
            color: "#fd2d1d"
            anchors.fill: parent
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.bottomMargin: 109
            anchors.topMargin: 35
        }

        Rectangle {
            id: rectangle2
            color: "#fcff3b"
            anchors.fill: parent
            anchors.leftMargin: 0
            anchors.topMargin: 72
            anchors.bottomMargin: 72
            anchors.rightMargin: 0
        }

        Rectangle {
            id: rectangle3
            color: "#244d77"
            anchors.fill: parent
            anchors.leftMargin: 0
            anchors.topMargin: 113
            anchors.bottomMargin: 32
            anchors.rightMargin: 0
        }
    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:4}
}
##^##*/

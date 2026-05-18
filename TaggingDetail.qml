import QtQuick 2.0

Item {
    height: 50
    width: 150

    Rectangle {
        id: rectangle
        color: "#ffffff"
        radius: 5
        border.color: "#ff0000"
        border.width: 2
        anchors.fill: parent

        Text {
            id: text1
            text: qsTr("Text")
            anchors.fill: parent
            font.pixelSize: 16
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:8}D{i:2}D{i:1}
}
##^##*/

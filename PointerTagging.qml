import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    width: 60
    height: 60
    property int number: 0
    property bool dataReceived: false
    property real distance: globalDistanceA
    property real positionX: 50
    property real positionY: 50

    ToolButton {
        id: taggingpointer
        anchors.fill: parent
        visible: dataReceived
        contentItem: Image {
            width: 60
            height: 60
            source: "images/pinPointerTagging.png"
            fillMode: Image.PreserveAspectFit
            smooth: true
        }
        background: Rectangle {
            color: "#00000000"
            border.color: "#00000000"
        }
    }

    Text {
        id: numberText
        text: number.toString()
        font.pixelSize: 15
        color: "#000000"
        anchors.centerIn: parent
        z: 1
        visible: dataReceived
    }

}

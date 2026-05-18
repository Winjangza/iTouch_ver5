import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    id: root

    width: parent ? Math.min(parent.width, 1024) : 1024
    height: 200
    x: parent ? (parent.width - width) / 2 : 0
    y: parent ? (parent.height - height) / 2 : 200

    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    z: 9999

    property string popupMessage: "SAVE COMPLETE"

    function show(message) {
        popupMessage = message || "SAVE COMPLETE"
        open()
        autoCloseTimer.restart()
    }

    background: Rectangle {
        color: "#808080C0"
        radius: 10
        border.color: "white"
        border.width: 1
    }

    contentItem: Item {
        anchors.fill: parent

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
            onPressed: root.close()
        }

        Text {
            anchors.centerIn: parent
            text: root.popupMessage
            color: "white"
            font.pixelSize: 44
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Timer {
        id: autoCloseTimer
        interval: 3000   // 3 วินาที
        repeat: false
        running: false

        onTriggered: {
            root.close()
        }
    }

    onClosed: {
        autoCloseTimer.stop()
    }
}

import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    id:ledStatus
    width: 36
    height: 36
    property bool status: statusSystem
    Rectangle {
        id: rectangle
        x: 0
        y: 0
        width: 36
        height: 36
        color: status ? "#90cf59" : "#e2e2e2"
        radius: 20
        border.width: 2
    }
//status? 90cf59 e2e2e2
}

/*##^##
Designer {
    D{i:0;formeditorZoom:3}
}
##^##*/

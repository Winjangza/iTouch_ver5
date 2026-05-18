import QtQuick 2.0
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12

Item {
    width: 50
    height: 50
    property int number: 0
    property bool dataReceived: false
    property string phase: ""

    Rectangle {
        id: rectangle
        color: "#00000000"
        anchors.fill: parent
        visible: dataReceived && (
            (phase == "A" && !controlAndMonitor.isGraphClearedA) ||
            (phase == "B" && !controlAndMonitor.isGraphClearedB) ||
            (phase == "C" && !controlAndMonitor.isGraphClearedC)
        )

        Image {
            id: tagging
            width: 50
            height: 50
            anchors.right: parent.right
            anchors.top: parent.top
            source: phase == "A" ? "images/pinPointerTaggingA.png" :
                    phase == "B" ? "images/pinPointerTaggingB.png" :
                    "images/pinPointerTaggingC.png"
            anchors.topMargin: -50
            anchors.rightMargin: 25
            fillMode: Image.PreserveAspectFit
            smooth: true

            Rectangle {
                id: taggingInfo
                x: 40
                y: 0
                width: textTaggingDetail.implicitWidth + 20
                height: textTaggingDetail.implicitHeight + 10
                color: "#ffffff"
                radius: 5
                border.color: phase == "A" ? "#ff0000" :
                             phase == "B" ? "#fff424" :
                             "#0230fa"
                border.width: 2
                visible: (phase == "A" && controlAndMonitor.isCursorActiveA && controlAndMonitor.activeTaggingNumberA === number) ||
                         (phase == "B" && controlAndMonitor.isCursorActiveB && controlAndMonitor.activeTaggingNumberB === number) ||
                         (phase == "C" && controlAndMonitor.isCursorActiveC && controlAndMonitor.activeTaggingNumberC === number)

                Text {
                    id: textTaggingDetail
                    text: phase == "A" ? controlAndMonitor.activeTaggingDetailA :
                          phase == "B" ? controlAndMonitor.activeTaggingDetailB :
                          controlAndMonitor.activeTaggingDetailC
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.centerIn: parent
                    wrapMode: Text.WordWrap
                }

                Component.onCompleted: {
                    console.log(`🟢 Tagging Info for Phase: ${phase} | isVisible: ${taggingInfo.visible} | ActiveTaggingNumberA: ${activeTaggingNumberA} | Number: ${number}`);
                    controlAndMonitor.checkCursorProximity();
                }
            }

            Text {
                id: numberText
                x: 14
                y: 8
                anchors.fill: parent
                font.pixelSize: 15
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.horizontalCenterOffset: 14
                anchors.leftMargin: 14
                anchors.rightMargin: 16
                anchors.topMargin: 8
                anchors.bottomMargin: 26
                anchors.horizontalCenter: parent.horizontalCenter
                color: "black"
                text: number
                z: 1
                visible: dataReceived
            }
        }
    }
}

//import QtQuick 2.0
//import QtQuick.Controls 2.15
//import QtGraphicalEffects 1.12

//Item {
//    width: 50
//    height: 50
//    property int number: 0
//    property bool dataReceived: false
//    property string phase: ""

//    Rectangle {
//        id: rectangle
//        color: "#00000000"
//        anchors.fill: parent
//        visible: dataReceived && (
//            (phase == "A" && !controlAndMonitor.isGraphClearedA) ||
//            (phase == "B" && !controlAndMonitor.isGraphClearedB) ||
//            (phase == "C" && !controlAndMonitor.isGraphClearedC)
//        )

//        Image {
//            id: tagging
//            width: 50
//            height: 50
//            anchors.right: parent.right
//            anchors.top: parent.top
//            source: phase == "A" ? "images/pinPointerTaggingA.png" :
//                    phase == "B" ? "images/pinPointerTaggingB.png" :
//                    "images/pinPointerTaggingC.png"
//            anchors.topMargin: -50
//            anchors.rightMargin: 25
//            fillMode: Image.PreserveAspectFit
//            smooth: true

//            Rectangle {
//                id: taggingInfo
//                x: 40
//                y: 0
//                width: 120
//                height: 30
//                color: "#ffffff"
//                radius: 5
//                border.color: phase == "A" ? "#ff0000" :
//                             phase == "B" ? "#fff424" :
//                             "#0230fa"
//                border.width: 2

//                Text {
//                    id: textTaggingInfo
//                    text: qsTr("Text")
//                    anchors.fill: parent
//                    font.pixelSize: 12
//                    horizontalAlignment: Text.AlignHCenter
//                    verticalAlignment: Text.AlignVCenter
//                }
//            }

//            Text {
//                id: numberText
//                x: 14
//                y: 8
//                anchors.fill: parent
//                font.pixelSize: 15
//                horizontalAlignment: Text.AlignHCenter
//                verticalAlignment: Text.AlignVCenter
//                anchors.horizontalCenterOffset: 14
//                anchors.leftMargin: 14
//                anchors.rightMargin: 16
//                anchors.topMargin: 8
//                anchors.bottomMargin: 26
//                anchors.horizontalCenter: parent.horizontalCenter
//                color: "black"
//                text: number
//                z: 1
//                visible: dataReceived
//            }
//        }
//    }
//}


/*##^##
Designer {
    D{i:0;formeditorZoom:3}
}
##^##*/
//import QtQuick 2.0
//import QtQuick.Controls 2.15
//import QtGraphicalEffects 1.12
//Item {
//    width: 50
//    height: 50
//    property int number: 0
//    property bool dataReceived: true
//    //    property real distance: globalDistanceA
//    property string phase: ""

//    Rectangle {
//        id: rectangle
//        color: "#00000000"
//        anchors.fill: parent
//        visible: dataReceived
//        //        ToolButton {
//        //            id: taggingpointer
//        //            anchors.fill: parent
//        //            contentItem:
//        //                Rectangle {
//        //                color: "#00000000"
//        //                border.color: "#00000000"
//        Image {
//            id: tagging
//            width: 50
//            height: 50
//            anchors.right: parent.right
//            anchors.top: parent.top
//            source: phase == "A" ? "images/pinPointerTaggingA.png" : phase == "B" ? "images/pinPointerTaggingB.png" : "images/pinPointerTaggingC.png"
//            anchors.topMargin: -50
//            anchors.rightMargin: 25
//            fillMode: Image.PreserveAspectFit
//            smooth: true
//            Rectangle {
//                id: taggingInfo
//                x: 40
//                y: 0
//                width: 120
//                height: 30
//                color: "#ffffff"
//                radius: 5
//                border.color: phase == "A" ? "#ff0000" : phase == "B" ? "#fff424" : "#0230fa"
//                border.width: 2
//                Text {
//                    id: text1
//                    text: qsTr("Text")
//                    anchors.fill: parent
//                    font.pixelSize: 12
//                    horizontalAlignment: Text.AlignHCenter
//                    verticalAlignment: Text.AlignVCenter
//                }
//            }

//            Text {
//                id: numberText
//                x: 14
//                y: 8
//                anchors.fill: parent
//                font.pixelSize: 15
//                horizontalAlignment: Text.AlignHCenter
//                verticalAlignment: Text.AlignVCenter
//                anchors.horizontalCenterOffset: 14
//                anchors.leftMargin: 14
//                anchors.rightMargin: 16
//                anchors.topMargin: 8
//                anchors.bottomMargin: 26
//                anchors.horizontalCenter: parent.horizontalCenter
//                color: "black"
//                text: number
//                z: 1
//                visible: dataReceived
//            }

//        }
//    }
//}

///*##^##
//Designer {
//    D{i:0;formeditorZoom:6}D{i:3}D{i:2}D{i:1}
//}
//##^##*/

import QtQuick 2.0
import QtQuick.Layouts 1.0

Item {
    height: 50
    property var taggingID: -1
    property bool checked: false
    property var distance: 0
    property string detail: ""
    property int amplitude: 0
    property string phase: ""
    property int listIndex: -1
    property bool isSelected: selectedRowIndex === listIndex

    onCheckedChanged: {
        for (var i = 0; i < newlistdatatebleA.count; i++) {
            if (newlistdatatebleA.get(i).num_listA === listIndex) {
                newlistdatatebleA.setProperty(i, "list_statusA", checked);
                console.log("✅ Updated newlistdatatebleA_list_statusA:", i, taggingID, checked);
                break;
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: rectangle
            color: "#ffffff"
            Layout.fillHeight: true
            Layout.fillWidth: true
            Rectangle {
                id: colorBox
                width: 45
                height: 45
                border.width: 1
                radius: 5
                anchors.centerIn: parent
                color: checked ? "#90cf59" : "#ffffff"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        checked = !checked;
                        var selectTaggingPoint = '{"objectName":"selectTaggingPoint", "select":' + checked + ', "taggingPointID":' + taggingID + ', "Phase":"' + phase + '"}';
                        // console.log("checkBox:", checked, taggingID, selectTaggingPoint, distance);
                        qmlCommand(selectTaggingPoint);
                        taggingpointA(taggingID, distance);
                    }
                }
            }

        }

        // ✅ ข้อมูลของแถวที่เลือก (เปลี่ยนสีเมื่อถูกเลือก)
        Rectangle {
            id: rectangle1
            color: isSelected ? "#072ff7" : "#ffffff"
            Layout.fillHeight: true
            Layout.fillWidth: true
            Text {
                id: name1
                text: taggingID
                anchors.fill: parent
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }
        }

        Rectangle {
            id: rectangle2
            color: isSelected ? "#072ff7" : "#ffffff"
            Layout.fillHeight: true
            Layout.fillWidth: true
            Text {
                id: name2
                text: distance
                anchors.fill: parent
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }
        }

        Rectangle {
            id: rectangle3
            color: isSelected ? "#072ff7" : "#ffffff"
            Layout.fillHeight: true
            Layout.fillWidth: true
            Text {
                id: name3
                text: detail
                anchors.fill: parent
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        anchors.leftMargin: 155
        onClicked: {
            selectedRowIndex = (selectedRowIndex === listIndex) ? -1 : listIndex;
            console.log("📌 Selected Row:", selectedRowIndex);
        }
    }
}


//import QtQuick 2.0
//import QtQuick.Layouts 1.0
//Item {
//    height: 50
//    property var taggingID: -1
//    property bool checked: false
//    property var distance: 0
//    property string detail: ""
//    property int amplitude: 0
//    property string phase: ""
//    property int listIndex: -1

//    onCheckedChanged: {
//        for (var i = 0; i < newlistdatatebleA.count; i++) {
//            if (newlistdatatebleA.get(i).num_listA === listIndex) {
//                newlistdatatebleA.setProperty(i, "list_statusA", checked);
//                console.log("Updated newlistdatatebleA_list_statusA:", i, taggingID, checked);
//                break;
//            }
//        }
//    }

//    RowLayout {
//        anchors.fill: parent
//        spacing: 0

//        Rectangle {
//            id: rectangle
//            color: "#0737ed"
//            Layout.fillHeight: true
//            Layout.fillWidth: true

//            Rectangle {
//                id: colorBox
//                width: 45
//                height: 45
//                border.width: 1
//                radius: 5
//                anchors.centerIn: parent
//                color: checked ? "#90cf59" : "#ffffff"
//                MouseArea {
//                    anchors.fill: parent
//                    onClicked: {
//                        checked = !checked;
//                        var selectTaggingPoint = '{"objectName":"selectTaggingPoint", "select":' + checked + ', "taggingPointID":' + taggingID + ', "Phase":"' + phase + '"}';
//                        console.log("checkBox:", checked, taggingID, selectTaggingPoint, distance);
//                        qmlCommand(selectTaggingPoint);
//                        taggingpointA(taggingID, distance);
//                    }
//                }
//            }
//        }

//        Rectangle {
//            id: rectangle1
//            color: "#ffffff"
//            Layout.fillHeight: true
//            Layout.fillWidth: true
//            Text {
//                id: name1
//                text: taggingID
//                anchors.fill: parent
//                horizontalAlignment: Text.AlignLeft
//                verticalAlignment: Text.AlignVCenter
//            }
//        }

//        Rectangle {
//            id: rectangle2
//            color: "#ffffff"
//            Layout.fillHeight: true
//            Layout.fillWidth: true
//            Text {
//                id: name2
//                text: distance
//                anchors.fill: parent
//                horizontalAlignment: Text.AlignLeft
//                verticalAlignment: Text.AlignVCenter
//            }
//        }

//        Rectangle {
//            id: rectangle3
//            color: "#ffffff"
//            Layout.fillHeight: true
//            Layout.fillWidth: true
//            Text {
//                id: name3
//                text: detail
//                anchors.fill: parent
//                horizontalAlignment: Text.AlignLeft
//                verticalAlignment: Text.AlignVCenter
//            }
//        }
//    }
    
//    MouseArea {
//        id: mouseArea
//        anchors.fill: parent
//        onClicked: {
//            rectangle.color = "#072ff7"
//            rectangle1.color = "#072ff7"
//            rectangle2.color = "#072ff7"
//            rectangle3.color = "#072ff7"
//        }
//    }
//}
//Item {
//    height: 50
//    property var taggingID:-1
//    property bool checked:statusA
//    property var distance:distanceA
//    property string detail:""
//    property int ampiltude:0
//    property string phase:phaseA

//    onCheckedChanged: {
//        for (var i = 0; i < newlistdatatebleA.count ; i++)  {
//            if( newlistdatatebleA.get(i).list_numberA === taggingID){
//                newlistdatatebleA.setProperty(i, "list_numberA",taggingID)
//                console.log("newlistdatatebleA_list_statusA:",i,taggingID)

//                break
//            }
//        }
//    }

//    RowLayout {
//        anchors.fill: parent
//        spacing: 0

//        Rectangle {
//            id: rectangle
//            color: "#ffffff"
//            Layout.fillHeight: true
//            Layout.fillWidth: true

//            Rectangle {
//                id: colorBox
//                x: 305
//                y: 226
//                width: 45
//                height: 45
//                border.width: 1
//                radius: 5
//                anchors.verticalCenter: parent.verticalCenter
//                anchors.horizontalCenter: parent.horizontalCenter
//                color: checked ? "#90cf59":"#ffffff"
//                MouseArea {
//                    anchors.fill: parent
//                    onClicked: {
//                        checked = !checked
//                        var selectTaggingPoint = '{"objectName":"selectTaggingPoint", "select":'+checked+' , "taggingPointID":'+taggingID+', "Phase":"'+phase+'"}';
//                        console.log("checkBox:",checked,taggingID,selectTaggingPoint,distance)
//                        qmlCommand(selectTaggingPoint);
//                        taggingpointA(taggingID,distance)
//                    }
//                }
//            }
//        }

//        Rectangle {
//            id: rectangle1
//            color: "#ffffff"
//            Layout.fillHeight: true
//            Layout.fillWidth: true
//            Text {
//                id: name1
//                text: taggingID
//                anchors.fill: parent
//                horizontalAlignment: Text.AlignLeft
//                verticalAlignment: Text.AlignVCenter
//            }
//        }

//        Rectangle {
//            id: rectangle2
//            color: "#ffffff"
//            Layout.fillHeight: true
//            Layout.fillWidth: true
//            Text {
//                id: name2
//                text: distance
//                anchors.fill: parent
//                horizontalAlignment: Text.AlignLeft
//                verticalAlignment: Text.AlignVCenter
//            }
//        }

//        Rectangle {
//            id: rectangle3
//            color: "#ffffff"
//            Layout.fillHeight: true
//            Layout.fillWidth: true
//            Text {
//                id: name3
//                text: detail
//                anchors.fill: parent
//                horizontalAlignment: Text.AlignLeft
//                verticalAlignment: Text.AlignVCenter
//            }
//        }
//    }
//}

//

/*##^##
Designer {
    D{i:0;formeditorZoom:2}D{i:3}
}
##^##*/

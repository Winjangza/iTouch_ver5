import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtWebSockets 1.0
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.VirtualKeyboard 2.15
import QtQuick.VirtualKeyboard.Styles 2.15
import QtQuick.VirtualKeyboard.Settings 2.15
import QtQuick.Controls 2.13
Item {
    width: 530
    height: 460
    // property alias patternModel: patternListView.model

     signal rowSelected(string filename, string event_datetime)
    signal clearTableRequested()
    Rectangle {
        id: rectangle
        color: "#f2f2f2"
        border.color: "#ffffff"
        border.width: 2
        anchors.fill: parent
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.topMargin: 0
        anchors.bottomMargin: 0

        RowLayout {
            y: 8
            height: 35
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 8
            anchors.rightMargin: 8

            TextField {
                id: namesearch
                Layout.fillWidth: true
                placeholderText: qsTr("Name search")
            }

            ToolButton {
                id: toolButtonNameSearch
                Layout.preferredHeight: 32
                Layout.preferredWidth: 40
                contentItem: Image {
                    source: "images/search.png"
                    width: 24
                    height: 24
                    fillMode: Image.PreserveAspectFit
                }
                background: Rectangle {
                    color: "#E0E0E0"
                    radius: 8
                }
                onClicked: {
                    console.log("Searching for name:", namesearch.text);
                    var nameFile = namesearch.text.trim();

                    if (nameFile.length > 0) {
                        var NameSearch = JSON.stringify({
                                                            "objectName":"SearchName",
                                                            "categories":"Surge",
                                                            "text": nameFile
                                                        });

                        console.log("Sending JSON:", NameSearch);
                        qmlCommand(NameSearch);
                        clearDataSuage();
                    } else {
                        console.log("Empty search text! No request sent.");
                    }
                }
            }

            TextField {
                id: dataSearch
                Layout.fillWidth: true
                placeholderText: qsTr("Date search")
            }

            ToolButton {
                id: toolButtonDateSearch
                Layout.preferredHeight: 32
                Layout.preferredWidth: 40
                contentItem: Image {
                    source: "images/search.png"
                    width: 24
                    height: 24
                    fillMode: Image.PreserveAspectFit
                }
                background: Rectangle {
                    color: "#E0E0E0"
                    radius: 8
                }
                onClicked: {
                    console.log("Searching for data:", dataSearch.text);
                    var nameFile = dataSearch.text.trim();

                    if (nameFile.length > 0) {
                        var NameSearch = JSON.stringify({
                                                            "objectName":"SearchDate",
                                                            "categories":"Surge",
                                                            "text": nameFile
                                                        });

                        console.log("Sending JSON:", NameSearch);
                        qmlCommand(NameSearch);
                        clearDataSuage();
                    } else {
                        console.log("Empty search text! No request sent.");
                    }

                }
            }
        }
        Rectangle {
            id: rectangle1
            color: "#d9d9d9"
            border.color: "#ffffff"
            border.width: 2
            anchors.fill: parent
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.topMargin: 49

            ColumnLayout {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                anchors.topMargin: 8
                anchors.bottomMargin: 8

                RowLayout {
                    // anchors.left: parent.left/
                    // anchors.right: parent.right

                    ToolButton {
                        id: filenameButton
                        property bool isAscending: false
                        text: isAscending ? "▲ FILENAME" : "▼ FILENAME"
                        font.pixelSize: 18
                        Layout.leftMargin: 2
                        Layout.fillWidth: false
                        background: Rectangle { color: "transparent" }
                        onClicked: {
                            isAscending = !isAscending;
                            console.log("Sorting by FILENAME:", isAscending ? "Ascending" : "Descending");
                            // sortPatternData("filename", isAscending);
                            var getNameRelay = '{"objectName":"sortnamePattern", "Sort":'+isAscending+' , "categories":"Surge"}';
                            qmlCommand(getNameRelay);
                            clearDataSuage();
                        }
                    }

                    ToolButton {
                        id: eventDateButton
                        property bool isAscending: false
                        text: isAscending ? "▲ EVENT DATE" : "▼ EVENT DATE"
                        font.pixelSize: 18
                        Layout.leftMargin: 100
                        Layout.preferredWidth: -1
                        Layout.fillHeight: false
                        Layout.fillWidth: false
                        flat: true
                        highlighted: false
                        background: Rectangle { color: "transparent" }
                        onClicked: {
                            isAscending = !isAscending;
                            console.log("Sorting by EVENT DATE:", isAscending ? "Ascending" : "Descending");
                            // sortPatternData("event_datetime", isAscending);
                            var getDateSurge=  '{"objectName":"sortdatePattern", "Sort":'+isAscending+' , "categories":"Surge"}';
                            qmlCommand(getDateSurge);
                            clearDataSuage();
                        }
                    }
                }

                TableView {
                    id: recordDatabase
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: surgeDataStorage
                    headerVisible: false

                    TableViewColumn {
                        role: "filename"
                        width: 230

                    }

                    TableViewColumn {
                        role: "event_datetime"
                        width: 300
                    }

                    onClicked: {
                        var selectedFilename = surgeDataStorage.get(row).filename;
                        var selectedEventDatetime = surgeDataStorage.get(row).event_datetime;

                        console.log("Selected Row:", row,);
                        console.log("Filename:", surgeDataStorage.get(row).filename);
                        console.log("Event Date:", surgeDataStorage.get(row).event_datetime);
                        rowSelected(selectedFilename, selectedEventDatetime);

                    }
                }
            }
        }
    }
    function clearDataSuage() {
        surgeDataStorage.clear();
        console.log("Table cleared!");
    }
    onClearTableRequested: {
        clearDataSuage();
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.5}
}
##^##*/
// headerVisible: false

// PopupWarningPeriodic.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root

    // open/close
    property bool popupinterlockPeriodic: false

    // from message
    property string modeLocal: ""            // "MASTER" or "SLAVE"
    property string recordPeriodicRaw: ""    // remote time e.g. "8.45"
    property string localPeriodicRaw: ""     // local time e.g. "10.5"
    property int diffMin: 0                  // remote - local in minutes (e.g. -125)
    property int expectedDiffMin: 5
    signal accepted(string modeLocal, string recordPeriodicRaw, string localPeriodicRaw, int diffMin)
    // ---------- helpers ----------
    function pad2(n) { return (n < 10 ? "0" : "") + n; }

    // "8.45" -> {h:8, m:45} ; "10.5" -> {h:10, m:50}
    function parseTimeDot(str) {
        var s = (str || "").trim();
        if (s.length === 0) return null;

        var parts = s.split(".");
        var h = parseInt(parts[0], 10);
        if (isNaN(h)) return null;

        var m = 0;
        if (parts.length > 1) {
            var mmStr = parts[1];
            if (mmStr.length === 1) mmStr = mmStr + "0"; // 8.5 -> 8:50
            m = parseInt(mmStr, 10);
            if (isNaN(m)) m = 0;
        }

        if (h < 0) h = 0;
        if (h > 23) h = 23;
        if (m < 0) m = 0;
        if (m > 59) m = 59;

        return { h: h, m: m };
    }

    function to12hLabel(h24, m) {
        var ampm = (h24 >= 12) ? "PM" : "AM";
        var h12 = h24 % 12;
        if (h12 === 0) h12 = 12;
        return h12 + ":" + pad2(m) + " " + ampm;
    }

    function addMinutes(h24, m, deltaMin) {
        var total = h24 * 60 + m + deltaMin;
        total = ((total % 1440) + 1440) % 1440;
        return { h: Math.floor(total / 60), m: total % 60 };
    }

    function diffTextFromMinutes(mins) {
        var absMin = Math.abs(mins);
        var sign = (mins < 0) ? "-" : "+";
        var h = Math.floor(absMin / 60);
        var m = absMin % 60;
        if (h > 0) return sign + h + "h " + m + "m";
        return sign + m + "m";
    }

    function whoIsRemote() {
        if (modeLocal === "MASTER") return "SLAVE";
        if (modeLocal === "SLAVE")  return "MASTER";
        return "REMOTE";
    }

    // ---------- build message ----------
    function buildMessage() {
        var remoteT = parseTimeDot(recordPeriodicRaw);
        var localT  = parseTimeDot(localPeriodicRaw);

        if (!remoteT) {
            return "⚠️ Invalid remote periodic time: \"" + recordPeriodicRaw + "\"";
        }
        if (!localT) {
            return "⚠️ Invalid local periodic time: \"" + localPeriodicRaw + "\"";
        }

        var localRole = (modeLocal || "").toUpperCase();
        var remoteRole = whoIsRemote();

        var remoteLabel = to12hLabel(remoteT.h, remoteT.m);
        var localLabel  = to12hLabel(localT.h, localT.m);

        // Requirement:
        // MASTER should be 5 minutes earlier than SLAVE
        // If local is MASTER -> recommended MASTER = remote(SLAVE) - 5
        // If local is SLAVE  -> recommended SLAVE  = remote(MASTER) + 5
        var recommended = null;
        var recommendedLabel = "(unknown)";

        if (localRole === "MASTER") {
            recommended = addMinutes(remoteT.h, remoteT.m, -5);
            recommendedLabel = to12hLabel(recommended.h, recommended.m);
        } else if (localRole === "SLAVE") {
            recommended = addMinutes(remoteT.h, remoteT.m, +5);
            recommendedLabel = to12hLabel(recommended.h, recommended.m);
        }

        // diffMin = remote - local
        var d = Number(diffMin);
        var diffText = diffTextFromMinutes(d);
        var diffLine = "Current difference (remote - local): " + diffText
                     + " (" + (isFinite(d) ? d : "unknown") + " minutes).";

        var header = "⚠️ Role: " + (localRole || "UNKNOWN") + "\n";
        var line1  = "Remote (" + remoteRole + ") periodic time: " + remoteLabel
                   + "  [raw: " + recordPeriodicRaw + "]\n";
        var line2  = "Local (" + (localRole || "UNKNOWN") + ") periodic time: " + localLabel
                   + "  [raw: " + localPeriodicRaw + "]\n";
        var line3  = diffLine + "\n\n";

        if (localRole === "MASTER") {
            return header
                 + line1
                 + line2
                 + line3
                 + "Recommendation:\n"
                 + "Set MASTER to " + recommendedLabel + " (5 minutes earlier than SLAVE).\n"
                 + "Press OK to confirm.";
        } else if (localRole === "SLAVE") {
            return header
                 + line1
                 + line2
                 + line3
                 + "Recommendation:\n"
                 + "Set SLAVE to " + recommendedLabel + " (5 minutes later than MASTER).\n"
                 + "Press OK to confirm.";
        } else {
            return header + line1 + line2 + line3;
        }
    }
    Popup {
        id: warningPopup
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 460
        height: 250
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        visible: root.popupinterlockPeriodic

        background: Rectangle {
            color: "#ff3333"
            border.color: "#990000"
            border.width: 2
            radius: 10

            Rectangle {
                width: parent.width
                height: 10
                color: "#990000"
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
            }
        }

        contentItem: ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 10

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    text: "⚠️"
                    font.pixelSize: 26
                    color: "#ffffff"
                }

                Text {
                    text: root.buildMessage()
                    font.pixelSize: 13
                    font.bold: true
                    color: "#ffffff"
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                }
            }

            Button {
                text: "OK"
                Layout.preferredWidth: 90
                Layout.preferredHeight: 34
                Layout.alignment: Qt.AlignHCenter

                background: Rectangle {
                    color: parent.pressed ? "#990000" : "#ffffff"
                    radius: 6
                }

                contentItem: Text {
                    text: parent.text
                    color: parent.pressed ? "#ffffff" : "#ff3333"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    root.accepted(root.modeLocal, root.recordPeriodicRaw, root.localPeriodicRaw, root.diffMin)
                    root.popupinterlockPeriodic = false
                    warningPopup.close()
                }
            }
        }
    }
}

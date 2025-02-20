/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Charts module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0

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
            text: qsTr("PATTERN")
            anchors.fill: parent
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.bottomMargin: 131
        }
        Rectangle {
            id: rectangle1
            color: "#f7cbac"
            anchors.fill: parent
            anchors.rightMargin: 0
            anchors.bottomMargin: 109
            anchors.leftMargin: 0
            anchors.topMargin: 35
        }

        Rectangle {
            id: rectangle2
            color: "#bc9121"
            anchors.fill: parent
            anchors.leftMargin: 0
            anchors.topMargin: 76
            anchors.bottomMargin: 68
            anchors.rightMargin: 0
        }

        Rectangle {
            id: rectangle3
            color: "#bed6ed"
            anchors.fill: parent
            anchors.leftMargin: 0
            anchors.topMargin: 119
            anchors.rightMargin: 0
            anchors.bottomMargin: 25
        }
    }



}

/*##^##
Designer {
    D{i:0;formeditorZoom:4}
}
##^##*/

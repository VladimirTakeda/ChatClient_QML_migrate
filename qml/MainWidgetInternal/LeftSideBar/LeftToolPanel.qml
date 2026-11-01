import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ChatClient_QML 1.0
import StyleModule 1.0

Rectangle{
    id: leftToolPanel_id
    color: Style.leftSidePanel_color

    signal profileRequested()

    Rectangle {
        id: avatar_id
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 16
        width: 44
        height: 44
        radius: width / 2
        color: Style.baseFilled_color

        Text {
            anchors.centerIn: parent
            text: {
                var n = chatClientObj.currentUserName
                return n && n.length > 0 ? n.charAt(0).toUpperCase() : "?"
            }
            color: "white"
            font.pixelSize: 18
            font.weight: Font.DemiBold
        }

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: avatarArea_id.containsMouse ? "#20FFFFFF" : "transparent"
        }

        MouseArea {
            id: avatarArea_id
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: leftToolPanel_id.profileRequested()
        }
    }
}

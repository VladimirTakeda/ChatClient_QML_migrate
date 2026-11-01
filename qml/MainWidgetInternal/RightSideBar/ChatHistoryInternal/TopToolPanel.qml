import QtQuick

import ChatClient_QML 1.0
import StyleModule 1.0

Rectangle{
    id: topPanel_id
    width: parent.width
    height: 54
    color: Style.base_color
    border.color: Style.border_color
    border.width: 1

    // Mirror the C++ side's current chat name into a local property. We update
    // it explicitly via Connections — relying on the Q_PROPERTY NOTIFY alone
    // is fragile if AUTOMOC regen hasn't fully caught up.
    property string chatName: chatClientObj.currentChatName
    readonly property bool hasChat: chatName.length > 0

    Connections {
        target: chatClientObj
        function onCurrentChatNameChanged() {
            topPanel_id.chatName = chatClientObj.currentChatName
        }
    }

    Rectangle {
        id: avatar_id
        width: 36
        height: 36
        anchors.left: parent.left
        anchors.leftMargin: 14
        anchors.verticalCenter: parent.verticalCenter
        radius: width / 2
        color: Style.baseFilled_color
        visible: topPanel_id.hasChat

        // Letter fallback so the avatar is identifiable even if user_blank.png
        // doesn't resolve (helps isolate "avatar hidden" vs "image missing").
        Text {
            anchors.centerIn: parent
            text: topPanel_id.chatName.length > 0
                  ? topPanel_id.chatName.charAt(0).toUpperCase()
                  : "?"
            color: "white"
            font.pixelSize: 16
            font.weight: Font.DemiBold
        }

        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "qrc:/ChatClient/ChatClient_QML/icons/user_blank.png"
            // If the png resolves, it overlays the letter. If not, the letter
            // stays visible — either way the circle isn't blank.
        }
    }

    Text {
        id: name_id
        anchors.left: avatar_id.right
        anchors.leftMargin: 12
        anchors.right: parent.right
        anchors.rightMargin: 14
        anchors.bottom: parent.verticalCenter
        anchors.bottomMargin: -2
        text: topPanel_id.chatName
        color: "black"
        font.pixelSize: 14
        font.weight: Font.DemiBold
        elide: Text.ElideRight
        visible: topPanel_id.hasChat
    }

    Text {
        id: status_id
        anchors.left: avatar_id.right
        anchors.leftMargin: 12
        anchors.right: parent.right
        anchors.rightMargin: 14
        anchors.top: parent.verticalCenter
        anchors.topMargin: 2
        text: qsTr("offline")
        color: Style.row_text_secondary
        font.pixelSize: 12
        visible: topPanel_id.hasChat
    }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle{
    id: delegat_id
    height: 45
    width: ListView.view.width
    // color: "transparent"
    color: parent.isCurrentItem ? "cadetblue" : "transparent"
    border.color: "black"

    MouseArea{
        id: mouseCursor_id
        anchors.fill: parent
        hoverEnabled: true
        // onEntered: { delegat_id.color = "lightcoral" }
        // onExited: { delegat_id.color = "transparent" }
        onClicked: {
            listViewContacts_id.currentIndex = index;
            chatClientObj.updateCurrentChat(index)
        }
    }

    Rectangle{
        readonly property real iconMargins: 10
        id: icon_id
        width: 45 - iconMargins
        height: parent.height - iconMargins
        anchors.verticalCenter: delegat_id.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 5
        // color: "transparent"
        radius: width / 2
        border.width: 1
        border.color: "darkred"

        Image {
            anchors.fill: parent
            visible: true
            source: "qrc:/ChatClient/ChatClient_QML/icons/blank.jpg"
        }
    }

    ColumnLayout{
        anchors.fill: parent
        RowLayout{
            Layout.alignment: Qt.AlignTop
            Text{
                text: model.chatName
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: icon_id.width + 10
            }
            Text{
                text: model.lastMessageTime
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: 10
            }
        }

        RowLayout{
            Layout.alignment: Qt.AlignBottom
            Text{
                id: lastText_id
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: icon_id.width + 10
                Layout.bottomMargin: 10
                wrapMode: Text.WordWrap
                maximumLineCount: 1
                text: model.lastMessage
            }
            Rectangle{
                id: missMassages_id
                readonly property int sizeMissMessage: 20
                width: sizeMissMessage
                height: sizeMissMessage
                radius: width / 2
                Layout.alignment: Qt.AlignRight
                Layout.bottomMargin: 5
                Layout.rightMargin: 10
                Text{
                    anchors {
                        fill: parent
                        centerIn: parent
                        bottomMargin: 1 // to center text within the inner circle
                    }
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: model.missedMessageCount
                }
            }
        }
    }
}



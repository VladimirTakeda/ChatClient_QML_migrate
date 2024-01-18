import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle{
    readonly property real leftRightInnerMargin: 10
    id: delegat_id
    height: 62
    width: ListView.view.width
    // color: "transparent"
    color: ListView.isCurrentItem ? "cadetblue" : "transparent"
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
        id: icon_id
        width: 45
        height: 45
        anchors.verticalCenter: delegat_id.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: delegat_id.leftRightInnerMargin
        radius: width / 2
        border.width: 1
        border.color: "darkred"
        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            visible: true
            source: "qrc:/ChatClient/ChatClient_QML/icons/user_blank.png"
        }
    }

    ColumnLayout{
        id: dataDelegat_id
        anchors.fill: parent
        readonly property real marginInner: 14
        RowLayout{
            Layout.alignment: Qt.AlignTop
            Text{
                id: userInfo_id
                text: model.chatName
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: dataDelegat_id.marginInner
                Layout.leftMargin: icon_id.width + delegat_id.leftRightInnerMargin + 12
            }
            Text{
                id: timeMessage_id
                text: model.lastMessageTime
                Layout.alignment: Qt.AlignRight
                Layout.topMargin: dataDelegat_id.marginInner
                Layout.rightMargin: delegat_id.leftRightInnerMargin
            }
        }

        RowLayout{
            Layout.alignment: Qt.AlignBottom
            Text{
                id: lastText_id
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignBottom
                Layout.bottomMargin: dataDelegat_id.marginInner
                Layout.leftMargin: icon_id.width + delegat_id.leftRightInnerMargin + 12
                wrapMode: Text.WordWrap
                maximumLineCount: 1
                text: model.lastMessage
            }
            Rectangle{
                id: missMassages_id
                readonly property int sizeMissMessage: 19
                width: sizeMissMessage
                height: sizeMissMessage
                radius: width / 2
                Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                Layout.rightMargin: delegat_id.leftRightInnerMargin
                Layout.bottomMargin: 12
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



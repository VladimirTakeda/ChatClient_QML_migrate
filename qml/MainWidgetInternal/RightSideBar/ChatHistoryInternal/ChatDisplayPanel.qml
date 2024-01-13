import QtQuick
import QtQuick.Controls


ListView{
    id: listViewDisplayPanel_id
    spacing: 4
    model: chatHistoryModel

    delegate: Rectangle{
        readonly property real rlSideMargins: 5
        anchors {
            right: model.isMyMessage ? listViewDisplayPanel_id.contentItem.right : undefined
            left: model.isMyMessage ? undefined : listViewDisplayPanel_id.contentItem.left
            rightMargin: model.isMyMessage ? rlSideMargins : undefined
            leftMargin: model.isMyMessage ? undefined : rlSideMargins
        }


        width: Math.min(messageText_id.implicitWidth + 24,
                        listViewDisplayPanel_id.width - 100)
        height: messageText_id.implicitHeight + 24
        radius: 10

        Label{
            id: messageText_id
            text: model.message
            color: "black"
            anchors.fill: parent
            anchors.margins: 12
            wrapMode: Label.Wrap
        }
    }

    //TODO: add custom ScrollBar as telegram
    // ScrollBar.vertical: ScrollBar { }
}


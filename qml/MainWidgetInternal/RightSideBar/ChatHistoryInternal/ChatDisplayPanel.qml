import QtQuick
import QtQuick.Controls.Basic

Item {
    property alias __listViewDisplayPanel: listViewDisplayPanel_id
    id: root_id
    ListView{
        id: listViewDisplayPanel_id
        anchors.fill: parent
        spacing: 4
        model: chatHistoryModel
        interactive: true
        verticalLayoutDirection: ListView.TopToBottom
        contentHeight: contentItem.childrenRect.height
        clip : true
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

        Connections {
            target: chatHistoryModel
            function onScrollToBottom() {
                listViewDisplayPanel_id.positionViewAtEnd()
            }
        }

        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.StopAtBounds
    }

    //TODO: add custom ScrollBar as telegram
    // ScrollBar.vertical: ScrollBar { }

}

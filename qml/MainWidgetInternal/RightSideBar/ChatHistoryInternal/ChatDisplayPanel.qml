import QtQuick
import QtQuick.Controls.Basic

Item {
    property alias __listViewDisplayPanel: listViewDisplayPanel_id
    id: root_id

    ListView {
        id: listViewDisplayPanel_id
        anchors.fill: parent
        clip: true
        spacing: 4
        model: chatHistoryModel
        interactive: true
        verticalLayoutDirection: ListView.TopToBottom
        delegate: Rectangle {
            readonly property real rlSideMargins: 5
            readonly property real maxWidth: listViewDisplayPanel_id.width - 100
            anchors {
                right: model.isMyMessage ? listViewDisplayPanel_id.contentItem.right : undefined
                left: model.isMyMessage ? undefined : listViewDisplayPanel_id.contentItem.left
                rightMargin: model.isMyMessage ? rlSideMargins : undefined
                leftMargin: model.isMyMessage ? undefined : rlSideMargins
            }
            radius: 10

            width: Math.min(column.implicitWidth, maxWidth)
            height: column.implicitHeight

            Column {
                id: column
                spacing: 5

                Loader {
                    active: model.attachments && model.attachments.length > 0
                    sourceComponent: Image {
                        id: testImage_id
                        width: 400
                        height: sourceSize.width
                                > 0 ? width * (sourceSize.height / sourceSize.width) : width
                        fillMode: Image.PreserveAspectFit
                        source: chatHistoryModel.imagesPath + model.attachments[0]
                        mipmap: true
                    }
                }

                Label {
                    id: messageText_id
                    text: model.message
                    color: "black"
                    leftPadding: 12
                    anchors.margins: 12
                    wrapMode: Label.Wrap
                }
            }
        }

        //TODO: fix reset missing messages ⬇
        Connections {
            target: chatHistoryModel
            function onScrollToBottom() {
                listViewDisplayPanel_id.positionViewAtEnd()
            }
        }

        onHeightChanged: listViewDisplayPanel_id.positionViewAtEnd()
        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.StopAtBounds
    }

    //TODO: add custom ScrollBar as telegram
    // ScrollBar.vertical: ScrollBar { }
}

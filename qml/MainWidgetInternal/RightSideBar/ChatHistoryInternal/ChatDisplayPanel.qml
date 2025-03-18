import QtQuick
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects

Item {
    property alias __listViewDisplayPanel: listViewDisplayPanel_id
    id: root_id

    Component {
        id: messageDelegate
        Rectangle {
            id: messageBubble_id
            property bool isMyMessage: model.isMyMessage
            property bool hasImage: model.attachments?.length > 0
            property int maxLineWidth: 300

            width: {
                if (hasImage && !messageText_id.visible) {
                    return image_id.width
                } else if (!hasImage && messageText_id.visible) {
                    // Increased padding for text-only messages
                    var textWidth = Math.min(maxLineWidth + 32,
                                             // Increased from 24 to 32
                                             messageText_id.implicitWidth + 32)
                    return Math.min(textWidth,
                                    listViewDisplayPanel_id.width * 0.75)
                } else {
                    var contentWidth = Math.max(
                                image_id.width, Math.min(
                                    maxLineWidth + 16,
                                    // Reduced from 24 to 16 for mixed content
                                    messageText_id.implicitWidth + 16))
                    return Math.min(contentWidth,
                                    listViewDisplayPanel_id.width * 0.75)
                }
            }
            // Adjust height based on content type
            height: contentColumn.implicitHeight
                    + (hasImage
                       && messageText_id.visible ? 8 : // Reduced from 12 to 8 for mixed content
                                                !hasImage
                                                && messageText_id.visible ? 16 : 0) // Increased padding for text-only

            x: isMyMessage ? listViewDisplayPanel_id.width - width - 8 : 8

            radius: hasImage && !messageText_id.visible ? 8 : 12
            color: isMyMessage ? "#DCF8C6" : "#FFFFFF"
            layer.enabled: true
            layer.effect: DropShadow {
                radius: 8
                samples: 16
                color: "#20000000"
            }

            Column {
                id: contentColumn
                anchors {
                    left: parent.left
                    right: parent.right
                    top: hasImage ? parent.top : undefined
                    verticalCenter: !hasImage
                                    && messageText_id.visible ? parent.verticalCenter : undefined
                }
                spacing: messageText_id.visible && hasImage ? 8 : 0

                Image {
                    id: image_id
                    width: {
                        if (!hasImage)
                            return 0

                        let aspectRatio = sourceSize.width / sourceSize.height

                        if (aspectRatio >= 1) {
                            return Math.min(400, sourceSize.width)
                        } else {
                            return Math.min(300 * aspectRatio, sourceSize.width)
                        }
                    }
                    height: {
                        if (!hasImage)
                            return 0

                        let aspectRatio = sourceSize.width / sourceSize.height

                        if (aspectRatio >= 1) {
                            return width / aspectRatio
                        } else {
                            return Math.min(300, sourceSize.height)
                        }
                    }
                    visible: hasImage
                    fillMode: Image.PreserveAspectFit
                    source: hasImage ? Qt.resolvedUrl(
                                           chatHistoryModel.imagesPath + model.attachments[0]) : ""
                    asynchronous: true
                    cache: true

                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Rectangle {
                            width: image_id.width
                            height: image_id.height
                            radius: 8
                        }
                    }
                }

                TextEdit {
                    id: messageText_id
                    width: parent.width - (hasImage ? 16 : 32)
                    anchors {
                        left: parent.left
                        right: parent.right
                        leftMargin: hasImage ? 8 : 16
                        rightMargin: hasImage ? 8 : 16
                    }
                    height: visible ? implicitHeight : 0
                    verticalAlignment: TextEdit.AlignVCenter
                    horizontalAlignment: TextEdit.AlignLeft
                    text: model.message || ""
                    wrapMode: TextEdit.Wrap
                    readOnly: true
                    selectByMouse: false
                    color: "#000000"
                    font.pixelSize: 14
                    visible: text !== ""
                }
            }
        }
    }

    ListView {
        id: listViewDisplayPanel_id
        anchors.fill: parent
        clip: true
        spacing: 12
        model: chatHistoryModel
        delegate: messageDelegate

        ScrollBar.vertical: ScrollBar {
            active: pressed || listViewDisplayPanel_id.moving
            opacity: active ? 1:0
            policy: ScrollBar.AsNeeded
            width: 8
            background: Rectangle {
                color: "#E0E0E0"
            }
        }

        Connections {
            target: chatHistoryModel
            function onScrollToBottom() {
                listViewDisplayPanel_id.positionViewAtEnd()
            }
        }
    }
}

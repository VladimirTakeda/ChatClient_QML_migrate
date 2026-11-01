import QtQuick
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects

import StyleModule 1.0

Item {
    property alias __listViewDisplayPanel: listViewDisplayPanel_id
    id: root_id

    readonly property string _chatFontFamily: {
        switch (Qt.platform.os) {
        case "osx": return "SF Pro Text"
        case "windows": return "Segoe UI"
        default: return ""
        }
    }
    readonly property int _textPixelSize: 15
    readonly property int _metaPixelSize: 12
    readonly property int _horizPad: 12
    readonly property int _vertPad: 7
    readonly property int _bubbleRadius: 12
    readonly property int _bubbleMarginX: 10

    Component {
        id: messageDelegate

        Item {
            id: delegateRoot
            width: listViewDisplayPanel_id.width
            height: bubble_id.height

            readonly property bool isMyMessage: model.isMyMessage
            readonly property bool hasImage: (model.attachments ? model.attachments.length : 0) > 0
            readonly property bool hasText: (model.message || "").length > 0
            readonly property int maxBubbleWidth: Math.min(540, Math.round(listViewDisplayPanel_id.width * 0.68))

            // Hidden measurement: natural (unwrapped) text width.
            // Used to decide inline-vs-wrapped meta without a layout cycle.
            Text {
                id: textMeasure_id
                visible: false
                text: delegateRoot.hasText ? model.message : ""
                font.family: root_id._chatFontFamily
                font.pixelSize: root_id._textPixelSize
            }

            // Width required to render text + meta on a single line (inline meta).
            readonly property int inlineWidth:
                textMeasure_id.implicitWidth + metaRow_id.implicitWidth
                + root_id._horizPad * 2 + 10

            // When even the single-line layout exceeds the bubble cap, the text
            // must wrap and the meta drops below it (bottom-right of the bubble).
            readonly property bool wrapNeeded:
                delegateRoot.hasText && inlineWidth > delegateRoot.maxBubbleWidth

            Rectangle {
                id: bubble_id
                color: delegateRoot.isMyMessage ? Style.bubble_out_color : Style.bubble_in_color
                radius: root_id._bubbleRadius
                x: delegateRoot.isMyMessage
                   ? (delegateRoot.width - width - root_id._bubbleMarginX)
                   : root_id._bubbleMarginX

                width: {
                    if (delegateRoot.hasImage && !delegateRoot.hasText) {
                        return image_id.width
                    }
                    if (delegateRoot.hasText) {
                        var textPart = delegateRoot.wrapNeeded
                            ? delegateRoot.maxBubbleWidth
                            : delegateRoot.inlineWidth
                        if (delegateRoot.hasImage) {
                            return Math.max(image_id.width, textPart)
                        }
                        return textPart
                    }
                    return 0
                }

                height: {
                    var h = 0
                    if (delegateRoot.hasImage) h += image_id.height
                    if (delegateRoot.hasText) {
                        h += root_id._vertPad * 2 + messageText_id.implicitHeight
                        if (delegateRoot.wrapNeeded) {
                            h += metaRow_id.implicitHeight + 2
                        }
                    }
                    return h
                }

                Image {
                    id: image_id
                    visible: delegateRoot.hasImage
                    anchors.top: parent.top
                    anchors.left: parent.left
                    width: {
                        if (!delegateRoot.hasImage) return 0
                        var ar = sourceSize.width / sourceSize.height
                        return ar >= 1
                            ? Math.min(400, sourceSize.width)
                            : Math.min(300 * ar, sourceSize.width)
                    }
                    height: {
                        if (!delegateRoot.hasImage) return 0
                        var ar = sourceSize.width / sourceSize.height
                        return ar >= 1
                            ? width / ar
                            : Math.min(300, sourceSize.height)
                    }
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    cache: true
                    source: delegateRoot.hasImage
                        ? Qt.resolvedUrl(chatHistoryModel.imagesPath + model.attachments[0])
                        : ""

                    layer.enabled: delegateRoot.hasImage
                    layer.effect: OpacityMask {
                        maskSource: Rectangle {
                            width: image_id.width
                            height: image_id.height
                            // Round only the top corners when text follows below;
                            // round all four for image-only bubbles.
                            radius: delegateRoot.hasText ? 0 : root_id._bubbleRadius
                        }
                    }
                }

                TextEdit {
                    id: messageText_id
                    visible: delegateRoot.hasText
                    anchors.left: parent.left
                    anchors.leftMargin: root_id._horizPad
                    anchors.right: parent.right
                    // On the inline path, reserve enough space on the right for the
                    // meta row so text and meta share the last line without overlap.
                    anchors.rightMargin: delegateRoot.wrapNeeded
                        ? root_id._horizPad
                        : (metaRow_id.implicitWidth + root_id._horizPad + 6)
                    anchors.top: image_id.visible ? image_id.bottom : parent.top
                    anchors.topMargin: root_id._vertPad

                    text: model.message || ""
                    wrapMode: TextEdit.Wrap
                    readOnly: true
                    selectByMouse: true
                    color: "#000000"
                    font.family: root_id._chatFontFamily
                    font.pixelSize: root_id._textPixelSize
                    textFormat: TextEdit.PlainText
                }

                // Meta backdrop — only drawn on image-only bubbles so the
                // white time stays legible on any image.
                Rectangle {
                    visible: delegateRoot.hasImage && !delegateRoot.hasText
                    anchors.right: parent.right
                    anchors.rightMargin: 6
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 6
                    width: metaRow_id.implicitWidth + 10
                    height: metaRow_id.implicitHeight + 4
                    radius: height / 2
                    color: "#60000000"
                }

                Row {
                    id: metaRow_id
                    spacing: 3
                    anchors.right: parent.right
                    anchors.rightMargin: (delegateRoot.hasImage && !delegateRoot.hasText)
                        ? 11
                        : root_id._horizPad
                    anchors.bottom: delegateRoot.wrapNeeded || (delegateRoot.hasImage && !delegateRoot.hasText)
                        ? parent.bottom
                        : messageText_id.bottom
                    anchors.bottomMargin: {
                        if (delegateRoot.hasImage && !delegateRoot.hasText) return 8
                        if (delegateRoot.wrapNeeded) return root_id._vertPad
                        return 1
                    }

                    Text {
                        text: model.messageTime || ""
                        color: (delegateRoot.hasImage && !delegateRoot.hasText)
                            ? "#FFFFFF"
                            : (delegateRoot.isMyMessage
                               ? Style.bubble_meta_out_color
                               : Style.bubble_meta_in_color)
                        font.family: root_id._chatFontFamily
                        font.pixelSize: root_id._metaPixelSize
                    }
                    Text {
                        visible: delegateRoot.isMyMessage
                        text: "✓"
                        color: (delegateRoot.hasImage && !delegateRoot.hasText)
                            ? "#FFFFFF"
                            : Style.bubble_meta_out_color
                        font.family: root_id._chatFontFamily
                        font.pixelSize: root_id._metaPixelSize
                        font.bold: true
                    }
                }
            }
        }
    }

    ListView {
        id: listViewDisplayPanel_id
        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        clip: true
        spacing: 3
        model: chatHistoryModel
        delegate: messageDelegate

        ScrollBar.vertical: ScrollBar {
            active: pressed || listViewDisplayPanel_id.moving
            opacity: active ? 1 : 0
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

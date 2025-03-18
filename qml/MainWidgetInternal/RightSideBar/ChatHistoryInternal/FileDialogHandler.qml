import QtCore
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Dialogs

import StyleModule 1.0

Rectangle{
    id: fileDialogHandler_id
    color: "transparent"
    readonly property int iconSize: 22

    Button {
        id: paperClipIcon_id
        anchors.centerIn: parent
        icon.source: "qrc:/ChatClient/ChatClient_QML/icons/paper_clip.svg"
        icon.width: fileDialogHandler_id.iconSize
        icon.height: fileDialogHandler_id.iconSize
        icon.color: "#999999"
        background: Item {  }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: paperClipIcon_id.icon.color = Qt.darker("#9B9B9B", 1.2)
            onExited: paperClipIcon_id.icon.color = "#999999"
            onClicked: {
                console.log("Empty")
            }
        }
    }

    FileDialog {
        id: folderDialog_id
        nameFilters: [ "Image files (*.png *.jpg)", "All files (*)" ]
        currentFolder: StandardPaths.standardLocations(StandardPaths.DesktopLocation)[0]
        onAccepted: {
            console.log("url of the file: ", folderDialog_id.selectedFile)
            contentImage_id.source = folderDialog_id.selectedFile
            dialog_id.open()
            messageBox_id.forceActiveFocus()
        }
        onRejected: { console.log("Rejected") }
    }

    Popup {
        id: dialog_id
        width: 365
        height: 490
        anchors.centerIn: Overlay.overlay
        modal: true
        background: Rectangle{
            radius: 7
        }
        closePolicy: Popup.CloseOnEscape

        Item {
            readonly property int _constLeftRightMargins: 20
            id: internalData_id
            anchors.fill: parent
            Row {
                id: topElements_id
                height: title_id.contentHeight
                spacing: parent.width - (title_id.contentWidth + internalData_id._constLeftRightMargins * 2)
                anchors {
                    left: internalData_id.left
                    leftMargin: internalData_id._constLeftRightMargins
                    right: internalData_id.right
                    rightMargin: internalData_id._constLeftRightMargins
                }

                Label{
                    id: title_id
                    text: "Send an image"
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    renderType: Text.NativeRendering
                }

                Button {
                    id: verticalDotsIcon_id
                    icon.source: "qrc:/ChatClient/ChatClient_QML/icons/three-dots-vertical2.svg"
                    icon.width: 0
                    icon.height: title_id.height
                    icon.color: "#999999"
                    background: Item {  }
                    display: AbstractButton.IconOnly
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: verticalDotsIcon_id.icon.color = Qt.darker("#9B9B9B", 1.2)
                        onExited: verticalDotsIcon_id.icon.color = "#999999"
                        onClicked: {
                            console.log("Empty")
                        }
                    }
                }
            }

            Rectangle {
                id: selectedImage_id
                height: 245
                width: parent.width
                anchors{
                    top: topElements_id.bottom
                    topMargin: 24
                    left: internalData_id.left
                    leftMargin: internalData_id._constLeftRightMargins
                    right: internalData_id.right
                    rightMargin: internalData_id._constLeftRightMargins

                }
                color: "#f1f1f1"
                Image {
                    id: contentImage_id
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    visible: true
                }
            }

            Label {
                id: indicatorHint_id
                anchors{
                    top: selectedImage_id.bottom
                    topMargin: 10
                    left: internalData_id.left
                    leftMargin: internalData_id._constLeftRightMargins
                    right: internalData_id.right
                    rightMargin: internalData_id._constLeftRightMargins
                }
                text: "Left-click on the photo to edit."
                font.pointSize: 10
                color: "#999999"
                renderTypeQuality: Text.HighRenderTypeQuality
                renderType: Text.NativeRendering
            }

            Item{
                id: rootCompress_id
                anchors{
                    top: indicatorHint_id.bottom
                    topMargin: 15
                    left: internalData_id.left
                    leftMargin: internalData_id._constLeftRightMargins
                    right: internalData_id.right
                    rightMargin: internalData_id._constLeftRightMargins
                }
                CheckBox {
                    id: compress_id
                    width: 22
                    height: 22
                    text: "Compress the image"
                    checked: true
                    indicator: Rectangle {
                        anchors.fill: parent
                        radius: 3
                        color: Style.baseFilled_color

                        Image {
                            anchors {
                                fill: parent
                                centerIn: parent
                                topMargin: 2
                            }

                            sourceSize.width: 1920
                            sourceSize.height: 1080
                            source: "qrc:/ChatClient/ChatClient_QML/icons/check_white.svg"
                            fillMode: Image.PreserveAspectFit
                            visible: compress_id.checked ? true : false
                        }
                    }
                    contentItem: Text {
                        height: compress_id.height
                        leftPadding: compress_id.width + 8
                        text: compress_id.text
                        font.pointSize: 12
                        color: "black"
                        verticalAlignment: Text.AlignVCenter
                        renderType: Text.NativeRendering
                    }
                }
            }

            Label {
                id: caption_id
                anchors{
                    top: rootCompress_id.bottom
                    topMargin: 35
                    left: internalData_id.left
                    leftMargin: internalData_id._constLeftRightMargins
                    right: internalData_id.right
                    rightMargin: internalData_id._constLeftRightMargins
                }
                text: "Caption"
                font.pointSize: 10
                color: Style.baseFilled_color
                font.weight: Font.DemiBold
                renderTypeQuality: Text.HighRenderTypeQuality
                renderType: Text.NativeRendering
            }

            Row {
                id: rootMessageBox_id
                spacing: 5
                anchors{
                    top: caption_id.bottom
                    topMargin: 4
                    left: internalData_id.left
                    leftMargin: internalData_id._constLeftRightMargins
                    right: internalData_id.right
                    rightMargin: internalData_id._constLeftRightMargins
                }
                TextInput {
                    id: messageBox_id
                    width: internalData_id.width - (smileIcon_id.width + rootMessageBox_id.spacing + internalData_id._constLeftRightMargins * 2.1)
                    verticalAlignment: Text.AlignVCenter
                    color: "black"
                    wrapMode: TextInput.Wrap
                    focus: true
                    font.pointSize: 12
                }

                Button {
                    id: smileIcon_id
                    icon.source: "qrc:/ChatClient/ChatClient_QML/icons/smileButton.png"
                    icon.width: fileDialogHandler_id.iconSize
                    icon.height: fileDialogHandler_id.iconSize
                    icon.color: "#999999"
                    background: Item {  }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: smileIcon_id.icon.color = Qt.darker("#9B9B9B", 1.2)
                        onExited: smileIcon_id.icon.color = "#999999"
                        onClicked: {
                            console.log("Empty")
                        }
                    }
                }

                // Image {
                //     id: smileIcon_id
                //     height: 20
                //     width: 20
                //     sourceSize.width: 512
                //     sourceSize.height: 512
                //     autoTransform: true
                //     fillMode: Image.PreserveAspectFit
                //     source: "qrc:/ChatClient/ChatClient_QML/icons/smileButton.png"
                // }
            }

            Rectangle {
                id: line_id
                anchors{
                    top: rootMessageBox_id.bottom
                    topMargin: 0
                    left: internalData_id.left
                    leftMargin: internalData_id._constLeftRightMargins
                    right: internalData_id.right
                    rightMargin: internalData_id._constLeftRightMargins
                }
                height: 2
                color: Style.baseFilled_color
            }

            Rectangle {
                id: listButtons_id
                height: 34
                color: "transparent"
                anchors{
                    top: line_id.bottom
                    topMargin: 8
                    left: internalData_id.left
                    right: internalData_id.right
                }
                Button {
                    id: add_id
                    anchors.left: parent.left
                    text: "Add"
                    contentItem: Text {
                        text: add_id.text
                        font.pointSize: 12
                        opacity: enabled ? 1.0 : 0.3
                        color: Style.baseFilled_color
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.weight: Font.DemiBold
                        renderTypeQuality: Text.HighRenderTypeQuality
                        renderType: Text.NativeRendering
                    }
                    background: Rectangle {
                        implicitWidth: 57; implicitHeight: 30
                        opacity: enabled ? 1 : 0.3
                        color: add_id.hovered ? "#e3f1fa" : "transparent"
                        radius: 4
                    }
                    onClicked: {
                        folderDialog_id.open()
                        messageBox_id.forceActiveFocus()
                    }
                }
                Button {
                    id: cancel_id
                    anchors {
                        right: send_id.left
                        rightMargin: 7
                    }

                    text: "Cancel"
                    contentItem: Text {
                        text: cancel_id.text
                        font.pointSize: 12
                        opacity: enabled ? 1.0 : 0.3
                        color: Style.baseFilled_color
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.weight: Font.DemiBold
                        renderTypeQuality: Text.HighRenderTypeQuality
                        renderType: Text.NativeRendering
                    }
                    background: Rectangle {
                        implicitWidth: 75; implicitHeight: 30
                        opacity: enabled ? 1 : 0.3
                        color: cancel_id.hovered ? "#e3f1fa" : "transparent"
                        radius: 4
                    }
                    onClicked: {
                        dialog_id.close()
                    }
                }
                Button {
                    id: send_id
                    anchors.right: parent.right
                    text: "Send"

                    onClicked: {
                        chatClientObj.sendImage(folderDialog_id.selectedFile, messageBox_id.text)
                        dialog_id.close()
                    }
                    contentItem: Text {
                        text: send_id.text
                        font.pointSize: 12
                        opacity: enabled ? 1.0 : 0.3
                        color: Style.baseFilled_color
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.weight: Font.DemiBold
                        renderTypeQuality: Text.HighRenderTypeQuality
                        renderType: Text.NativeRendering
                    }
                    background: Rectangle {
                        implicitWidth: 64; implicitHeight: 30
                        opacity: enabled ? 1 : 0.3
                        color: send_id.hovered ? "#e3f1fa" : "transparent"
                        radius: 4
                    }
                }
            }
        }
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {
            folderDialog_id.open()
        }
    }
}

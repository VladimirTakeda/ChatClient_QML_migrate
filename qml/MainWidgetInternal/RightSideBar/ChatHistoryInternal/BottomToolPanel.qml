import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Dialogs

import ChatClient_QML 1.0
import StyleModule 1.0


Rectangle{
    property alias __staticBox: staticBox_id
    readonly property real iconsSize: 22
    readonly property int constHeightSize: 45
    id: bottomPanel_id
    implicitWidth: parent.width
    implicitHeight: bottomPanel_id.constHeightSize - messageField_id.sizeInputText + messageField_id.contentHeight
    color: Style.base_color

    Rectangle{
        property alias __rowLayoutBottomToolPanel_id: rowLayoutBottomToolPanel_id
        id: staticBox_id
        width: parent.width
        height: bottomPanel_id.constHeightSize
        anchors.bottom: parent.bottom
        color: Style.base_color

        RowLayout{
            property alias __inputContainer: inputContainer_id
            id: rowLayoutBottomToolPanel_id
            width: parent.width
            anchors.centerIn: parent

            FileDialogHandler{
                id: paperClip_id
                Layout.preferredWidth: bottomPanel_id.iconsSize
                Layout.preferredHeight: bottomPanel_id.iconsSize
                Layout.leftMargin: 14
            }

            Item {
                property alias __messageBox: messageField_id
                id: inputContainer_id
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: 12
                Layout.rightMargin: 10
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                TextInput{
                    readonly property int sizeInputText: 16
                    id: messageField_id
                    anchors.fill: parent
                    focus: true

                    verticalAlignment: Text.AlignVCenter
                    color: "black"

                    wrapMode: TextInput.Wrap
                    Text {
                        id: customPlaceholder_id
                        anchors{
                            fill: parent
                            left: messageField_id.left
                            leftMargin: 2
                        }
                        verticalAlignment: Text.AlignVCenter
                        text: "Write a message..."
                        color: messageField_id.cursorVisible ? Style.placeholderLight_color : Style.placeholderDark_color
                        visible: !messageField_id.text.length
                    }

                    Keys.onPressed:(event)=>{
                                       if ((event.key === Qt.Key_Enter || event.key === Qt.Key_Return) &&
                                           messageField_id.length) {
                                           chatClientObj.sendNewMessage(messageField_id.text)
                                           messageField_id.clear()
                                       }
                                   }
                }
            }

            Rectangle{
                id: smiles_id
                Layout.preferredWidth: bottomPanel_id.iconsSize
                Layout.preferredHeight: bottomPanel_id.iconsSize
                Layout.rightMargin: 14
                color: "transparent"
                Image {
                    anchors.fill: parent
                    sourceSize.width: 1920
                    sourceSize.height: 1080
                    autoTransform: true
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/ChatClient/ChatClient_QML/icons/smileButton.png"
                }
            }

            Rectangle{
                id: sendMessage_id
                Layout.preferredWidth: bottomPanel_id.iconsSize
                Layout.preferredHeight: bottomPanel_id.iconsSize
                Layout.rightMargin: 14
                color: "transparent"
                Image {
                    anchors.fill: parent
                    sourceSize.width: 800
                    sourceSize.height: 600
                    rotation: 45
                    source: "qrc:/ChatClient/ChatClient_QML/icons/sendMessage.png"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            chatClientObj.sendNewMessage(messageField_id.text)
                            messageField_id.clear()
                        }
                    }
                }
            }
        }
    }
}

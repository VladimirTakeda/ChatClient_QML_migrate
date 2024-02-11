import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import ChatClient_QML 1.0
import StyleModule 1.0

Rectangle{
    property alias __rowLayoutBottomToolPanel_id: rowLayoutBottomToolPanel_id
    readonly property real iconsSize: 22
    readonly property int constHeightSize: 45
    id: bottomPanel_id
    implicitWidth: parent.width
    implicitHeight: constHeightSize
    color: Style.base_color

    Rectangle{
        id: dynamicBox_id
        width: parent.width
        height: constHeightSize
        anchors.bottom: parent.bottom
        color: Style.base_color
    }

    RowLayout{
        property alias __inputConteiner: inputContainer_id
        id: rowLayoutBottomToolPanel_id
        width: parent.width
        anchors.centerIn: parent

        Rectangle{
            id: paperClip_id
            Layout.preferredWidth: bottomPanel_id.iconsSize
            Layout.preferredHeight: bottomPanel_id.iconsSize
            Layout.leftMargin: 14
            color: "transparent"

            Image {
                anchors.fill: parent
                autoTransform: true
                fillMode: Image.PreserveAspectFit
                source: "qrc:/ChatClient/ChatClient_QML/icons/paper_clip.svg"
            }
        }

        Rectangle {
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
                focus: false

                verticalAlignment: Text.AlignVCenter
                color: "black"

                wrapMode: TextInput.Wrap

                onTextChanged: {
                    dynamicBox_id.height = bottomPanel_id.constHeightSize - sizeInputText + messageField_id.contentHeight
                    console.log("dynamicBox_id.height = ", dynamicBox_id.height)
                    console.log("messageBox.height = ", sizeInputText)
                }

                Text {
                    id: customPlaceholder_id
                    anchors{
                        fill: parent
                        left: messageField_id.left
                        leftMargin: 2
                    }
                    verticalAlignment: Text.AlignVCenter
                    text: "Compose message..."
                    color: messageField_id.cursorVisible ? Style.placeholderLight_color : Style.placeholderDark_color
                    visible: !messageField_id.text.length
                }
                Keys.onPressed:(event)=>{
                                   if ((event.key === Qt.Key_Enter || event.key === Qt.Key_Return) &&
                                       messageField_id.length) {
                                       // console.log(messageField_id.text)
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

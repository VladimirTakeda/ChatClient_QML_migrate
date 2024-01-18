import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import ChatClient_QML 1.0

Rectangle{
    id: bottomPanel_id
    width: parent.width
    height: 45
    color: "crimson"

    readonly property real iconsSize: 22
    RowLayout{
        width: parent.width
        anchors.centerIn: parent

        Rectangle{
            id: paperClip_id
            Layout.preferredWidth: bottomPanel_id.iconsSize
            Layout.preferredHeight: bottomPanel_id.iconsSize
            Layout.leftMargin: 14
            color: "transparent"

            // border.width: 1
            // border.color: "darkred"
            Image {
                anchors.fill: parent
                autoTransform: true
                fillMode: Image.PreserveAspectFit
                source: "qrc:/ChatClient/ChatClient_QML/icons/paper_clip.svg"
            }
        }

        TextInput{
            id: messageField_id
            Layout.fillWidth: true
            Layout.leftMargin: 12
            Layout.rightMargin: 10
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            // placeholderText: qsTr("<font color='lightgray'>Compose message...")
            color: "black"

            wrapMode: TextArea.Wrap

            // background: Rectangle {
            //     // implicitWidth: parent.width
            //     // implicitHeight: parent.height
            //     color: "white"
            // }

            // onActiveFocusChanged: {
            //     if (activeFocus) {
            //         messageField_id.placeholderText = "<font color='gray'>Compose message...";
            //     } else {
            //         messageField_id.placeholderText = "<font color='lightgray'>Compose message...";
            //     }
            // }

            Keys.onPressed:(event)=>{
                               if ((event.key === Qt.Key_Enter || event.key === Qt.Key_Return) &&
                                   messageField_id.length) {
                                   console.log(messageField_id.text)
                                   chatClientObj.sendNewMessage(messageField_id.text)
                                   messageField_id.clear()
                               }
                           }
        }

        Rectangle{
            id: smiles_id
            Layout.preferredWidth: bottomPanel_id.iconsSize
            Layout.preferredHeight: bottomPanel_id.iconsSize
            Layout.rightMargin: 14
            color: "transparent"

            // border.width: 1
            // border.color: "darkred"
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

            // border.width: 1
            // border.color: "darkred"
            Image {
                anchors.fill: parent
                rotation: 45
                source: "qrc:/ChatClient/ChatClient_QML/icons/sendMessage.png"
            }
        }
    }
}

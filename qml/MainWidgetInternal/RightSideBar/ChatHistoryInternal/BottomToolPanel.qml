import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import ChatClient_QML 1.0

Rectangle{
    id: bottomPanel_id
    width: parent.width
    height: 50
    color: "crimson"

    RowLayout{
        width: parent.width
        anchors.centerIn: parent

        TextArea{
            id: messageField_id
            Layout.fillWidth: true
            placeholderText: qsTr("<font color='lightgray'>Compose message...")
            color: "darkgray"

            wrapMode: TextArea.Wrap
            background: Rectangle {
                implicitWidth: parent.width
                implicitHeight: parent.height
                color: "transparent"
            }

            onActiveFocusChanged: {
                if (activeFocus) {
                    messageField_id.placeholderText = "<font color='gray'>Compose message...";
                } else {
                    messageField_id.placeholderText = "<font color='lightgray'>Compose message...";
                }
            }

            Keys.onPressed: (event)=> {
                                if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                                    console.log(messageField_id.text)
                                    chatClientObj.sendNewMessage(messageField_id.text)
                                    messageField_id.clear()
                                }
                            }
        }
    }
}

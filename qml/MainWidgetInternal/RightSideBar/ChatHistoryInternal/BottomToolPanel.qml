import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import ChatClient_QML 1.0

Rectangle{
    id: bottomPanel_id
    width: parent.width
    height: 50
    color: "crimson"

    // property int currentIndex: -1
    // Connections {
    //     target: listViewDisplayPanel_id
    //     function onMessageSelected() {
    //         bottomPanel_id.currentIndex = index;
    //     }
    // }

    RowLayout{
        width: parent.width
        anchors.centerIn: parent

        TextArea{
            id: messageField_id
            Layout.fillWidth: true
            placeholderText: qsTr("<font color = 'darkgrey' Compose message...")
            color: "darkgray"

            wrapMode: TextArea.Wrap
            background: Rectangle {
                implicitWidth: parent.width
                implicitHeight: parent.height
                color: "transparent"
            }

            onActiveFocusChanged: {
                if (activeFocus) {
                    // При получении фокуса изменить цвет placeholder
                    messageField_id.placeholderText = "lightgray";
                    console.log("activeFocus --> true")
                } else {
                    // При потере фокуса вернуть исходный цвет placeholder
                    messageField_id.placeholderText = "blue";
                }
            }

            Keys.onEnterPressed: event => {
                                     console.log(messageField_id.text)
                                     messageField_id.clear()
                                 }
            Keys.onReturnPressed: event => {
                                      console.log(messageField_id.text)
                                      chatClientObj.sendNewMessage(messageField_id.text)
                                      messageField_id.clear()

                                  }
            Keys.onEscapePressed: event => {
                                      messageField_id.focus = false
                                  }
        }
    }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ChatClient_QML 1.0

Item{

    Component.onDestruction: print("Destroying listViewContacts_id item")
    Component.onCompleted: print("Creating listViewContacts_id item")
    ColumnLayout{
        anchors.fill: parent
        spacing: 0
        ListView{
            id: listViewContacts_id
            currentIndex: -1
            Layout.fillWidth: true
            Layout.fillHeight: true
            interactive: false
            clip: true
            spacing: 0
            model: contactsModel

            Connections {
              target: chatClientObj
                  Component.onCompleted: print("Creating listViewContacts_id connection --------")
              function onDialogIndexChanged(index) {
                 console.log("curr hightlight dialog is idx " + index)
               listViewContacts_id.currentIndex = index;
              }
            }

            delegate: DelegateContactPanel{
                Layout.alignment: Qt.AlignTop
            }
        }
    }
}

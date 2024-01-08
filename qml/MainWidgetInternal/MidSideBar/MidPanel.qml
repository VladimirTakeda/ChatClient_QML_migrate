import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ChatClient_QML 1.0

Rectangle{
    id: midToolPanel_id
    color: "green"
    ColumnLayout{
        anchors.fill: parent
        SearchPanel{
            id: searchPanel_id
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
        }
        StackView{
            id: mainWindowStack_id
            initialItem: ContactsPanel{
                id: contactsPanel_id
            }
            Layout.fillHeight: true
        }
    }
}


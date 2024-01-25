import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ChatClient_QML 1.0

ColumnLayout{
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

        delegate: DelegateContactPanel{
            Layout.alignment: Qt.AlignTop
        }

        // highlight: Rectangle{
        //     Layout.fillWidth: true
        //     implicitHeight: 62
        //     color: "#419FD9"
        // }
    }
}

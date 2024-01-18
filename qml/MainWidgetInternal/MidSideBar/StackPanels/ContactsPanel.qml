import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ChatClient_QML 1.0

ColumnLayout{
    ListView{
        id: listViewContacts_id
        currentIndex: -1
        Layout.fillWidth: true
        Layout.fillHeight: true
        interactive: false
        model: contactsModel

        // highlight: Rectangle{ color: listViewContacts_id.view === listViewContacts_id.index ? "cadetblue" : "transparent"}

        delegate: DelegateContactPanel{

        }
    }
}

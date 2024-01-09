import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ChatClient_QML 1.0

ColumnLayout{
    ListView{
        Layout.fillWidth: true
        Layout.fillHeight: true

        model: ListModel{
            id: contactsModel_id
            ListElement{
                name: "Contact 1"
                time: "20:30"
            }
            ListElement{
                name: "Contact 2"
                time: "20:40"
            }
        }

        delegate: DelegateContactPanel{

        }
    }
}

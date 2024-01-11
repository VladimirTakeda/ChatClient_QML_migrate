import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ChatClient_QML 1.0

ColumnLayout{
    ListView{
        Layout.fillWidth: true
        Layout.fillHeight: true

        model: contactsModel

        delegate: DelegateContactPanel{

        }
    }
}

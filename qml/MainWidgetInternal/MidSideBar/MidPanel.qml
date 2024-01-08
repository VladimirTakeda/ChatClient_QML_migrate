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
            Layout.fillWidth: true
            Layout.fillHeight: true
            initialItem: ContactsPanel{
                anchors.fill: parent
            }
        }
    }
}


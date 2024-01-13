import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ChatClient_QML 1.0

Rectangle{
    id: chatHistory_id
    color: "blue"

    ColumnLayout{
        anchors.fill: parent
        TopToolPanel{
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
        }

        ChatDisplayPanel{
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        BottomToolPanel{
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignBottom
        }
    }


}

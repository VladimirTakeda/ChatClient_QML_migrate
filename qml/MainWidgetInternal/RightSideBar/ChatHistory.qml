import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ChatClient_QML 1.0

Rectangle{
    property alias __bottomToolPanel: bottomToolPanel_id
    property alias __chatDisplayPanel: chatDisplayPanel_id
    id: chatHistory_id
    color: "transparent"

    Image {
        id: walls_id
        anchors.fill: parent
        source: "qrc:/ChatClient/ChatClient_QML/icons/walls2.jpg"
        fillMode: Image.Stretch
    }

    ColumnLayout{
        anchors.fill: parent
        TopToolPanel{
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
        }

        ChatDisplayPanel{
            id: chatDisplayPanel_id
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        BottomToolPanel{
            id: bottomToolPanel_id
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignBottom
        }
    }
}

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import ChatClient_QML 1.0

Rectangle{
    id: mainWidget_id
    implicitWidth: 1034
    implicitHeight: 734
    RowLayout{
        anchors.fill: parent
        spacing: 0

        LeftToolPanel {
            id: leftToolPanel_id
            Layout.minimumWidth:72
            Layout.preferredWidth: 72
            Layout.maximumWidth: 72
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        SplitView{
            width: mainWidget_id.width
            height: mainWidget_id.height
            orientation: Qt.Horizontal

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 50
            Layout.preferredWidth: 2 * parent.width/3

            MidPanel {
                id: midToolPanel_id
                SplitView.minimumHeight: 500
                SplitView.fillWidth: true
                SplitView.preferredWidth: 260
                SplitView.minimumWidth: 260 // до какого размера будет сжиматься
            }
            ChatHistory {
                //TODO: add limit width to 375
                id: chatHistory_id
                SplitView.minimumHeight: 500
                SplitView.minimumWidth: 375
                SplitView.preferredWidth: 550
                SplitView.fillWidth: false
            }
        }
    }
}

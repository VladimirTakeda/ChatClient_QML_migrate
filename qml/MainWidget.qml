import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import ChatClient_QML 1.0

Rectangle{
    id: mainWidget_id
    // anchors.fill: parent
    RowLayout{
        anchors.fill: parent

        LeftToolPanel {
            id: leftToolPanel_id
            Layout.minimumWidth:80
            Layout.preferredWidth: 100
            Layout.maximumWidth: 80
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
                SplitView.minimumHeight: 25
                SplitView.preferredHeight: 50
                SplitView.maximumHeight: 50
                SplitView.fillWidth: true
                SplitView.preferredWidth: 200 // до какого размера будет сжиматься
                SplitView.minimumWidth: 250 //значение, которое меняет ширину мид панели
            }
            ChatHistory {
                id: chatHistory_id
                SplitView.minimumHeight: 25
                SplitView.preferredHeight: 50
                SplitView.maximumHeight: 100
                SplitView.fillWidth: false
                SplitView.minimumWidth: 500
                SplitView.preferredWidth: 500
            }
        }
    }
}

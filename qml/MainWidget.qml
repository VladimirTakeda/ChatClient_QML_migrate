import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import ChatClient_QML 1.0

//TODO: singleton includes files

Rectangle{
    id: mainWidget_id
    anchors.fill: parent

    RowLayout{
        anchors.fill: parent

        LeftToolPanel {
            id: leftToolPanel_id
            Layout.minimumWidth:50
            Layout.preferredWidth: parent.width/8
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        SplitView{
            width: parent.width
            height: parent.height
            orientation: Qt.Horizontal

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 50
            // SplitView.minimumWidth: 400
            Layout.preferredWidth: 2 * parent.width/3
            // SplitView.preferredWidth: 2 * parent.width/3

            MidPanel {
                id: midToolPanel_id
                SplitView.minimumHeight: 25
                SplitView.preferredHeight: 50
                SplitView.maximumHeight: 100
                SplitView.fillWidth: false
                SplitView.minimumWidth: 300 //значение, которое меняет ширину мид панели
            }
            ChatHistory {
                id: chatHistory_id
                SplitView.minimumHeight: 25
                SplitView.preferredHeight: 50
                SplitView.maximumHeight: 100
                SplitView.fillWidth: true
                SplitView.minimumWidth: 300
            }
        }
    }
}

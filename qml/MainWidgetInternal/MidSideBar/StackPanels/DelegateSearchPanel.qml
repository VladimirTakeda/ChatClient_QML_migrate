import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ChatClient_QML 1.0

Rectangle{
    id: delegat_id
    height: 62
    width: ListView.view.width
    // color: "lightseagreen"
    color: "transparent"
    border.color: "black"

    MouseArea{
        id: mouseCursor_id
        anchors.fill: parent
        hoverEnabled: true
        onEntered: { delegat_id.color = "lightcoral" }
        onExited: { delegat_id.color = "transparent" }
        readonly property string pathContactsPanel: "qrc:/ChatClient/ChatClient_QML/qml/MainWidgetInternal/MidSideBar/StackPanels/ContactsPanel.qml"
        readonly property string pathSearchResultPanel: "qrc:/ChatClient/ChatClient_QML/qml/MainWidgetInternal/MidSideBar/StackPanels/SearchResultPanel.qml"
        onClicked:{
            console.log("current index", index)
            searchModel.onItemClicked(index)
            stackViewSearchPanel_id.replace(pathContactsPanel)
            //TODO: add the call's method clear() from SearchPanel
        }
    }

    Rectangle{
        readonly property real iconLeftMargin: 10
        id: icon_id
        width: 45
        height: 45
        anchors.verticalCenter: delegat_id.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: icon_id.iconLeftMargin
        radius: width / 2
        border.width: 1
        border.color: "darkred"
        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            visible: true
            source: "qrc:/ChatClient/ChatClient_QML/icons/user_blank.png"
        }
    }

    ColumnLayout{
        anchors.fill: parent
        Text{
            id: userInfo_id
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 14
            Layout.leftMargin: icon_id.width + icon_id.iconLeftMargin + 12
            wrapMode: Text.WordWrap
            text: model.chatName
        }
    }
}

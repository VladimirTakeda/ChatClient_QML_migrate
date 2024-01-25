import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ChatClient_QML 1.0

import StyleModule 1.0


Rectangle{
    id: midToolPanel_id
    color: Style.base_color

    ColumnLayout{
        anchors.fill: parent
        spacing: 0
        SearchPanel{
            id: searchPanel_id
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
        }
        StackView{
            id : stackViewSearchPanel_id
            Layout.fillWidth: true
            Layout.fillHeight: true

            // initialItem: "qrc:/ChatClient/ChatClient_QML/qml/MainWidgetInternal/MidSideBar/StackPanels/SearchResultPanel.qml"
            initialItem: "qrc:/ChatClient/ChatClient_QML/qml/MainWidgetInternal/MidSideBar/StackPanels/ContactsPanel.qml"
            replaceEnter: Transition {
                PropertyAnimation { properties: "opacity"; duration: 0 }
            }
            replaceExit: Transition {
                PropertyAnimation { properties: "opacity"; duration: 0 }
            }
        }
    }
}


import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ChatClient_QML 1.0

import StyleModule 1.0


Rectangle{
    // property alias __columnLayout: columnLayout_id
    id: midToolPanel_id
    color: Style.base_color

    ColumnLayout{
        // property alias __stackViewSearchPanel: stackViewSearchPanel_id
        id: columnLayout_id
        anchors.fill: parent
        spacing: 0
        SearchPanel{
            id: searchPanel_id
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
        }
        StackView{
            // property alias __contactsPanel: contactsPanel_id
            id: stackViewSearchPanel_id
            Layout.fillWidth: true
            Layout.fillHeight: true
            Item{
                id: contactStack_id
                Loader{
                    anchors.fill: parent
                    source: "qrc:/ChatClient/ChatClient_QML/qml/MainWidgetInternal/MidSideBar/StackPanels/ContactsPanel.qml"
                }
            }
            Item{
                id: searchResultStack_id
                Loader{
                    anchors.fill: parent
                    source: "qrc:/ChatClient/ChatClient_QML/qml/MainWidgetInternal/MidSideBar/StackPanels/SearchResultPanel.qml"
                }
            }

            initialItem: contactStack_id
            replaceEnter: Transition {
                PropertyAnimation { properties: "opacity"; duration: 0 }
            }
            replaceExit: Transition {
                PropertyAnimation { properties: "opacity"; duration: 0 }
            }
        }
    }
}


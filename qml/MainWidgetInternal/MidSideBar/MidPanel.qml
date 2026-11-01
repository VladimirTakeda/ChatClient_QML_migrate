import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ChatClient_QML 1.0

import StyleModule 1.0


Rectangle{
    id: midToolPanel_id
    color: Style.base_color
    clip: true

    property bool profileOpen: false

    // Two-wide slider: left half holds the chats view, right half holds the
    // profile view. Animating the slider's x swaps them with a horizontal push.
    Item {
        id: slider_id
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: midToolPanel_id.width * 2
        x: midToolPanel_id.profileOpen ? -midToolPanel_id.width : 0

        Behavior on x {
            NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
        }

        // --- Chats view (search bar + contacts/search results stack) ---
        Item {
            id: chatsView_id
            x: 0
            width: midToolPanel_id.width
            height: parent.height

            ColumnLayout{
                id: columnLayout_id
                anchors.fill: parent
                spacing: 0
                SearchPanel{
                    id: searchPanel_id
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                }
                StackView{
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

        // --- Profile view ---
        ProfileWidget {
            id: profileView_id
            x: midToolPanel_id.width
            width: midToolPanel_id.width
            height: parent.height
            onCloseRequested: midToolPanel_id.profileOpen = false
        }
    }
}

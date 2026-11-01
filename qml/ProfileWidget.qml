import QtQuick
import QtQuick.Controls.Basic

import ChatClient_QML 1.0
import StyleModule 1.0

Rectangle {
    id: profile_id
    color: Style.filled_color

    signal closeRequested()

    // Swallow clicks so they never reach the panel below.
    MouseArea {
        anchors.fill: parent
        onPressed: (mouse) => mouse.accepted = true
        hoverEnabled: true
    }

    // --- Header ---
    Rectangle {
        id: header_id
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 54
        color: Style.base_color
        border.color: Style.border_color
        border.width: 1
        z: 1

        Item {
            id: backBtn_id
            width: 36
            height: 36
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                anchors.fill: parent
                radius: width / 2
                color: backArea_id.containsMouse ? Style.filled_color : "transparent"
            }
            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -2
                text: "‹"
                font.pixelSize: 30
                color: Style.baseFilled_color
            }
            MouseArea {
                id: backArea_id
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: profile_id.closeRequested()
            }
        }

        Text {
            anchors.left: backBtn_id.right
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Settings")
            font.pixelSize: 15
            font.weight: Font.DemiBold
            color: "black"
        }

        Text {
            id: editLabel_id
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Edit")
            font.pixelSize: 14
            color: Style.baseFilled_color

            MouseArea {
                anchors.fill: parent
                anchors.margins: -8
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: console.log("Edit clicked")
            }
        }
    }

    // --- Scrollable content ---
    Flickable {
        anchors.top: header_id.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        contentHeight: contentColumn_id.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: contentColumn_id
            width: parent.width
            spacing: 0

            // Avatar + name block
            Rectangle {
                width: parent.width
                height: 230
                color: Style.base_color

                Column {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 28
                    spacing: 12

                    Rectangle {
                        width: 120
                        height: 120
                        radius: 60
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: Style.baseFilled_color

                        Text {
                            anchors.centerIn: parent
                            text: {
                                var n = chatClientObj.currentUserName
                                return n && n.length > 0 ? n.charAt(0).toUpperCase() : "?"
                            }
                            color: "white"
                            font.pixelSize: 54
                            font.weight: Font.DemiBold
                        }
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: chatClientObj.currentUserName || qsTr("User")
                        font.pixelSize: 22
                        font.weight: Font.DemiBold
                        color: "black"
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("online")
                        font.pixelSize: 13
                        color: Style.baseFilled_color
                    }
                }
            }

            // --- Section header: Account Info ---
            Rectangle {
                width: parent.width
                height: 36
                color: Style.filled_color
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 8
                    text: qsTr("Account Info")
                    font.pixelSize: 12
                    color: Style.row_text_secondary
                    font.capitalization: Font.AllUppercase
                }
            }

            // Info rows
            Rectangle {
                width: parent.width
                color: Style.base_color
                height: infoCol_id.height

                Column {
                    id: infoCol_id
                    width: parent.width
                    spacing: 0

                    Repeater {
                        model: [
                            { title: qsTr("Set a Username"), subtitle: qsTr("Username") },
                            { title: qsTr("Add a few words about yourself"), subtitle: qsTr("Bio") }
                        ]
                        delegate: Item {
                            width: parent.width
                            height: 64

                            Rectangle {
                                anchors.fill: parent
                                color: infoHover_id.containsMouse ? "#F7F7F7" : "transparent"
                            }
                            MouseArea {
                                id: infoHover_id
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                            }
                            Column {
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 3

                                Text {
                                    text: modelData.title
                                    font.pixelSize: 15
                                    color: Style.baseFilled_color
                                }
                                Text {
                                    text: modelData.subtitle
                                    font.pixelSize: 13
                                    color: Style.row_text_secondary
                                }
                            }
                            Rectangle {
                                visible: index < 1
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                height: 1
                                color: Style.border_color
                            }
                        }
                    }
                }
            }

            // --- Section header: Settings ---
            Rectangle {
                width: parent.width
                height: 36
                color: Style.filled_color
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 8
                    text: qsTr("Settings")
                    font.pixelSize: 12
                    color: Style.row_text_secondary
                    font.capitalization: Font.AllUppercase
                }
            }

            // Settings rows
            Rectangle {
                width: parent.width
                color: Style.base_color
                height: settingsCol_id.height

                Column {
                    id: settingsCol_id
                    width: parent.width
                    spacing: 0

                    Repeater {
                        model: [
                            { label: qsTr("Notifications and Sounds"), bg: "#F89C1E", glyph: "◉" },
                            { label: qsTr("Privacy and Security"),     bg: "#6AB641", glyph: "⧉" },
                            { label: qsTr("Data and Storage"),         bg: "#5CBAEA", glyph: "⇅" },
                            { label: qsTr("Chat Settings"),            bg: "#8E85EE", glyph: "✎" },
                            { label: qsTr("Advanced"),                 bg: "#F17171", glyph: "⚙" },
                            { label: qsTr("Language"),                 bg: "#3CB2E6", glyph: "A"      }
                        ]
                        delegate: Item {
                            width: parent.width
                            height: 54

                            Rectangle {
                                anchors.fill: parent
                                color: rowHover_id.containsMouse ? "#F7F7F7" : "transparent"
                            }
                            MouseArea {
                                id: rowHover_id
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: console.log(modelData.label)
                            }

                            Rectangle {
                                id: iconBox_id
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                anchors.verticalCenter: parent.verticalCenter
                                width: 28
                                height: 28
                                radius: 7
                                color: modelData.bg

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.glyph
                                    color: "white"
                                    font.pixelSize: 16
                                    font.weight: Font.DemiBold
                                }
                            }

                            Text {
                                anchors.left: iconBox_id.right
                                anchors.leftMargin: 14
                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData.label
                                font.pixelSize: 15
                                color: "black"
                            }

                            Text {
                                anchors.right: parent.right
                                anchors.rightMargin: 18
                                anchors.verticalCenter: parent.verticalCenter
                                text: "›"
                                font.pixelSize: 22
                                color: Style.row_text_secondary
                            }

                            Rectangle {
                                visible: index < 5
                                anchors.left: parent.left
                                anchors.leftMargin: 62
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                height: 1
                                color: Style.border_color
                            }
                        }
                    }
                }
            }

            // Logout
            Rectangle {
                width: parent.width
                height: 20
                color: "transparent"
            }
            Rectangle {
                width: parent.width
                height: 54
                color: logoutHover_id.containsMouse ? "#F7F7F7" : Style.base_color

                MouseArea {
                    id: logoutHover_id
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: confirmLogout_id.open()
                }
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Log Out")
                    font.pixelSize: 15
                    color: "#E53935"
                }
            }

            Rectangle {
                width: parent.width
                height: 20
                color: "transparent"
            }
        }
    }

    Popup {
        id: confirmLogout_id
        anchors.centerIn: Overlay.overlay
        modal: true
        width: 320
        padding: 20

        background: Rectangle {
            radius: 8
            color: Style.base_color
            border.color: Style.border_color
            border.width: 1
        }

        Column {
            width: parent.width
            spacing: 12

            Text {
                text: qsTr("Log out")
                font.pixelSize: 16
                font.weight: Font.DemiBold
                color: "black"
            }
            Text {
                width: parent.width
                text: qsTr("Are you sure? Your local chat history and cached images will be deleted.")
                font.pixelSize: 13
                color: Style.row_text_secondary
                wrapMode: Text.Wrap
            }

            Row {
                anchors.right: parent.right
                spacing: 24
                topPadding: 8

                Text {
                    text: qsTr("Cancel")
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                    color: Style.baseFilled_color
                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -8
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: confirmLogout_id.close()
                    }
                }
                Text {
                    text: qsTr("Log Out")
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                    color: "#E53935"
                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -8
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            confirmLogout_id.close()
                            chatClientObj.logout()
                        }
                    }
                }
            }
        }
    }
}

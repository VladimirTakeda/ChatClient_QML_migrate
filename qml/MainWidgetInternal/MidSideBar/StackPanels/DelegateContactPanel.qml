import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle{
    id: delegat_id
    height: 45
    width: parent.width
    // color: "lightseagreen"
    color: "transparent"
    border.color: "black"

    MouseArea{
        id: mouseCursor_id
        anchors.fill: parent
        hoverEnabled: true
        onEntered: { delegat_id.color = "lightcoral" }
        onExited: { delegat_id.color = "lightseagreen" }
    }

    Rectangle{
        readonly property real iconMargins: 10
        id: icon_id
        width: 45 - iconMargins
        height: parent.height - iconMargins
        anchors.verticalCenter: delegat_id.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 5
        // color: "transparent"
        radius: width / 2
        border.width: 1
        border.color: "darkred"

        Image {
            anchors.fill: parent
            visible: true
            source: "qrc:/ChatClient/ChatClient_QML/icons/blank.jpg"
        }
    }

    ColumnLayout{
        anchors.fill: parent
        RowLayout{
            Layout.alignment: Qt.AlignTop
            Text{
                text: name
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: icon_id.width + 10
            }
            Text{
                text: time
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: 10

            }
        }

        RowLayout{
            Layout.alignment: Qt.AlignBottom
            Text{
                id: lastText_id
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: icon_id.width + 10
                Layout.bottomMargin: 10
                Layout.preferredWidth: 100
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                maximumLineCount: 1
                text: "loooooooooooooooooooooooooooong message from contact"
            }
            Rectangle{
                readonly property int sizeMissMessage: 20
                width: sizeMissMessage
                height: sizeMissMessage
                radius: width / 2
                Layout.alignment: Qt.AlignRight
                Layout.bottomMargin: 5
                Layout.rightMargin: 10
                Rectangle{
                    id: innerRadius_id
                    width: parent.width - 4
                    height: parent.height - 4
                    radius: width / 2
                    color: "transparent"
                    anchors.centerIn: parent
                    // color: "grey"
                    Text{
                        anchors.centerIn: innerRadius_id
                        text: "2"
                    }
                }
            }
        }
    }
}



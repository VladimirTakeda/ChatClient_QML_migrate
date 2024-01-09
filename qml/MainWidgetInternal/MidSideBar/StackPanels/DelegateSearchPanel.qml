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
        onExited: { delegat_id.color = "transparent" }
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
        Text{
            text: chatName
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: icon_id.width + 10
            Layout.topMargin: 3
            wrapMode: Text.WordWrap
        }
        /*Text{
            text: domen
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: icon_id.width + 10
            Layout.bottomMargin: 3
            wrapMode: Text.WordWrap
        }*/
    }
}

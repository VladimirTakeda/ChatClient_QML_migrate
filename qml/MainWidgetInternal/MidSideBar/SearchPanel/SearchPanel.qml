import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import StyleModule 1.0

Rectangle{
    property alias innerSearch: innerSearchArea_id
    id: searchPanel_id
    width: parent.width
    height: 54
    color: Style.base_color

    Rectangle{
        property alias messageBox_id: messageBox_id
        readonly property int margineSize: 20

        id: innerSearchArea_id
        width: parent.width - margineSize
        height: parent.height - margineSize
        anchors.centerIn: parent
        radius: 20
        color: Style.filled_color
        border.color: Style.filled_color
        border.width: 1

        TextInput{
            id: messageBox_id
            anchors.fill: parent
            verticalAlignment: TextInput.AlignVCenter
            leftPadding: 10

            onTextEdited: {
                if (text.trim() === "" && stackViewSearchPanel_id.currentItem !== contactStack_id) {
                    stackViewSearchPanel_id.replace(contactStack_id)
                } else if (text.trim() !== "" && stackViewSearchPanel_id.currentItem !== searchResultStack_id) {
                    stackViewSearchPanel_id.replace(searchResultStack_id)
                }
                chatClientObj.SearchPrefix = text
            }
        }

        Text {
            id: customPlaceholder_id
            anchors.fill: messageBox_id
            anchors.left: messageBox_id.left
            anchors.leftMargin: 10
            verticalAlignment: Text.AlignVCenter
            text: "Search"
            color: messageBox_id.cursorVisible ? Style.placeholderLight_color : Style.placeholderDark_color
            visible: !messageBox_id.text.length
        }
    }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle{
    property alias innerSearch: innerSearchArea_id
    id: searchPanel_id
    width: parent.width
    height: 54
    color: "transparent"
    // color: "lightblue"


    Rectangle{
        // property alias textInput: inputText_id
        id: innerSearchArea_id

        readonly property int margineSize: 20

        width: parent.width - margineSize
        height: parent.height - margineSize
        anchors.centerIn: parent
        radius: 20
        color: "white"

        TextInput{
            readonly property string pathContactsPanel: "qrc:/ChatClient/ChatClient_QML/qml/MainWidgetInternal/MidSideBar/StackPanels/ContactsPanel.qml"
            readonly property string pathSearchResultPanel: "qrc:/ChatClient/ChatClient_QML/qml/MainWidgetInternal/MidSideBar/StackPanels/SearchResultPanel.qml"
            // property alias textInput: inputText_id
            id: inputText_id
            anchors.fill: parent
            verticalAlignment: TextInput.AlignVCenter
            leftPadding: 10
            onTextEdited: {
                if (text.trim() === "" && stackViewSearchPanel_id.currentItem !== pathContactsPanel) {
                    stackViewSearchPanel_id.replace(pathContactsPanel)
                } else if (text.trim() !== "" && stackViewSearchPanel_id.currentItem !== stackViewSearchPanel_id.item) {
                    stackViewSearchPanel_id.replace(pathSearchResultPanel)
                }
                chatClientObj.SearchPrefix = text
            }
        }
        Text {
            id: customPlaceholder_id
            anchors.fill: inputText_id
            anchors.left: inputText_id.left
            anchors.leftMargin: 10
            verticalAlignment: Text.AlignVCenter
            text: "Search"
            color: inputText_id.cursorVisible ? "lightgray" : "gray"
            visible: !inputText_id.text.length
        }
    }
}

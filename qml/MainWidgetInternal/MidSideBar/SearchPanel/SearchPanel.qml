import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle{

    Loader {
        id: searchResultPanelLoader
        source: "qrc:/ChatClient/ChatClient_QML/qml/MainWidgetInternal/MidSideBar/StackPanels/SearchResultPanel.qml"
    }

    id: searchPanel_id
    width: parent.width
    height: 50
    color: "green"
    Rectangle{
        readonly property int margineSize: 15

        width: parent.width - margineSize
        height: parent.height - margineSize
        anchors.centerIn: parent
        radius: 15
        color: "white"

        TextInput{
            id: inputText_id
            anchors.fill: parent
            verticalAlignment: TextInput.AlignVCenter
            leftPadding: 10
            onTextEdited: {
                if (text.trim() === "" && stackview_id.currentItem !== ContactsPanel) {
                    stackview_id.push(ContactsPanel)
                } else if (text.trim() !== "" && stackview_id.currentItem !== searchResultPanelLoader.item) {
                    stackview_id.push(searchResultPanelLoader.item)
                }
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

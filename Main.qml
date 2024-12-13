import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: appWindow_id
    width: 1034
    height: 734
    visible: true
    title: qsTr("ChatClient")

    //TODO: main window shrinks inner elements during collapsing
    minimumWidth: appWindow_id.width - 500
    minimumHeight: 500

    StackView{
        id: mainWindowStack_id
        anchors.fill: parent
        initialItem: chatClientObj.isUserRegistered() ? "qml/MainWidget.qml" : "qml/StartWidget.qml"
    }
    Item{
        focus: true
        Keys.onEscapePressed: {Qt.quit()}
    }

    Connections {
       target: Qt.application
       function onAboutToQuit() {
          chatClientObj.saveDialogs()
       }
    }

    Connections {
       target: chatClientObj
       function onGoToMainWidget() {
           mainWindowStack_id.replace("qrc:/ChatClient/ChatClient_QML/qml/MainWidget.qml")
       }
    }
}

import QtQuick
import QtQuick.Controls

Window {
    id: main_id
    width: 1034
    height: 734
    visible: true
    title: qsTr("Hello World")

    //TODO: main window shrinks inner elements during collapsing
    minimumWidth: main_id.width - 500

    StackView{
        id: mainWindowStack_id
        initialItem: MainWidget{
            id: mainWidget_id
        }
        anchors{
            fill: parent
        }
    }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


Rectangle{
    //TODO: collapse hides a part of content

    id: startWidget_id
    // width: parent.width; height: parent.height
    // anchors.fill: parent
    readonly property real minSize: textSecond_id.width
    color: "grey"

    RowLayout{
        Layout.alignment: Qt.AlignVCenter
        Layout.minimumWidth: minSize
        anchors{
            fill: parent
        }
        Item{
            Layout.fillWidth: true
        }
        ColumnLayout{
            id: startInfo_id

            Layout.alignment: Qt.AlignHCenter
            implicitWidth: Math.max(textSecond_id.width)  // Устанавливаем implicitWidth

            Item{
                Layout.fillHeight: true
            }
            Text{
                text: "<b>P2P Chat Desktop\n\n<b>"
                font.pointSize: 12
                font.family: "Segoe UI"
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }
            Text{
                id: textSecond_id
                text: "Welcome to the official P2P Chat app.\n It's fast and secure\n\n\n"
                horizontalAlignment: Text.AlignHCenter
            }
            Button{
                id: startMessage_id
                Layout.preferredWidth: textSecond_id.width
                onClicked: {
                    mainWindowStack_id.replace("qrc:/ChatClient/ChatClient_QML/qml/Registration.qml")
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
        Item{
            Layout.fillWidth: true
        }
    }
}

import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts


Rectangle{
    //TODO: collapse hides a part of content

    id: startWidget_id
    implicitWidth: 1034
    implicitHeight: 734
    readonly property real minSize: textSecond_id.width
    color: "white"

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
                contentItem: Text{
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: "white"
                    font.pixelSize: 18
                    text: "Continue"
                }
                background: Rectangle{
                    id: startMessageRec_id
                    height: 35
                    radius: 4
                    color: "#0088CC"
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: startMessageRec_id.color = Qt.darker("#0088CC", 1.4)
                        onExited: startMessageRec_id.color = "#0088CC"
                    }
                }
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

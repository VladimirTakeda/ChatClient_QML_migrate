import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts


Rectangle{
    readonly property real minSize: textSecond_id.width
    readonly property real heightFields: 27
    readonly property int sizeTextPlaceholder: 12
    // readonly property int heightPaddingItems: 30

    id: registrationWidget_id
    // width: parent.width; height: parent.height
    // anchors{
    //     fill: parent
    // }
    color: "white"

    RowLayout{
        anchors.fill: parent

        Layout.alignment: Qt.AlignVCenter
        Layout.minimumWidth: minSize
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
                text: "Your info"
                font.pointSize: 12
                font.family: "Segoe UI"
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }

            Text{
                id: textSecond_id
                text: "Please enter your login and password\n\n\n"
                horizontalAlignment: Text.AlignHCenter
            }

            TextField{
                id: login_id
                Layout.preferredHeight: heightFields
                Layout.preferredWidth: textSecond_id.width
                placeholderText: "Login"
                font.pointSize: sizeTextPlaceholder
            }

            Item{
                Layout.preferredHeight: 20
            }

            TextField{
                id: password
                Layout.preferredHeight: heightFields
                Layout.preferredWidth: textSecond_id.width
                echoMode: TextInput.Password
                placeholderText: "Password"
                font.pointSize: sizeTextPlaceholder
            }

            Item{
                Layout.preferredHeight: 40
            }

            Button{
                id: signUp_id
                Layout.preferredWidth: textSecond_id.width
                text: "Sign Up"
                // font.pixelSize: 20
                // palette.buttonText: "white"
                contentItem: Text{
                    text: signUp_id.text
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: "white"

                    font.pixelSize: 18
                }

                background: Rectangle{
                    height: 35
                    radius: 4
                    color: "#0088CC"
                    //TODO: Add hovered handler
                }

                onClicked: {
                    chatClientObj.registerUser(login_id.text, password.text)
                    //TODO make replace in void ChatClient::RegisterUserReply(QNetworkReply *reply)
                    mainWindowStack_id.replace("qrc:/ChatClient/ChatClient_QML/qml/MainWidget.qml")
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

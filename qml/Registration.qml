import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Rectangle{
    readonly property real minSize_: textSecond_id.width
    readonly property real heightFields_: 27
    readonly property int sizeTextPlaceholder_: 12
    // readonly property int heightPaddingItems: 30

    id: registrationWidget_id
    implicitWidth: 1034
    implicitHeight: 734

    color: "white"

    Button {
        readonly property int arrowSizeDefualt_: 30
        id: arrow_back_button_id
        icon.source: "qrc:/ChatClient/ChatClient_QML/icons/arrow-left-short-custom.svg"
        icon.width: arrowSizeDefualt_
        icon.height: arrowSizeDefualt_
        icon.color: "transparent"
        background: Item {  }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: arrow_back_button_id.icon.color = Qt.darker("#B2B2B2", 1.2)
            onExited: arrow_back_button_id.icon.color = "transparent"
            onClicked: {
                mainWindowStack_id.replace("qrc:/ChatClient/ChatClient_QML/qml/StartWidget.qml")
            }
        }
    }

    RowLayout{
        anchors.fill: parent

        Layout.alignment: Qt.AlignVCenter
        Layout.minimumWidth: minSize_
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
                Layout.preferredHeight: heightFields_
                Layout.preferredWidth: textSecond_id.width
                placeholderText: "Login"
                font.pointSize: sizeTextPlaceholder_
            }

            Item{
                Layout.preferredHeight: 20
            }

            TextField{
                id: password
                Layout.preferredHeight: heightFields_
                Layout.preferredWidth: textSecond_id.width
                echoMode: TextInput.Password
                placeholderText: "Password"
                font.pointSize: sizeTextPlaceholder_
                Keys.onPressed: (event)=> {
                                    if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                                        signUp_id.clicked()
                                    }
                                }
            }

            Item{
                Layout.preferredHeight: 40
            }

            Button{
                id: signUp_id
                Layout.preferredWidth: textSecond_id.width
                text: "Sign Up"
                contentItem: Text{
                    text: signUp_id.text
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: "white"

                    font.pixelSize: 18
                }

                background: Rectangle{
                    id: signUpRec_id
                    height: 35
                    radius: 4
                    color: "#0088CC"
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: signUpRec_id.color = Qt.darker("#0088CC", 1.4)
                        onExited: signUpRec_id.color = "#0088CC"
                    }
                }

                onClicked: {
                    chatClientObj.registerUser(login_id.text, password.text)
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

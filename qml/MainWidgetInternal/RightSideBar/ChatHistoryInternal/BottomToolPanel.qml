import QtCore
import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Dialogs

import ChatClient_QML 1.0
import StyleModule 1.0


Rectangle{
    property alias __rowLayoutBottomToolPanel_id: rowLayoutBottomToolPanel_id
    readonly property real iconsSize: 22
    readonly property int constHeightSize: 45
    id: bottomPanel_id
    implicitWidth: parent.width
    implicitHeight: bottomPanel_id.constHeightSize - messageField_id.sizeInputText + messageField_id.contentHeight
    color: Style.base_color

    Rectangle{
        id: dynamicBox_id
        width: parent.width
        height: bottomPanel_id.constHeightSize
        anchors.bottom: parent.bottom
        color: Style.base_color


        RowLayout{
            property alias __inputContainer: inputContainer_id
            id: rowLayoutBottomToolPanel_id
            width: parent.width
            anchors.centerIn: parent

            Rectangle{
                id: paperClip_id
                Layout.preferredWidth: bottomPanel_id.iconsSize
                Layout.preferredHeight: bottomPanel_id.iconsSize
                Layout.leftMargin: 14
                color: "transparent"

                Image {
                    anchors.fill: parent
                    autoTransform: true
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/ChatClient/ChatClient_QML/icons/paper_clip.svg"
                }

                FileDialog {
                    id: folderDialog_id
                    nameFilters: [ "Image files (*.png *.jpg)", "All files (*)" ]
                    currentFolder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
                    onAccepted: {

                        console.log("url of the file: ", folderDialog_id.selectedFile)
                    }
                    onRejected: { console.log("Rejected") }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        folderDialog_id.open()
                    }
                }
            }

            Item {
                property alias __messageBox: messageField_id
                id: inputContainer_id
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: 12
                Layout.rightMargin: 10
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                TextInput{
                    readonly property int sizeInputText: 16
                    id: messageField_id
                    anchors.fill: parent
                    focus: false

                    verticalAlignment: Text.AlignVCenter
                    color: "black"

                    wrapMode: TextInput.Wrap
                    Text {
                        id: customPlaceholder_id
                        anchors{
                            fill: parent
                            left: messageField_id.left
                            leftMargin: 2
                        }
                        verticalAlignment: Text.AlignVCenter
                        text: "Compose message..."
                        color: messageField_id.cursorVisible ? Style.placeholderLight_color : Style.placeholderDark_color
                        visible: !messageField_id.text.length
                    }

                    Keys.onPressed:(event)=>{
                                       if ((event.key === Qt.Key_Enter || event.key === Qt.Key_Return) &&
                                           messageField_id.length) {
                                           // console.log(messageField_id.text)
                                           chatClientObj.sendNewMessage(messageField_id.text)
                                           messageField_id.clear()
                                           // __chatDisplayPanel.__listViewDisplayPanel.positionViewAtEnd()

                                           // console.log("width ",__chatDisplayPanel.__listViewDisplayPanel.width)
                                       }
                                   }
                }
            }

            Rectangle{
                id: smiles_id
                Layout.preferredWidth: bottomPanel_id.iconsSize
                Layout.preferredHeight: bottomPanel_id.iconsSize
                Layout.rightMargin: 14
                color: "transparent"
                Image {
                    anchors.fill: parent
                    autoTransform: true
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/ChatClient/ChatClient_QML/icons/smileButton.png"
                }
            }

            Rectangle{
                id: sendMessage_id
                Layout.preferredWidth: bottomPanel_id.iconsSize
                Layout.preferredHeight: bottomPanel_id.iconsSize
                Layout.rightMargin: 14
                color: "transparent"
                Image {
                    anchors.fill: parent
                    rotation: 45
                    source: "qrc:/ChatClient/ChatClient_QML/icons/sendMessage.png"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            chatClientObj.sendNewMessage(messageField_id.text)
                            messageField_id.clear()
                        }
                    }
                }
            }
        }
    }
}

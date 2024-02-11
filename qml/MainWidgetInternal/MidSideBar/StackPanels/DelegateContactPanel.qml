import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import StyleModule 1.0


Rectangle{
    property alias __delegatContactMouseArea: mouseCursor_id
    readonly property ListView __lv: ListView.view
    readonly property real leftRightInnerMargin: 10
    id: delegat_id
    implicitHeight: 62
    implicitWidth: __lv.width
    color: __lv.currentIndex === model.index ? Style.baseFilled_color : "transparent"

    MouseArea{
        id: mouseCursor_id
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            __lv.currentIndex = model.index
            chatClientObj.updateCurrentChat(model.index)
            // called method from BottomToolPanel
           chatHistory_id.__bottomToolPanel_id.__rowLayoutBottomToolPanel_id.__inputConteiner.__messageBox.focus = true


            // delegat_id.color = "#419FD9"
        }
        // onEntered: {
        //     if(__lv.currentIndex !== model.index)
        //         delegat_id.color = "#F1F1F1"
        // }
        // onExited: {
        //     if(__lv.currentIndex !== model.index)
        //         delegat_id.color = "transparent"
        // }
    }



    Rectangle{
        id: icon_id
        width: 45
        height: 45
        anchors.verticalCenter: delegat_id.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: delegat_id.leftRightInnerMargin
        radius: width / 2
        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            visible: true
            source: "qrc:/ChatClient/ChatClient_QML/icons/user_blank.png"
        }
    }

    ColumnLayout{
        id: dataDelegat_id
        anchors.fill: parent
        readonly property real marginInner: 14
        RowLayout{
            Layout.alignment: Qt.AlignTop
            Text{
                id: userInfo_id
                text: model.chatName
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: dataDelegat_id.marginInner
                Layout.leftMargin: icon_id.width + delegat_id.leftRightInnerMargin + 12
            }
            Text{
                id: timeMessage_id
                text: model.lastMessageTime
                Layout.alignment: Qt.AlignRight
                Layout.topMargin: dataDelegat_id.marginInner
                Layout.rightMargin: delegat_id.leftRightInnerMargin
            }
        }

        RowLayout{
            Layout.alignment: Qt.AlignBottom
            Text{
                id: lastText_id
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignBottom
                Layout.bottomMargin: dataDelegat_id.marginInner
                Layout.leftMargin: icon_id.width + delegat_id.leftRightInnerMargin + 12
                elide: Text.ElideRight
                // property wrapper for ... at the end of the text
                property TextMetrics textMetrics: TextMetrics {
                    text: model.lastMessage
                    elideWidth: delegat_id.width
                    elide: Text.ElideRight
                }
                wrapMode: Text.WrapAnywhere
                maximumLineCount: 1
                text: textMetrics.text
            }
            Rectangle{
                id: missMassages_id
                readonly property int sizeMissMessage: 19
                width: sizeMissMessage
                height: sizeMissMessage
                radius: width / 2
                Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                Layout.rightMargin: delegat_id.leftRightInnerMargin
                Layout.bottomMargin: 12
                color: Style.filledDark_color
                Text{
                    anchors {
                        fill: parent
                        centerIn: parent
                        bottomMargin: 1 // to center text within the inner circle
                    }
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: model.missedMessageCount
                }
            }
        }
    }
}



import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Rectangle{
    id: bottomPanel_id
    width: parent.width
    height: 50
    color: "crimson"

    RowLayout{
        width: parent.width
        anchors.centerIn: parent

        TextArea{
            id: messageField_id
            Layout.fillWidth: true
            placeholderText: qsTr("Compose message...")

            wrapMode: TextArea.Wrap
            background: Rectangle {
                implicitWidth: parent.width
                implicitHeight: parent.height
                color: "transparent"
            }
            // onPressed: {
            //     console.log(messageField_id.text)
            // }

            Keys.onEnterPressed: event => {
                                console.log(messageField_id.text)
                                messageField_id.clear()
                            }
        }
    }
}

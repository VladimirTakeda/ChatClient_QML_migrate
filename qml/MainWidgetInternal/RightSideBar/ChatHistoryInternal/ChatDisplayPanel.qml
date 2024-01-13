import QtQuick
import QtQuick.Controls


ListView{
    id: listViewDisplayPanel_id
    spacing: 4
    model: ListModel{
        ListElement {
            message: "Стоимость мелкомягких оценивается в $2.888 триллиона, а у Apple — Apple — $2.887. Инвестиции в нейросети приносят свои плоды."
            boolFlag: true
        }
        ListElement {
            message: "Стоимость мелкомягких оценивается в $2.888 триллиона"
            boolFlag: false
        }
        ListElement {
            message: "Чтобы добавить отступ слева для делегата в ListView, вы можете использовать свойство anchors.left и anchors.leftMargin вместо anchors.right и anchors.rightMargin. Вот как вы можете изменить ваш код:"
            boolFlag: true
        }
    }

    delegate: Rectangle{
        readonly property real rlSideMargins: 5
        anchors {
            right: boolFlag ? listViewDisplayPanel_id.contentItem.right : undefined
            left: boolFlag ? undefined : listViewDisplayPanel_id.contentItem.left
            rightMargin: boolFlag ? rlSideMargins : undefined
            leftMargin: boolFlag ? undefined : rlSideMargins
        }

        width: Math.min(messageText_id.implicitWidth + 24,
                        listViewDisplayPanel_id.width - 100)
        height: messageText_id.implicitHeight + 24
        radius: 10

        Label{
            id: messageText_id
            text: message
            color: "black"
            anchors.fill: parent
            anchors.margins: 12
            wrapMode: Label.Wrap
        }
    }

    //TODO: add custom ScrollBar as telegram
    // ScrollBar.vertical: ScrollBar { }
}


import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ChatClient_QML 1.0


Rectangle{
    id: searchResultPanel_id
    color: "transparent"

    Rectangle{
        id: resultGlobalSearch_id
        width: parent.width
        height: 30
        color: "cornsilk"
        Text{
            anchors{
                fill: parent
                leftMargin: 10
            }
            verticalAlignment: Text.AlignVCenter
            text: "Results global search"
        }
    }

    ListView{
        height: parent.height - resultGlobalSearch_id.height
        anchors{
            // fill: parent
            top: resultGlobalSearch_id.bottom
            left: parent.left
            right: parent.right
            // bottom: parent.bottom
        }
        model: ListModel{
            id: searchModel_id
            ListElement{
                name: "Contact 1"
                domen: "@sdlfkjdlskfjs"
            }
            ListElement{
                name: "Contact 2"
                domen: "@7907sdfjlksdfj"
            }
        }

        delegate: DelegateSearchPanel{

        }
    }
}

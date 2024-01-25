import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import StyleModule 1.0

Rectangle{
    id: searchResultPanel_id
    color: "transparent"

    ListView{
        anchors.fill: parent
        interactive: false
        clip: true
        model: searchModel
        spacing: 0

        delegate: DelegateSearchPanel{
        }

        header: Rectangle{
            id: resultGlobalSearch_id
            width: parent.width
            height: 30
            color: Style.filled_color
            Text{
                anchors{
                    fill: parent
                    leftMargin: 10
                }
                verticalAlignment: Text.AlignVCenter
                text: "Results global search"
            }
        }
    }
}

pragma Singleton
import QtQuick

QtObject{
    readonly property color base_color: "#FFFFFF"
    readonly property color baseFilled_color: "#2AABEE"
    readonly property color leftSidePanel_color: "#293A4C"
    readonly property color contactElement_color: "#419FD9"
    readonly property color placeholderLight_color: "lightgray"
    readonly property color placeholderDark_color: "gray"

    readonly property color icon_color: "#999999"
    readonly property color icon_color_darker: "#9B9B9B"
    readonly property color icon_color_send_message_darker: "#23B8EE"

    readonly property color filled_color: "#F1F1F1"
    readonly property color filledDark_color: "#BBBBBB"
    readonly property color border_color: "#e7e7e7"

    readonly property color bubble_out_color: "#EEFFDE"
    readonly property color bubble_in_color: "#FFFFFF"
    readonly property color bubble_meta_out_color: "#4FAE4E"
    readonly property color bubble_meta_in_color: "#A0A6AB"

    readonly property color row_selected_text_color: "#FFFFFF"
    readonly property color row_text_secondary: "#8E8E93"

    readonly property color unread_badge_color: baseFilled_color
}

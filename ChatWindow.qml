import QtQuick 2.11
import QtQuick.Controls 2.4
import MCommons 1.0 as MCommons

import "colors.js" as Colors

Item {
    id: root

    property string user_id
    property string title_color
    property int component_margin: 6

    Rectangle {
        id: bg
        anchors.fill: parent
        color: "white"
    }

    MCommons.MessageListModel {
        id: message_model
        userId: root.user_id
        chatManager: chat_manager
    }

    Item {
        id: header
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        height: Math.max(title.height, btn_exit.height) + 2*component_margin
        Rectangle {
            anchors.fill: parent
            color: Colors.TANGO_SKYBLUE2
        }

        Text {
            id: title
            anchors {
               centerIn: parent
            }

            font.pointSize: 30
            text: user_name
            color: "white"
        }

        ChatButton {
            id: btn_exit
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: component_margin
            }

            icon_source: "images/cross.svg"
            onClicked: {
                user_active = false
            }
        }
    }

    ListView {
        id: scroll_wrapper

        anchors {
            top: header.bottom
            topMargin: 2
            bottom: footer.top
            bottomMargin: 2
            left: parent.left
            right: parent.right
        }

        model: message_model
        spacing: 3
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        delegate: ChatDelegate {
            width: parent.width
            max_text_width: Math.floor(width * 0.9)
            alternative_style: model.sender_id === root.user_id
        }

        onCountChanged: {
            currentIndex = count - 1
        }

        ScrollIndicator.vertical: ChatScrollIndicator {}
    }

    Item {
        id: footer
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        height: Math.max(input_edit.height, btn_send.height) + 2*component_margin

        Rectangle {
            anchors.fill: parent
            color: Colors.TANGO_SKYBLUE2
        }

        ChatTextEdit {
            id: input_edit
            anchors {
                left: parent.left
                leftMargin: component_margin
                right: btn_send.left
                rightMargin: component_margin
                verticalCenter: parent.verticalCenter
            }

            font.pointSize: 20
            forwardTo_list: [key_handler]

            Item {
                id: key_handler

                Keys.onPressed: {
                    if((event.key === Qt.Key_Return
                            || event.key ===  Qt.Key_Enter)
                            && event.modifiers === Qt.NoModifier)
                    {
                        send_message()
                        event.accepted = true;
                    }
                }
            }
        }

        ChatButton {
            id: btn_send
            anchors {
                right: parent.right
                rightMargin: component_margin
                verticalCenter: parent.verticalCenter
            }

            icon_source: "images/arrow_up.svg"
            onClicked: {
                send_message()
            }
        }
    }

    function send_message(text) {
        if(input_edit.text.length) {
            message_model.send_message(input_edit.text.trim());
            input_edit.text = ""
        }
    }
}

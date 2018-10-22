import QtQuick 2.11
import "colors.js" as Colors

Item {
    id: delegate
    height: loader.height

    property int max_text_width: 100
    property int margin: 5
    property bool alternative_style: false

    Loader {
        id: loader
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 2*12

        sourceComponent: {
            if(type == "chat") {
                return chat_delegate
            } else if(type == "info") {
                return info_delegate
            }
            return null
        }
    }

    Component {
        id: chat_delegate

        Item {
            height: bubble.height

            Item {
                id: bubble
                anchors {
                    left: alternative_style ? undefined : parent.left
                    right: alternative_style ? parent.right : undefined
                }

                width: Math.max(user_label.width, text_label.paintedWidth) + 2*margin
                height: text_label.y + text_label.height + 2*margin

                Rectangle {
                    id: bg
                    anchors.fill: parent
                    radius: 4
                    color: alternative_style ? Colors.TANGO_CHAMELEON2 : Colors.TANGO_CHOCOLATE1
                }

                Text {
                    id: user_label
                    anchors {
                        top: parent.top
                        topMargin: delegate.margin
                        left: alternative_style ? undefined : parent.left
                        right: alternative_style ? parent.right : undefined
                        leftMargin: delegate.margin
                        rightMargin: delegate.margin
                    }
                    text: {
                        var t = ""
                        if(!alternative_style) {
                            t = model.sender_id + ", "
                        }

                        t += format_time(model.time)
                        return t
                    }
                    font.bold: true
                    font.pointSize: 12
                }

                Text {
                    id: text_label
                    width: max_text_width
                    anchors {
                        top: user_label.bottom
                        left: parent.left
                        leftMargin: delegate.margin
                    }

                    text: model.text
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    font.pointSize: 14
                }
            }
        }
    }

    Component {
        id: info_delegate

        Item {
            height: childrenRect.height
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: format_time(model.time)+" - "+model.text
                font.italic: true
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    function format_time(time) {
        return time.toLocaleString(Qt.locale(),"hh:mm:ss")
    }
}

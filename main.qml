import QtQuick 2.11
import QtQuick.Window 2.2
import ChatManager 1.0 as ChatManager

Window {
    id: window
    visible: true
    width: 700
    height: 720
    minimumHeight: 480
    minimumWidth: 640
    title: qsTr("MChat")

    property int spacing: 2

    ChatManager.ChatManager {
        id: chat_manager
    }

    ListModel {
        id: user_model
        ListElement {
            user_name: "Alice"
            user_active: false
        }
        ListElement {
            user_name: "Bob"
            user_active: false
        }
//        ListElement {
//            user_name: "Charlie"
//            user_active: false
//        }
//        ListElement {
//            user_name: "Dan"
//            user_active: false
//        }
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.6
    }

    GridView {
        id: chat_grid
        anchors.fill: parent

        model: user_model
        boundsBehavior: Flickable.StopAtBounds

        property int max_colums: user_model.count > 2 ? 2 : 1

        cellWidth: Math.floor(width/max_colums)
        cellHeight: Math.floor(height / 2)

        delegate: Item {
            id: wrapper

            width: GridView.view.cellWidth
            height: GridView.view.cellHeight

            objectName: "888" + user_name
            focus: false
            Loader {
                anchors {
                    fill: parent
                    margins: 6
                }
                sourceComponent: {
                    if(user_active) {
                        return active_component
                    } else {
                         return inactive_component
                    }
                }
            }

            Component {
                id: active_component
                Item {
                    ChatWindow {
                        anchors {
                            fill: parent
                        }
                        user_id: user_name
                    }
                }
            }

            Component {
                id: inactive_component
                Item {
                    Rectangle {
                        id: bg
                        anchors.fill: parent
                        color: "white"
                        opacity: 0.7
                    }

                    Text {
                        id: user_label
                        anchors.centerIn: parent
                        text: user_name
                        font.pointSize: 40
                    }

                    ChatButton {
                        id: btn_send
                        anchors {
                            top: user_label.bottom
                            horizontalCenter: user_label.horizontalCenter
                        }

                        icon_source: "images/add.svg"
                        onClicked: {
                            user_active = true
                        }
                    }
                }
            }
        }
    }
}

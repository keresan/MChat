import QtQuick 2.11

ChatPressable {
    id: button
    width: 40
    height: 40
    radius: Math.floor(width/2)

    property url icon_source

    Image {
        id: image
        anchors.centerIn: parent
        width: parent.width - 4
        height: parent.width - 4
        source: icon_source
        fillMode: Image.PreserveAspectFit
    }
}

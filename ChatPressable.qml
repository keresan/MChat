import QtQuick 2.11
import "colors.js" as Colors

Rectangle {
    id: pressable

    property color default_color: "transparent"

    signal clicked();

    MouseArea {
        id: mouse_area
        anchors.fill: parent
        onClicked: pressable.clicked()
    }

    color: mouse_area.pressed ? Colors.TANGO_ORANGE2 : default_color
}

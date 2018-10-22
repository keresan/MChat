import QtQuick 2.11
import QtQuick.Controls 2.4

ScrollIndicator {
    size: 0.3
    position: 0.2
    orientation: Qt.Vertical

    property bool visible_when_inactive: false

    visible: {
        if(orientation == Qt.Vertical) {
            var indicator_needed = parent.height < parent.contentHeight
        } else {
            indicator_needed = parent.width < parent.contentWidth
        }

        return indicator_needed && (visible_when_inactive || active)
    }

    contentItem: Rectangle {
        implicitWidth: 4
        implicitHeight: 10
        color: "black"
        opacity: 0.7
        radius: 2
    }
}

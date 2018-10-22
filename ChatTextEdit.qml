import QtQuick 2.11
import QtQuick.Controls 2.4

Item {
    id: wrapper
    width: 100;
    height: flick.height + 4;

    property alias text: edit.text
    property alias font: edit.font
    property alias selectByMouse: edit.selectByMouse
    property alias selectByKeyboard: edit.selectByKeyboard
    property variant forwardTo_list: []
    property int min_visible_lines: 1
    property int max_visible_lines: 3

    FontMetrics {
        id: font_metrics
        font: edit.font
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: 3
        color: "white"
    }

    Flickable {
         id: flick
         anchors.centerIn: parent
         width: parent.width
         height: resolveMinimumHeight();

         contentWidth: edit.paintedWidth
         contentHeight: edit.paintedHeight
         clip: true
         flickableDirection: Flickable.VerticalFlick
         boundsBehavior: Flickable.StopAtBounds

         ScrollIndicator.vertical: ChatScrollIndicator {
             visible_when_inactive: true
         }

         TextEdit {
             id: edit
             width: flick.width

             focus: true
             wrapMode: TextEdit.Wrap
             onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
             Keys.forwardTo: forwardTo_list
             selectByMouse: true
             selectByKeyboard: true
             leftPadding: 8
             rightPadding: 8
             topPadding: 2
             bottomPadding: 2
             font.pointSize: 14

             /* This is to avoid loosing of a focus to anoter component when
                arrow key is pressed while cursor is on the edge of the text. */
             KeyNavigation.left: edit
             KeyNavigation.right: edit
             KeyNavigation.up: edit
             KeyNavigation.down: edit
         }

         function ensureVisible(r) {
             if (contentX >= r.x) {
                 contentX = r.x;
             } else if (contentX+width <= r.x+r.width) {
                 contentX = r.x+r.width-width;
             }

             if (contentY >= r.y) {
                 contentY = r.y;
             } else if (contentY+height <= r.y+r.height) {
                 contentY = r.y+r.height-height;
             }
         }
     }

    function resolveMinimumHeight() {
        var lines = Math.max(min_visible_lines, Math.min(max_visible_lines, edit.lineCount))
        var h = lines * font_metrics.lineSpacing + 1 + edit.topPadding + edit.bottomPadding;
        return  Math.ceil(h)
    }
}

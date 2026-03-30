import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    property alias text: label.text
    property alias textColor: label.color
    property alias textWidth: label.contentWidth

    signal clicked()

    Layout.fillHeight: true
    Layout.alignment: Qt.AlignVCenter

    Layout.preferredWidth: label.contentWidth + 20

    radius: 4

    border.color: "black"
    border.width: 0.5

    color: tapHandler.pressed ? '#00CCCC' : hoverHandler.hovered ? '#00DDDD' : '#00FFFF'

    Text {
        id: label
        anchors.centerIn: parent

        text: 'none'
        color: 'black'
    }

    TapHandler {
        id: tapHandler
        onTapped: clicked()
    }

    HoverHandler {
        id: hoverHandler
    }
}

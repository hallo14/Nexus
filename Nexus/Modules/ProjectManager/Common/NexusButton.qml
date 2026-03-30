import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Item {

    property alias text: label.text
    property alias textColor: label.color
    property alias textWidth: label.contentWidth
    //property alias glowColor: effect.shadowColor

    signal clicked()

    Layout.fillHeight: true
    Layout.alignment: Qt.AlignVCenter

    Layout.preferredWidth: label.contentWidth + 20


    Rectangle {
        id: rectangle

        anchors.fill: parent

        radius: 4

        border.color: "#006666"
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

    // MultiEffect {
    //     id: effect
    //     source: rectangle
    //     anchors.fill: rectangle
    //     shadowEnabled: true
    //     shadowBlur: 1.0
    //     shadowColor: rectangle.color
    //     shadowOpacity: 0.3
    //     shadowVerticalOffset: 0
    //     shadowHorizontalOffset: 0
    // }
}

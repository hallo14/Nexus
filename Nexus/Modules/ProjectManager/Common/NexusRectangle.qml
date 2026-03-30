import QtQuick 2.15
import QtQuick.Effects
import QtQuick.Layouts

Item {
    id: root

    property alias color: rectangle.color
    property alias border: rectangle.border
    property alias shadowColor: effect.shadowColor

    Rectangle {
        id: rectangle
        anchors.fill: parent
    }

    MultiEffect {
        id: effect
        source: rectangle
        anchors.fill: rectangle
        shadowEnabled: true
        shadowBlur: 1.0
        shadowVerticalOffset: 3
        shadowHorizontalOffset: 3
    }

}

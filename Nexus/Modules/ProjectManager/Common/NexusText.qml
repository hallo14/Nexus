import QtQuick 2.15

Item {

    property alias text: label.text
    property alias color: label.color
    property alias font: label.font
    property alias contentWidth: label.contentWidth
    property alias contentHeight: label.contentHeight
    property alias textVAlign: label.verticalAlignment
    property alias textHAlign: label.horizontalAlignment

    height: label.implicitHeight
    width: parent.width

    Text {
        id: label

        anchors.fill: parent

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft

        elide: Text.ElideRight
        clip: true

        text: 'none'
        color: 'black'
    }
}

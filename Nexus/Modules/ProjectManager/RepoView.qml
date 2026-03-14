import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: projectlist

    property var backend

    Layout.fillHeight: true
    Layout.preferredWidth: root.width * 0.3
    Layout.margins: 10

    color: "#999"

    border.color: "#555"
    border.width: 1

    ListView {
        anchors.fill: parent

        model: backend.repoList

        delegate: ItemDelegate {
            width: projectlist.width
            text: modelData.name
        }
    }
}

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

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            Layout.maximumHeight: 30
            spacing: 0

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true

                color: "green"

                Button {
                    anchors.right: parent.right
                    height: parent.height
                    width: parent.height

                    onClicked: {
                        backend.fetchRepos()
                    }
                }
            }

        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            model: backend.repoList

            delegate: ItemDelegate {
                id: repo
                width: projectlist.width
                text: modelData.name

                background: Rectangle {
                    color: repo.down ? '#444' : '#666'
                    border.color: '#444'
                    border.width: 1

                }
            }
        }
    }
}

import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls
import Modules.ProjectManager 1.0

ColumnLayout {
    id: repoInfoView

    required property GithubController backend

    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.margins: 10

    spacing: 0

    Rectangle {
        id: topbar

        Layout.preferredHeight: 30
        Layout.fillWidth: true

        color: "#666"

        border.color: "#555"
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.margins: 5

            Text {
                text: backend.selectedRepo.name
                Layout.fillWidth: true

                Layout.alignment: Qt.AlignVCenter
                verticalAlignment: Text.AlignVCenter
            }

            Rectangle {
                id: addCommand


                Layout.fillHeight: true
                Layout.alignment: Qt.AlignVCenter

                Layout.preferredWidth: addCommandText.contentWidth + 20

                radius: 4

                border.color: "black"
                border.width: 0.5

                color: tapHandler.pressed ? '#00CCCC' : hoverHandler.hovered ? '#00DDDD' : '#00FFFF'

                Text {
                    id: addCommandText
                    anchors.centerIn: parent

                    text: 'add command'
                    color: 'black'
                }

                TapHandler {
                    id: tapHandler

                    onTapped: {

                    }
                }

                HoverHandler {
                    id: hoverHandler
                }
            }
        }
    }

    RowLayout {
        Layout.fillHeight: true
        Layout.fillWidth: true
        spacing: 0

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true

            color: "#999"

            border.color: "#555"
            border.width: 1
        }

        CommandList {
            backend: repoInfoView.backend
        }
    }
}


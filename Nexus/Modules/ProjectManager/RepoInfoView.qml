import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls
import Modules.ProjectManager 1.0

NexusRectangle {
    id: repoInfoView

    required property GithubController backend

    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.margins: 10

    color: "#000"
    shadowColor: "#555"
    border.color: "transparent"
    border.width: 0

    ColumnLayout {
        id: layout

        anchors.fill: parent

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

                NexusButton {
                    text: "add command"

                    CommandDialog {
                        id: commandDialog
                        onAccepted: backend.addCommand(name, command)
                    }

                    onClicked: commandDialog.open()
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
}

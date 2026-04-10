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
                    Layout.preferredWidth: 90

                    CommandDialog {
                        id: commandDialog
                        onAccepted: backend.addCommand(name, commands())
                    }

                    onClicked: {
                        commandDialog.clear()
                        commandDialog.open()
                    }
                }
            }
        }

        SplitView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: -1
            handle: Rectangle {
                implicitWidth: 2
                color: "#666"
            }

            RepoActionView {

            }

            CommandList {
                backend: repoInfoView.backend
            }
        }
    }
}

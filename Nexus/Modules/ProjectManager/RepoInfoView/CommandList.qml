import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls
import Modules.ProjectManager 1.0

Rectangle {
    id: commandList

    required property GithubController backend

    Layout.fillHeight: true
    Layout.preferredWidth: root.width * 0.3

    color: "#999"

    border.color: "#555"
    border.width: 1


    ListView {
        anchors.fill: parent

        model: Object.keys(backend.selectedRepo.commands)

        delegate: RowLayout {

            width: commandList.width
            spacing: 0

            ItemDelegate {
                id: repoCommand
                Layout.fillWidth: true

                contentItem: Column {

                    NexusText {
                        text: modelData
                        font.bold: true
                        color: "black"
                    }
                    NexusText {
                        text: backend.selectedRepo.commands[modelData]
                        color: "#666"
                    }
                }



                background: Rectangle {
                    color: repoCommand.down ? '#CCC' : '#EEE'
                    border.color: '#444'
                    border.width: 1

                    anchors.fill: parent

                    topLeftRadius: 4
                    bottomLeftRadius: 4

                    anchors.margins: 3
                    anchors.rightMargin: 0
                }

                CommandContextMenu {
                    id: contextMenu
                    y: repoCommand.height

                    MenuItem {
                        text: "execute"
                        onTriggered: backend.executeCommand(backend.selectedRepo.commands[modelData])
                    }
                    MenuItem {
                        text: "delete"
                    }
                }

                onClicked: backend.executeCommand(backend.selectedRepo.commands[modelData])
            }

            NexusButton {
                Layout.preferredWidth: 30

                text: "\u270E"
                rect.color: pressed ? '#FFA000' : hovered ? '#FFB300' : '#FFC107'
                font.pixelSize: 16
                textRotation: 100

                rect.radius: 0

                Layout.margins: 3
                Layout.leftMargin: 0
                Layout.rightMargin: 0

                CommandDialog {
                    id: commandDialog
                    name: modelData
                    command: backend.selectedRepo.commands[modelData]
                    onAccepted: backend.addCommand(name, command)
                }

                onClicked: commandDialog.open()
            }

            NexusButton {
                Layout.preferredWidth: 30

                text: "\u00D7"
                rect.color: pressed ? '#880E4F' : hovered ? '#B71C1C' : '#D32F2F'
                font.pixelSize: 16

                rect.topLeftRadius: 0
                rect.bottomLeftRadius: 0

                Layout.margins: 3
                Layout.leftMargin: 0

                onClicked: backend.removeCommand(modelData)
            }
        }
    }
}

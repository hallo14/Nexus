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

                    Text {
                        text: modelData
                        font.bold: true
                        color: "black"
                    }
                    Text {
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

                onClicked: contextMenu.open()
            }

            NexusButton {
                Layout.preferredWidth: 30

                text: "X"

                rect.topLeftRadius: 0
                rect.bottomLeftRadius: 0

                Layout.margins: 3
                Layout.leftMargin: 0

                onClicked: backend.removeCommand(modelData)
            }
        }
    }
}

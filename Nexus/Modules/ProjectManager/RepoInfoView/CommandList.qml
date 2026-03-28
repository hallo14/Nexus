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

        delegate: ItemDelegate {
            id: repoCommand
            width: commandList.width


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
                anchors.margins: 3

                radius: 4
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
    }
}

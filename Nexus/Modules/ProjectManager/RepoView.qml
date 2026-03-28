import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

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

                color: "#666"

                border.color: "#555"
                border.width: 1

                Button {
                    height: parent.height

                    contentItem: Text {
                        verticalAlignment: Text.AlignVCenter
                        text: "add Repo"
                        color: "black"

                    }

                    onClicked: {
                        folderDialog.open()
                    }

                    FolderDialog {
                        id: folderDialog

                        onAccepted: {
                            backend.addLocalRepo(folderDialog.selectedFolder)
                        }
                    }
                }

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

                contentItem: Text {
                    text: modelData.name
                    color: "black"

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                }

                background: Rectangle {
                    color: repo.down ? '#CCC' : '#EEE'
                    border.color: '#444'
                    border.width: 1

                    anchors.fill: parent
                    anchors.margins: 3

                    radius: 4
                }
            }
        }
    }
}

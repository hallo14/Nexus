import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Effects

NexusRectangle {
    id: projectlist
    property var backend

    Layout.fillHeight: true
    Layout.preferredWidth: root.width * 0.3
    Layout.margins: 10

    color: "#999"

    border.color: "#555"
    shadowColor: "#555"
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        spacing: 0


        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 30

            color: "#666"

            border.color: "#555"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                spacing: 0

                NexusButton {

                    Layout.margins: 5

                    height: parent.height
                    width: textWidth + 20

                    text: "add repo"

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

                NexusButton {
                    Layout.margins: 5
                    Layout.alignment: Qt.AlignRight
                    Layout.fillHeight: true
                    Layout.preferredWidth: textWidth + 20

                    text: "refresh"

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

                onClicked: backend.selectedIndex = model.index
            }
        }
    }
}

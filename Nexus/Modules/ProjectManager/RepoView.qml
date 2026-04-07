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


                    Layout.preferredWidth: 60

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

                    text: "\u21BB"
                    font.pixelSize: 16

                    onClicked: {
                        backend.refreshRepos()
                    }
                }
            }

        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            model: backend.repoList

            delegate: RowLayout {

                width: projectlist.width
                spacing: 0

                ItemDelegate {
                    id: repo

                    Layout.fillWidth: true

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


                        topLeftRadius: 4
                        bottomLeftRadius: 4

                        anchors.margins: 3
                        anchors.rightMargin: 0
                    }

                    onClicked: backend.selectedIndex = model.index
                }

                NexusButton {
                    text: "x"
                    rect.color: pressed ? '#880E4F' : hovered ? '#B71C1C' : '#D32F2F'

                    Layout.preferredWidth: 30

                    rect.topLeftRadius: 0
                    rect.bottomLeftRadius: 0

                    Layout.margins: 3
                    Layout.leftMargin: 0

                    onClicked: backend.removeLocalRepo(model.index, modelData.name)
                }
            }
        }
    }
}

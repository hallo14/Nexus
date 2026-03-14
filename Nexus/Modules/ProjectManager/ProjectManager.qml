import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Modules.ProjectManager 1.0

Item {

    Layout.fillWidth: true
    Layout.fillHeight: true

    id: root

    GithubController {
        id: backend
        Component.onCompleted: backend.fetchRepos()
    }

    Rectangle {
        anchors.fill: parent
        color: "orange"

        RowLayout {

            anchors.fill: parent

            ColumnLayout {

                Layout.fillHeight: true
                Layout.fillWidth: true



                Rectangle {
                    id: projectlist

                    Layout.fillHeight: true
                    Layout.preferredWidth: root.width * 0.3
                    Layout.margins: 10

                    color: "#999"

                    ListView {
                        anchors.fill: parent

                        model: backend.repoList

                        delegate: ItemDelegate {
                            width: projectlist.width
                            text: modelData.name
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.margins: 10

                color: "#999"
            }

        }

    }

}

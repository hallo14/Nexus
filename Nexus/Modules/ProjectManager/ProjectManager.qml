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

        ColumnLayout {

            anchors.fill: parent

            TopBar {
                backend: backend
            }

            RowLayout {

                Layout.fillHeight: true
                Layout.fillWidth: true


                RepoView {
                    backend: backend
                }



                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.margins: 10

                    color: "#999"

                    border.color: "#555"
                    border.width: 1
                }

            }
        }
    }

}

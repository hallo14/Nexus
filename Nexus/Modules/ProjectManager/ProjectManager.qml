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

    Loader {
        id: popupLoader
        anchors.fill: parent
        active: false
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
                spacing: 0


                RepoView {
                    backend: backend
                }


                RepoInfoView {
                    backend: backend
                }

            }
        }
    }

    function showPopup(sourceFile, properties) {
        popupLoader.active = true
        popupLoader.setSource(sourceFile, properties)
    }
}

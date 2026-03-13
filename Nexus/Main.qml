import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Modules.ProjectManager 1.0
import Modules.Vault 1.0

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Nexus")

    ColumnLayout {

        anchors.fill: parent
        spacing: 0

        TabBar {

            id: tabBar
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            spacing: 1

            TabButton {
                id: projectManagerTab
                implicitHeight: parent.height

                text: "ProjectManager"

                background: Rectangle {
                    color: projectManagerTab.checked ? "#555" : "#444"

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: projectManagerTab.width
                        height: 2
                        color: "#DDF"

                        visible: projectManagerTab.checked
                    }
                }
            }
            TabButton {
                id: vaultTab
                implicitHeight: parent.height

                text: "Vault"

                background: Rectangle {
                    color: vaultTab.checked ? "#555" : "#444"

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: vaultTab.width
                        height: 2
                        color: "#DDF"

                        visible: vaultTab.checked
                    }
                }
            }
        }

        StackLayout {

            Layout.fillWidth: true
            Layout.fillHeight: true

            currentIndex: tabBar.currentIndex

            ProjectManager {

            }

            Vault {

            }

        }
    }

}

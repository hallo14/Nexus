import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls
import Modules.ProjectManager 1.0
import Modules.Vault 1.0

ColumnLayout {

    anchors.fill: parent
    spacing: 0

    TabBar {

        id: tabBar
        Layout.fillWidth: true
        Layout.preferredHeight: 40
        spacing: 1

        background: Rectangle {
            color: 'black'
        }

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

        Loader {
            active: true
            sourceComponent: ProjectManager {}
        }

        Loader {
            active: true
            sourceComponent: Vault {}
        }

    }
}

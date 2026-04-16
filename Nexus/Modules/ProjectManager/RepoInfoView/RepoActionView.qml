import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls 2.15
import Modules.ProjectManager 1.0

Rectangle {
    SplitView.fillHeight: true
    SplitView.fillWidth: true

    color: "#999"

    border.color: "#555"
    border.width: 1

    property var currentTerminal: terminalRepeater.itemAt(backend.selectedIndex)

    SplitView {
        anchors.fill: parent
        orientation: Qt.Vertical
        handle: Rectangle {
            implicitHeight: 2
            color: "#555"
        }

        Rectangle {
            SplitView.fillHeight: true
            color: "transparent"
        }

        StackLayout {
            SplitView.preferredHeight: parent.height * 0.5
            SplitView.preferredWidth: parent.width

            currentIndex: backend.selectedIndex

            Repeater {
                id: terminalRepeater
                model: backend.repoList

                delegate: Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    NexusTerminalWrapper {
                        dir: modelData.localPath
                        anchors.fill: parent
                    }
                }
            }
        }
    }
}

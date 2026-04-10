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

        ColumnLayout {
            SplitView.preferredHeight: parent.height * 0.4
            spacing: -1

            Terminal {
                id: terminal
                dir: backend.selectedRepo.localPath
            }
            ScrollView {
                id: terminalScroll

                Layout.fillWidth: true
                Layout.fillHeight: true

                ScrollBar.vertical.policy: ScrollBar.AlwaysOff

                TextArea {
                    width: ScrollView.availableWidth
                    height: ScrollView.availableHeight
                    readOnly: true
                    text: terminal.buffer
                    wrapMode: Text.Wrap
                    font.family: "monospace"
                    onTextChanged: {
                            cursorPosition = text.length
                    }
                }
            }

            TextField {
                Layout.fillWidth: true
                Layout.preferredHeight: 30
                placeholderText: "Command..."
                onTextChanged: terminal.command = text
                onAccepted: {
                    terminal.executeCommand()
                    text = ""
                }
            }
        }
    }
}

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
                    id: terminalArea
                    width: ScrollView.availableWidth
                    height: ScrollView.availableHeight
                    readOnly: true
                    text: terminal.buffer
                    color: "white"
                    wrapMode: Text.Wrap
                    font.family: "monospace"
                    onTextChanged: {
                            cursorPosition = text.length
                    }
                    background: Rectangle {
                        color: "black"
                        border.color: "gray"
                        border.width: 1
                    }

                    Shortcut {
                        sequences: [ StandardKey.Copy ]
                        onActivated: {
                            if (terminalArea.selectedText === "") {
                                terminal.stopCommand();
                            } else {
                                terminalArea.copy();
                            }
                        }
                    }
                }
            }

            TextField {
                id: terminalInput
                Layout.fillWidth: true
                Layout.preferredHeight: 30
                placeholderText: "Command..."
                enabled: terminal ? !terminal.processRunning : false
                onTextChanged: terminal.command = text
                onAccepted: {
                    terminal.executeCommand()
                    text = ""
                }
            }
        }
    }
}

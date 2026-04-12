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

        ColumnLayout {
            SplitView.preferredHeight: parent.height * 0.4
            spacing: -1

            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: backend.selectedIndex

                Repeater {
                    id: terminalRepeater
                    model: backend.repoList

                    delegate: ColumnLayout {
                        spacing: -1

                        Terminal {
                            id: terminal
                            dir: modelData.localPath
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
                                    border.color: "black"
                                    border.width: 1
                                }

                                Shortcut {
                                    sequences: [ StandardKey.Copy ]
                                    enabled: index === backend.selectedIndex
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
                            placeholderTextColor: "gray"
                            enabled: terminal ? !terminal.processRunning : false


                            onTextEdited: terminal.command = text
                            onAccepted: {
                                terminal.executeCommand()
                                text = ""
                            }
                            Keys.onPressed: (event) => {
                                if (event.key === Qt.Key_Up) {
                                    terminal.incrementIndex(1);
                                    event.accepted = true;
                                }
                                else if (event.key === Qt.Key_Down) {
                                    terminal.incrementIndex(-1);
                                    event.accepted = true;
                                }
                            }

                            background: Rectangle {
                                color: enabled ? "white" : "gray"
                                border.color: "black"
                                border.width: 1
                            }

                            Binding {
                                target: terminalInput
                                property: "text"
                                value: terminal.command
                            }
                        }
                    }
                }
            }
        }
    }
}

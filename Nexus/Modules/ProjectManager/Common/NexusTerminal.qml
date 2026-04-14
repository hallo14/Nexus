import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls
import Modules.ProjectManager 1.0

ColumnLayout {
    anchors.fill: parent
    spacing: -1

    property alias dir: terminal.dir

    Terminal {
        id: terminal
        dir: dir

        Component.onCompleted: terminal.printStartupMessage()
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
            terminal.prepareCommand()
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

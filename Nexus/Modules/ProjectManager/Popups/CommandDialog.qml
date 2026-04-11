import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

Dialog {
    id: commandDialog
    title: "New Command"
    anchors.centerIn: Overlay.overlay
    width: Overlay.overlay?.width * 0.6
    height: Overlay.overlay?.height * 0.6
    modal: true
    standardButtons: Dialog.Ok | Dialog.Cancel

    property alias name: nameInput.text
    function commands() {
        let commandList = [];
        for (let i = 0; i < commandModel.count; ++i) {
            commandList.push(commandModel.get(i).cmdText)
        }
        return commandList;
    }
    function loadCommands(commandArray) {
        commandModel.clear()
        for (let cmd of commandArray) {
            commandModel.append({"cmdText": cmd})
        }
    }
    function clear() {
        commandModel.clear()
        commandModel.append({"cmdText": ""})
    }

    ColumnLayout {

        anchors.fill: parent

        TextField {
            id: nameInput
            Layout.fillWidth: true
            placeholderText: "Action Name"
        }

        Label { text: "Commands:"}

        ListModel {
            id: commandModel
            Component.onCompleted: commandModel.append({"cmdText": ""})
        }

        ScrollView {
            id: scrollView
            Layout.fillWidth: true
            Layout.fillHeight: true

            ScrollBar.vertical.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.snapMode: ScrollBar.SnapOnRelease

            Column {

                height: scrollView.availableHeight
                width: scrollView.width

                Repeater {
                    model: commandModel
                    delegate: RowLayout {
                        width: parent.width
                        spacing: -1

                        TextField {
                            Layout.fillWidth: true
                            placeholderText: "command" + (index + 1)
                            text: cmdText
                            onTextChanged: commandModel.setProperty(index, "cmdText", text)
                        }

                        NexusButton {
                            Layout.fillHeight: true
                            Layout.preferredWidth: 30

                            text: "\u00D7"
                            rect.color: pressed ? '#880E4F' : hovered ? '#B71C1C' : '#D32F2F'
                            font.pixelSize: 16

                            rect.topLeftRadius: 0
                            rect.bottomLeftRadius: 0

                            rect.border.color: '#444'
                            rect.border.width: 1

                            visible: commandModel.count > 1

                            onClicked: commandModel.remove(index)

                        }
                    }
                }
            }
        }

        NexusButton {
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.preferredHeight: 20

            text: "add Command"

            onClicked: commandModel.append({"cmdText": ""})
        }
    }
}

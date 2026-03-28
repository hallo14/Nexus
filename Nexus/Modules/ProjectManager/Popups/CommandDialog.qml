import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls

Dialog {
    id: commandDialog
    title: "New Command"
    anchors.centerIn: Overlay.overlay
    modal: true
    standardButtons: Dialog.Ok | Dialog.Cancel

    readonly property alias name: nameInput.text
    readonly property alias command: commandInput.text

    ColumnLayout {

        TextField {
            id: nameInput
            Layout.fillWidth: true
            placeholderText: "Action Name (e.g. Fetch)"
        }
        TextField {
            id: commandInput
            Layout.fillWidth: true
            placeholderText: "Command"
        }

    }
}

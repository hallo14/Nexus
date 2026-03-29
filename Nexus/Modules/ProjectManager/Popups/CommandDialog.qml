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

        anchors.fill: parent

        TextField {
            id: nameInput
            Layout.fillWidth: true
            placeholderText: "Action Name"
        }
        TextField {
            id: commandInput
            Layout.fillWidth: true
            placeholderText: "Command"
        }

    }
}

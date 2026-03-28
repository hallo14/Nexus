import QtQuick
import QtQuick.Layouts
import QtQuick.Controls


Rectangle {

    id: topbar

    property var backend

    Layout.fillWidth: true
    Layout.preferredHeight: 40
    Layout.margins: 10
    Layout.bottomMargin: 0

    color: "#999"
    border.color: "#555"
    border.width: 1


    NexusButton {
        id: login

        anchors.right: topbar.right
        anchors.verticalCenter: topbar.verticalCenter
        anchors.rightMargin: 5

        implicitHeight: topbar.height - 10
        implicitWidth: topbar.height * 2 - 10

        text: 'Sign in'

        onClicked: {
            backend.requestCode()
            showPopup("Popups/LoginPopup.qml", { "backend": backend })
        }
    }
}

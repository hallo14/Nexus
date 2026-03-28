import QtQuick 2.15
import QtQuick.Controls



Popup {
    id: authPopup
    property var backend

    Component.onCompleted: authPopup.open()

    anchors.centerIn: Overlay.overlay
    width: 300
    height: 200
    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    Column {
        anchors.centerIn: parent
        spacing: 10
        Text {
            text: "Enter this code on GitHub:"
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            text: backend.userCode
            font.bold: true
            font.pointSize: 20
            horizontalAlignment: Text.AlignHCenter
        }
        Button {
            text: "Copy and Close"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                authPopup.close();
                backend.copyToClipboard(backend.userCode);
                Qt.openUrlExternally(backend.verificationURI);
            }
            background: Rectangle {
                color: "#A99"
                radius: 2
                border.color: "black"
                border.width: 1
            }
        }
    }

    background: Rectangle {
        color: "#C08686"
        border.color: "black"
        border.width: 2
    }
}

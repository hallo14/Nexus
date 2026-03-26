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


    Button {
        id: login

        anchors.right: topbar.right
        anchors.verticalCenter: topbar.verticalCenter

        height: topbar.height
        width: topbar.height * 2

        contentItem: Text {
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            text: 'Sign in'
            color: 'black'
        }


        background: Rectangle {
            color: '#444'
        }

        onClicked: {
            backend.requestCode();
            authPopup.open();
        }
    }

    Popup {
        id: authPopup
        anchors.centerIn: parent
        width: 300
        height: 200
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        Column {
            anchors.centerIn: parent
            spacing: 10
            Text { text: "Enter this code on GitHub:" }
            Text {
                text: backend.userCode
                font.bold: true
                font.pointSize: 20
            }
            Button {
                text: "Copy and Close"
                onClicked: {
                    authPopup.close();
                    backend.copyToClipboard(backend.userCode);
                    Qt.openUrlExternally(backend.verificationURI);
                }
            }
        }
    }
}

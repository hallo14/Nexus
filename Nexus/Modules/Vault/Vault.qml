import QtQuick
import QtQuick.Layouts

Item {

    Layout.fillWidth: true
    Layout.fillHeight: true

    id: root

    Rectangle {

        anchors.fill: parent
        color: "lime"

        Text {

            anchors.centerIn: parent
            text: "Vault"
        }
    }

}

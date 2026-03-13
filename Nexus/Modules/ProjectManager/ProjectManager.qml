import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {

    Layout.fillWidth: true
    Layout.fillHeight: true

    id: root

    Rectangle {
        anchors.fill: parent
        color: "orange"

        RowLayout {

            anchors.fill: parent

            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.3
                Layout.margins: 10

                color: "#999"
            }

            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.margins: 10

                color: "#999"
            }

        }

    }

}

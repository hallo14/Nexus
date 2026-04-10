import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls 2.15

Rectangle {
    SplitView.fillHeight: true
    SplitView.fillWidth: true

    color: "#999"

    border.color: "#555"
    border.width: 1

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

            TextArea {
                Layout.fillWidth: true
                Layout.fillHeight: true
                readOnly: true
                text: "Hallo\nHallo"
            }

            TextField {
                Layout.fillWidth: true
                Layout.preferredHeight: 30
                placeholderText: "Command..."
            }
        }
    }
}

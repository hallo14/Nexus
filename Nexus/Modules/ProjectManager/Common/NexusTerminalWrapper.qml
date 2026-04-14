import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    id: terminalWrapper
    anchors.fill: parent
    spacing: -1

    property var dir

    ListModel {
        id: listModel
        Component.onCompleted: listModel.append({"terminal":""})
    }

    TabBar {
        id: tabBar
        Layout.fillWidth: true
        Layout.minimumHeight: 20
        Layout.preferredHeight: terminalWrapper.height * 0.1
        spacing: -1

        Repeater{
            model: listModel
            delegate: TabButton {
                height: parent.height
                background: Rectangle {
                    color: "green"
                    border.width: 1
                    border.color: "black"
                }
            }
        }

        TabButton {}
    }


    StackLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        currentIndex: tabBar.currentIndex
        Repeater {
            model: listModel
            delegate: NexusTerminal {
                dir: terminalWrapper.dir
            }
        }
    }
}

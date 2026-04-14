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
        Component.onCompleted: listModel.append({"":""})
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
                background: NexusButton {
                    rect.radius: 0
                    rect.color: "green"
                    rect.border.width: 1
                    rect.border.color: "black"
                    text: "Terminal" + (index+1)
                }
            }
        }

        TabButton {
            text: "+"
            onClicked: {
                listModel.append({"":""})
                tabBar.setCurrentIndex(tabBar.count-2)
            }
        }
    }


    StackLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        currentIndex: tabBar.currentIndex
        Repeater {
            model: listModel
            delegate: NexusTerminal {
                Layout.fillHeight: true
                Layout.fillWidth: true
                dir: terminalWrapper.dir
                Component.onCompleted: tabBar.setCurrentIndex(0)
            }
        }
    }
}

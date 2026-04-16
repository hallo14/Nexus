import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    id: terminalWrapper
    spacing: 0

    property var dir

    ListModel {
        id: listModel
        Component.onCompleted: listModel.append({"":""})
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: terminalWrapper.height * 0.1
        spacing: -1

        TabBar {
            id: tabBar
            Layout.fillWidth: true
            Layout.fillHeight: true
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

        }
        Button {
            text: "+"
            Layout.preferredWidth: 40
            Layout.fillHeight: true
            onClicked: {
                listModel.append({"":""})
                tabBar.setCurrentIndex(tabBar.count-1)
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

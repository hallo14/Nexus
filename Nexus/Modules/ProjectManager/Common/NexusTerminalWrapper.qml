import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    id: terminalWrapper
    spacing: -1

    property var dir

    ListModel {
        id: listModel
        Component.onCompleted: listModel.append({"":""})
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: terminalWrapper.height * 0.1
        Layout.maximumHeight: 40
        spacing: -1

        TabBar {
            id: tabBar
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: -1

            background: Item {}

            Repeater{
                model: listModel
                delegate: TabButton {
                    implicitHeight: tabBar.height
                    implicitWidth: tabBar.width / listModel.count * 0.8
                    contentItem: Text {
                        text: "Terminal" + (index+1)
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        color: tabBar.currentIndex === index ? "#000000" : "#B0BEC5"
                    }

                    background: NexusRectangle {
                        anchors.fill: parent
                        effect.shadowEnabled: false
                        color: tabBar.currentIndex === index ? "#37474F" : "#212121"
                        border.color: "#006666"
                        border.width: 0.5


                    }
                    NexusButton {
                        rect.radius: 0
                        x: tabBar.width / listModel.count * 0.8
                        implicitWidth: tabBar.width / listModel.count * 0.2
                        implicitHeight: tabBar.height
                        rect.color: pressed ? '#880E4F' : hovered ? '#FF5252' : '#D32F2F'

                        text: "\u00D7"
                        textColor: tabBar.currentIndex === index ? "#000000" : "#B0BEC5"
                        onClicked: listModel.remove(index)
                    }
                }
            }
        }
        NexusButton {
            text: "+"
            rect.radius: 0
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
            }
        }
    }
}

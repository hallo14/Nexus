import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Nexus")
    color: "aqua"

    Text {
        anchors.centerIn: parent
        text: "Loading... :D"
        font.pixelSize: 16

    }


    Loader {
        id: nexus
        active: false
        anchors.fill: parent
        asynchronous: true
        source: "qrc:/qt/qml/Nexus/Nexus.qml"
    }

    Component.onCompleted: nexus.active = true

}

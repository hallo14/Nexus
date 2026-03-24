import QtQuick
import QtQuick.Layouts
import QtQuick.Controls


Rectangle {

    id: topbar

    Layout.fillWidth: true
    Layout.preferredHeight: 40
    Layout.margins: 10
    Layout.bottomMargin: 0

    color: "#999"
    border.color: "#555"
    border.width: 1


    Button {
        anchors.right: topbar.right
        anchors.verticalCenter: topbar.verticalCenter

        height: topbar.height
        width: topbar.height

        contentItem: Text {
            text: 'Sign in'
            color: 'black'
        }


        background: Rectangle {


            color: '#444'

        }
    }


}

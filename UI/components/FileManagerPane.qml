import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Pane {
    property alias toolbar: toolbar
    property alias columnHeaders: columnHeaders
    property alias fileListView: fileListView
    property alias fileModel: fileModel

    Rectangle {
        anchors.fill: parent

        Toolbar {
            id: toolbar
        }

        ColumnHeaders {
            id: columnHeaders
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 50
            anchors.leftMargin: 20
        }

        FileList {
            id: fileListView
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.topMargin: 80
        }

        ListModel {
            id: fileModel
        }
    }
}
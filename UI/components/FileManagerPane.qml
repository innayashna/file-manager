import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Pane {
    id: fileManagerPane

    property alias toolbar: toolbar
    property alias columnHeaders: columnHeaders
    property alias fileListView: fileListView
    property alias fileModel: fileModel

    property string currentDirectory: "/"
    property string currentDirectoryShortPath: "/"
    property var directoryHistory: []

    property bool showExtension: true
    property bool showSize: true
    property bool showDate: true

    Rectangle {
        anchors.fill: parent

        Toolbar {
            id: toolbar
        }

        ColumnHeaders {
            id: columnHeaders
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 40
            anchors.leftMargin: 20
        }

        FileList {
            id: fileListView
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.topMargin: 70
        }

        ListModel {
            id: fileModel
        }
    }
}
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

    property string activeSort: "sortNone"

    property bool showExtension: true
    property bool showSize: true
    property bool showDate: true

    Rectangle {
        anchors.fill: parent

        Toolbar {
            id: toolbar
        }

        Rectangle {
            color: "gray"
            anchors.top: toolbar.bottom
            anchors.topMargin: 10
            width: 650
            height: 1
        }

        ColumnHeaders {
            id: columnHeaders
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.topMargin: 40
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
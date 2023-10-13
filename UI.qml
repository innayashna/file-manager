import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import FileManager 1.0

ApplicationWindow {
    visible: true
    width: 400
    height: 400
    title: "File Manager"

    Rectangle {
        color: "white"
        anchors.fill: parent

        ListView {
            id: fileListView
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.topMargin: 50;
            model: fileModel

            delegate: Item {
                width: 400
                height: 30

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var selectedItem = model.fullPath;
                        listDirectoryContents(selectedItem);
                    }
                }

                Row {
                    spacing: 5

                    Image {
                        source: model.icon
                        width: 16
                        height: 16
                    }

                    Text {
                        text: model.name
                    }
                }
            }
        }

        Button {
            id: goBackButton
            icon.source: "icons/navigation/arrow-small-left.png"
            onClicked: {
                navigateUp();
            }
            visible: false
            background: Rectangle {
                color: "transparent"
            }
        }

        ListModel {
            id: fileModel
        }
    }

    property string currentDirectory: "/"

    Component.onCompleted: {
        listDirectoryContents("/");
        goBackButton.visible = true;
    }

    function listDirectoryContents(directoryPath) {
        fileModel.clear();
        var result = fileManager.listFilesAndFolders(directoryPath);
        for (var i = 0; i < result.length; ++i) {
            fileModel.append({
                name: result[i].name,
                icon: result[i].icon,
                fullPath: result[i].fullPath});
        }
        currentDirectory = directoryPath;
    }

    function navigateUp() {
        var parts = currentDirectory.split('/');
        if (parts.length > 1) {
            parts.pop(); // Remove the last part (current directory)
            var previousDirectory = parts.join('/');
            // Check if previousDirectory is empty, and if so, set it to "/"
            if (previousDirectory === "") {
                previousDirectory = "/";
            }
            listDirectoryContents(previousDirectory);
        } else {
            // If at the root, just list the contents of the root again
            listDirectoryContents("/");
        }
    }
}

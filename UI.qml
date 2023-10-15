import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import FileManager 1.0

ApplicationWindow {
    visible: true
    width: 700
    height: 600
    title: "File Manager"

    Rectangle {
        color: "white"
        anchors.fill: parent

        Row {
            spacing: 5
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 50
            anchors.leftMargin: 20

            Text {
                text: "Name"
                font.bold: true
                width: 200
            }

            Text {
                text: "Extension"
                font.bold: true
                width: 120
            }

            Text {
                text: "Size"
                font.bold: true
                width: 100
            }

            Text {
                text: "Date Modified"
                font.bold: true
                width: 200
            }
        }

        ListView {
            id: fileListView
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.topMargin: 80
            model: fileModel

            delegate: Item {
                width: 700
                height: 30

                Row {
                    spacing: 5

                    Image {
                        source: model.icon
                        width: 16
                        height: 16
                    }

                    Text {
                        text: model.name
                        width: 200
                    }

                    Text {
                        text: model.extension
                        width: 100
                    }

                    Text {
                        text: model.size
                        width: 100
                    }

                    Text {
                        text: model.dateModified
                        width: 200
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var selectedItem = model.fullPath;
                        listDirectoryContents(selectedItem);
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
                size: result[i].size,
                extension: result[i].extension,
                dateModified: result[i].dateModified,
                fullPath: result[i].fullPath
            });
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

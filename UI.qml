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
                id: nameHeader
                text: "Name"
                font.bold: true
                width: 200
            }

            Text {
                id: extensionHeader
                text: "Extension"
                font.bold: true
                width: 110
            }

            Text {
                id: sizeHeader
                text: "Size"
                font.bold: true
                width: 100
            }

            Text {
                id: dateHeader
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
                        text: model.showExtension ? model.extension : ""
                        width: model.showExtension ? 100 : 0
                    }

                    Text {
                        text: model.showSize ? model.size : ""
                        width: model.showSize ? 100 : 0
                    }

                    Text {
                        text: model.showDate ? model.dateModified : ""
                        width: model.showDateModified ? 200 : 0
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

        Row {
            spacing: 5

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

            Button {
                id: attributeMenuButton
                text: "Attributes"
                font.bold: true

                background: Rectangle {
                    color: "transparent"
                }

                onClicked: attributeMenu.popup()

                Menu {
                    id: attributeMenu
                    y: attributeMenuButton.height
                    MenuItem {
                        id: extensionMenuItem
                        text: "Extension"
                        checkable: true
                        checked: true

                        onCheckedChanged: {
                            updateAttributeVisibility("showExtension", checked);
                        }
                    }
                    MenuItem {
                        id: sizeMenuItem
                        text: "Size"
                        checkable: true
                        checked: true

                        onCheckedChanged: {
                            updateAttributeVisibility("showSize", checked);
                        }
                    }
                    MenuItem {
                        id: dateMenuItem
                        text: "Date Modified"
                        checkable: true
                        checked: true

                        onCheckedChanged: {
                            updateAttributeVisibility("showDate", checked);
                        }
                    }
                }
            }
        }

        ListModel {
            id: fileModel
        }
    }

    property string currentDirectory: "/"
    property bool showExtension: true
    property bool showSize: true
    property bool showDate: true

    Component.onCompleted: {
        listDirectoryContents("/");
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
                fullPath: result[i].fullPath,
                showExtension: showExtension,
                showSize: showSize,
                showDate: showDate
            });
        }
        currentDirectory = directoryPath;
    }

    function navigateUp() {
        var parts = currentDirectory.split('/');
        if (parts.length > 1) {
            parts.pop();
            var previousDirectory = parts.join('/');
            if (previousDirectory === "") {
                previousDirectory = "/";
            }
            listDirectoryContents(previousDirectory);
        } else {
            listDirectoryContents("/");
        }
    }

    function updateAttributeVisibility(attribute, checked) {
        for (var i = 0; i < fileModel.count; ++i) {
            fileModel.get(i)[attribute] = checked;
        }

        switch (attribute) {
            case "showExtension":
                extensionHeader.visible = checked;
                showExtension = checked;
                break;
            case "showSize":
                sizeHeader.visible = checked;
                showSize = checked;
                break;
            case "showDate":
                dateHeader.visible = checked;
                showDate = checked;
                break;
        }
    }
}

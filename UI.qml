import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import FileManager 1.0

ApplicationWindow {
    visible: true
    width: 700
    height: 600
    title: "File Manager"

    property string currentDirectory: "/"
    property var directoryHistory: []
    property string clipboardSourcePath: ""

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
                        const selectedItem = model.fullPath;
                        goBackButton.enabled = true
                        listDirectoryContents(selectedItem);
                        resetSorting();
                    }
                }

                MouseArea {
                    id: fileActionsMenuArea
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton

                    onClicked: (mouse)=> {
                        if (mouse.button === Qt.RightButton) {
                            fileActionsMenu.popup();
                        }
                    }
                }

                Menu {
                    id: fileActionsMenu
                    height: pasteMenuItem.visible ? 120 : 60

                    MenuItem {
                        id: copyMenuItem
                        text: "Copy"
                        onTriggered: {
                            copyItem(model.fullPath)
                        }
                    }

                    MenuItem {
                        id: pasteMenuItem
                        text: "Paste"
                        visible: clipboardSourcePath !== ""
                        onTriggered: {
                            pasteItem(model.fullPath)
                        }
                    }
                }
            }
        }

        Row {
            spacing: 5

            Button {
                id: goBackButton
                icon.source: "icons/navigation/arrow-small-left.png"
                enabled: false
                onClicked: {
                    resetSorting();
                    navigateBack();
                }
                background: Rectangle {
                    color: "transparent"
                }
            }

            Button {
                id: goForwardButton
                icon.source: "icons/navigation/arrow-small-right.png"
                enabled: false
                onClicked: {
                    resetSorting();
                    navigateForward();
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

            Button {
                id: sortMenuButton
                text: "Sort"
                font.bold: true

                background: Rectangle {
                    color: "transparent"
                }

                onClicked: sortMenu.popup()

                Menu {
                    id: sortMenu
                    y: sortMenuButton.height

                    RadioButton {
                        id: sortNone
                        text: "None"
                        checked: true
                        onClicked: {
                            listDirectoryContents(currentDirectory)
                        }
                    }

                    RadioButton {
                        id: sortByName
                        text: "By name"
                        onClicked: {
                            sortDirectoryContentsByName();
                        }
                    }

                    RadioButton {
                        id: sortBySize
                        text: "By size"
                        onClicked: {
                            sortDirectoryContentsBySize();
                        }
                    }

                    RadioButton {
                        id: sortByDateModified
                        text: "By date"
                        onClicked: {
                            sortDirectoryContentsByDateModified();
                        }
                    }
                }
            }
        }

        ListModel {
            id: fileModel
        }
    }

    Component.onCompleted: {
        listDirectoryContents("/");
    }

    property bool showExtension: true
    property bool showSize: true
    property bool showDate: true

    function populateFileModel(result) {
        fileModel.clear();
        for (let i = 0; i < result.length; ++i) {
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
    }

    function listDirectoryContents(directoryPath) {
        const result = fileManager.listFilesAndFolders(directoryPath);
        populateFileModel(result);
        currentDirectory = directoryPath;
    }

    function sortDirectoryContentsByName() {
        const result = fileManager.sortByName(currentDirectory);
        populateFileModel(result);
    }

    function sortDirectoryContentsBySize() {
        const result = fileManager.sortBySize(currentDirectory);
        populateFileModel(result);
    }

    function sortDirectoryContentsByDateModified() {
        const result = fileManager.sortByDateModified(currentDirectory);
        populateFileModel(result);
    }

    function resetSorting() {
        sortNone.checked = true;
    }

    function updateAttributeVisibility(attribute, checked) {
        for (let i = 0; i < fileModel.count; ++i) {
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

    function navigateBack() {
        const parts = currentDirectory.split('/');
        if (parts.length > 1) {
            parts.pop();
            let previousDirectory = parts.join('/');
            if (previousDirectory === "") {
                goBackButton.enabled = false;
                previousDirectory = "/";
            }
            directoryHistory.push(currentDirectory);
            goForwardButton.enabled = true;
            listDirectoryContents(previousDirectory);
        } else {
            listDirectoryContents("/");
        }
    }

    function navigateForward() {
        if (directoryHistory.length >= 1) {
            const forwardDirectory = directoryHistory.pop();
            if (forwardDirectory.startsWith(currentDirectory.toString())) {
                listDirectoryContents(forwardDirectory);
                goBackButton.enabled = true;
            } else {
                goForwardButton.enabled = false;
            }
        }
    }

    function copyItem(sourcePath) {
        clipboardSourcePath = sourcePath;
    }

    function pasteItem(destinationPath) {
        const sourcePath = clipboardSourcePath;

        if (sourcePath && destinationPath) {
            fileManager.copy(sourcePath, destinationPath);
            listDirectoryContents(destinationPath);
            clipboardSourcePath = "";
        }
    }
}

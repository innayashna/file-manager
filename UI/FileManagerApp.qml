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
    property string cutItemPath: ""

    Rectangle {
        color: "white"
        anchors.fill: parent

        ColumnHeaders {
            id: columnHeaders
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 50
            anchors.leftMargin: 20
        }

        FileList {
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.topMargin: 80
        }

        Toolbar {
            id: toolbar
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
                showDate: showDate,
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
                columnHeaders.extensionHeader.visible = checked;
                showExtension = checked;
                break;
            case "showSize":
                columnHeaders.sizeHeader.visible = checked;
                showSize = checked;
                break;
            case "showDate":
                columnHeaders.dateHeader.visible = checked;
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

    property var cutItems: []

    function copyItem(sourcePath) {
        clipboardSourcePath = sourcePath;
        cutItems = [];
    }

    function pasteItem(destinationPath) {
        const sourcePath = clipboardSourcePath;

        if (sourcePath && destinationPath) {
            if (cutItems.includes(sourcePath)) {
                fileManager.copyItem(sourcePath, destinationPath);
                deleteItem(sourcePath);
                cutItems = cutItems.filter(item => item !== sourcePath);
            } else {
                fileManager.copyItem(sourcePath, destinationPath);
            }
            listDirectoryContents(destinationPath);
            clipboardSourcePath = "";
        }
    }

    function deleteItem(fullPath) {
        fileManager.deleteItem(fullPath);
        listDirectoryContents(currentDirectory);
        cutItems = cutItems.filter(item => item !== fullPath);
    }

    function cutItem(fullPath) {
        cutItemPath = fullPath;
        listDirectoryContents(currentDirectory);
        clipboardSourcePath = fullPath;
        cutItems.push(fullPath);
    }

    function renameItem(sourcePath, newName) {
        if (newName !== "") {
            fileManager.renameItem(sourcePath, newName);
            listDirectoryContents(currentDirectory);
        }
    }
}

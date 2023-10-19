import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import FileManager 1.0

import "./components"

ApplicationWindow {
    visible: true
    width: 1300
    height: 650
    title: "File Manager"

    property string currentDirectory: "/"
    property var directoryHistory: []
    property string clipboardSourcePath: ""

    property bool showExtension: true
    property bool showSize: true
    property bool showDate: true

    property string cutItemPath: ""
    property var cutItems: []

    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        FileManagerPane {
            id: leftPane
            implicitWidth: 650
        }

        FileManagerPane {
            id: rightPane
            implicitWidth: 650
        }
    }

    Component.onCompleted: {
        listDirectoryContents( "/", leftPane);
        listDirectoryContents( "/", rightPane);
    }

    function populateFileModel(result, pane) {
        pane.fileModel.clear();
        for (let i = 0; i < result.length; ++i) {
            pane.fileModel.append({
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

    function listDirectoryContents(directoryPath, pane) {
        const result = fileManager.listFilesAndFolders(directoryPath);
        populateFileModel(result, pane);
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
        leftPane.toolbar.sortNone.checked = true;
    }

    function updateAttributeVisibility(attribute, checked) {
        for (let i = 0; i < leftPane.fileModel.count; ++i) {
            leftPane.fileModel.get(i)[attribute] = checked;
        }

        switch (attribute) {
            case "showExtension":
                leftPane.columnHeaders.extensionHeader.visible = checked;
                showExtension = checked;
                break;
            case "showSize":
                leftPane.columnHeaders.sizeHeader.visible = checked;
                showSize = checked;
                break;
            case "showDate":
                leftPane.columnHeaders.dateHeader.visible = checked;
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
                leftPane.toolbar.goBackButton.enabled = false;
                previousDirectory = "/";
            }
            directoryHistory.push(currentDirectory);
            leftPane.toolbar.goForwardButton.enabled = true;
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
                leftPane.toolbar.goBackButton.enabled = true;
            } else {
                leftPane.toolbar.goForwardButton.enabled = false;
            }
        }
    }

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

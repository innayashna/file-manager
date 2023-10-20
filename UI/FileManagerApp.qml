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

    property string clipboardSourcePath: ""
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
                showExtension: pane.showExtension,
                showSize: pane.showSize,
                showDate: pane.showDate
            });
        }
    }

    function listDirectoryContents(directoryPath, pane) {
        const result = fileManager.listFilesAndFolders(directoryPath);
        populateFileModel(result, pane);
        pane.currentDirectory = directoryPath;
    }

    function sortDirectoryContentsByName(pane) {
        const result = fileManager.sortByName(pane.currentDirectory);
        populateFileModel(result, pane);
    }

    function sortDirectoryContentsBySize(pane) {
        const result = fileManager.sortBySize(pane.currentDirectory);
        populateFileModel(result, pane);
    }

    function sortDirectoryContentsByDateModified(pane) {
        const result = fileManager.sortByDateModified(pane.currentDirectory);
        populateFileModel(result, pane);
    }

    function resetSorting(pane) {
        pane.toolbar.sortNone.checked = true;
    }

    function updateAttributeVisibility(attribute, checked, pane) {
        for (let i = 0; i < pane.fileModel.count; ++i) {
            pane.fileModel.get(i)[attribute] = checked;
        }

        switch (attribute) {
            case "showExtension":
                pane.columnHeaders.extensionHeader.visible = checked;
                pane.showExtension = checked;
                break;
            case "showSize":
                pane.columnHeaders.sizeHeader.visible = checked;
                pane.showSize = checked;
                break;
            case "showDate":
                pane.columnHeaders.dateHeader.visible = checked;
                pane.showDate = checked;
                break;
        }
    }

    function navigateBack(pane) {
        const parts = pane.currentDirectory.split('/');
        if (parts.length > 1) {
            parts.pop();
            let previousDirectory = parts.join('/');
            if (previousDirectory === "") {
                pane.toolbar.goBackButton.enabled = false;
                previousDirectory = "/";
            }
            pane.directoryHistory.push(pane.currentDirectory);
            pane.toolbar.goForwardButton.enabled = true;
            listDirectoryContents(previousDirectory, pane);
        } else {
            listDirectoryContents("/", pane);
        }
    }

    function navigateForward(pane) {
        if (pane.directoryHistory.length >= 1) {
            const forwardDirectory = pane.directoryHistory.pop();
            if (forwardDirectory.startsWith(pane.currentDirectory.toString())) {
                listDirectoryContents(forwardDirectory, pane);
                pane.toolbar.goBackButton.enabled = true;
            } else {
                pane.toolbar.goForwardButton.enabled = false;
            }
        }
    }

    function copyItem(sourcePath) {
        console.log(sourcePath)
        cutItems = [];
    }

    function pasteItem(destinationPath, pane) {
        const sourcePath = clipboardSourcePath;

        if (sourcePath && destinationPath) {
            if (cutItems.includes(sourcePath)) {
                fileManager.copyItem(sourcePath, destinationPath);
                deleteItem(sourcePath, pane);
                cutItems = cutItems.filter(item => item !== sourcePath);
            } else {
                fileManager.copyItem(sourcePath, destinationPath);
            }
            listDirectoryContents(destinationPath, pane);
            updateInactivePane(pane);
            clipboardSourcePath = "";
        }
    }

    function deleteItem(fullPath, pane) {
        fileManager.deleteItem(fullPath);
        listDirectoryContents(pane.currentDirectory, pane);
        updateInactivePane(pane);
        cutItems = cutItems.filter(item => item !== fullPath);
    }

    function cutItem(fullPath, pane) {
        cutItemPath = fullPath;
        listDirectoryContents(pane.currentDirectory, pane);
        updateInactivePane(pane);
        clipboardSourcePath = fullPath;
        cutItems.push(fullPath);
    }

    function renameItem(sourcePath, newName, pane) {
        if (newName !== "") {
            fileManager.renameItem(sourcePath, newName);
            listDirectoryContents(pane.currentDirectory, pane);
            updateInactivePane(pane);
        }
    }

    function updateInactivePane(pane) {
        if (pane === rightPane) {
            listDirectoryContents(leftPane.currentDirectory, leftPane);
        } else {
            listDirectoryContents(rightPane.currentDirectory, rightPane);
        }
    }
}

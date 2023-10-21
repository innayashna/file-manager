import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Menu {
    id: fileActionsMenu

    MenuItem {
        id: copyMenuItem
        text: "Copy"
        onTriggered: {
            copyItem(model.fullPath)
        }
    }

    MenuItem {
        id: cutMenuItem
        text: "Cut"
        onTriggered: {
            cutItem(model.fullPath, fileManagerPane)
        }
    }

    MenuItem {
        id: pasteMenuItem
        text: "Paste"
        enabled: clipboardSourcePath !== ""
        onTriggered: {
            if (!model.isDir) {
                fileDialogs.pasteFileIntoFileDialog.open();
                return;
            }

            if (clipboardSourcePath === model.fullPath) {
                fileDialogs.pasteFileIntoItselfDialog.open();
                return;
            }
            pasteItem(model.fullPath, fileManagerPane)
        }
    }

    MenuItem {
        id: renameMenuItem
        text: "Rename"
        onTriggered: {
            menuDialogs.renameDialog.open();
        }
    }

    MenuItem {
        id: deleteMenuItem
        text: "Delete"
        onTriggered: {
            menuDialogs.confirmDeleteDialog.open()
        }
    }

    FileDialogs {
        id: fileDialogs
    }

    Connections {
        target: menuDialogs
    }
}


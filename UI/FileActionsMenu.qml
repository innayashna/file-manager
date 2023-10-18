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
            cutItem(model.fullPath)
        }
    }

    MenuItem {
        id: pasteMenuItem
        text: "Paste"
        enabled: clipboardSourcePath !== ""
        onTriggered: {
            pasteItem(model.fullPath)
        }
    }

    MenuItem {
        id: renameMenuItem
        text: "Rename"
        onTriggered: {
            renameDialog.open();
        }
    }

    MenuItem {
        id: deleteMenuItem
        text: "Delete"
        onTriggered: {
            confirmDeleteDialog.open()
        }
    }

    Dialog {
        id: renameDialog
        title: "Rename Item"
        standardButtons: Dialog.Ok | Dialog.Cancel

        TextInput {
            id: newNameInput
            width: 300
            text: model.name
            selectByMouse: true
        }

        onAccepted: {
            const newName = newNameInput.text.trim();
            if (newName !== "") {
                renameItem(model.fullPath, newName);
            }
        }
    }

    Dialog {
        id: confirmDeleteDialog
        title: "Confirm Deletion"
        standardButtons: Dialog.Ok | Dialog.Cancel

        Text {
            text: "Are you sure you want to delete this item?"
        }

        onAccepted: {
            deleteItem(model.fullPath);
        }
    }
}


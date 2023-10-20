import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15


Item {
    id: menuDialogs

    property alias renameDialog: renameDialog
    property alias confirmDeleteDialog: confirmDeleteDialog

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
                renameItem(model.fullPath, newName, fileManagerPane);
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
            deleteItem(model.fullPath, fileManagerPane);
        }
    }
}
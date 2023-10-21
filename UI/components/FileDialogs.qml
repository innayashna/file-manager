import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Item {
    id: fileDialogs

    property alias openFileDialog: openFileDialog
    property alias pasteFileIntoFileDialog: pasteFileIntoFileDialog
    property alias pasteFileIntoItselfDialog: pasteFileIntoItselfDialog

    Dialog {
        id: openFileDialog
        title: "Open File Error"
        standardButtons: Dialog.Ok

        parent: fileManagerPane
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        Text {
            text: "Sorry, app could not open files!"
        }
    }

    Dialog {
        id: pasteFileIntoFileDialog
        title: "Paste File Error"
        standardButtons: Dialog.Ok

        parent: fileManagerPane
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        Text {
            text: "File should only be pasted to directory!"
        }
    }

    Dialog {
        id: pasteFileIntoItselfDialog
        title: "Paste File Error"
        standardButtons: Dialog.Ok

        parent: fileManagerPane
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        Text {
            text: "You can't paste an item into itself!"
        }
    }
}
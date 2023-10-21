import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Item {
    id: fileDialogs

    property alias openFileDialog: openFileDialog
    property alias pasteFileDialog: pasteFileDialog

    Dialog {
        id: openFileDialog
        title: "Open File"
        standardButtons: Dialog.Ok

        parent: fileManagerPane
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        Text {
            text: "Sorry, app could not open files!"
        }
    }

    Dialog {
        id: pasteFileDialog
        title: "Paste File"
        standardButtons: Dialog.Ok

        parent: fileManagerPane
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        Text {
            text: "File should only be pasted to directory!"
        }
    }
}
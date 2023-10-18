import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Menu {
    id: sortMenu
    y: sortMenuButton.height

    property alias sortNone: sortNone

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
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Row {
    id: toolbar
    spacing: 5

    property alias goBackButton: goBackButton
    property alias goForwardButton: goForwardButton
    property alias sortNone: sortMenu.sortNone

    Button {
        id: goBackButton
        icon.source: "icons/navigation/arrow-small-left.png"
        enabled: false
        onClicked: {
            resetSorting(fileManagerPane);
            navigateBack(fileManagerPane);
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
            resetSorting(fileManagerPane);
            navigateForward(fileManagerPane);
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

        AttributeMenu {
            id: attributeMenu
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

        SortMenu {
            id: sortMenu
        }
    }
}
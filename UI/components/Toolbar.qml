import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

RowLayout {
    id: toolbar
    spacing: 20

    property alias goBackButton: goBackButton
    property alias goForwardButton: goForwardButton
    property alias sortNone: sortMenu.sortNone

    Button {
        id: goBackButton

        topPadding: 0
        bottomPadding: 0
        leftPadding: 15
        rightPadding: 0

        icon.source: "icons/navigation/arrow-small-left.png"
        icon.width: 20
        icon.height: 20

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

        topPadding: 0
        bottomPadding: 0
        leftPadding: 0
        rightPadding: 0

        icon.source: "icons/navigation/arrow-small-right.png"
        icon.width: 20
        icon.height: 20

        enabled: false

        onClicked: {
            resetSorting(fileManagerPane);
            navigateForward(fileManagerPane);
        }

        background: Rectangle {
            color: "transparent"
        }
    }

    Text {
        id: currentPath
        text: fileManagerPane.currentDirectoryShortPath
        Layout.minimumWidth: 300
        Layout.maximumWidth: 300
        font.bold: true
    }

    Item {
        id: blancSpace
        width: 20
    }

    Button {
        id: attributeMenuButton
        text: "Attributes"
        font.bold: true

        topPadding: 0
        bottomPadding: 0
        leftPadding: 0
        rightPadding: 0

        background: Rectangle {
            color: "transparent"
        }

        onClicked: attributeMenu.popup()

        AttributeMenu {
            id: attributeMenu
        }
    }

    Item {
        width: 10
    }

    Button {
        id: sortMenuButton
        text: "Sort"
        font.bold: true

        topPadding: 0
        bottomPadding: 0
        leftPadding: 0
        rightPadding: 0

        background: Rectangle {
            color: "transparent"
        }

        onClicked: sortMenu.popup()

        SortMenu {
            id: sortMenu
        }
    }
}
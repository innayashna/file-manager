import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Row {
    id: toolbar
    spacing: 5

    Button {
        id: goBackButton
        icon.source: "icons/navigation/arrow-small-left.png"
        enabled: false
        onClicked: {
            resetSorting();
            navigateBack();
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
            resetSorting();
            navigateForward();
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

        Menu {
            id: attributeMenu
            y: attributeMenuButton.height
            MenuItem {
                id: extensionMenuItem
                text: "Extension"
                checkable: true
                checked: true

                onCheckedChanged: {
                    updateAttributeVisibility("showExtension", checked);
                }
            }

            MenuItem {
                id: sizeMenuItem
                text: "Size"
                checkable: true
                checked: true

                onCheckedChanged: {
                    updateAttributeVisibility("showSize", checked);
                }
            }

            MenuItem {
                id: dateMenuItem
                text: "Date Modified"
                checkable: true
                checked: true

                onCheckedChanged: {
                    updateAttributeVisibility("showDate", checked);
                }
            }
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

        Menu {
            id: sortMenu
            y: sortMenuButton.height

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
    }
}
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

ListView {
    id: fileListView
    model: fileModel

    delegate: Item {
        width: 650
        height: 30

        Row {
            spacing: 5

            Image {
                id: image
                source: model.icon
                width: 16
                height: 16
            }

            Text {
                text: model.name
                elide: Text.ElideRight
                color: model.fullPath === cutItemPath ? "gray" : "black"
                width: 200
            }

            Text {
                text: model.showExtension ? model.extension : ""
                elide: Text.ElideRight
                width: model.showExtension ? 100 : 0
            }

            Text {
                text: model.showSize ? model.size : ""
                elide: Text.ElideRight
                width: model.showSize ? 100 : 0
            }

            Text {
                text: model.showDate ? model.dateModified : ""
                width: model.showDateModified ? 200 : 0
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                const selectedItem = model.fullPath;
                toolbar.goBackButton.enabled = true
                listDirectoryContents(selectedItem, fileManagerPane);
                keepActiveSort(fileManagerPane);
            }
        }

        MouseArea {
            id: fileActionsMenuArea
            anchors.fill: parent
            acceptedButtons: Qt.RightButton

            onClicked: (mouse) => {
                if (mouse.button === Qt.RightButton) {
                    fileActionsMenu.popup();
                }
            }
        }

        FileActionsMenu {
            id: fileActionsMenu
        }

        FileMenuDialogs {
            id: menuDialogs
        }
    }

    Connections {
        target: toolbar
    }
}
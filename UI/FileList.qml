import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

ListView {
    id: fileListView
    model: fileModel

    delegate: Item {
        width: 700
        height: 30

        Row {
            spacing: 5

            Image {
                source: model.icon
                width: 16
                height: 16
            }

            Text {
                text: model.name
                color: model.fullPath === cutItemPath ? "gray" : "black"
                width: 200
            }

            Text {
                text: model.showExtension ? model.extension : ""
                width: model.showExtension ? 100 : 0
            }

            Text {
                text: model.showSize ? model.size : ""
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
                listDirectoryContents(selectedItem);
                resetSorting();
            }
        }

        MouseArea {
            id: fileActionsMenuArea
            anchors.fill: parent
            acceptedButtons: Qt.RightButton

            onClicked: (mouse)=> {
                if (mouse.button === Qt.RightButton) {
                    fileActionsMenu.popup();
                }
            }
        }

        FileActionsMenu {
            id: fileActionsMenu
        }
    }

    Connections {
        target: toolbar
    }
}
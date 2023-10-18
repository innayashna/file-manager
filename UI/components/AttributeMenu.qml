import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

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
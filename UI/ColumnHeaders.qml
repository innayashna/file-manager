import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Row {
    spacing: 5

    Text {
        id: nameHeader
        text: "Name"
        font.bold: true
        width: 200
    }

    Text {
        id: extensionHeader
        text: "Extension"
        font.bold: true
        width: 110
    }

    Text {
        id: sizeHeader
        text: "Size"
        font.bold: true
        width: 100
    }

    Text {
        id: dateHeader
        text: "Date Modified"
        font.bold: true
        width: 200
    }
}
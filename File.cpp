#include "File.h"

File::File(const QString &filePath) : QObject(nullptr) {
    QFileInfo fileInfo(filePath);

    fullPath = fileInfo.absoluteFilePath();
    name = fileInfo.fileName();
    extension = fileInfo.suffix().toLower();
    size = fileInfo.size();
    dateModified = fileInfo.lastModified();
    isDir = fileInfo.isDir();
}

QString File::getFullPath() const {
    return fullPath;
}
QString File::getName() const {
    return name;
}

QString File::getExtension() const {
    return extension;
}

qint64 File::getSize() const {
    return size;
}

QDateTime File::getDateModified() const {
    return dateModified;
}

bool File::isDirectory() const {
    return isDir;
}

QString File::getIcon() const {
    return icon;
}

void File::setIcon(const QString &newIcon) {
    icon = newIcon;
}

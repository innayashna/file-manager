#include <QDir>
#include "include/File.h"

File::File(const QString &filePath) : QObject(nullptr) {
    QFileInfo fileInfo(filePath);

    fullPath = fileInfo.absoluteFilePath();
    name = fileInfo.fileName();
    dateModified = fileInfo.lastModified();
    isDir = fileInfo.isDir();

    if (isDir) {
        extension = "";
        size = getSize();
    } else {
        extension = fileInfo.suffix().toLower();
        size = fileInfo.size();
    }
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
    if (isDir) {
        qint64 totalSize = 0;
        QDir dir(fullPath);
        dir.setFilter(QDir::Files | QDir::Dirs | QDir::NoDotAndDotDot);
        QFileInfoList entries = dir.entryInfoList();
                foreach (QFileInfo entry, entries) {
                totalSize += entry.size();
            }
        return totalSize;
    } else {
        return size;
    }
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

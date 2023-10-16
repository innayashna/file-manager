#include "FileManager.h"
#include "File.h"
#include <filesystem>
#include <QFileInfo>
#include <iostream>

namespace fs = std::filesystem;

FileManager::FileManager(QObject *parent) : QObject(parent) {}

QList<File*> FileManager::listFilesAndFolders(const QString &path) {
    QList<File*> result;
    fs::path rootPath = path.toStdString();

    try {
        if (fs::exists(rootPath) && fs::is_directory(rootPath)) {
            for (const auto& entry : fs::directory_iterator(rootPath)) {
                File* file = new File(QString::fromStdString(entry.path().string()));
                QString icon = defineIcon(*file);
                file->setIcon(icon);
                result.append(file);
            }
        } else {
            File* errorFile = new File("Invalid directory path or directory does not exist.");
            result.append(errorFile);
        }
    } catch (const std::exception& ex) {
        File* errorFile = new File("Error: " + QString(ex.what()));
        result.append(errorFile);
    }

    return result;
}

QList<File*> FileManager::sortByName(const QString &path) {
    QList<File*> fileList = listFilesAndFolders(path);
    std::sort(fileList.begin(), fileList.end(), [](File *a, File *b) {
        return a->getName().toLower() < b->getName().toLower();
    });
    return fileList;
}

QList<File*> FileManager::sortBySize(const QString &path) {
    QList<File*> fileList = listFilesAndFolders(path);
    std::sort(fileList.begin(), fileList.end(), [](File *a, File *b) {
        return a->getSize() < b->getSize();
    });
    return fileList;
}

QList<File*> FileManager::sortByDateModified(const QString &path) {
    QList<File*> fileList = listFilesAndFolders(path);
    std::sort(fileList.begin(), fileList.end(), [](File *a, File *b) {
        return a->getDateModified() > b->getDateModified();
    });
    return fileList;
}

QString FileManager::defineIcon(const File& file) {
    if (file.isDirectory()) {
        return "icons/file/folder.png";
    } else {
        QString extension = file.getExtension().toLower();

        if (extension == "txt") {
            return "icons/file/txt.png";
        } else if (extension == "jpeg") {
            return "icons/file/picture.png";
        } else if (extension == "pdf") {
            return "icons/file/pdf.png";
        } else if (extension == "mp3") {
            return "icons/file/music.png";
        } else if (extension == "mp4") {
            return "icons/file/video.png";
        } else {
            return "icons/file/default-file.png";
        }
    }
}

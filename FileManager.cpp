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

void FileManager::copyItem(const QString &sourcePath, const QString &destinationPath) {
    fs::path source = sourcePath.toStdString();
    fs::path destination = destinationPath.toStdString();

    try {
        if (fs::exists(source)) {
            std::string sourceName = source.filename();
            fs::path destinationWithFileName = destination / sourceName;

            int index = 1;
            while (fs::exists(destinationWithFileName)) {
                std::string newName = generateUniqueName(sourceName, index);
                destinationWithFileName = destination / newName;
                index++;
            }

            fs::copy(source, destinationWithFileName, fs::copy_options::recursive);
        } else {
            qDebug() << "Source path does not exist: " << sourcePath;
        }
    } catch (const std::exception &ex) {
        qDebug() << "Error copying file/directory: " << ex.what();
    }
}

void FileManager::deleteItem(const QString &path) {
    fs::path itemPath = path.toStdString();
    try {
        if (fs::exists(itemPath)) {
            if (fs::is_directory(itemPath)) {
                fs::remove_all(itemPath);
            } else {
                fs::remove(itemPath);
            }
        } else {
            qDebug() << "Item does not exist: " << path;
        }
    } catch (const std::exception &ex) {
        qDebug() << "Error deleting file/directory: " << ex.what();
    }
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

std::string FileManager::generateUniqueName(const std::string &sourceName, int index) {
    if (sourceName.find('.') != std::string::npos) {
        std::string baseName = sourceName.substr(0, sourceName.find_last_of('.'));
        std::string extension = sourceName.substr(sourceName.find_last_of('.'));
        return baseName + "_" + std::to_string(index) + extension;
    } else {
        return sourceName + "_" + std::to_string(index);
    }
}
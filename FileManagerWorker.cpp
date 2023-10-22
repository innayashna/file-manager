#include <filesystem>
#include <QFileInfo>
#include <iostream>

#include "FileManagerWorker.h"

namespace fs = std::filesystem;

void FileManagerWorker::copyItem(const QString &sourcePath, const QString &destinationPath) {
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
    emit copyFinished();
}

void FileManagerWorker::deleteItem(const QString &path) {
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
    emit deleteFinished();
}

std::string FileManagerWorker::generateUniqueName(const std::string &sourceName, int index) {
    if (sourceName.find('.') != std::string::npos) {
        std::string baseName = sourceName.substr(0, sourceName.find_last_of('.'));
        std::string extension = sourceName.substr(sourceName.find_last_of('.'));
        return baseName + "_" + std::to_string(index) + extension;
    } else {
        return sourceName + "_" + std::to_string(index);
    }
}


#include <filesystem>
#include <QFileInfo>
#include <QThread>

#include "File.h"
#include "FileManager.h"
#include "FileManagerWorker.h"

namespace fs = std::filesystem;

FileManager::FileManager(QObject *parent) : QObject(parent) {
    copyThread = new QThread();
    deleteThread = new QThread();
    copyWorker = new FileManagerWorker();
    deleteWorker = new FileManagerWorker();

    copyWorker->moveToThread(copyThread);
    deleteWorker->moveToThread(deleteThread);

    connect(copyWorker, SIGNAL(copyFinished()), this, SIGNAL(copyFinished()));
    connect(deleteWorker, SIGNAL(deleteFinished()), this, SIGNAL(deleteFinished()));

    copyThread->start();
    deleteThread->start();
}

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
    connect(copyWorker, SIGNAL(copyFinished()), copyThread, SLOT(quit()));

    QMetaObject::invokeMethod(copyWorker, "copyItem", Qt::QueuedConnection,
                              Q_ARG(QString, sourcePath), Q_ARG(QString, destinationPath));
    copyThread->start();
    emit copyFinished();
}

void FileManager::deleteItem(const QString &path) {
    connect(deleteWorker, SIGNAL(deleteFinished()), deleteThread, SLOT(quit()));

    QMetaObject::invokeMethod(deleteWorker, "deleteItem", Qt::QueuedConnection, Q_ARG(QString, path));
    deleteThread->start();
    emit deleteFinished();
}

void FileManager::renameItem(const QString &sourcePath, const QString &newName) {
    fs::path source = sourcePath.toStdString();
    fs::path parentPath = source.parent_path();
    fs::path newPath = parentPath / newName.toStdString();

    try {
        if (fs::exists(source)) {
            if (!fs::exists(newPath)) {
                fs::rename(source, newPath);
            } else {
                qDebug() << "A file with the same name already exists at the destination.";
            }
        } else {
            qDebug() << "Source path does not exist: " << sourcePath;
        }
    } catch (const std::exception &ex) {
        qDebug() << "Error renaming file/directory: " << ex.what();
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

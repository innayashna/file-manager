#include "FileManager.h"
#include <filesystem>
#include <QFileInfo>

namespace fs = std::filesystem;

FileManager::FileManager(QObject *parent) : QObject(parent) {}

QStringList FileManager::listFilesAndFolders(const QString &path) {
    QStringList result;
    fs::path rootPath = path.toStdString();

    try {
        if (fs::exists(rootPath) && fs::is_directory(rootPath)) {
            for (const auto& entry : fs::directory_iterator(rootPath)) {
                result << QString::fromStdString(entry.path().string());
            }
        } else {
            result << "Invalid directory path or directory does not exist.";
        }
    } catch (const std::exception& ex) {
        result << QString("Error: ") + ex.what();
    }

    return result;
}

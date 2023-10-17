#ifndef FILE_MANAGER_H
#define FILE_MANAGER_H

#include <QObject>
#include <QStringList>
#include "File.h"

namespace fs = std::filesystem;

class FileManager : public QObject {
Q_OBJECT
public:
    explicit FileManager(QObject *parent = nullptr);
    Q_INVOKABLE static QList<File*> listFilesAndFolders(const QString &path);
    Q_INVOKABLE static QList<File*> sortByName(const QString &path);
    Q_INVOKABLE static QList<File*> sortBySize(const QString &path);
    Q_INVOKABLE static QList<File*> sortByDateModified(const QString &path);
    Q_INVOKABLE static void copy(const QString &sourcePath, const QString &destinationPath);

private:
    static QString defineIcon(const File& file);
    static std::string generateUniqueName(const std::string &sourceName, int index);
};

#endif // FILE_MANAGER_H

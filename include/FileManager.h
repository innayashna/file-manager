#ifndef FILE_MANAGER_H
#define FILE_MANAGER_H

#include <QObject>
#include <QStringList>
#include <QThread>
#include <QMutex>

#include "File.h"
#include "FileManagerWorker.h"

namespace fs = std::filesystem;

class FileManager : public QObject {
Q_OBJECT
public:
    explicit FileManager(QObject *parent = nullptr);
    Q_INVOKABLE static QList<File*> listFilesAndFolders(const QString &path);
    Q_INVOKABLE static QList<File*> sortByName(const QString &path);
    Q_INVOKABLE static QList<File*> sortBySize(const QString &path);
    Q_INVOKABLE static QList<File*> sortByDateModified(const QString &path);
    Q_INVOKABLE static void renameItem(const QString &sourcePath, const QString &newName);

signals:
    void copyFinished();
    void deleteFinished();

public slots:
    void copyItem(const QString& sourcePath, const QString& destinationPath);
    void deleteItem(const QString& path);

private:
    QThread* copyThread;
    QThread* deleteThread;
    FileManagerWorker* copyWorker;
    FileManagerWorker* deleteWorker;
    static QString defineIcon(const File& file);
};

#endif // FILE_MANAGER_H

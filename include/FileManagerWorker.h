#ifndef FILE_MANAGER_WORKER_H
#define FILE_MANAGER_WORKER_H

#include <QObject>

class FileManagerWorker : public QObject {
Q_OBJECT

public slots:
    void copyItem(const QString &sourcePath, const QString &destinationPath);
    void deleteItem(const QString &path);

signals:
    void copyFinished();
    void deleteFinished();

private:
    static std::string generateUniqueName(const std::string &sourceName, int index);
};

#endif // FILE_MANAGER_WORKER_H

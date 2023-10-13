#ifndef FILE_MANAGER_H
#define FILE_MANAGER_H

#include <QObject>
#include <QStringList>

class FileManager : public QObject {
Q_OBJECT
public:
    explicit FileManager(QObject *parent = nullptr);
    Q_INVOKABLE QStringList listFilesAndFolders(const QString &path);
};

#endif // FILE_MANAGER_H

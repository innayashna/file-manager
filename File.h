#ifndef FILE_H
#define FILE_H

#include <QString>
#include <QDateTime>
#include <QFileInfo>

class File : public QObject {
Q_OBJECT
Q_PROPERTY(QString fullPath READ getFullPath)
Q_PROPERTY(QString name READ getName)
Q_PROPERTY(QString icon READ getIcon)
Q_PROPERTY(QString extension READ getExtension)
Q_PROPERTY(qint64 size READ getSize)
Q_PROPERTY(QDateTime dateModified READ getDateModified)
Q_PROPERTY(bool isDir READ isDirectory)

public:
    explicit File(const QString &filePath);

    [[nodiscard]] QString getFullPath() const;
    [[nodiscard]] QString getName() const;
    [[nodiscard]] QString getExtension() const;
    [[nodiscard]] qint64 getSize() const;
    [[nodiscard]] QDateTime getDateModified() const;
    [[nodiscard]] bool isDirectory() const;
    [[nodiscard]] QString getIcon() const;
    void setIcon(const QString &icon);

private:
    QString fullPath;
    QString name;
    QString extension;
    qint64 size;
    QDateTime dateModified;
    bool isDir;
    QString icon;
};

#endif // FILE_H

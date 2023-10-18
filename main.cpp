#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "FileManager.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterType<File>("FileManager", 1, 0, "File");
    FileManager fileManager;
    engine.rootContext()->setContextProperty("fileManager", &fileManager);

    const QUrl url(QStringLiteral("qrc:/qt/qml/fileManager/UI/FileManagerApp.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                if (!obj && url == objUrl)
                    QCoreApplication::exit(-1);
            }, Qt::QueuedConnection);
    engine.load(url);

    return QGuiApplication::exec();
}
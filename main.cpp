#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "messagelistmodel.h"
#include "chatmanager.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<MessageListModel>("MCommons", 1, 0, "MessageListModel");
    qmlRegisterType<ChatManager>("ChatManager", 1, 0, "ChatManager");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}

#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <src/model/contactsmodel.h>
#include <src/core/chatclient.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    ChatClient chatClient;

    QQmlApplicationEngine engine;
    engine.addImportPath(":/chatClient.com/imports");
    const QUrl url(u"qrc:/chatClient.com/imports/ChatClient_QML/Main.qml"_qs);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <src/model/chathistorymodel.h>
#include <src/model/contactsmodel.h>
#include <src/model/searchmodel.h>
#include <src/core/chatclient.h>

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    auto searchModel = std::make_shared<SearchModel>(nullptr);
    auto contactsModel = std::make_shared<ContactsModel>(nullptr);
    auto historyModel = std::make_shared<ChatHistoryModel>(nullptr);

    // ChatClient and the three models are QML_SINGLETON types: each one remembers
    // its only instance in its constructor and QML gets it from the static
    // create(). So they must be constructed here, before the engine loads
    // Main.qml. QML then uses them by type name (ChatClient, ContactsModel, ...).
    ChatClient chatClient(contactsModel, searchModel, historyModel);

    QQmlApplicationEngine engine;
    engine.addImportPath(":/ChatClient");

    const QUrl url(QStringLiteral("qrc:/ChatClient/ChatClient_QML/Main.qml"));

    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
        []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

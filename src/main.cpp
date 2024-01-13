#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <src/model/contactsmodel.h>
#include <src/model/searchmodel.h>
#include <src/model/chathistorymodel.h>

#include <src/core/chatclient.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    std::shared_ptr<SearchModel> searchModel = std::make_shared<SearchModel>();
    std::shared_ptr<ContactsModel> contactsModel = std::make_shared<ContactsModel>();
    std::shared_ptr<ChatHistoryModel> historyModel = std::make_shared<ChatHistoryModel>();

    ChatClient chatClient(contactsModel, searchModel, historyModel);

    QQmlApplicationEngine engine;
    engine.addImportPath(":/ChatClient");
    engine.rootContext()->setContextProperty("chatClientObj", &chatClient);
    engine.rootContext()->setContextProperty("searchModel", searchModel.get());
    engine.rootContext()->setContextProperty("contactsModel", contactsModel.get());
    engine.rootContext()->setContextProperty("chatHistoryModel", historyModel.get());
    //engine.setInitialProperties({{"chatClientObj", QVariant::fromValue(&chatClient)}});

    const QUrl url(QStringLiteral("qrc:/ChatClient/ChatClient_QML/Main.qml"));

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

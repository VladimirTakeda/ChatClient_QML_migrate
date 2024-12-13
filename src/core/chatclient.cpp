#include <QNetworkAccessManager>
#include <QApplication>
#include <QJsonObject>
#include <QJsonDocument>
#include <QNetworkReply>
#include <QSettings>
#include <QJsonArray>
#include <QDir>
#include <QFileDialog>
#include <QHttpMultiPart>
#include <QUrlQuery>

#include "chatclient.h"

#include <src/model/data/dialogsmanager.h>
#include <src/model/contactsmodel.h>
#include <src/model/searchmodel.h>
#include <src/model/chathistorymodel.h>

#include <src/network/websocketclient.h>
#include <src/network/httpclient.h>

#include <src/utils/utils.h>

class QListWidgetItem;

namespace{

std::vector<UserInfo> ParseUsers(QByteArray reply)
{
    qDebug() << reply;
    QJsonDocument itemDoc = QJsonDocument::fromJson(reply);
    QJsonObject rootObject = itemDoc.object();
    QJsonArray array = rootObject.value("users").toArray();
    std::vector<UserInfo> answer;
    int currUserId = getCurrUserId();
    for (const QJsonValue & value : array) {
        QJsonObject obj = value.toObject();
        if (obj["id"].toInt() != currUserId)
            answer.emplace_back(obj["id"].toInt(), obj["nickname"].toString());
    }
    return answer;
}

}

ChatClient::ChatClient(std::shared_ptr<ContactsModel> contactsModel, std::shared_ptr<SearchModel> searchModel, std::shared_ptr<ChatHistoryModel> chatHistoryModel, QObject *parent) :
    QObject(parent),
    m_httpClient(std::make_shared<HttpClient>()),
    m_dialogsManager(std::make_shared<DialogsManager>()),
    m_contactsModel(contactsModel),
    m_searchModel(searchModel),
    m_chatHistoryModel(chatHistoryModel)
{
    loadDialogs();

    m_contactsModel->SetDataSource(m_dialogsManager);
    m_searchModel->SetDataSource(std::vector<UserInfo>());
    connect(m_searchModel.get(), &SearchModel::ItemClicked, this, &ChatClient::SetNewDialog);
}

//need because of std::unique_ptr<WebSocket::WebSocketClient> m_client field
ChatClient::~ChatClient(){};

void ChatClient::SetUpWSConnection(){
    QString url = QString("ws://localhost:8080/create?user_id=%1&device_id=%2").arg(getCurrUserId()).arg(getCurrDeviceId());
    m_client.reset(new WebSocket::WebSocketClient(QUrl(url), std::bind(&ChatClient::GotNewMessage, this, std::placeholders::_1)));
}

void ChatClient::loadDialogs()
{
    qDebug() << "Start loading dialogs";
    m_dialogsManager->LoadFromMemory();
}

void ChatClient::saveDialogs() const
{
    qDebug() << "Start saving dialogs";
    m_dialogsManager->SaveToMemory();
}

void ChatClient::GotNewMessage(WebSocket::Message msg)
{
    qDebug() << __FUNCTION__;
    auto processMessage = [this, msg](){
        qDebug() << "We are inside the lambda";
        if (!m_dialogsManager->IsChatExist(msg.chatTo)){
            m_dialogsManager->CreateNewChat(msg.userFrom, msg.chatTo, msg.chatName.value());
        }
        m_dialogsManager->AddMessage(msg.chatTo, {msg.text, msg.isMyMessage, msg.time, msg.attachments});
        //if it's current dialog then update otherwise no
        bool IsSelectedDialog = false;
        if (m_currChat && m_currChat->m_chatId == msg.chatTo)
            IsSelectedDialog = true;

        [&](int userId, const QString &lastMessage, bool NeedIncrement, const QDateTime& localMsgTime){
            if (NeedIncrement){
                (*(m_dialogsManager->m_IdToDialog.at(userId)))->m_unreadCount++;
            }
        }(msg.chatTo, msg.text, !IsSelectedDialog, msg.time);

        // hack
        if (m_currChat)
            m_chatHistoryModel->SetDataSource(m_currChat);
        m_contactsModel->SetDataSource(m_dialogsManager);
        //update qml index
        qDebug() << "new message changes the index";
        if (m_currChat)
            emit dialogIndexChanged(std::distance(m_dialogsManager->m_modelData.begin(), m_dialogsManager->m_IdToDialog[m_currChat->m_chatId]));

        OnGotNotification(msg.chatName.value(), msg.text, (*m_dialogsManager->m_IdToDialog.at(msg.chatTo))->m_unreadCount, msg.time);

        // to prevent double connection? because we invoke void ChatClient::GotNewMessage(WebSocket::Message msg) several times
        QObject::disconnect(this, &ChatClient::AttachmentsDownloaded, this, nullptr);
    };

    if (!msg.attachments.empty()) {
        // Подключаемся к сигналу о завершении загрузки
        connect(this, &ChatClient::AttachmentsDownloaded, this, processMessage);
        DownLoadAttachments(msg.attachments[0]);
    } else {
        qDebug() << "Invoke lambda";
        processMessage();
    }
}

bool ChatClient::isUserRegistered(){
#ifdef Q_OS_WIN
    QSettings settings(QCoreApplication::applicationDirPath() + "/settings.ini", QSettings::IniFormat);
#endif

#ifdef Q_OS_MAC
    QSettings settings(QCoreApplication::applicationDirPath() + "/../../../settings.ini", QSettings::IniFormat);
#endif

    qDebug() << "curr path" << settings.fileName();

    bool IsRegistered = settings.value("registered", false).toBool();
    if (IsRegistered)
        SetUpWSConnection();

    return IsRegistered;
}

void ChatClient::sendNewMessage(const QString& message, QVector<QString> attachments)
{
    qDebug() << __FUNCTION__ << " ???? ";
    QJsonObject obj;
    obj["content"] = message;
    obj["user_from_id"] = getCurrUserId();
    obj["chat_to_id"] = m_currChat ? m_currChat->GetChatId() : -1;
    obj["chat_name"] = getCurrUserName();

    QJsonArray jsonArray;

    for (const auto& elem : attachments){
        jsonArray.append(elem);
    }

    obj["attachments"] = jsonArray;

    QJsonDocument doc(obj);

    m_client->SendTextMessage(doc.toJson(QJsonDocument::Compact));
}

void ChatClient::DownLoadAttachments(const QString& attachedFileName){
    QString fileName = QString("QCoreApplication::applicationDirPath()") + "/../../../images/" + attachedFileName;
    if (!QFile::exists(fileName)){
        QNetworkRequest request;

        QJsonObject obj;
        obj["file_id"] = attachedFileName;
        QJsonDocument doc(obj);
        QByteArray data = doc.toJson();

        QUrl url;

        url.setScheme("http");
        url.setHost("localhost");
        url.setPath("/getFile");
        url.setPort(8080);
        request.setUrl(url);
        request.setRawHeader("Content-Type", "application/json");
        std::vector<std::pair<std::string, QVariant>> properties = {{"attachmentName", attachedFileName}};
        m_httpClient->sendHttpRequest(std::move(request), std::move(data), properties, std::bind(&ChatClient::DownLoadAttachmentsReply, this, std::placeholders::_1));
    }
    else{
        qDebug() << "Invoke lambda by signal";
        emit AttachmentsDownloaded();
    }
}

void ChatClient::updateCurrentChat(int index){
    qDebug() << "update curr Chat: " << index;
    m_currChat = m_dialogsManager->GetDialogByIndex(index);
    m_currChat->m_unreadCount = 0;
    m_contactsModel->SetDataSource(m_dialogsManager);
    m_chatHistoryModel->SetDataSource(m_currChat);
}

QString ScaleSizeImage(const QString& filePath){
    QPixmap pixmap(QUrl(filePath).toLocalFile());
    if (pixmap.width() > 640 || pixmap.height() > 640) {
        // Уменьшение изображения
        qreal scaleFactor = qMin(640.0 / pixmap.width(), 640.0 / pixmap.height());
        pixmap = pixmap.scaled(pixmap.size() * scaleFactor, Qt::KeepAspectRatio);
    }
    // Сохранение изображения
    QFileInfo originalFileInfo(filePath);
    QString originalFileName = originalFileInfo.fileName();

    // Создаем новый путь с тем же именем файла
    QString fileName = QString(QCoreApplication::applicationDirPath()) + "/../../../images/" + originalFileName;

    QFileInfo fileInfo(fileName);
    QDir().mkpath(fileInfo.absolutePath()); // Создаем папку, если её нет

    if (!pixmap.toImage().save(fileName))
        qDebug() << "Alarm";
    return fileName;
}

void ChatClient::sendImage(const QString& path, const QString& message){
    if (path.isEmpty() && message.isEmpty())
        return;
    QString scalesPath = path;
    if (!path.isEmpty()){
        scalesPath = ScaleSizeImage(path);
    }

    QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

    QHttpPart filePart;
    filePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"file\"; filename=\"" + scalesPath + "\""));

    QFile *file = new QFile(scalesPath);
    file->open(QIODevice::ReadOnly);
    filePart.setBodyDevice(file);
    file->setParent(multiPart);

    multiPart->append(filePart);

    QUrl url;
    url.setScheme("http");
    url.setHost("localhost");
    url.setPath("/uploadFile");
    url.setPort(8080);

    QUrlQuery urlQuery;
    urlQuery.addQueryItem("userId", QString::number(getCurrUserId()));
    urlQuery.addQueryItem("chatId", QString::number(m_currChat->m_chatId));

    url.setQuery(urlQuery);

    QNetworkRequest request(url);

    std::vector<std::pair<std::string, QVariant>> properties = {{"message", message}};
    m_httpClient->sendHttpRequest(std::move(request), multiPart, properties, std::bind(&ChatClient::SendImageReply, this, std::placeholders::_1));
}

void ChatClient::SendImageReply(QNetworkReply *reply){
    if (reply->error() == QNetworkReply::NoError) {
        QJsonDocument itemDoc = QJsonDocument::fromJson(reply->readAll());
        QJsonObject rootObject = itemDoc.object();
        qDebug() << "got fileId" << rootObject.value("file_id").toString();
        QString message = reply->property("message").toString();
        sendNewMessage(message, {rootObject.value("file_id").toString()});
    }
    else {
        qDebug() << "Failure" <<reply->errorString();
    }
}

void ChatClient::LookingForPeople(const QString& prefix)
{
    if (prefix.isEmpty())
        return;

    QNetworkRequest request;

    QJsonObject obj;
    obj["search_prefix"] = prefix;
    obj["this_user_id"] = getCurrUserId();
    QJsonDocument doc(obj);
    QByteArray data = doc.toJson();

    QUrl url;

    url.setScheme("http");
    url.setHost("localhost");
    url.setPath("/get_users_by_prefix");
    url.setPort(8080);
    request.setUrl(url);
    request.setRawHeader("Content-Type", "application/json");

    qDebug() << "send search request with prefix: " << prefix;
    m_httpClient->sendHttpRequest(std::move(request), std::move(data), {}, std::bind(&ChatClient::LookingForPeopleReply, this, std::placeholders::_1));
}

void ChatClient::LookingForPeopleReply(QNetworkReply *reply){
    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << "got search reques";
        SetSearchResults(ParseUsers(reply->readAll()));
    }
    else {
        qDebug() << "Failure" <<reply->errorString();
    }
}

void ChatClient::SetSearchResults(std::vector<UserInfo>&& results)
{
    m_searchModel->SetDataSource(std::move(results));
}

void ChatClient::SetNewDialog(int index)
{
    QString login = m_searchModel->data(m_searchModel->index(index), ContactsRoles::ChatNameRole).toString();
    int userId = m_searchModel->data(m_searchModel->index(index), ContactsRoles::UserIdRole).toInt();

    if (!m_dialogsManager->IsDialogWithUserExist(userId)){
        SendCreateDialogReq(getCurrUserId(), userId, login);
    }
    else{
        // set curr dialiog with userId
        m_currChat = *m_dialogsManager->m_IdToDialog[m_dialogsManager->m_UserToChat[userId]];
        int index = std::distance(m_dialogsManager->m_modelData.begin(), m_dialogsManager->m_IdToDialog[m_dialogsManager->m_UserToChat[userId]]);
        qDebug() << "chat already created: " << index;
        emit dialogIndexChanged(index);
        m_chatHistoryModel->SetDataSource(m_currChat);
    }
}

void ChatClient::SendCreateDialogReq(int fromUser, int toUser, const QString& toUserName){
    QNetworkRequest request;

    QJsonObject obj;
    obj["from_user"] = fromUser;
    obj["to_user"] = toUser;
    QJsonDocument doc(obj);
    QByteArray data = doc.toJson();

    QUrl url;

    url.setScheme("http");
    url.setHost("localhost");
    url.setPath("/chats");
    url.setPort(8080);
    request.setUrl(url);
    request.setRawHeader("Content-Type", "application/json");

    std::vector<std::pair<std::string, QVariant>> properties = {{"toUserId", toUser}, {"toUserName", toUserName}};
    m_httpClient->sendHttpRequest(std::move(request), std::move(data), properties, std::bind(&ChatClient::CreateChatReply, this, std::placeholders::_1));
}

void ChatClient::CreateChatReply(QNetworkReply *reply){
    if (reply->error() == QNetworkReply::NoError) {
        QJsonDocument itemDoc = QJsonDocument::fromJson(reply->readAll());
        QJsonObject rootObject = itemDoc.object();
        m_dialogsManager->CreateNewChat(reply->property("toUserId").toInt(), rootObject.value("chatId").toInt(), reply->property("toUserName").toString());
        m_contactsModel->SetDataSource(m_dialogsManager);
        m_currChat = m_dialogsManager->GetDialogByIndex(0);
        qDebug() << "changed index by new dialog";
        emit dialogIndexChanged(0);
        m_chatHistoryModel->SetDataSource(m_currChat);
    }
    else {
        qDebug() << "Failure" <<reply->errorString();
    }
}

void ChatClient::DownLoadAttachmentsReply(QNetworkReply *reply){
    if (reply->error() == QNetworkReply::NoError) {
        QByteArray data = reply->readAll();
        QDir().mkpath(QCoreApplication::applicationDirPath() + "/../../../images/");
        QFile file(QString(QCoreApplication::applicationDirPath()) + "/../../../images/" + reply->property("attachmentName").toString());
        if (file.open(QIODevice::WriteOnly)) {
            file.write(data);
            file.close();
            qDebug() << "File downloaded successfully.";
        } else {
            qDebug() << "Failed to save the file.";
        }
        qDebug() << "file downloaded success";
        emit AttachmentsDownloaded();
        qDebug() << "Invoke lambda by signal reply";
    }
    else {
        qDebug() << "Failure" <<reply->errorString();
    }
}

void ChatClient::OnGotNotification(const QString& name, const QString& text, int64_t unreadCount, const QDateTime& time)
{
    /*m_popUp->setPopupText(name, text, unreadCount, time);
    m_popUp->show();*/
}

QString ChatClient::SearchPrefix() const
{
    return m_SearchPrefix;
}

void ChatClient::setSearchPrefix(const QString &newSearchPrefix)
{
    if (m_SearchPrefix == newSearchPrefix)
        return;
    m_SearchPrefix = newSearchPrefix;
    LookingForPeople(m_SearchPrefix);
    emit SearchPrefixChanged();
}


void ChatClient::registerUser(const QString& login, const QString& password)
{
    QNetworkRequest request;

    QJsonObject requestData;
    requestData["deviceId"] = QString(QSysInfo::machineUniqueId());
    requestData["deviceType"] = QSysInfo::productType();
    requestData["login"] = login;
    requestData["password"] = password;


    QJsonDocument doc(requestData);
    QByteArray data = doc.toJson();

    QUrl url;

    url.setScheme("http");
    url.setHost("localhost");
    url.setPath("/user/register");
    url.setPort(8080);
    request.setUrl(url);
    request.setRawHeader("Content-Type", "application/json");

    m_httpClient->sendHttpRequest(std::move(request), std::move(data), {{"currUserName", login}}, std::bind(&ChatClient::RegisterUserReply, this, std::placeholders::_1));
}

void ChatClient::RegisterUserReply(QNetworkReply *reply){
    if (reply->error() == QNetworkReply::NoError) {
        QJsonDocument itemDoc = QJsonDocument::fromJson(reply->readAll());
        QJsonObject rootObject = itemDoc.object();
        qDebug() << rootObject;
        SaveUserInfo(rootObject.value("userId").toInt(), rootObject.value("deviceId").toString(),  reply->property("currUserName").toString());
        SetUpWSConnection();
        emit goToMainWidget();
    }
    else {
        qDebug() << "Failure" <<reply->errorString();
    }
}

void ChatClient::SaveUserInfo(int userId, const QString& deviceId, const QString& userName)
{
#ifdef Q_OS_WIN
    QSettings settings(QCoreApplication::applicationDirPath() + "/settings.ini", QSettings::IniFormat);
#endif

#ifdef Q_OS_MAC
    QSettings settings(QCoreApplication::applicationDirPath() + "/../../../settings.ini", QSettings::IniFormat);
#endif
    settings.setValue("userId", userId);
    settings.setValue("deviceId", deviceId);
    settings.setValue("registered", true);
    settings.setValue("currUserName", userName);
}

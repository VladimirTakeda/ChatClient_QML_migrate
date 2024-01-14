#include "chatclient.h"

#include <src/model/data/dialogsmanager.h>
#include <src/model/contactsmodel.h>
#include <src/model/searchmodel.h>
#include <src/model/chathistorymodel.h>

#include <src/network/websocketclient.h>
#include <src/network/httpclient.h>

#include <src/utils/utils.h>

#include <QNetworkAccessManager>
#include <QApplication>
#include <QJsonObject>
#include <QJsonDocument>
#include <QNetworkReply>
#include <QSettings>
#include <QJsonArray>
#include <QDir>

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
    m_contactsModel->SetDataSource(m_dialogsManager);
    m_searchModel->SetDataSource(std::vector<UserInfo>());
    connect(m_searchModel.get(), &SearchModel::ItemClicked, this, &ChatClient::SetNewDialog);
    //connect(ui->listWidget_2, &QListWidget::itemClicked, this, &ChatWidget::SetNewDialog);
    //connect(ui->listWidget, &QListWidget::itemClicked, this, &ChatWidget::SetDialog);
}

ChatClient::~ChatClient()
{
}

void ChatClient::AddNewWidgetDialog(int chatId, const QString& name, bool needSetItem)
{
    /*QListWidgetItem *contactItem = new QListWidgetItem(ui->listWidget);
    auto newUser = new UserItemWidget();
    newUser->SetName(name);
    contactItem->setData(Qt::UserRole, chatId);
    contactItem->setSizeHint(newUser->sizeHint());
    ui->listWidget->addItem(contactItem);
    ui->listWidget->setItemWidget(contactItem, newUser);
    if (needSetItem)
        contactItem->setSelected(true);
    m_idToDialogWidget.emplace(chatId, contactItem);
    ui->stackedWidget->setCurrentIndex(0);*/
}

void ChatClient::UpdateWidgetDialog(int userId, const QString &lastMessage, uint64_t unreadCount, const QDateTime& localMsgTime)
{
    /*UserItemWidget *itemWidget = qobject_cast<UserItemWidget*>(ui->listWidget->itemWidget(m_idToDialogWidget[userId]));
    itemWidget->SetUnreadCount(unreadCount);
    itemWidget->SetLastText(lastMessage);
    itemWidget->SetLastTextTime(localMsgTime);*/
}

void ChatClient::AddMessageToWidgetDialog(int userId, const QString &lastMessage, bool NeedIncrement, const QDateTime& localMsgTime)
{
    /*UserItemWidget *itemWidget = qobject_cast<UserItemWidget*>(ui->listWidget->itemWidget(m_idToDialogWidget[userId]));
    if (NeedIncrement){
        itemWidget->IncrementUnreadCount();
        m_dialogsManager->m_IdToDialog.at(userId).m_unreadCount++;
    }
    itemWidget->SetLastText(lastMessage);
    itemWidget->SetLastTextTime(localMsgTime);*/
}

void ChatClient::SetUpWSConnection(){
    QString url = QString("ws://localhost:8080/create?user_id=%1&device_id=%2").arg(getCurrUserId()).arg(getCurrDeviceId());
    m_client.reset(new WebSocket::WebSocketClient(QUrl(url), std::bind(&ChatClient::GotNewMessage, this, std::placeholders::_1)));
}

void ChatClient::LoadDialogs()
{
    m_dialogsManager->LoadFromMemory();
    for (const auto& [userId, value]: m_dialogsManager->m_IdToDialog){
        //AddNewWidgetDialog(userId, m_dialogsManager->m_IdToName[userId], false);
        //UpdateWidgetDialog(userId, value.m_messages.back().text, value.m_unreadCount, value.m_messages.back().time);
    }
}

void ChatClient::SaveDialogs() const
{
    m_dialogsManager->SaveToMemory();
}

void ChatClient::GotNewMessage(WebSocket::Message msg)
{
    if (!m_dialogsManager->IsChatExist(msg.chatTo)){
        m_dialogsManager->CreateNewChat(msg.userFrom, msg.chatTo, msg.chatName);
        AddNewWidgetDialog(msg.chatTo, msg.chatName, false);
    }
    m_dialogsManager->AddMessage(msg.chatTo, {msg.text, msg.isMyMessage, msg.time});
    //if it's current dialog then update otherwise no
    bool IsSelectedDialog = false;
    //if (auto currItem = ui->listWidget->currentItem(); currItem != nullptr && currItem->data(Qt::UserRole).toInt() == msg.chatTo)
        //IsSelectedDialog = true;

    if (IsSelectedDialog)
        UpdateTextBrowser(msg.chatTo);

    AddMessageToWidgetDialog(msg.chatTo, msg.text, !IsSelectedDialog, msg.time);

    // hack
    m_chatHistoryModel->SetDataSource(m_currChat);

    if (!m_dialogsManager)
        qDebug() << "null manager";
    if (m_dialogsManager->m_IdToDialog.count(msg.chatTo) == 0){
        qDebug() << "can't find chat " << msg.chatTo;
    }
    try{
        qDebug() << (*m_dialogsManager->m_IdToDialog.at(msg.chatTo))->m_unreadCount;
    }
    catch (...){
        qDebug() << "can't dereference list iterator";
    }

    OnGotNotification(msg.chatName, msg.text, (*m_dialogsManager->m_IdToDialog.at(msg.chatTo))->m_unreadCount, msg.time);
}

void ChatClient::UpdateTextBrowser(int selectedContactId)
{
    //ui->textBrowser->clear();
    //ui->textBrowser->setHtml(m_dialogsManager->GetDialog(selectedContactId).GetHtmlDialog());
}

bool ChatClient::isRegistered(){
    QSettings settings(QApplication::applicationDirPath() + "/settings.ini", QSettings::IniFormat);
    qDebug() << "dir path " << QApplication::applicationDirPath();
    qDebug() << "curr path" << settings.fileName();

    bool IsRegistered = settings.value("registered", false).toBool();
    if (IsRegistered)
        SetUpWSConnection();

    return IsRegistered;
}

void ChatClient::sendNewMessage(const QString& message)
{
    QJsonObject obj;
    obj["content"] = message;
    obj["user_from_id"] = getCurrUserId();
    obj["chat_to_id"] = m_currChat ? m_currChat->GetChatId() : -1;
    obj["chat_name"] = m_currChat? m_currChat->GetName() : "";

    QJsonDocument doc(obj);

    m_client->SendTextMessage(doc.toJson(QJsonDocument::Compact));
}

void ChatClient::updateCurrentChat(int index){
    qDebug() << "update curr Chat: " << index;
    m_currChat = m_dialogsManager->GetDialogByIndex(index);
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

void ChatClient::SetSearchResults(const std::vector<UserInfo>& results)
{
    m_searchModel->SetDataSource(results);
    /*ui->listWidget_2->clear();
    for (const UserInfo& userInfo : results){
        QListWidgetItem *contactItem = new QListWidgetItem(ui->listWidget_2);
        auto user = new UserItemWidget();
        user->SetName(userInfo.userLogin);
        user->SetLastText("");
        contactItem->setData(Qt::UserRole, userInfo.userId);
        contactItem->setSizeHint(user->sizeHint());
        ui->listWidget_2->addItem(contactItem);
        ui->listWidget_2->setItemWidget(contactItem, user);
    }*/
}

void ChatClient::SetExistingDialogs()
{

}

/*void ChatClient::SetDialog(QListWidgetItem * clickedItem)
{
    UserItemWidget *itemWidget = qobject_cast<UserItemWidget*>(ui->listWidget->itemWidget(clickedItem));

    itemWidget->ClearUnreadCount();
    m_dialogsManager->m_IdToDialog.at(clickedItem->data(Qt::UserRole).toInt()).m_unreadCount = 0;

    ui->stackedWidget_2->setCurrentIndex(1);
    ui->label_4->setText(itemWidget->GetName());
    UpdateTextBrowser(clickedItem->data(Qt::UserRole).toInt());
}*/

void ChatClient::SetNewDialog(int index)
{
    QString login = m_searchModel->data(m_searchModel->index(index), ContactsRoles::ChatNameRole).toString();
    int userId = m_searchModel->data(m_searchModel->index(index), ContactsRoles::UserIdRole).toInt();

    //ui->stackedWidget_2->setCurrentIndex(1, ContactsRoles::ChatNameRole);
    //ui->label_4->setText(itemWidget->GetName());
    if (!m_dialogsManager->IsDialogWithUserExist(userId)){
        SendCreateDialogReq(getCurrUserId(), userId, login);
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
        // CreateNewDialog
        QJsonDocument itemDoc = QJsonDocument::fromJson(reply->readAll());
        QJsonObject rootObject = itemDoc.object();
        m_dialogsManager->CreateNewChat(reply->property("toUserId").toInt(), rootObject.value("chatId").toInt(), reply->property("toUserName").toString());
        m_contactsModel->SetDataSource(m_dialogsManager);
        //AddNewWidgetDialog(rootObject.value("chatId").toInt(), reply->property("toUserName").toString(), true);
        //UpdateTextBrowser(rootObject.value("chatId").toInt());
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
    }
    else {
        qDebug() << "Failure" <<reply->errorString();
    }
}

void ChatClient::SaveUserInfo(int userId, const QString& deviceId, const QString& userName)
{
    QSettings settings(QApplication::applicationDirPath() + "/settings.ini", QSettings::IniFormat);
    settings.setValue("userId", userId);
    settings.setValue("deviceId", deviceId);
    settings.setValue("registered", true);
    settings.setValue("currUserName", userName);
}

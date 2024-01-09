#include "chatclient.h"

#include <src/model/data/dialogsmanager.h>
#include <src/model/contactsmodel.h>
#include <src/model/searchmodel.h>

#include <src/network/websocketclient.h>
#include <src/network/httpclient.h>

#include <src/utils/utils.h>

#include <QNetworkAccessManager>
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

ChatClient::ChatClient(std::shared_ptr<ContactsModel> contactsModel, std::shared_ptr<SearchModel> searchModel, QObject *parent) :
    QObject(parent),
    m_httpClient(std::make_shared<HttpClient>()),
    m_dialogsManager(std::make_shared<DialogsManager>()),
    m_contactsModel(contactsModel),
    m_searchModel(searchModel)
{
    m_contactsModel->SetDataSource(m_dialogsManager);
    m_searchModel->SetDataSource(std::vector<UserInfo>());
    //connect(ui->lineEdit, &QLineEdit::textEdited, this, &ChatWidget::LookingForPeople);
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

    OnGotNotification(msg.chatName, msg.text, m_dialogsManager->m_IdToDialog.at(msg.chatTo)->m_unreadCount, msg.time);
}

void ChatClient::UpdateTextBrowser(int selectedContactId)
{
    //ui->textBrowser->clear();
    //ui->textBrowser->setHtml(m_dialogsManager->GetDialog(selectedContactId).GetHtmlDialog());
}

void ChatClient::on_lineEdit_2_returnPressed()
{
    /*qDebug() << "here";
    QJsonObject obj;
    obj["content"] = ui->lineEdit_2->text();
    obj["user_from_id"] = getCurrUserId();
    obj["chat_to_id"] = ui->listWidget->currentItem()->data(Qt::UserRole).toInt();
    obj["chat_name"] = getCurrUserName();

    QJsonDocument doc(obj);

    m_client->SendTextMessage(doc.toJson(QJsonDocument::Compact));

    ui->lineEdit_2->clear();*/
}

void ChatClient::LookingForPeople(const QString& prefix)
{
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

    m_httpClient->sendHttpRequest(std::move(request), std::move(data), {}, std::bind(&ChatClient::LookingForPeopleReply, this, std::placeholders::_1));
}

void ChatClient::LookingForPeopleReply(QNetworkReply *reply){
    if (reply->error() == QNetworkReply::NoError) {
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

/*void ChatClient::SetNewDialog(QListWidgetItem * clickedItem)
{
    ui->lineEdit->clear();

    UserItemWidget *itemWidget = qobject_cast<UserItemWidget*>(ui->listWidget_2->itemWidget(clickedItem));

    ui->stackedWidget_2->setCurrentIndex(1);
    ui->label_4->setText(itemWidget->GetName());
    if (!m_dialogsManager->IsDialogWithUserExist(clickedItem->data(Qt::UserRole).toInt())){
        SendCreateDialogReq(getCurrUserId(), clickedItem->data(Qt::UserRole).toInt(), itemWidget->GetName());
    }
}*/

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
        AddNewWidgetDialog(rootObject.value("chatId").toInt(), reply->property("toUserName").toString(), true);
        UpdateTextBrowser(rootObject.value("chatId").toInt());
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

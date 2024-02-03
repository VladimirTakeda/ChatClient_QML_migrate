#pragma ones

#include <memory>
#include <QString>
#include <QObject>
#include <QQmlEngine>
#include <qqml.h>

class QNetworkAccessManager;
class QNetworkReply;
class HttpClient;
class UserInfo;

namespace WebSocket{
class Message;
class WebSocketClient;
}

class ContactsModel;
class SearchModel;
class ChatHistoryModel;

class DialogsManager;
class Dialog;

class ChatClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString SearchPrefix READ SearchPrefix WRITE setSearchPrefix NOTIFY SearchPrefixChanged FINAL)
public:
    ChatClient(std::shared_ptr<ContactsModel> contactsModel,
               std::shared_ptr<SearchModel> searchModel,
               std::shared_ptr<ChatHistoryModel> chatHistoryModel,
               QObject *parent = nullptr);
    void SetUpWSConnection();
    Q_INVOKABLE void loadDialogs();
    Q_INVOKABLE void saveDialogs() const;
    ~ChatClient();

    QString SearchPrefix() const;
    void setSearchPrefix(const QString &newSearchPrefix);

    Q_INVOKABLE bool isRegistered();

    Q_INVOKABLE void sendNewMessage(const QString& message);
    Q_INVOKABLE void updateCurrentChat(int index);

    Q_INVOKABLE void registerUser(const QString& login, const QString& password);
    void RegisterUserReply(QNetworkReply *reply);
    void SaveUserInfo(int userId, const QString& deviceId, const QString& userName);

signals:
    void SearchPrefixChanged();
    void dialogIndexChanged(int index);

private:
    void AddNewWidgetDialog(int chatId, const QString& name, bool needSetItem);
    void UpdateWidgetDialog(int chatId, const QString& lastMessage, uint64_t unreadCount, const QDateTime& localMsgTime);
    void AddMessageToWidgetDialog(int userId, const QString &lastMessage, bool NeedIncrement, const QDateTime& localMsgTime);
    void SetExistingDialogs();
    void SetSearchResults(const std::vector<UserInfo>& results);
    void SetNewDialog(int index);
    void SendCreateDialogReq(int fromUser, int toUser, const QString& toUserName);
    void GotNewMessage(WebSocket::Message mgs);
    void UpdateTextBrowser(int selectedContactId);

private slots:
    void LookingForPeople(const QString& prefix);
    void LookingForPeopleReply(QNetworkReply *rep);
    void CreateChatReply(QNetworkReply *rep);
    void OnGotNotification(const QString& name, const QString& text, int64_t unreadCount, const QDateTime& time);

private:

    std::unique_ptr<WebSocket::WebSocketClient> m_client;
    std::shared_ptr<HttpClient> m_httpClient;

    std::shared_ptr<DialogsManager> m_dialogsManager;

    std::shared_ptr<ContactsModel> m_contactsModel;
    std::shared_ptr<SearchModel> m_searchModel;
    std::shared_ptr<ChatHistoryModel> m_chatHistoryModel;

    QString m_SearchPrefix;
    std::shared_ptr<Dialog> m_currChat;
};

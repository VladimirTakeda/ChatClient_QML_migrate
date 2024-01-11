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

class DialogsManager;

class ChatClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString SearchPrefix READ SearchPrefix WRITE setSearchPrefix NOTIFY SearchPrefixChanged FINAL)
public:
    ChatClient(std::shared_ptr<ContactsModel> contactsModel, std::shared_ptr<SearchModel> searchModel, QObject *parent = nullptr);
    void SetUpWSConnection();
    void LoadDialogs();
    void SaveDialogs() const;
    ~ChatClient();

    QString SearchPrefix() const;
    void setSearchPrefix(const QString &newSearchPrefix);

signals:
    void SearchPrefixChanged();

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
    void on_lineEdit_2_returnPressed();
    void LookingForPeople(const QString& prefix);
    void LookingForPeopleReply(QNetworkReply *rep);
    void CreateChatReply(QNetworkReply *rep);
    void OnGotNotification(const QString& name, const QString& text, int64_t unreadCount, const QDateTime& time);

private:

    std::unique_ptr<WebSocket::WebSocketClient> m_client;
    std::shared_ptr<HttpClient> m_httpClient;

    std::unordered_map<QString, int> m_DialogsToId;
    std::shared_ptr<DialogsManager> m_dialogsManager;

    std::shared_ptr<ContactsModel> m_contactsModel;
    std::shared_ptr<SearchModel> m_searchModel;
    QString m_SearchPrefix;
};

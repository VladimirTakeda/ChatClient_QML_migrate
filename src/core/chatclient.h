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

/// Core engine for communication between UI and C++
class ChatClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString SearchPrefix READ SearchPrefix WRITE setSearchPrefix NOTIFY SearchPrefixChanged FINAL)
public:
    ChatClient(std::shared_ptr<ContactsModel> contactsModel,
               std::shared_ptr<SearchModel> searchModel,
               std::shared_ptr<ChatHistoryModel> chatHistoryModel,
               QObject *parent = nullptr);
    ~ChatClient();
    /// @brief Establish websocket connection between desktop client and backend side
    void SetUpWSConnection();
    /// @brief Return search prefix for users name
    QString SearchPrefix() const;
    /// @brief Set up a new search prefix
    void setSearchPrefix(const QString &newSearchPrefix);

    /// @brief Loads dialogs from local memory
    Q_INVOKABLE void loadDialogs();
    /// @brief Saves dialogs to local memory
    Q_INVOKABLE void saveDialogs() const;
    /// @brief Check if current user has been registered (if yes - establish websocket connection)
    Q_INVOKABLE bool isUserRegistered();
    /// @brief Send a text message from current user to another (using websocket)
    Q_INVOKABLE void sendNewMessage(const QString& message);
    /// @brief Set up curretn chat across the models by index (on UI update)
    Q_INVOKABLE void updateCurrentChat(int index);
    /// @brief Send image to backend and get it's id
    Q_INVOKABLE void sendImage(const QString& path, const QString& message);
    /// @brief Send user credentials and gets his id
    Q_INVOKABLE void registerUser(const QString& login, const QString& password);

    /// @brief Save information about current user to local storage
    void SaveUserInfo(int userId, const QString& deviceId, const QString& userName);

signals:
    /// @brief We need to make a request to backend to get a new user list according the new prefix
    void SearchPrefixChanged();
    /// @brief We clicked to another dialog and wee need to redraw all messages
    void dialogIndexChanged(int index);
    /// @brief We wants to see main widget with dialogs
    void goToMainWidget();

private:
    /// @brief Set the result of searching contacts to Search Model
    void SetSearchResults(const std::vector<UserInfo>& results);
    /// @brief Create a new dialog with one contact from Search Model or set up an existina dialog
    void SetNewDialog(int index);
    /// @brief Send http request to create a new dialog
    void SendCreateDialogReq(int fromUser, int toUser, const QString& toUserName);
    /// @brief Qt slot to recieve a new message from any contact
    void GotNewMessage(WebSocket::Message mgs);
    /// @brief Send http request to search for contacts by prefix
    void LookingForPeople(const QString& prefix);

private slots:
    void RegisterUserReply(QNetworkReply *reply);
    void SendImageReply(QNetworkReply *reply);
    void LookingForPeopleReply(QNetworkReply *reply);
    void CreateChatReply(QNetworkReply *reply);

    /// @brief TODO: it's a slot for push notifications
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

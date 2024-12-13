#ifndef WEBSOCKETCLIENT_H
#define WEBSOCKETCLIENT_H


#include <QtWebSockets/QWebSocketServer>
#include <QtWebSockets/QWebSocket>

#include <QObject>
#include <QDebug>

namespace WebSocket{

/// A struct for websocket message
struct Message{
    QString text;
    std::optional<QString> chatName;
    int userFrom;
    int chatTo;
    bool isMyMessage;
    QVector<QString> attachments; //vector of path (1 right now)
    QDateTime time;
};

/// A class to provide websocket (bidirectional) connection
class WebSocketClient : public QObject{
public:
    /// @brief Creates a socket and set up the slots for connection
    WebSocketClient(const QUrl &url, std::function<void(Message)> callBack, QObject* parent = nullptr);
    ~WebSocketClient();
    /// @brief send text message to socket
    void SendTextMessage(const QString& msg);
private slots:
    /// @brief Set up slot to message recieving
    void OnNewConnection();
    /// @brief Do nothing (just print some logs)
    void OnCloseConnection();
    /// @brief Parse the message and pass it to the callback
    void OnTextMessageRecieved(QString message);
    /// @brief We don't use ssl right now, may be delete this?
    void handle_ssl_errors(const QList<QSslError> &errors);
private:
    QWebSocket m_socket;
    std::function<void(Message)> m_callBack;
};

}

#endif // WEBSOCKETCLIENT_H

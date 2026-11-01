#include "websocketclient.h"

#include <src/utils/utils.h>

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

namespace WebSocket{

WebSocketClient::WebSocketClient(const QUrl &url, std::function<void(Message)> callBack, QObject* parent):
    QObject(parent),
    m_socket(),
    m_callBack(callBack)
{
    connect(&m_socket, QOverload<QAbstractSocket::SocketError>::of(&QWebSocket::errorOccurred),
            [=](QAbstractSocket::SocketError error){
                qDebug() << "Error";
            });
    connect(&m_socket, &QWebSocket::connected, this, &WebSocketClient::OnNewConnection);
    connect(&m_socket, &QWebSocket::disconnected, this, &WebSocketClient::OnCloseConnection);
    connect(&m_socket, QOverload<const QList<QSslError>&>::of(&QWebSocket::sslErrors),
            this, &WebSocketClient::handle_ssl_errors);
    qDebug() << "websocket path " << url.path();
    qDebug() << "websocket port " << url.port();
    qDebug() << "websocket url " << url.url();
    qDebug() << "websocket host " << url.host();
    m_socket.open(url);
    qDebug() << m_socket.state();
}

WebSocketClient::~WebSocketClient(){};

void WebSocketClient::SendTextMessage(const QString& msg){
    qDebug() << msg;
    qDebug() << "Sended bytes : " << m_socket.sendTextMessage(msg);
}

void WebSocketClient::OnNewConnection(){
    qDebug() << "New Connection";

    connect(&m_socket, &QWebSocket::textMessageReceived, this, &WebSocketClient::OnTextMessageRecieved);
}

void WebSocketClient::OnCloseConnection(){
    qDebug() << "Closed Connection";
}

void WebSocketClient::OnTextMessageRecieved(QString message){
    qDebug() << "[TIME] WS raw frame:" << message;
    QJsonDocument itemDoc = QJsonDocument::fromJson(message.toUtf8());
    QJsonObject rootObject = itemDoc.object();
    Message msg;
    msg.text = rootObject.value("content").toString();
    msg.userFrom = rootObject.value("user_from_id").toInt();
    msg.chatTo = rootObject.value("chat_to_id").toInt();
    msg.chatName = rootObject.value("chat_name").toString();
    msg.isMyMessage = (msg.userFrom == getCurrUserId());

    QJsonArray array = rootObject.value("attachments").toArray();

    foreach (const QJsonValue & value, array) {
        msg.attachments.push_back(value.toString());
    }

    const QJsonValue timeField = rootObject.value("time");
    const QString timeStr = timeField.toString();
    qDebug() << "[TIME] WS time field: present=" << (timeField.type() != QJsonValue::Undefined)
             << "type=" << timeField.type()
             << "raw=" << timeStr;
    msg.time = QDateTime::fromString(timeStr, Qt::ISODate).toLocalTime();
    qDebug() << "[TIME] WS parsed msg.time valid=" << msg.time.isValid()
             << "value=" << msg.time.toString(Qt::ISODate);
    if (!msg.time.isValid()) {
        msg.time = QDateTime::currentDateTime();
        qDebug() << "[TIME] WS fallback to currentDateTime:" << msg.time.toString(Qt::ISODate);
    }

    m_callBack(msg);
}

void WebSocketClient::handle_ssl_errors(const QList<QSslError> &errors){
    Q_UNUSED(errors);
    qDebug() << "SSL";
    m_socket.ignoreSslErrors();
}
}

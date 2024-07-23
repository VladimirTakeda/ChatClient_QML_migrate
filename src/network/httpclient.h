#ifndef HTTPCLIENT_H
#define HTTPCLIENT_H

#include <QObject>
#include <QHash>
#include <qsslerror.h>

class QNetworkAccessManager;
class QNetworkReply;
class QNetworkRequest;
class QHttpMultiPart;

constexpr std::string_view createChatReq = "CreateChatReq";
constexpr std::string_view getUsersListReq = "GetUsersListReq";

class HttpClient : public QObject {
    Q_OBJECT
public:
    HttpClient(QObject* parent = nullptr);

public:
    /// sends http request to backend side and sets up a callbeck for the answer
    void sendHttpRequest(QNetworkRequest&& request, QByteArray&& data, const std::vector<std::pair<std::string, QVariant>>& properties, std::function<void(QNetworkReply *)>);
    /// sends http request to backend side by blocks (for images and other large data)
    void sendHttpRequest(QNetworkRequest&& request, QHttpMultiPart *multipart, const std::vector<std::pair<std::string, QVariant>>& properties, std::function<void(QNetworkReply *)> callBack);
private slots:
    /// default slot to avaluate any answer
    void onRequestFinished(QNetworkReply* reply);
    /// default slot to avaluate any error
    void onSslErrors(QList<QSslError> errors);

private:
    QNetworkAccessManager* m_networkManager;
    std::unordered_map<QNetworkReply*, std::function<void(QNetworkReply *)>> m_reqToFunc;
    QHash<QNetworkReply*, std::string_view> m_requestNames;
};

#endif // HTTPCLIENT_H

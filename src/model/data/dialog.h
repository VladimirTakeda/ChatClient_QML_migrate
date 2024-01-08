#ifndef DIALOG_H
#define DIALOG_H

#include <QString>
#include <QList>
#include <QDateTime>

struct Message {
    QString text;
    bool isMyMessage;
    QDateTime time;
};

class DialogsManager;
class ChatClient;

class Dialog
{
    friend DialogsManager;
    friend ChatClient;
public:
    Dialog(int64_t chatId,const QString& name);
    void addMessage(const Message& msg);
    int GetChatId() const;
    QString GetName() const;
    std::shared_ptr<Message> GetLastMessage() const;
    const QString & GetHtmlDialog() const;
    int GetUnreadCount() const;
private:
    uint64_t m_unreadCount;
    int64_t m_chatId;
    QList<std::shared_ptr<Message>> m_messages;
    QString m_dialogName;
};

#endif // DIALOG_H

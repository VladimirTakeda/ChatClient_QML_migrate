#ifndef DIALOG_H
#define DIALOG_H

#include <QString>
#include <QList>
#include <QDateTime>

struct Message {
    QString text;
    bool isMyMessage;
    QDateTime time;
    //TODO: add attachments here
};

class DialogsManager;
class ChatClient;

/// A structure that represents a dialog of current user with another one
class Dialog
{
    friend DialogsManager;
    friend ChatClient;
public:
    Dialog(int64_t chatId,const QString& name);
    /// @brief Returns a number of all messages in dialog
    size_t Size() const;
    /// @brief Adds a new message to dialog
    void addMessage(const Message& msg);
    /// @brief Return chatId of curretn dialog
    int GetChatId() const;
    /// @brief Return the name of interlocutor in this dialog or the name of a chat
    QString GetName() const;
    /// @brief Return the last message of the dialog
    std::shared_ptr<Message> GetLastMessage() const;
    /// @brief Return the number of unread messages of curretn dialog
    int GetUnreadCount() const;
    /// @brief Provide access to message by index
    std::shared_ptr<Message> operator[](size_t index) const;
private:
    uint64_t m_unreadCount;
    int64_t m_chatId;
    QList<std::shared_ptr<Message>> m_messages;
    QString m_dialogName;
};

#endif // DIALOG_H

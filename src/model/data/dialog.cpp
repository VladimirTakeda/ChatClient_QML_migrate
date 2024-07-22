#include "../utils/utils.h"

#include "dialog.h"

QDataStream &operator<<(QDataStream &out, const Message& message)
{
    out << message.isMyMessage;
    QByteArray text = message.text.toUtf8();
    uint64_t msgSize = static_cast<uint64_t>(text.size());
    out << msgSize;
    out.writeRawData(text.constData(), msgSize);
    out << message.time;

    return out;
}

QDataStream &operator>>(QDataStream &in, Message& message)
{
    in >> message.isMyMessage;
    uint64_t size;
    in >> size;

    QByteArray text;
    text.resize(size);
    in.readRawData(text.data(), size);
    message.text = QString::fromUtf8(text);

    in >> message.time;

    return in;
}

Dialog::Dialog(){};

Dialog::Dialog(int64_t chatId, const QString& name) : m_chatId(chatId), m_dialogName(name), m_unreadCount(0)
{
}

size_t Dialog::Size() const
{
    return m_messages.size();
}

void Dialog::addMessage(const Message& msg)
{
    m_messages.push_back(std::make_shared<Message>(msg));
}

int Dialog::GetChatId() const
{
    return m_chatId;
}

QString Dialog::GetName() const
{
    if (m_dialogName.has_value())
        return m_dialogName.value();
    return m_InterlocutorName.value();
}

std::shared_ptr<Message> Dialog::GetLastMessage() const
{
    return m_messages.empty() ? nullptr : m_messages.back();
}

int Dialog::GetUnreadCount() const{
    return m_unreadCount;
}

std::shared_ptr<Message> Dialog::operator[](size_t index) const{
    if (m_messages.size() <= index)
        throw std::out_of_range("");
    return m_messages[index];
}


QDataStream &operator<<(QDataStream &out, const Dialog &dialog)
{
    out << dialog.m_chatId;
    out << dialog.m_unreadCount;
    out << dialog.m_dialogName;
    out << dialog.m_InterlocutorName;

    out << static_cast<uint64_t>(dialog.m_messages.size());

    for (const std::shared_ptr<Message>& msg : dialog.m_messages) {
        out << *msg;
    }
    return out;
}

QDataStream &operator>>(QDataStream &in, Dialog &dialog)
{
    in >> dialog.m_chatId;
    in >> dialog.m_unreadCount;
    in >> dialog.m_dialogName;
    in >> dialog.m_InterlocutorName;

    uint64_t messagesCount;
    in >> messagesCount;

    for (int j = 0; j < messagesCount; j++) {
        Message currentMessage;
        in >> currentMessage;
        dialog.addMessage(currentMessage);
    }

    return in;
}

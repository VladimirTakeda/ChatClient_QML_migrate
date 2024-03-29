#include "dialog.h"

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
    return m_dialogName;
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

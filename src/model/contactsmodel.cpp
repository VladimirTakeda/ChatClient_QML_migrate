#include "contactsmodel.h"

#include <src/model/data/dialogsmanager.h>

ContactsModel::ContactsModel(QObject *parent)
    : QAbstractListModel{parent}, m_signalConnected{false}

{
}

int ContactsModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_dialogsManager->DialogsCount();
}

QVariant ContactsModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_dialogsManager->DialogsCount())
        return {};

    const auto &dialog = m_dialogsManager->GetDialogByIndex(index.row());
    if (role == ChatNameRole)
        return dialog.GetName();
    if (role == LastMessageRole){
        auto lastMessage = dialog.GetLastMessage();
        if (lastMessage)
            return lastMessage->text;
        return "";
    }
    if (role == LastMessageTimeRole){
        auto lastMessage = dialog.GetLastMessage();
        if (lastMessage)
            return lastMessage->time.toString();
        return "";
    }
    if(role == MissedMessageCountRole)
        return dialog.GetUnreadCount();

    return {};
}

bool ContactsModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    return false;
}

Qt::ItemFlags ContactsModel::flags(const QModelIndex &index) const
{
    if(!index.isValid()) return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

//names will be used in qml
QHash<int, QByteArray> ContactsModel::roleNames() const
{
    QHash<int, QByteArray> roles{
        {ChatNameRole, "chatName"},
        {LastMessageRole, "lastMessage"},
        {LastMessageTimeRole, "lastMessageTime"},
        {MissedMessageCountRole, "missedMessageCount"}
    };
    return roles;
}

std::shared_ptr<DialogsManager> ContactsModel::dataSource() const
{
    return m_dialogsManager;
}

void ContactsModel::SetDataSource(std::shared_ptr<DialogsManager> manager)
{
    beginResetModel();      //reset data of model

    if(m_dialogsManager && m_signalConnected)
        m_dialogsManager->disconnect(this);

    m_dialogsManager = manager;

    //TODO: add signals

    m_signalConnected = true;

    endResetModel();
}



QString ContactsModel::ChatName() const
{
    return m_ChatName;
}

void ContactsModel::setChatName(const QString &newChatName)
{
    if (m_ChatName == newChatName)
        return;
    m_ChatName = newChatName;
    emit ChatNameChanged();
}

QString ContactsModel::LastMessage() const
{
    return m_LastMessage;
}

void ContactsModel::setLastMessage(const QString &newLastMessage)
{
    m_LastMessage = newLastMessage;
}

QString ContactsModel::LastMessageTime() const
{
    return m_LastMessageTime;
}

void ContactsModel::setLastMessageTime(const QString &newLastMessageTime)
{
    if (m_LastMessageTime == newLastMessageTime)
        return;
    m_LastMessageTime = newLastMessageTime;
    emit LastMessageTimeChanged();
}

QString ContactsModel::MissedMessageCount() const
{
    return m_MissedMessageCount;
}

void ContactsModel::setMissedMessageCount(const QString &newMissedMessageCount)
{
    if (m_MissedMessageCount == newMissedMessageCount)
        return;
    m_MissedMessageCount = newMissedMessageCount;
    emit MissedMessageCountChanged();
}

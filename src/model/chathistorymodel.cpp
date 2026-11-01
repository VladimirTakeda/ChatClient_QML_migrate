#include "chathistorymodel.h"

#include <QDebug>

#include <src/model/data/dialog.h>

namespace {
const QString timeFormat = "h:mm AP";
}

ChatHistoryModel::ChatHistoryModel(QObject *parent)
    : QAbstractListModel{parent}, m_signalConnected{false}

{
}

int ChatHistoryModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_chatHistory ? m_chatHistory->Size() : 0;
}

QVariant ChatHistoryModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_chatHistory->Size())
        return {};

    const auto &message = (*m_chatHistory)[index.row()];
    if (role == MessageRole)
        return message->text;
    if (role == IsMyMessageRole){
        return message->isMyMessage;
    }
    if (role == AttachmentRole){
        return message->attachments;
    }
    if (role == MessageTimeRole){
        const QString formatted = message->time.toString(timeFormat);
        qDebug() << "[TIME] ChatHistoryModel::data row=" << index.row()
                 << "time.isValid=" << message->time.isValid()
                 << "iso=" << message->time.toString(Qt::ISODate)
                 << "formatted=" << formatted;
        return formatted;
    }

    return {};
}

bool ChatHistoryModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    return false;
}

Qt::ItemFlags ChatHistoryModel::flags(const QModelIndex &index) const
{
    if(!index.isValid()) return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

//names will be used in qml
QHash<int, QByteArray> ChatHistoryModel::roleNames() const
{
    static QHash<int, QByteArray> roles{
        {MessageRole, "message"},
        {IsMyMessageRole, "isMyMessage"},
        {AttachmentRole, "attachments"},
        {MessageTimeRole, "messageTime"},
    };
    return roles;
}

std::shared_ptr<Dialog> ChatHistoryModel::dataSource() const
{
    return m_chatHistory;
}

void ChatHistoryModel::SetDataSource(std::shared_ptr<Dialog> manager)
{
    beginResetModel();      //reset data of model

    m_chatHistory = manager;

    m_signalConnected = true;

    endResetModel();

    emit scrollToBottom();
}

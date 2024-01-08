#include "searchmodel.h"

UserInfo::UserInfo(int userId, QString&& userNickname) : userId(userId), userLogin(std::move(userNickname)){

}

SearchModel::SearchModel(QObject *parent)
    : QAbstractListModel{parent}, m_signalConnected{false}

{
}

int SearchModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_foundedUsers.size();
}

QVariant SearchModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_foundedUsers.size())
        return {};

    const auto &user = m_foundedUsers[index.row()];
    if (role == ChatNameRole)
        return user.userLogin;

    return {};
}

bool SearchModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    return false;
}

Qt::ItemFlags SearchModel::flags(const QModelIndex &index) const
{
    if(!index.isValid()) return Qt::NoItemFlags;
    return Qt::ItemIsEditable;
}

//names will be used in qml
QHash<int, QByteArray> SearchModel::roleNames() const
{
    QHash<int, QByteArray> roles{
        {ChatNameRole, "chatName"},
    };
    return roles;
}

const std::vector<UserInfo>& SearchModel::dataSource() const
{
    return m_foundedUsers;
}

void SearchModel::SetDataSource(std::vector<UserInfo> &&results)
{
    beginResetModel();      //reset data of model

    m_foundedUsers = results;

    //TODO: add signals

    m_signalConnected = true;

    endResetModel();
}



QString SearchModel::ChatName() const
{
    return m_ChatName;
}

void SearchModel::setChatName(const QString &newChatName)
{
    if (m_ChatName == newChatName)
        return;
    m_ChatName = newChatName;
    emit ChatNameChanged();
}

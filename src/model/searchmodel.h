#pragma ones

#include <QAbstractListModel>
#include <QObject>
#include <QQmlEngine>

struct UserInfo
{
    UserInfo(int, QString&&);
    QString userLogin;
    int userId;
};

class SearchModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString ChatName READ ChatName WRITE setChatName NOTIFY ChatNameChanged FINAL)

    enum ContactsRoles{
        ChatNameRole = Qt::UserRole + 1,
        DialogIconRole
    };

public:
    explicit SearchModel(QObject *parent = nullptr);

    QVariant data(const QModelIndex &index = {}, int role = Qt::DisplayRole) const override;                //for editable models
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;        //for editable models

    int rowCount(const QModelIndex &parent = {}) const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    QHash<int, QByteArray> roleNames() const override;

    QString ChatName() const;
    void setChatName(const QString &newChatName);

    void SetDataSource(const std::vector<UserInfo> &results);
    const std::vector<UserInfo>& dataSource() const;

signals:

    void ChatNameChanged();

private:
    QString m_ChatName;

    std::vector<UserInfo> m_foundedUsers;
    bool m_signalConnected;
};

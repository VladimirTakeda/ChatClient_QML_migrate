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

bool operator == (const UserInfo& left, const UserInfo& right);

enum ContactsRoles{
    ChatNameRole = Qt::UserRole + 1,
    UserIdRole,
    DialogIconRole
};

/// A QML model that represents founded users by prefix
class SearchModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit SearchModel(QObject *parent = nullptr);

    QVariant data(const QModelIndex &index = {}, int role = Qt::DisplayRole) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;

    int rowCount(const QModelIndex &parent = {}) const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    QHash<int, QByteArray> roleNames() const override;

    /// Set a new data source
    void SetDataSource(const std::vector<UserInfo> &results);
    /// Returns curretn data source
    const std::vector<UserInfo>& dataSource() const;

    /// It's a slot to avaluate the click on item of the model, in this slot we should set up the dialog with clicked user
    Q_INVOKABLE void onItemClicked(int index);

signals:
    void ItemClicked(int index);

private:
    std::vector<UserInfo> m_foundedUsers;
    bool m_signalConnected;
};

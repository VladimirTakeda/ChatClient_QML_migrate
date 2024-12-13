#pragma ones

#include <QAbstractListModel>
#include <QObject>
#include <QQmlEngine>

class DialogsManager;

/// A QML model that represents current user contacts (on the left panel)
class ContactsModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

    enum ContactsRoles{
        ChatNameRole = Qt::UserRole + 1,
        LastMessageRole,
        LastMessageTimeRole,
        MissedMessageCountRole,
        DialogIconRole
    };

public:
    explicit ContactsModel(QObject *parent = nullptr);

    /// returns the information about contact by index and role (index represents the contact, role represents the exact info about the contact)
    QVariant data(const QModelIndex &index = {}, int role = Qt::DisplayRole) const override;
    /// set an information about the contact by index
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;

    int rowCount(const QModelIndex &parent = {}) const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    QHash<int, QByteArray> roleNames() const override;
    /// Changes the curretn model data source
    void SetDataSource(std::shared_ptr<DialogsManager>);
    /// Returns curretn data source
    std::shared_ptr<DialogsManager> dataSource() const;

private:

    std::shared_ptr<DialogsManager> m_dialogsManager;
    bool m_signalConnected;
};

#pragma ones

#include <QAbstractListModel>
#include <QObject>
#include <QQmlEngine>

class DialogsManager;

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

    QVariant data(const QModelIndex &index = {}, int role = Qt::DisplayRole) const override;                //for editable models
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;        //for editable models

    int rowCount(const QModelIndex &parent = {}) const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    QHash<int, QByteArray> roleNames() const override;

    void SetDataSource(std::shared_ptr<DialogsManager>);
    std::shared_ptr<DialogsManager> dataSource() const;

private:

    std::shared_ptr<DialogsManager> m_dialogsManager;
    bool m_signalConnected;
};

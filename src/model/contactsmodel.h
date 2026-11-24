#pragma once

#include <QAbstractListModel>
#include <QObject>
#include <QPointer>
#include <QQmlEngine>

class DialogsManager;

/// A QML model that represents current user contacts (on the left panel)
class ContactsModel : public QAbstractListModel {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    enum ContactsRoles {
        ChatNameRole = Qt::UserRole + 1,
        LastMessageRole,
        LastMessageTimeRole,
        MissedMessageCountRole,
        DialogIconRole
    };

public:
    /// No default argument on purpose: a default-constructible QML_SINGLETON is
    /// created by the QML engine with `new`, ignoring create(), and QML would get
    /// a second, empty model (see qmlsingleton.h)
    explicit ContactsModel(QObject *parent);
    /// QML_SINGLETON factory: gives the QML engine the one ContactsModel that
    /// main() created
    static ContactsModel *create(QQmlEngine *, QJSEngine *);

    /// returns the information about contact by index and role (index represents
    /// the contact, role represents the exact info about the contact)
    QVariant data(const QModelIndex &index = {},
                  int role = Qt::DisplayRole) const override;
    /// set an information about the contact by index
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    int rowCount(const QModelIndex &parent = {}) const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    QHash<int, QByteArray> roleNames() const override;
    /// Changes the curretn model data source
    void SetDataSource(std::shared_ptr<DialogsManager>);
    /// Returns curretn data source
    std::shared_ptr<DialogsManager> dataSource() const;

private:
    static inline QPointer<ContactsModel> s_instance;

    std::shared_ptr<DialogsManager> m_dialogsManager;
    bool m_signalConnected;
};

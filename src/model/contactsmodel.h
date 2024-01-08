#pragma ones

#include <QAbstractListModel>
#include <QObject>
#include <QQmlEngine>

class DialogsManager;

class ContactsModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString ChatName READ ChatName WRITE setChatName NOTIFY ChatNameChanged FINAL)
    Q_PROPERTY(QString LastMessage READ LastMessage WRITE setLastMessage NOTIFY LastMessageChanged FINAL)
    Q_PROPERTY(QString LastMessageTime READ LastMessageTime WRITE setLastMessageTime NOTIFY LastMessageTimeChanged FINAL)
    Q_PROPERTY(QString MissedMessageCount READ MissedMessageCount WRITE setMissedMessageCount NOTIFY MissedMessageCountChanged FINAL)

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

    QString ChatName() const;
    void setChatName(const QString &newChatName);

    QString LastMessage() const;
    void setLastMessage(const QString &newLastMessage);

    QString LastMessageTime() const;
    void setLastMessageTime(const QString &newLastMessageTime);

    QString MissedMessageCount() const;
    void setMissedMessageCount(const QString &newMissedMessageCount);

    void SetDataSource(std::shared_ptr<DialogsManager>);
    std::shared_ptr<DialogsManager> dataSource() const;

signals:

    void ChatNameChanged();

    void LastMessageChanged();

    void LastMessageTimeChanged();

    void MissedMessageCountChanged();

private:
    QString m_ChatName;
    QString m_LastMessage;
    QString m_LastMessageTime;
    QString m_MissedMessageCount;

    std::shared_ptr<DialogsManager> m_dialogsManager;
    bool m_signalConnected;
};

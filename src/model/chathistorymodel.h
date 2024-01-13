#pragma ones

#include <QAbstractListModel>
#include <QObject>
#include <QQmlEngine>

class Dialog;

class ChatHistoryModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

    enum ContactsRoles{
        MessageRole = Qt::UserRole + 1,
        IsMyMessageRole
    };

public:
    explicit ChatHistoryModel(QObject *parent = nullptr);

    QVariant data(const QModelIndex &index = {}, int role = Qt::DisplayRole) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;

    int rowCount(const QModelIndex &parent = {}) const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    QHash<int, QByteArray> roleNames() const override;

    void SetDataSource(std::shared_ptr<Dialog>);
    std::shared_ptr<Dialog> dataSource() const;

private:

    std::shared_ptr<Dialog> m_chatHistory;
    bool m_signalConnected;
};

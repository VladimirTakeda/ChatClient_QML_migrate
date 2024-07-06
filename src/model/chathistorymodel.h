#pragma ones

#include <QAbstractListModel>
#include <QObject>
#include <QQmlEngine>

class Dialog;

/// A QML model that represents the curretn dialog i.e. it's messages
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

    /// returns the information about message by index and role (index represents the message, role represents the exact info about the message)
    QVariant data(const QModelIndex &index = {}, int role = Qt::DisplayRole) const override;
    /// set an information about the message by index
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;
    /// Returns the current model size
    int rowCount(const QModelIndex &parent = {}) const override;
    /// ????
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    /// Defines the information about the model element (i.e. message)
    QHash<int, QByteArray> roleNames() const override;
    /// Changes the curretn model data source, i.e. set up a new dialog
    void SetDataSource(std::shared_ptr<Dialog>);
    /// Returns curretn data source
    std::shared_ptr<Dialog> dataSource() const;
signals:
    /// A sigmal to QML to draw the history from the end (not from the start)
    void scrollToBottom();

private:

    std::shared_ptr<Dialog> m_chatHistory;
    bool m_signalConnected;
};

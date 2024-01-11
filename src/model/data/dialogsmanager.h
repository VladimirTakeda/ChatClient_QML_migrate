#ifndef DIALOGSMANAGER_H
#define DIALOGSMANAGER_H

#include "dialog.h"

#include <unordered_set>

class ChatClient;

class DialogsManager : public QObject
{
    Q_OBJECT
    friend ChatClient;
public:
    DialogsManager(QObject *parent = nullptr);
    void CreateNewChat(std::optional<int> userId, int chatId, const QString& userToName);
    void AddMessage(int userId, const Message& msg);
    const Dialog& GetDialog(int userId);
    const Dialog& GetDialogByIndex(int modelIndex);
    bool IsChatExist(int chatId) const;
    bool IsDialogWithUserExist(int userId) const;
    void LoadFromMemory();
    void SaveToMemory() const;
    int DialogsCount() const;

private:
    void SaveDialogs() const;
    void SaveGuiDialogs() const;
    void LoadDialogs();
    void LoadGuiDialogs();

private:
    //std::unordered_map<int, int> m_UserToChatId;
    std::unordered_set<int32_t> m_users; // users, we have dialog with

    std::unordered_map<int32_t, std::list<std::shared_ptr<Dialog>>::iterator> m_IdToDialog;
    std::list<std::shared_ptr<Dialog>> m_modelData;

    std::unordered_map<int32_t, QString> m_IdToName;
};

#endif // DIALOGSMANAGER_H

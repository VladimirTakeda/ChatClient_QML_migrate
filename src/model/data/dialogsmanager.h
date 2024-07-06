#ifndef DIALOGSMANAGER_H
#define DIALOGSMANAGER_H

#include <unordered_set>

#include "dialog.h"

class ChatClient;

/// A structure that store all the dialogs of current user and provide API to manupulate them
class DialogsManager : public QObject
{
    Q_OBJECT
    friend ChatClient;
public:
    DialogsManager(QObject *parent = nullptr);
    /// @brief Creates a new chat and sets up it id and name
    void CreateNewChat(std::optional<int> userId, int chatId, const QString& userToName);
    /// @brief Adds a message to a chat by id
    void AddMessage(int userId, const Message& msg);
    /// @brief Return a dialog by interlocutor id
    const Dialog& GetDialog(int userId);
    /// @brief Return a dialog by model index
    std::shared_ptr<Dialog> GetDialogByIndex(int modelIndex);
    /// @brief Check if the chat with presented chatId is exist in local memory
    bool IsChatExist(int chatId) const;
    /// @brief Check if the chat with userId is exist in local memory
    bool IsDialogWithUserExist(int userId) const;

    /// @brief Loads chats from local memory
    void LoadFromMemory();
    /// @brief Saves chats to local memory
    void SaveToMemory() const;

    /// @brief Returns the size of dialogs model, i.e. the number of dialogs
    int DialogsCount() const;

private:
    // Saves dialogs model to local memory
    void SaveDialogs() const;
    void SaveGuiDialogs() const;
    // Loads dialogs model from local memory
    void LoadDialogs();
    void LoadGuiDialogs();

private:
    std::unordered_set<int32_t> m_users; // users, we have dialog with
    std::unordered_map<int32_t, int32_t> m_UserToChat;

    std::unordered_map<int32_t, std::list<std::shared_ptr<Dialog>>::iterator> m_IdToDialog;
    std::list<std::shared_ptr<Dialog>> m_modelData;

    std::unordered_map<int32_t, QString> m_IdToName;
};

#endif // DIALOGSMANAGER_H

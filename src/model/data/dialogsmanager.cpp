#include "dialogsmanager.h"

#include <QString>
#include <QFile>
#include <QCoreApplication>
#include <QDebug>

DialogsManager::DialogsManager(QObject *parent) : QObject(parent)
{

}

void DialogsManager::CreateNewChat(std::optional<int> userId, int chatId, const QString &userToName)
{
    if (userToName.isEmpty()) {
        qWarning() << "[EMPTY-NAME] DialogsManager::CreateNewChat called with EMPTY userToName."
                   << "userId=" << (userId ? QString::number(*userId) : "nullopt")
                   << "chatId=" << chatId;
    }
    if (userId){
        m_UserToChat[userId.value()] = chatId;
    }
    m_modelData.push_front(std::make_shared<Dialog>(chatId, userToName));
    m_IdToDialog.emplace(chatId, m_modelData.begin());
}

void DialogsManager::AddMessage(int chatId, const Message& msg)
{
    auto iter = m_IdToDialog.at(chatId);
    std::shared_ptr<Dialog> dialog = *iter;
    dialog->addMessage(msg);
    m_modelData.erase(iter);
    m_modelData.push_front(dialog);
    m_IdToDialog[chatId] =  m_modelData.begin();
}

const Dialog& DialogsManager::GetDialog(int chatId)
{
    return  **m_IdToDialog.at(chatId);
}

std::shared_ptr<Dialog> DialogsManager::GetDialogByIndex(int index)
{
    return *(std::next(m_modelData.begin(), index));
}

bool DialogsManager::IsChatExist(int chatId) const
{
    return m_IdToDialog.count(chatId);
}

bool DialogsManager::IsDialogWithUserExist(int userId) const
{
    return m_UserToChat.count(userId);
}

//TODO rewrite to binary format
void DialogsManager::LoadFromMemory()
{
    LoadDialogs();
}

//TODO rewrite to binary format
void DialogsManager::SaveToMemory() const
{
    SaveDialogs();
}

void DialogsManager::SaveDialogs() const
{
#ifdef Q_OS_WIN
    QFile outFile("dialogs");
#endif

#ifdef Q_OS_MAC
    QFile outFile(QCoreApplication::applicationDirPath() + "/../../../dialogs");
#endif
    if (outFile.open(QIODevice::WriteOnly)) {
        //DataStream writes in binary format
        QDataStream out(&outFile);

        out << static_cast<uint64_t>(m_modelData.size());
        for (auto &dialog : m_modelData){
            const bool dnEmpty = dialog->m_dialogName.has_value() && dialog->m_dialogName->isEmpty();
            const bool inEmpty = dialog->m_InterlocutorName.has_value() && dialog->m_InterlocutorName->isEmpty();
            if ((dnEmpty || !dialog->m_dialogName.has_value()) &&
                (inEmpty || !dialog->m_InterlocutorName.has_value())) {
                qWarning() << "[EMPTY-NAME] DialogsManager::SaveDialogs persisting dialog with empty/missing name."
                           << "chatId=" << dialog->GetChatId()
                           << "m_dialogName.has_value=" << dialog->m_dialogName.has_value()
                           << "m_InterlocutorName.has_value=" << dialog->m_InterlocutorName.has_value();
            }
            out << *dialog;
        }

        int32_t size = m_UserToChat.size();
        out << size;

        // Записываем элементы контейнера
        for (const auto& [key, value] : m_UserToChat) {
            out << key;
            out << value;
        }

        outFile.close();
    }
}

void DialogsManager::LoadDialogs()
{
#ifdef Q_OS_WIN
    QFile inFile("dialogs");
#endif

#ifdef Q_OS_MAC
    QFile inFile(QCoreApplication::applicationDirPath() + "/../../../dialogs");
#endif

    if (inFile.open(QIODevice::ReadOnly)) {
        m_IdToDialog.clear();
        m_modelData.clear();

        QDataStream in(&inFile);

        uint64_t dialogsCount = 0;
        in >> dialogsCount;
        qDebug() << "LoadDialogs: file" << inFile.fileName() << "contains" << dialogsCount << "dialog(s)";

        for (uint64_t i = 0; i < dialogsCount; i++){
            std::shared_ptr<Dialog> currentDialog = std::make_shared<Dialog>();
            in >> *currentDialog;

            const bool dnEmpty = currentDialog->m_dialogName.has_value() && currentDialog->m_dialogName->isEmpty();
            const bool inEmpty = currentDialog->m_InterlocutorName.has_value() && currentDialog->m_InterlocutorName->isEmpty();
            if ((dnEmpty || !currentDialog->m_dialogName.has_value()) &&
                (inEmpty || !currentDialog->m_InterlocutorName.has_value())) {
                qWarning() << "[EMPTY-NAME] DialogsManager::LoadDialogs loaded dialog with empty/missing name."
                           << "chatId=" << currentDialog->GetChatId()
                           << "m_dialogName.has_value=" << currentDialog->m_dialogName.has_value()
                           << "m_InterlocutorName.has_value=" << currentDialog->m_InterlocutorName.has_value();
            }

            if (!currentDialog->m_messages.empty()) {
                m_modelData.push_back(currentDialog);
                m_IdToDialog.emplace(currentDialog->GetChatId(), std::prev(m_modelData.end()));
            }
        }

        int32_t size;
        in >> size;

        int32_t userId;
        int32_t chatId;

        for (int i = 0; i < size; i++) {
            in >> userId >> chatId;
            m_UserToChat[userId] = chatId;
        }

        inFile.close();
    }
}

int DialogsManager::DialogsCount() const
{
    return m_modelData.size();
}

void DialogsManager::Clear()
{
    m_modelData.clear();
    m_IdToDialog.clear();
    m_UserToChat.clear();
}

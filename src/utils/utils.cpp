#include "utils.h"

#include <QSettings>
#include <QApplication>

int getCurrUserId(){
#ifdef Q_OS_WIN
    QSettings settings(QCoreApplication::applicationDirPath() + "/settings.ini", QSettings::IniFormat);
#endif

#ifdef Q_OS_MAC
    QSettings settings(QCoreApplication::applicationDirPath() + "/../../../settings.ini", QSettings::IniFormat);
#endif
    qDebug() << settings.fileName();
    return settings.value("userId").toInt();
}

QString getCurrDeviceId(){
#ifdef Q_OS_WIN
    QSettings settings(QCoreApplication::applicationDirPath() + "/settings.ini", QSettings::IniFormat);
#endif

#ifdef Q_OS_MAC
    QSettings settings(QCoreApplication::applicationDirPath() + "/../../../settings.ini", QSettings::IniFormat);
#endif
    qDebug() << settings.fileName();
    return settings.value("deviceId").toString();
}

QString getCurrUserName(){
#ifdef Q_OS_WIN
    QSettings settings(QCoreApplication::applicationDirPath() + "/settings.ini", QSettings::IniFormat);
#endif

#ifdef Q_OS_MAC
    QSettings settings(QCoreApplication::applicationDirPath() + "/../../../settings.ini", QSettings::IniFormat);
#endif
    qDebug() << settings.fileName();
    return settings.value("currUserName").toString();
}

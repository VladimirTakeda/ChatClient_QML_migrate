#pragma once

#include <QDataStream>
#include <QString>
#include <optional>

/// Return curr user id from QSettings file
int getCurrUserId();
/// Return curr device id from QSettings file
QString getCurrDeviceId();
/// Return curr user name from QSettings file
QString getCurrUserName();

template<typename T>
QDataStream& operator<<(QDataStream& out, const std::optional<T>& opt)
{
    out << opt.has_value();
    if (opt.has_value()) {
        out << *opt;
    }
    return out;
}

template<typename T>
QDataStream& operator>>(QDataStream& in, std::optional<T>& opt)
{
    bool hasValue = false;
    in >> hasValue;

    if (hasValue) {
        T value{};
        in >> value;
        opt = std::move(value);
    } else {
        opt.reset();
    }
    return in;
}
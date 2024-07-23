#pragma ones

#include <QString>

/// Return curr user id from QSettings file
int getCurrUserId();
/// Return curr device id from QSettings file
QString getCurrDeviceId();
/// Return curr user name from QSettings file
QString getCurrUserName();


template<typename T>
QDataStream& operator<<(QDataStream& out, const std::optional<T>& opt)
{
    QChar value = opt.has_value() ? QChar::fromLatin1(0) : QChar::fromLatin1(1);
    out << value;
    if (opt.has_value()) {
        out << opt.value();
    }
    return out;
}

// Оператор >> для чтения std::optional<T> из QDataStream
template<typename T>
QDataStream& operator>>(QDataStream& in, std::optional<T>& opt)
{
    QChar hasValue;
    in >> hasValue;

    if (hasValue.isNull()) {
        T value;
        in >> value;
        opt = std::move(value);
    } else {
        opt = std::nullopt;
    }
    return in;
}

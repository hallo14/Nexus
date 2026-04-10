#ifndef TERMINAL_H
#define TERMINAL_H

#include <QObject>
#include <QtQml/qqmlregistration.h>

#endif // TERMINAL_H


class Terminal : public QObject {
    Q_OBJECT
    QML_ELEMENT


private:
    QStringList buffer;
    QString command;

public:


signals:


}

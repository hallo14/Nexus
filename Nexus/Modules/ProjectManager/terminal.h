#ifndef TERMINAL_H
#define TERMINAL_H

#include <QObject>
#include <QtQml/qqmlregistration.h>
#include <QProcess>

#endif // TERMINAL_H


class Terminal : public QObject {
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QString buffer READ buffer NOTIFY bufferChanged)
    Q_PROPERTY(QString command READ command WRITE setCommand NOTIFY commandChanged)
    Q_PROPERTY(QString dir READ dir WRITE setDir NOTIFY dirChanged)


private:
    QString m_buffer;
    QString m_command;
    QString m_dir;
    QProcess* m_process;

public:
    explicit Terminal(QObject* parent = nullptr);
     ~Terminal();

    QString buffer();
    QString command();
    QString dir();

    void setCommand(QString command);
    void setDir(QString dir);

    Q_INVOKABLE void executeCommand();


signals:
    void bufferChanged();
    void commandChanged();
    void dirChanged();

};

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
    Q_PROPERTY(bool processRunning READ processRunning NOTIFY processRunningChanged)


private:
    QString m_buffer;
    QStringList m_commandList = {""};
    int m_commandIndex = 0;
    QString m_dir;
    QProcess* m_process;
    bool m_processRunning = false;

public:
    explicit Terminal(QObject* parent = nullptr);
     ~Terminal();

    QString buffer();
    QString command();
    QString dir();
    bool processRunning();

    void setCommand(QString command);
    void setDir(QString dir);

    Q_INVOKABLE void executeCommand();
    Q_INVOKABLE void stopCommand();
    Q_INVOKABLE void incrementIndex(int idx = 1);

    Q_INVOKABLE void printStartupMessage();


signals:
    void bufferChanged();
    void commandChanged();
    void dirChanged();
    void processRunningChanged();

};

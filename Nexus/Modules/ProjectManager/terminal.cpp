#include "terminal.h"
#include <QTimer>
#include <qdebug.h>
#include <QRegularExpression>

QString Terminal::buffer()
{
    return m_buffer;
}

QString Terminal::command()
{
    return m_command;
}

QString Terminal::dir()
{
    return m_dir;
}

bool Terminal::processRunning()
{
    return m_processRunning;
}

void Terminal::setCommand(QString command)
{
    m_command = command;
    emit commandChanged();
}

void Terminal::setDir(QString dir)
{
    m_dir = dir;
    emit dirChanged();
}

void Terminal::executeCommand()
{
    stopCommand();
    m_process->setWorkingDirectory(m_dir);
    m_process->startCommand("cmd /c " + m_command);
    m_processRunning = true;
    emit processRunningChanged();
}

void Terminal::stopCommand()
{
    if (!m_process || m_process->state() == QProcess::NotRunning) return;

    QProcess::startDetached("taskkill", {"/f", "/t", "/pid", QString::number(m_process->processId())});
}

Terminal::Terminal(QObject* parent) : QObject(parent) {
    m_process = new QProcess(this);

    connect(m_process, &QProcess::readyReadStandardOutput, this, [this] {
        m_buffer += QString::fromUtf8(m_process->readAllStandardOutput()).remove(QRegularExpression("\x1b\\[[0-9;]*[a-zA-Z]"));
        emit bufferChanged();
    });

    connect(m_process, &QProcess::readyReadStandardError, this, [this] {
        m_buffer += QString::fromUtf8(m_process->readAllStandardError()).remove(QRegularExpression("\x1b\\[[0-9;]*[a-zA-Z]"));
        emit bufferChanged();
    });

    connect(m_process, &QProcess::started, this, [this] {
        m_processRunning = true;
        emit processRunningChanged();
    });

    connect(m_process, &QProcess::finished, this, [this] {
        m_processRunning = false;
        emit processRunningChanged();
    });

    connect(m_process, &QProcess::aboutToClose, this, [this] {
        stopCommand();
    });
}

Terminal::~Terminal() {
    if (m_process && m_process->state() == QProcess::Running) {
        QProcess::startDetached("taskkill", {"/f", "/t", "/pid", QString::number(m_process->processId())});
        m_process->waitForFinished();
    }
}

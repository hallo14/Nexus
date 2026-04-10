#include "terminal.h"

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
    if (m_process->state() == QProcess::Running) {
        QProcess::startDetached("taskkill", {"/f", "/t", "/pid", QString::number(m_process->processId())});
        m_process->waitForFinished();
    }
    m_process->setWorkingDirectory(m_dir);
    m_process->startCommand("cmd /c" + m_command);
}

Terminal::Terminal(QObject* parent) : QObject(parent) {
    m_process = new QProcess(this);

    connect(m_process, &QProcess::readyReadStandardOutput, this, [this] {
        m_buffer += QString::fromUtf8(m_process->readAllStandardOutput());
        emit bufferChanged();
    });

    connect(m_process, &QProcess::readyReadStandardError, this, [this] {
        m_buffer += QString::fromUtf8(m_process->readAllStandardError());
        emit bufferChanged();
    });

    connect(m_process, &QProcess::aboutToClose, this, [this] {
        QProcess::startDetached("taskkill", {"/f", "/t", "/pid", QString::number(m_process->processId())});
        m_process->waitForFinished();
    });
}

Terminal::~Terminal() {
    if (m_process && m_process->state() == QProcess::Running) {
        QProcess::startDetached("taskkill", {"/f", "/t", "/pid", QString::number(m_process->processId())});
        m_process->waitForFinished();
    }
}

#include "terminal.h"
#include <QTimer>
#include <qdebug.h>
#include <QRegularExpression>
#include <QDir>

QString Terminal::buffer()
{
    return m_buffer;
}

QString Terminal::command()
{
    return m_commandList[m_commandIndex];
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
    m_commandList[m_commandIndex] = command;
    emit commandChanged();
}

void Terminal::setDir(QString dir)
{
    m_dir = dir;
    emit dirChanged();
}

void Terminal::executeCommand(QString cmd)
{
    stopCommand();

    m_process->setWorkingDirectory(m_dir);

    QString baseCmd = cmd.split(' ').at(0);
    if (m_localCommands.contains(baseCmd)) {
        (this->*m_localCommands[baseCmd])(cmd);
        return;
    } else {
        m_process->startCommand("cmd /c " + cmd);
    }
    m_processRunning = true;
    emit processRunningChanged();
}

void Terminal::prepareCommand()
{
    QString cmd = command().toLower();

    stopCommand();
    m_buffer += m_dir.split('/').last() + "> " + cmd + '\n';
    if (m_commandList[0] != "") {
        m_commandList.emplaceFront("");
    }
    m_commandIndex = 0;
    emit bufferChanged();

    executeCommand(cmd);
}

void Terminal::stopCommand()
{
    if (!m_process || m_process->state() == QProcess::NotRunning) return;

    QProcess::startDetached("taskkill", {"/f", "/t", "/pid", QString::number(m_process->processId())});
}

void Terminal::incrementIndex(int idx)
{
    if (m_commandIndex + idx >= m_commandList.size() || m_commandIndex + idx < 0) return;
    m_commandIndex += idx;
    emit commandChanged();
}

void Terminal::printStartupMessage()
{
    QString message = {
        "[PROJECT] " + m_dir.split('/').last() + "\n"
        "[ROOT]      " + m_dir + "\n"
        "[TYPE]       Ready for input...\n"
    };

    m_buffer.append(message);
    emit bufferChanged();
}

void Terminal::handleCls(QString cmd)
{
    m_buffer.clear();
    emit bufferChanged();
}

void Terminal::handleCd(QString cmd)
{
    QString arg = cmd.split(' ').at(1).trimmed();

    QDir dir(m_dir);
    if (dir.cd(arg)) {
        m_dir = dir.path();
        m_buffer.append("New Directory: " + m_dir + "\n");
        emit dirChanged();
    }
    else {
        m_buffer.append("ERROR: \"" + arg + "\" not found\n");
    }
    bufferChanged();
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

    m_localCommands["cls"] = &Terminal::handleCls;
    m_localCommands["clear"] = &Terminal::handleCls;
    m_localCommands["cd"] = &Terminal::handleCd;
}

Terminal::~Terminal() {
    if (m_process && m_process->state() == QProcess::Running) {
        QProcess::startDetached("taskkill", {"/f", "/t", "/pid", QString::number(m_process->processId())});
        m_process->waitForFinished();
    }
}

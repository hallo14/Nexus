#include "githubcontroller.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QTimer>
#include <QClipboard>
#include <QGuiApplication>
#include <QDir>
#include <QProcess>


GithubController::GithubController(QObject* parent) : QObject(parent) {
    m_manager = new QNetworkAccessManager(this);
    connect(m_manager, &QNetworkAccessManager::finished, this, &GithubController::onFinished);
    getReposFromConfig();
}

QList<GithubRepo> GithubController::repoList() {
    return m_repoList;
}
QString GithubController::userCode() {
    return m_userCode;
}
QString GithubController::verificationURI() {
    return m_verificationURI;
}
GithubRepo GithubController::selectedRepo() {
    if (m_selectedIndex < 0 || m_selectedIndex >= m_repoList.size()) return {};
    return m_repoList.at(m_selectedIndex);
}
int GithubController::selectedIndex() {
    return m_selectedIndex;
}
void GithubController::setSelectedIndex(int idx) {
    m_selectedIndex = idx;

    selectedIndexChanged();
    selectedRepoChanged();
}
void GithubController::addCommand(QString name, QString command) {
    if (m_selectedIndex < 0 || m_selectedIndex >= m_repoList.size()) return;
    addCommandToConfig(m_repoList[m_selectedIndex].name, name, command);
    m_repoList[m_selectedIndex].commands[name] = command;
    selectedRepoChanged();
}
void GithubController::executeCommand(QString command) {
    if (command.isEmpty()) return;

    QString workingDir = m_repoList[m_selectedIndex].localPath;
    QString nativePath = QDir::toNativeSeparators(workingDir);

    command.replace("%ProjectDir%", nativePath);

    qDebug() << command;
    QStringList args;
    args << "/c" << command;

    QProcess::startDetached("cmd.exe", args, nativePath);

}
void GithubController::copyToClipboard(QString text) {
    QGuiApplication::clipboard()->setText(text);
}
void GithubController::addLocalRepo(QString urlString) {
    QUrl url(urlString);

    QString path = url.toLocalFile();

    QDir dir(path);
    if (!dir.exists(".git")) return;

    dir.cd(".git");

    QFile file(QString(dir.filePath("config")));

    QString content;
    if (!file.open(QIODevice::ReadOnly)) return;

    QTextStream in(&file);
    QString line;
    while (!in.atEnd()) {
        line = in.readLine().trimmed();

        if (line.startsWith("url = ")) break;
    }
    file.close();

    line = line.section('=', 1).trimmed();


    if (line.endsWith(".git")) {
        line.chop(4);
    }


    QString repoName = line.section('/', -1);

    GithubRepo repo;
    repo.name = repoName;
    repo.localPath = path;

    if (!addRepoToConfig(repo)) return;

    m_repoList.append(repo);


    repoListChanged();
    selectedRepoChanged();
}
bool GithubController::addRepoToConfig(GithubRepo repo) {
    QFile file("config/config.json");

    QDir dir("config/");
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    QJsonObject root;

    if (file.exists() && file.open(QIODevice::ReadOnly)) {
        root = QJsonDocument::fromJson(file.readAll()).object();
        file.close();
    }


    if (root["repos"].toObject().contains(repo.name)) return false;

    QJsonObject newRepoContent;
    newRepoContent["path"] = repo.localPath;

    QJsonObject repos;
    repos = root["repos"].toObject();

    repos[repo.name] = newRepoContent;
    root["repos"] = repos;

    if (file.open(QIODevice::WriteOnly)) {
        file.write(QJsonDocument(root).toJson());
        file.close();
    }

    return true;
}
void GithubController::addCommandToConfig(QString repoName, QString commandName, QString command) {
    QFile file("config/config.json");

    QDir dir("config/");
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    QJsonObject root;

    if (file.exists() && file.open(QIODevice::ReadOnly)) {
        root = QJsonDocument::fromJson(file.readAll()).object();
        file.close();
    }

    QJsonObject repos;
    repos = root["repos"].toObject();

    QJsonObject repo;
    repo = repos[repoName].toObject();

    QJsonObject commands;
    commands = repo["commands"].toObject();

    commands[commandName] = command;

    repo["commands"] = commands;
    repos[repoName] = repo;
    root["repos"] = repos;

    if (file.open(QIODevice::WriteOnly)) {
        file.write(QJsonDocument(root).toJson());
        file.close();
    }
}
void GithubController::getReposFromConfig() {
    QFile file("config/config.json");

    QJsonObject root;

    if (file.exists() && file.open(QIODevice::ReadOnly)) {
        root = QJsonDocument::fromJson(file.readAll()).object();
        file.close();
    }


    QJsonObject repoObject = root["repos"].toObject();
    QStringList keys = repoObject.keys();

    for (QString key : keys) {
        GithubRepo repo;
        repo.name = key;

        QJsonObject repoData = repoObject[key].toObject();
        repo.localPath = repoData["path"].toString();

        QJsonObject cObject = repoData["commands"].toObject();
        QStringList cKeys = cObject.keys();
        for (QString cKey : cKeys) {
            repo.commands[cKey] = cObject[cKey].toString();
        }

        m_repoList.append(repo);
    }

    repoListChanged();
}

void GithubController::fetchRepos() {

    if (m_accessToken != "") {
        QUrl url = QUrl("https://api.github.com/user/repos");

        QNetworkRequest request(url);

        request.setRawHeader("Accept", "application/json");
        request.setRawHeader("Authorization", QString("Bearer %1").arg(m_accessToken).toUtf8());
        request.setRawHeader("User-Agent", "Nexus");

        m_manager->get(request)->setProperty("requestID", "fetchRepos");

    }
}

void GithubController::requestCode() {

    QUrl url = QUrl("https://github.com/login/device/code");

    QNetworkRequest request(url);

    request.setRawHeader("Accept", "application/json");
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject json;

    json["client_id"] = "Ov23li3vfajx3pVXpdXn";
    json["scope"] = "repo";

    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    m_manager->post(request, data)->setProperty("requestID", "requestCode");
}

void GithubController::fetchAccessToken() {
    QUrl url = QUrl("https://github.com/login/oauth/access_token");

    QNetworkRequest request(url);

    request.setRawHeader("Accept", "application/json");
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject json;

    json["client_id"] = "Ov23li3vfajx3pVXpdXn";
    json["device_code"] = m_deviceCode;
    json["grant_type"] = "urn:ietf:params:oauth:grant-type:device_code";

    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    m_manager->post(request, data)->setProperty("requestID", "requestAccessToken");

}

void GithubController::onFinished(QNetworkReply* reply) {

    if (reply->error() != QNetworkReply::NoError) {
        qDebug() << reply->errorString();
        reply->deleteLater();

        return;
    }

    if (reply->property("requestID") == "requestCode") {
        QByteArray response = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(response);
        QJsonObject obj = doc.object();

        m_deviceCode = obj["device_code"].toString();
        m_interval = (obj["interval"].toInt()+5) * 1000;
        m_userCode = obj["user_code"].toString();
        m_verificationURI = obj["verification_uri"].toString();

        userCodeChanged();

        m_timer = new QTimer(this);
        connect(m_timer, &QTimer::timeout, this, &GithubController::fetchAccessToken);
        m_timer->start(m_interval);
    }
    else if (reply->property("requestID") == "requestAccessToken") {
        QByteArray response = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(response);
        QJsonObject obj = doc.object();

        if (obj.contains("access_token")) {
            m_accessToken = obj["access_token"].toString();
            m_timer->stop();

        }
        else if (obj.contains("error")) {
            qDebug() << obj["error"];
        }
    }


    reply->deleteLater();
}

#include "githubcontroller.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>


GithubController::GithubController(QObject* parent) : QObject(parent) {
    m_manager = new QNetworkAccessManager(this);
    connect(m_manager, &QNetworkAccessManager::finished, this, &GithubController::onFetchFinished);
}

QVariantList GithubController::repoList() {
    return m_repoList;
}

void GithubController::fetchRepos() {

    QUrl url = QUrl("https://api.github.com/users/hallo14/repos");

    QNetworkRequest request(url);

    request.setHeader(QNetworkRequest::UserAgentHeader, "nexus");

    m_manager->get(request);

}
void GithubController::onFetchFinished(QNetworkReply* reply) {


    if (reply->error() == QNetworkReply::NoError) {
        QByteArray response = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(response);
        QJsonArray array = doc.array();

        for (const QJsonValue& value : array) {
            QVariantMap repo;
            QJsonObject obj = value.toObject();
            repo["name"] = obj["name"].toString();
            m_repoList.append(repo);

        }

        emit repoListChanged();
    }
    reply->deleteLater();
}

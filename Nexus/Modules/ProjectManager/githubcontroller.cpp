#include "githubcontroller.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>


GithubController::GithubController(QObject* parent) : QObject(parent) {
    m_manager = new QNetworkAccessManager(this);
    connect(m_manager, &QNetworkAccessManager::finished, this, &GithubController::onFinished);
}

QVariantList GithubController::repoList() {
    return m_repoList;
}

void GithubController::fetchRepos() {

    QUrl url = QUrl("https://api.github.com/users/hallo14/repos");

    QNetworkRequest request(url);

    request.setHeader(QNetworkRequest::UserAgentHeader, "nexus");

    m_manager->get(request)->setProperty("requestID", "fetchRepos");

}

void GithubController::requestCode() {

    QUrl url = QUrl("https://github.com/login/device/code");

    QNetworkRequest request(url);

    request.setRawHeader("Accept", "application/json");


    QJsonObject json;

    json["client_id"] = "Ov23li3vfajx3pVXpdXn";
    json["scope"] = "repo";

    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    m_manager->post(request, data)->setProperty("requestID", "requestCode");
}

void GithubController::onFinished(QNetworkReply* reply) {

    if (reply->error() != QNetworkReply::NoError) {
        reply->deleteLater();
        return;
    }

    if (reply->property("requestID") == "fetchRepos") {
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
    else if (reply->property("requestID") == "requestCode") {
        QByteArray response = reply->readAll();
        QJsonDocument doc = QJsonDocument::fromJson(response);
        QJsonArray array = doc.array();

        QDebug(array[])
    }


    reply->deleteLater();
}

#include "githubcontroller.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QTimer>
#include <QClipboard>
#include <QGuiApplication>


GithubController::GithubController(QObject* parent) : QObject(parent) {
    m_manager = new QNetworkAccessManager(this);
    connect(m_manager, &QNetworkAccessManager::finished, this, &GithubController::onFinished);
}

QVariantList GithubController::repoList() {
    return m_repoList;
}
QString GithubController::userCode() {
    return m_userCode;
}
QString GithubController::verificationURI() {
    return m_verificationURI;
}
void GithubController::copyToClipboard(QString text) {
    QGuiApplication::clipboard()->setText(text);
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

    if (reply->property("requestID") == "fetchRepos") {
        m_repoList.clear();

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

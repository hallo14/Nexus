#ifndef GITHUBCONTROLLER_H
#define GITHUBCONTROLLER_H

#include <QObject>
#include <QStandardItem>
#include <QStandardItemModel>
#include <QNetworkAccessManager>
#include <QtQml/qqmlregistration.h>
#include <QNetworkReply>

#endif // GITHUBCONTROLLER_H


struct GitHubRepo {
    QString name;
};

class GithubController : public QObject {
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QVariantList repoList READ repoList NOTIFY repoListChanged)
    Q_PROPERTY(QString userCode READ userCode NOTIFY userCodeChanged)
    Q_PROPERTY(QString verificationURI READ verificationURI NOTIFY verificationURIChanged)

private:
    QNetworkAccessManager* m_manager;

    QVariantList m_repoList;

    QTimer* m_timer;
    QString m_deviceCode;
    int m_interval;
    QString m_accessToken;
    QString m_userCode;
    QString m_verificationURI;

public:

    explicit GithubController(QObject* parent = nullptr);

    QVariantList repoList();
    QString userCode();
    QString verificationURI();

    Q_INVOKABLE void fetchRepos();
    Q_INVOKABLE void requestCode();
    void fetchAccessToken();

    Q_INVOKABLE void copyToClipboard(QString text);


signals:
    void repoListChanged();
    void userCodeChanged();
    void verificationURIChanged();

private slots:
    void onFinished(QNetworkReply* reply);
};

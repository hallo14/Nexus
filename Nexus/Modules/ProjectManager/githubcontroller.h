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

private:
    QNetworkAccessManager* m_manager;

    QVariantList m_repoList;

public:

    explicit GithubController(QObject* parent = nullptr);

    QVariantList repoList();
    Q_INVOKABLE void fetchRepos();


signals:
    void repoListChanged();

private slots:
    void onFetchFinished(QNetworkReply* reply);
};

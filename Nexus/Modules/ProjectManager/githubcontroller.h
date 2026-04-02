#ifndef GITHUBCONTROLLER_H
#define GITHUBCONTROLLER_H

#include <QObject>
#include <QStandardItem>
#include <QStandardItemModel>
#include <QNetworkAccessManager>
#include <QtQml/qqmlregistration.h>
#include <QNetworkReply>
#include <QMap>

#endif // GITHUBCONTROLLER_H


struct GithubRepo {
    Q_GADGET
    Q_PROPERTY(QString name MEMBER name);
    Q_PROPERTY(QString localPath MEMBER localPath);
    Q_PROPERTY(QVariantMap commands MEMBER commands);

public:

    QString name;
    QString localPath;
    QVariantMap commands;
};

class GithubController : public QObject {
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QList<GithubRepo> repoList READ repoList NOTIFY repoListChanged)
    Q_PROPERTY(QString userCode READ userCode NOTIFY userCodeChanged)
    Q_PROPERTY(QString verificationURI READ verificationURI NOTIFY verificationURIChanged)
    Q_PROPERTY(int selectedIndex READ selectedIndex WRITE setSelectedIndex NOTIFY selectedIndexChanged FINAL)
    Q_PROPERTY(GithubRepo selectedRepo READ selectedRepo NOTIFY selectedRepoChanged FINAL)

private:
    QNetworkAccessManager* m_manager;

    QList<GithubRepo> m_repoList;
    int m_selectedIndex;

    QTimer* m_timer;
    QString m_deviceCode;
    int m_interval;
    QString m_accessToken;
    QString m_userCode;
    QString m_verificationURI;

public:

    explicit GithubController(QObject* parent = nullptr);

    QList<GithubRepo> repoList();
    QString userCode();
    QString verificationURI();
    GithubRepo selectedRepo();
    int selectedIndex();
    void setSelectedIndex(int idx);
    Q_INVOKABLE void executeCommand(QString command);
    bool addRepoToConfig(GithubRepo repo);
    bool removeRepoFromConfig(QString repoName);
    void addCommandToConfig(QString repoName, QString commandName, QString command);
    void removeCommandFromConfig(QString repoName, QString commandName);
    void getReposFromConfig();
    Q_INVOKABLE void refreshRepos();

    Q_INVOKABLE void fetchRepos();
    Q_INVOKABLE void requestCode();
    void fetchAccessToken();

    Q_INVOKABLE void addCommand(QString name, QString command);
    Q_INVOKABLE void removeCommand(QString name);

    Q_INVOKABLE void addLocalRepo(QString start);
    Q_INVOKABLE void removeLocalRepo(int idx, QString repoName);

    Q_INVOKABLE void copyToClipboard(QString text);


signals:
    void repoListChanged();
    void userCodeChanged();
    void verificationURIChanged();
    void selectedRepoChanged();
    void selectedIndexChanged();

private slots:
    void onFinished(QNetworkReply* reply);
};

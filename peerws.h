#pragma once

#include <QObject>
#include <QWebSocketServer>
#include <QWebSocket>
#include <QTimer>
#include <QAbstractSocket>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStringList>

class PeerWs : public QObject
{
    Q_OBJECT

public:
    explicit PeerWs(QObject *parent = nullptr);
    explicit PeerWs(quint16 port, QObject *parent = nullptr);

    void start(const QString &mode, const QString &targetIP, quint16 port);
    bool isConnected() const;
    QString currentMode() const;
    QString currentTarget() const;
    QString localIp() const;

signals:
    void messageReceived(const QString &msg);
    void status(const QString &s);
    void linkReady(bool ok);

public slots:
    void sendMessageDisplay(const QString &msg);

private slots:
    void onNewConnection();
    void onServerMessage(const QString &msg);
    void onServerDisconnected();

    void onClientConnected();
    void onClientMessage(const QString &msg);
    void onClientDisconnected();
    void onClientError(QAbstractSocket::SocketError err);
    void reconnect();

private:
    QString normalizeMode(const QString &mode) const;
    QString stateToStr(QAbstractSocket::SocketState st) const;
    void flushPending();
    void sendHello();

    QString m_mode;
    QString m_targetIP;
    quint16 m_port = 0;

    QWebSocketServer *server = nullptr;
    QWebSocket *incoming = nullptr;
    QWebSocket client;
    QTimer reconnectTimer;
    QStringList pendingMsgs;
    QString m_localIp;
};

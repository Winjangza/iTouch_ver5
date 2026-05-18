#include "peerws.h"

#include <QHostAddress>
#include <QUrl>
#include <QDebug>
#include <QDateTime>
#include <QNetworkInterface>

PeerWs::PeerWs(QObject *parent)
    : QObject(parent)
{
    reconnectTimer.setInterval(2000);
    reconnectTimer.setSingleShot(true);
    connect(&reconnectTimer, &QTimer::timeout, this, &PeerWs::reconnect);

    connect(&client, &QWebSocket::connected,
            this, &PeerWs::onClientConnected);

    connect(&client, &QWebSocket::textMessageReceived,
            this, &PeerWs::onClientMessage);

    connect(&client, &QWebSocket::disconnected,
            this, &PeerWs::onClientDisconnected);

    connect(&client,
            QOverload<QAbstractSocket::SocketError>::of(&QWebSocket::error),
            this,
            &PeerWs::onClientError);
}

PeerWs::PeerWs(quint16 port, QObject *parent)
    : QObject(parent),
      m_port(port)
{
    reconnectTimer.setInterval(2000);
    reconnectTimer.setSingleShot(true);
    connect(&reconnectTimer, &QTimer::timeout, this, &PeerWs::reconnect);

    connect(&client, &QWebSocket::connected,
            this, &PeerWs::onClientConnected);

    connect(&client, &QWebSocket::textMessageReceived,
            this, &PeerWs::onClientMessage);

    connect(&client, &QWebSocket::disconnected,
            this, &PeerWs::onClientDisconnected);

    connect(&client,
            QOverload<QAbstractSocket::SocketError>::of(&QWebSocket::error),
            this,
            &PeerWs::onClientError);
}

QString PeerWs::normalizeMode(const QString &mode) const
{
    const QString m = mode.trimmed().toUpper();
    if (m == "MASTER") return "master";
    if (m == "SLAVE")  return "slave";
    return QString();
}

QString PeerWs::stateToStr(QAbstractSocket::SocketState st) const
{
    switch (st) {
    case QAbstractSocket::UnconnectedState: return "Unconnected";
    case QAbstractSocket::HostLookupState:  return "HostLookup";
    case QAbstractSocket::ConnectingState:  return "Connecting";
    case QAbstractSocket::ConnectedState:   return "Connected";
    case QAbstractSocket::ClosingState:     return "Closing";
    case QAbstractSocket::BoundState:       return "Bound";
    case QAbstractSocket::ListeningState:   return "Listening";
    default: return "Other";
    }
}

QString PeerWs::currentMode() const
{
    return m_mode;
}

QString PeerWs::currentTarget() const
{
    return m_targetIP;
}

QString PeerWs::localIp() const
{
    return m_localIp;
}

bool PeerWs::isConnected() const
{
    if (incoming && incoming->state() == QAbstractSocket::ConnectedState)
        return true;

    if (client.state() == QAbstractSocket::ConnectedState)
        return true;

    return false;
}

void PeerWs::start(const QString &mode, const QString &targetIP, quint16 port)
{
    const QString m = normalizeMode(mode);
    if (m.isEmpty()) {
        emit status("DISPLAY PEER: invalid mode");
        qWarning() << "[PeerWs] invalid mode =" << mode;
        return;
    }

    m_mode = m;
    m_targetIP = targetIP.trimmed();
    m_port = port;

    reconnectTimer.stop();
    pendingMsgs.clear();

    // หาค่า local ip แบบง่าย
    m_localIp.clear();
    const auto ifs = QNetworkInterface::allAddresses();
    for (const QHostAddress &addr : ifs) {
        if (addr.protocol() == QAbstractSocket::IPv4Protocol &&
            !addr.isLoopback()) {
            m_localIp = addr.toString();
            break;
        }
    }

    // cleanup เก่า
    if (incoming) {
        incoming->close();
        incoming->deleteLater();
        incoming = nullptr;
    }

    if (server) {
        if (server->isListening())
            server->close();
        server->deleteLater();
        server = nullptr;
    }

    if (client.state() != QAbstractSocket::UnconnectedState) {
        client.abort();
    }

    // ---------------- MASTER = LISTEN ----------------
    if (m_mode == "master") {
        server = new QWebSocketServer(QStringLiteral("DisplayPeer"),
                                      QWebSocketServer::NonSecureMode,
                                      this);

        connect(server, &QWebSocketServer::newConnection,
                this, &PeerWs::onNewConnection);

        const bool ok = server->listen(QHostAddress::Any, m_port);

        qDebug() << "[PeerWs] MASTER listen =" << ok
                 << "port =" << m_port
                 << "err =" << server->errorString();

        if (!ok) {
            emit status(QString("DISPLAY PEER LISTEN FAILED: %1").arg(server->errorString()));
            emit linkReady(false);
            return;
        }

        emit status(QString("DISPLAY PEER MASTER LISTEN %1").arg(m_port));
        emit linkReady(false);
        return;
    }

    // ---------------- SLAVE = CONNECT ----------------
    if (m_mode == "slave") {
        if (m_targetIP.isEmpty()) {
            emit status("DISPLAY PEER SLAVE: targetIP empty");
            emit linkReady(false);
            return;
        }

        const QString url = QString("ws://%1:%2").arg(m_targetIP).arg(m_port);
        qDebug() << "[PeerWs] SLAVE connect ->" << url;

        emit status(QString("DISPLAY PEER SLAVE CONNECT %1").arg(url));
        client.open(QUrl(url));
        emit linkReady(false);
        return;
    }
}

void PeerWs::sendHello()
{
    QJsonObject o;
    o["type"] = "peer_hello";
    o["ip"] = m_localIp;
    o["ts"] = QDateTime::currentDateTime().toString(Qt::ISODate);

    const QString msg = QString::fromUtf8(QJsonDocument(o).toJson(QJsonDocument::Compact));
    sendMessageDisplay(msg);
}

void PeerWs::sendMessageDisplay(const QString &msg)
{
    qDebug() << "[PeerWs] sendMessageDisplay role=" << m_mode
             << "connected=" << isConnected()
             << "msg=" << msg.left(200);

    if (m_mode == "master") {
        if (!incoming || incoming->state() != QAbstractSocket::ConnectedState) {
            qWarning() << "[PeerWs] queue msg (master no incoming yet)";
            if (!pendingMsgs.contains(msg))
                pendingMsgs << msg;
            return;
        }
        incoming->sendTextMessage(msg);
        return;
    }

    if (m_mode == "slave") {
        if (client.state() != QAbstractSocket::ConnectedState) {
            qWarning() << "[PeerWs] queue msg (slave not connected yet)";
            if (!pendingMsgs.contains(msg))
                pendingMsgs << msg;
            return;
        }
        client.sendTextMessage(msg);
        return;
    }

    qWarning() << "[PeerWs] unknown mode -> queue";
    if (!pendingMsgs.contains(msg))
        pendingMsgs << msg;
}

void PeerWs::flushPending()
{
    if (pendingMsgs.isEmpty()) {
        qDebug() << "[PeerWs] flushPending: nothing";
        return;
    }

    qDebug() << "[PeerWs] flushPending count =" << pendingMsgs.size();

    if (m_mode == "master") {
        if (!incoming || incoming->state() != QAbstractSocket::ConnectedState) {
            qDebug() << "[PeerWs] flushPending master not ready";
            return;
        }

        for (const QString &m : pendingMsgs) {
            qDebug() << "[PeerWs] flush(master):" << m.left(200);
            incoming->sendTextMessage(m);
        }
        pendingMsgs.clear();
        return;
    }

    if (m_mode == "slave") {
        if (client.state() != QAbstractSocket::ConnectedState) {
            qDebug() << "[PeerWs] flushPending slave not ready";
            return;
        }

        for (const QString &m : pendingMsgs) {
            qDebug() << "[PeerWs] flush(slave):" << m.left(200);
            client.sendTextMessage(m);
        }
        pendingMsgs.clear();
        return;
    }
}

void PeerWs::onNewConnection()
{
    if (!server) return;

    QWebSocket *ws = server->nextPendingConnection();
    if (!ws) return;

    const QString peerIp = ws->peerAddress().toString();
    qDebug() << "[PeerWs] newConnection from" << peerIp << ":" << ws->peerPort();

    if (incoming) {
        incoming->close();
        incoming->deleteLater();
        incoming = nullptr;
    }

    incoming = ws;

    connect(incoming, &QWebSocket::textMessageReceived,
            this, &PeerWs::onServerMessage);

    connect(incoming, &QWebSocket::disconnected,
            this, &PeerWs::onServerDisconnected);

    emit status("DISPLAY PEER CONNECTED");
    emit linkReady(true);

    flushPending();
    sendHello();
}

void PeerWs::onServerMessage(const QString &msg)
{
    qDebug() << "[PeerWs] server recv:" << msg;
    emit messageReceived(msg);
}

void PeerWs::onServerDisconnected()
{
    qWarning() << "[PeerWs] server disconnected";
    emit status("DISPLAY PEER DISCONNECTED");
    emit linkReady(false);

    if (incoming) {
        incoming->deleteLater();
        incoming = nullptr;
    }
}

void PeerWs::onClientConnected()
{
    qDebug() << "[PeerWs] client connected";
    emit status("DISPLAY PEER CONNECTED");
    emit linkReady(true);

    flushPending();
    sendHello();
}

void PeerWs::onClientMessage(const QString &msg)
{
    qDebug() << "[PeerWs] client recv:" << msg;
    emit messageReceived(msg);
}

void PeerWs::onClientDisconnected()
{
    qWarning() << "[PeerWs] client disconnected";
    emit status("DISPLAY PEER DISCONNECTED");
    emit linkReady(false);

    // ฝั่ง slave ให้ reconnect เองตลอด
    reconnectTimer.start();
}

void PeerWs::onClientError(QAbstractSocket::SocketError err)
{
    Q_UNUSED(err);
    qWarning() << "[PeerWs] client error:" << client.errorString()
               << "state=" << stateToStr(client.state());

    emit status(QString("DISPLAY PEER ERROR: %1").arg(client.errorString()));
    emit linkReady(false);

    reconnectTimer.start();
}

void PeerWs::reconnect()
{
    if (m_mode != "slave") return;
    if (m_targetIP.isEmpty()) return;
    if (m_port == 0) return;

    const QString url = QString("ws://%1:%2").arg(m_targetIP).arg(m_port);
    qDebug() << "[PeerWs] reconnect ->" << url;

    if (client.state() != QAbstractSocket::UnconnectedState)
        client.abort();

    client.open(QUrl(url));
}

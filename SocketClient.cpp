#include "SocketClient.h"

QT_USE_NAMESPACE

//! [constructor]
SocketClient::SocketClient(QObject *parent) :
    QObject(parent)
{
    connect(&m_webSocket, &QWebSocket::connected, this, &SocketClient::onConnected);
    connect(&m_webSocket, &QWebSocket::disconnected, this, &SocketClient::onDisconnected);
    connect(&m_webSocket, QOverload<QAbstractSocket::SocketError>::of(&QWebSocket::error),
    [=](QAbstractSocket::SocketError error){
        if (isConnected){
            emit closed(m_socketID, m_ipaddress);
            isConnected = false;
        }
//        qDebug() << "Connecting Error: ";
//        emit SocketClientError();
    });
    connect(&m_webSocket, &QWebSocket::textMessageReceived,
            this, &SocketClient::onTextMessageReceived);
}
//! [constructor]

//! [createConnection]
void SocketClient::createConnection(int softphoneID, int channelIdInRole, QString ipaddress, quint16 port)
{
    QString url = QString("ws://%1:%2").arg(ipaddress).arg(port);
    QUrl iGateSocketServerUrl(url);
    qDebug() << "WebSocket server:" << url;
    if (m_debug)
        qDebug() << "WebSocket server:" << url;
    m_url = iGateSocketServerUrl;
    m_ipaddress = ipaddress;
    softPhoneID = softphoneID;
    m_socketID = channelIdInRole;
    m_webSocket.open(QUrl(iGateSocketServerUrl));
}
void SocketClient::createConnection(QString ipaddress, quint16 port)
{
    QString url = QString("ws://%1:%2").arg(ipaddress).arg(port);
//    QString url = QString("ws://%1:%2").arg("192.168.10.25").arg("1234");
    QUrl iGateSocketServerUrl(url);
//    qDebug() << "WebSocket server:" << url;
    if (m_debug)
        qDebug() << "WebSocket server:" << url;
    m_url = iGateSocketServerUrl;
    m_ipaddress = ipaddress;
    qDebug() << "m_ipaddress:" << m_ipaddress << m_url;

    m_webSocket.open(QUrl(iGateSocketServerUrl));
}
//! [createConnection]

//! [onConnected]
void SocketClient::onConnected()
{
    isConnected = true;
    qDebug() << "WebSocket connected";
    emit Connected();
}
//! [onConnected]

//! [onTextMessageReceived]
void SocketClient::onTextMessageReceived(QString message)
{
    emit newCommandProcess(message);
}
//! [onTextMessageReceived]

void SocketClient::sendMessage(QString msg){
    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();
    QString getCommand =  QJsonValue(command["objectName"]).toString().trimmed();
    QString menuID =  QJsonValue(command["menuID"]).toString().trimmed();
    if(msg!=""){
        qDebug() << "send socket:"<< msg;
        m_webSocket.sendTextMessage(msg);
    }else if(getCommand == "ButtonPattern"){
        qDebug() << "sendMessage:"<< msg;
        m_webSocket.sendTextMessage(msg);
    }

}

void SocketClient::onDisconnected()
{
    isConnected = false;
    qDebug() << m_ipaddress << "WebSocket disconnected";
    emit closed(m_socketID, m_ipaddress);
    emit SocketClientError();
    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
    emit disconnected(pClient);
}

void SocketClient::onError(QAbstractSocket::SocketError error)
{
    qDebug() << "Connecting Error: ";
    isConnected = false;
//    emit SocketClientError();
}
void SocketClient::disconnectFromServer() {
    if (m_webSocket.state() == QAbstractSocket::ConnectedState ||
        m_webSocket.state() == QAbstractSocket::ConnectingState)
    {
        qDebug() << "Closing WebSocket connection to" << m_ipaddress;
        m_webSocket.close();   // triggers onDisconnected()
        isConnected = false;
    } else {
        qDebug() << "WebSocket already disconnected";
    }
}

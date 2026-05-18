#pragma once
#include <QObject>
#include <QWebSocketServer>
#include <QWebSocket>
#include <QSet>

class WebServer : public QObject {
    Q_OBJECT
public:
    explicit WebServer(quint16 port, QObject* parent = nullptr);
    ~WebServer();

    bool isListening() const { return m_server && m_server->isListening(); }
    QString errorString() const { return m_server ? m_server->errorString() : QStringLiteral("no server"); }

signals:
    // ส่งต่อข้อความจาก client ไปยัง MainWindow::manageData(QString, QWebSocket*)
    void newCommandProcess(const QString& message, QWebSocket* client);

public slots:
    // ส่งข้อความไปยัง client ปลายทาง (ใช้กับสัญญาณจาก Database)
    void sendMessage(QString message, QWebSocket* pSender);

    // ส่งทุกคน
    void broadcast(const QString& msg);

    // helper: ส่งให้ client ที่กำหนด
    void sendTo(QWebSocket* client, const QString& msg);

    // รับข้อความจาก client (ต่อเข้ากับ textMessageReceived)
    void processMessage(const QString& message);
    void broadcastMessage(QString message);
private slots:
    void onNewConnection();
    void onClientDisconnected();
    void onServerClosed();

private:
    QWebSocketServer* m_server = nullptr;
    QSet<QWebSocket*> m_clients;
};

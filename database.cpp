#include "database.h"
#include <QDateTime>
#include <QStringList>
#include <QString>
#include <QProcess>
#include <QVariant>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>
#include <QJsonDocument>
#include <typeinfo>
#include <QVariant>
Database::Database(QString dbName, QString user, QString password, QString host, QObject *parent) :
    QObject(parent)
{
    qDebug() << "Connecting to MySQL" << dbName << user << password << host;
    db = QSqlDatabase::addDatabase("QMYSQL");
    db.setHostName(host);
    db.setDatabaseName(dbName);
    db.setUserName(user);
    db.setPassword(password);

    if (!db.open()) {
        qDebug() << "Database connection failed:" << db.lastError().text();
        return;
    }
    qDebug() << "Database connected successfully!";
}
void Database::checkDatabaseAndUpdate() {
    qDebug() << "[DBCheck] checkDatabaseAndUpdate()";

    QSqlDatabase db = QSqlDatabase::database();
    if (!db.isOpen()) {
        if (!db.open()) {
//            qWarning() << "[DBCheck] open failed:" << db.lastError().text();
            return;
        }
    }

    const QString schema = db.databaseName();
    QSqlQuery q(db);

    auto tableExists = [&](const QString& name)->bool {
        QSqlQuery qq(db);
        qq.prepare(R"(
            SELECT COUNT(*)
              FROM INFORMATION_SCHEMA.TABLES
             WHERE TABLE_SCHEMA = :schema AND TABLE_NAME = :name
        )");
        qq.bindValue(":schema", schema);
        qq.bindValue(":name", name);
        if (!qq.exec()) { qWarning() << "[DBCheck] tableExists failed:" << name << qq.lastError().text(); return false; }
        qq.next();
        return qq.value(0).toInt() > 0;
    };

    auto columnExists = [&](const QString& table, const QString& col)->bool {
        QSqlQuery qq(db);
        qq.prepare(R"(
            SELECT COUNT(*)
              FROM INFORMATION_SCHEMA.COLUMNS
             WHERE TABLE_SCHEMA = :schema AND TABLE_NAME = :t AND COLUMN_NAME = :c
        )");
        qq.bindValue(":schema", schema);
        qq.bindValue(":t", table);
        qq.bindValue(":c", col);
        if (!qq.exec()) { qWarning() << "[DBCheck] columnExists failed:" << table << col << qq.lastError().text(); return false; }
        qq.next();
        return qq.value(0).toInt() > 0;
    };

    auto ensureRowExists = [&](const QString& table, const QString& whereCountSQL, const QString& insertSQL)->void {
        QSqlQuery qq(db);
        if (!qq.exec(whereCountSQL)) {
//            qWarning() << "[DBCheck] row check failed for" << table << ":" << qq.lastError().text();
            return;
        }
        qq.next();
        if (qq.value(0).toInt() == 0) {
            QSqlQuery qins(db);
            if (!qins.exec(insertSQL)) {
                qWarning() << "[DBCheck] seed row failed for" << table << ":" << qins.lastError().text();
            } else {
                qDebug() << "[DBCheck] seeded default row for" << table;
            }
        }
    };

    // ========================= userMode =========================
    if (!tableExists("userMode")) {
        if (!q.exec(R"(
            CREATE TABLE userMode (
              id INT NOT NULL PRIMARY KEY,
              `USER` VARCHAR(32) NULL,
              IP_MASTER VARCHAR(64) NULL,
              IP_SLAVE VARCHAR(64) NULL,
              LOCATION VARCHAR(64) NULL,
              swversion VARCHAR(64) NULL,
              IP_SNMP VARCHAR(64) NULL,
              IP_TIMERSERVER VARCHAR(64) NULL
            )
        )")) { qWarning() << "[DBCheck] CREATE userMode failed:" << q.lastError().text(); return; }
        // seed แถว id=1 เท่านั้น
        ensureRowExists("userMode",
                        "SELECT COUNT(*) FROM userMode WHERE id=1",
                        "INSERT INTO userMode (id, `USER`, IP_MASTER, IP_SLAVE, LOCATION, swversion, IP_SNMP, IP_TIMERSERVER) "
                        "VALUES (1, 'MASTER', NULL, NULL, 'Asia/Bangkok', NULL, NULL, NULL)");
    } else {
        const QStringList cols = {"USER","IP_MASTER","IP_SLAVE","LOCATION","swversion","IP_SNMP","IP_TIMERSERVER"};
        for (const QString& c : cols) {
            if (!columnExists("userMode", c)) {
                QString alter = QString("ALTER TABLE userMode ADD COLUMN %1 VARCHAR(64) NULL")
                                .arg(c == "USER" ? "`USER`" : c);
                if (!q.exec(alter)) { qWarning() << "[DBCheck] ALTER userMode add" << c << "failed:" << q.lastError().text(); return; }
            }
        }
        // seed id=1 เฉพาะกรณีไม่มีจริง ๆ
        ensureRowExists("userMode",
                        "SELECT COUNT(*) FROM userMode WHERE id=1",
                        "INSERT INTO userMode (id, `USER`, IP_MASTER, IP_SLAVE, LOCATION, swversion, IP_SNMP, IP_TIMERSERVER) "
                        "VALUES (1, 'MASTER', NULL, NULL, 'Asia/Bangkok', NULL, NULL, NULL)");
    }

    // ====================== zoomValueRecord =====================
    if (!tableExists("zoomValueRecord")) {
        if (!q.exec(R"(
            CREATE TABLE zoomValueRecord (
              ID              INT NOT NULL PRIMARY KEY,
              valueOfZoom     DOUBLE NOT NULL DEFAULT 1.000,
              lastZoomVoltage INT UNSIGNED NOT NULL DEFAULT 1000
            )
        )")) { qWarning() << "[DBCheck] CREATE zoomValueRecord failed:" << q.lastError().text(); return; }
        ensureRowExists("zoomValueRecord",
                        "SELECT COUNT(*) FROM zoomValueRecord WHERE ID=1",
                        "INSERT INTO zoomValueRecord (ID, valueOfZoom, lastZoomVoltage) VALUES (1, 1.000, 1000)");
    } else {
        if (!columnExists("zoomValueRecord","lastZoomVoltage")) {
            if (!q.exec(R"(ALTER TABLE zoomValueRecord ADD COLUMN lastZoomVoltage INT UNSIGNED NOT NULL DEFAULT 1000 AFTER valueOfZoom)")) {
                qWarning() << "[DBCheck] ALTER zoomValueRecord add lastZoomVoltage failed:" << q.lastError().text(); return;
            }
        }
        // ไม่มี UPDATE ค่าใด ๆ
        ensureRowExists("zoomValueRecord",
                        "SELECT COUNT(*) FROM zoomValueRecord WHERE ID=1",
                        "INSERT INTO zoomValueRecord (ID, valueOfZoom, lastZoomVoltage) VALUES (1, 1.000, 1000)");
    }

    // ======================== maxminValue =======================
    if (!tableExists("maxminValue")) {
        if (!q.exec(R"(
            CREATE TABLE maxminValue (
              id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
              minDistance DOUBLE NOT NULL DEFAULT 0.0,
              maxDistance DOUBLE NOT NULL DEFAULT 0.0,
              minVoltage  DOUBLE NOT NULL DEFAULT 0.0,
              maxVoltage  DOUBLE NOT NULL DEFAULT 0.0,
              voltageOffset DOUBLE NOT NULL DEFAULT 0.0,
              maxVoltagePlusOffset DOUBLE NOT NULL DEFAULT 0.0
            )
        )")) { qWarning() << "[DBCheck] CREATE maxminValue failed:" << q.lastError().text(); return; }
        // seed แถวแรก (จำนวนเท่าไหร่ก็ได้ตามดีไซน์ คุณเคยใช้ 1 แถว)
        QSqlQuery qins(db);
        if (!qins.exec(R"(INSERT INTO maxminValue (minDistance,maxDistance,minVoltage,maxVoltage,voltageOffset,maxVoltagePlusOffset)
                           VALUES (0.0,0.0,0.0,0.0,0.0,0.0))")) {
            qWarning() << "[DBCheck] seed maxminValue failed:" << qins.lastError().text(); return;
        }
    } else {
        // ไม่มีการอัปเดตค่าเดิม แค่ ensure มีอย่างน้อย 1 แถว
        ensureRowExists("maxminValue",
                        "SELECT COUNT(*) FROM maxminValue",
                        "INSERT INTO maxminValue (minDistance,maxDistance,minVoltage,maxVoltage,voltageOffset,maxVoltagePlusOffset) "
                        "VALUES (0.0,0.0,0.0,0.0,0.0,0.0)");
    }

    // ======================== DistanceData ======================
    if (!tableExists("DistanceData")) {
        if (!q.exec(R"(
            CREATE TABLE DistanceData (
              AutoNumber  INT NOT NULL PRIMARY KEY,
              DistanceKm  INT NOT NULL DEFAULT 0
            )
        )")) { qWarning() << "[DBCheck] CREATE DistanceData failed:" << q.lastError().text(); return; }
        ensureRowExists("DistanceData",
                        "SELECT COUNT(*) FROM DistanceData WHERE AutoNumber=1",
                        "INSERT INTO DistanceData (AutoNumber, DistanceKm) VALUES (1, 0)");
    } else {
        ensureRowExists("DistanceData",
                        "SELECT COUNT(*) FROM DistanceData WHERE AutoNumber=1",
                        "INSERT INTO DistanceData (AutoNumber, DistanceKm) VALUES (1, 0)");
    }

    // ===================== updateLocalNetwork ===================
    if (!tableExists("updateLocalNetwork")) {
        if (!q.exec(R"(
            CREATE TABLE updateLocalNetwork (
              id             INT NOT NULL PRIMARY KEY,
              dhcpmethod     VARCHAR(8)  NOT NULL DEFAULT 'off',
              ipaddress      VARCHAR(64) NOT NULL DEFAULT '192.168.10.38',
              gateway        VARCHAR(64) NOT NULL DEFAULT '192.168.10.254',
              subnet         VARCHAR(64) NOT NULL DEFAULT '255.255.255.0',
              pridns         VARCHAR(64) NOT NULL DEFAULT '8.8.8.8',
              secdns         VARCHAR(64) NOT NULL DEFAULT '8.8.4.4',
              phyNetworkName VARCHAR(32) NOT NULL DEFAULT 'eth0',
              updated_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
                                         ON UPDATE CURRENT_TIMESTAMP
            )
        )")) { qWarning() << "[DBCheck] CREATE updateLocalNetwork failed:" << q.lastError().text(); return; }
        ensureRowExists("updateLocalNetwork",
                        "SELECT COUNT(*) FROM updateLocalNetwork WHERE id=1",
                        "INSERT INTO updateLocalNetwork (id) VALUES (1)");
    } else {
        struct NeedCol { const char* name; const char* ddl; };
        const NeedCol cols[] = {
            {"dhcpmethod",     "ALTER TABLE updateLocalNetwork ADD COLUMN dhcpmethod VARCHAR(8)  NOT NULL DEFAULT 'off'"},
            {"ipaddress",      "ALTER TABLE updateLocalNetwork ADD COLUMN ipaddress  VARCHAR(64) NOT NULL DEFAULT '192.168.10.38'"},
            {"gateway",        "ALTER TABLE updateLocalNetwork ADD COLUMN gateway    VARCHAR(64) NOT NULL DEFAULT '192.168.10.254'"},
            {"subnet",         "ALTER TABLE updateLocalNetwork ADD COLUMN subnet     VARCHAR(64) NOT NULL DEFAULT '255.255.255.0'"},
            {"pridns",         "ALTER TABLE updateLocalNetwork ADD COLUMN pridns     VARCHAR(64) NOT NULL DEFAULT '8.8.8.8'"},
            {"secdns",         "ALTER TABLE updateLocalNetwork ADD COLUMN secdns     VARCHAR(64) NOT NULL DEFAULT '8.8.4.4'"},
            {"phyNetworkName", "ALTER TABLE updateLocalNetwork ADD COLUMN phyNetworkName VARCHAR(32) NOT NULL DEFAULT 'eth0'"},
            {"updated_at",     "ALTER TABLE updateLocalNetwork ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"}
        };
        for (const auto& c : cols) {
            if (!columnExists("updateLocalNetwork", c.name)) {
                if (!q.exec(QString::fromUtf8(c.ddl))) {
                    qWarning() << "[DBCheck] ALTER updateLocalNetwork add" << c.name << "failed:" << q.lastError().text(); return;
                }
            }
        }
        ensureRowExists("updateLocalNetwork",
                        "SELECT COUNT(*) FROM updateLocalNetwork WHERE id=1",
                        "INSERT INTO updateLocalNetwork (id) VALUES (1)");
    }

    qDebug() << "[DBCheck] ✅ Structure verified (no data updates).";
}

void Database::updateLocalNetwork(QString message,QWebSocket* wClient){
        qDebug() << "updateLocalNetwork:" << message;

        // เปิด DB หากยังไม่เปิด
        if (!db.isOpen()) {
            qDebug() << "Opening database...";
            if (!db.open()) {
                qWarning() << "Failed to open database:" << db.lastError().text();
                return;
            }
        }

        // 1) parse JSON
        QJsonParseError jerr;
        const QJsonDocument doc = QJsonDocument::fromJson(message.toUtf8(), &jerr);
        if (jerr.error != QJsonParseError::NoError || !doc.isObject()) {
            qWarning() << "[updateLocalNetwork] Bad JSON:" << jerr.errorString();
            return;
        }
        const QJsonObject obj = doc.object();

        // 2) อ่านค่าพารามิเตอร์ (มี default ให้)
        const QString dhcpmethod     = obj.value("dhcpmethod").toString();            // "on"=DHCP, "off"=static
        const QString ipaddress      = obj.value("ipaddress").toString();
        const QString subnet         = obj.value("subnet").toString();
        const QString gateway        = obj.value("gateway").toString();
        const QString pridns         = obj.value("pridns").toString();
        const QString secdns         = obj.value("secdns").toString();
        const QString phyNetworkName = obj.value("phyNetworkName").toString();       // ใช้ตามที่ตั้งไว้

        // (optional) normalize dhcpmethod
        const QString dhcpNorm = (dhcpmethod.compare("on", Qt::CaseInsensitive) == 0) ? "on" : "off";

        // 3) UPSERT ลงตาราง (id=1 เสมอ)
        QSqlQuery q(db);
        q.prepare(R"SQL(
            INSERT INTO updateLocalNetwork
                (id, dhcpmethod, ipaddress, gateway, subnet, pridns, secdns, phyNetworkName)
            VALUES
                (1, :dhcpmethod, :ipaddress, :gateway, :subnet, :pridns, :secdns, :phy)
            ON DUPLICATE KEY UPDATE
                dhcpmethod     = VALUES(dhcpmethod),
                ipaddress      = VALUES(ipaddress),
                gateway        = VALUES(gateway),
                subnet         = VALUES(subnet),
                pridns         = VALUES(pridns),
                secdns         = VALUES(secdns),
                phyNetworkName = VALUES(phyNetworkName)
        )SQL");

        q.bindValue(":dhcpmethod", dhcpNorm);
        q.bindValue(":ipaddress",  ipaddress);
        q.bindValue(":gateway",    gateway);
        q.bindValue(":subnet",     subnet);
        q.bindValue(":pridns",     pridns);
        q.bindValue(":secdns",     secdns);
        q.bindValue(":phy",        phyNetworkName);

        if (!q.exec()) {
            qWarning() << "[updateLocalNetwork] UPSERT failed:" << q.lastError().text();
            return;
        }

        qDebug() << "[updateLocalNetwork] UPSERT OK for id=1";
        getLocalNetwork(wClient);
}

void Database::getLocalNetwork(QWebSocket* wClient){
    qDebug() << "getLocalNetwork()";

    // เปิด DB ถ้ายังไม่เปิด
    if (!db.isOpen()) {
        qDebug() << "Opening database...";
        if (!db.open()) {
            qWarning() << "Failed to open database:" << db.lastError().text();
            return;
        }
    }

    // ----------------------------
    // 1) ดึง updateLocalNetwork (id=1) แล้ว emit menuID="network"
    // ----------------------------
    {
        QSqlQuery q(db);
        if (!q.exec("SELECT id, dhcpmethod, ipaddress, gateway, subnet, pridns, secdns, phyNetworkName, updated_at "
                    "FROM updateLocalNetwork WHERE id=1 LIMIT 1")) {
            qWarning() << "[getLocalNetwork] select updateLocalNetwork failed:" << q.lastError().text();
            return;
        }

        if (!q.next()) {
            // ถ้าไม่มีแถว ให้สร้าง id=1 ตาม default ของตาราง
            QSqlQuery ins(db);
            if (!ins.exec("INSERT INTO updateLocalNetwork (id) VALUES (1)")) {
                qWarning() << "[getLocalNetwork] insert default updateLocalNetwork failed:" << ins.lastError().text();
                return;
            }
            // select ใหม่
            if (!q.exec("SELECT id, dhcpmethod, ipaddress, gateway, subnet, pridns, secdns, phyNetworkName, updated_at "
                        "FROM updateLocalNetwork WHERE id=1 LIMIT 1")) {
                qWarning() << "[getLocalNetwork] reselect updateLocalNetwork failed:" << q.lastError().text();
                return;
            }
            if (!q.next()) {
                qWarning() << "[getLocalNetwork] updateLocalNetwork no row after insert (unexpected)";
                return;
            }
        }

        dhcpmethodMonitor  = q.value("dhcpmethod").toString();
        iPaddressMonitor   = q.value("ipaddress").toString();
        gatewayMonitor     = q.value("gateway").toString();
        subnetMonitor      = q.value("subnet").toString();
        pridnsMonitor      = q.value("pridns").toString();
        secdnsMonitor      = q.value("secdns").toString();
        phyNameMonitor     = q.value("phyNetworkName").toString();
        // const QDateTime updatedAt = q.value("updated_at").toDateTime(); // ถ้าจะส่งก็เติมได้

        QJsonObject o;
        o["menuID"]         = "network";
        o["objectName"]     = "network";
        o["dhcpmethod"]     = dhcpmethodMonitor;
        o["ipaddress"]      = iPaddressMonitor;
        o["gateway"]        = gatewayMonitor;
        o["subnet"]         = subnetMonitor;
        o["pridns"]         = pridnsMonitor;
        o["secdns"]         = secdnsMonitor;
        o["phyNetworkName"] = phyNameMonitor;
        // o["updated_at"]   = updatedAt.isValid()? updatedAt.toUTC().toString(Qt::ISODate) : QString();
        const QString raw_network = QString::fromUtf8(QJsonDocument(o).toJson(QJsonDocument::Compact));
        emit databasesToCpp(raw_network);

        emit getupdateLocalNetwork(raw_network, wClient);
        qDebug() << "[getLocalNetwork] emitted network:" << raw_network;
    }

    // ----------------------------
    // 2) ดึง userMode (id=1) แล้ว emit menuID="userMode"
    // ----------------------------
    {
        auto asStr = [](const QVariant &v)->QString {
            return v.isNull() ? QString() : v.toString();
        };

        QSqlQuery q2(db);
        if (!q2.exec("SELECT id, USER, IP_MASTER, IP_SLAVE, swversion, IP_SNMP, IP_TIMERSERVER "
                     "FROM userMode WHERE id=1 LIMIT 1")) {
            qWarning() << "[getLocalNetwork] select userMode failed:" << q2.lastError().text();
            return;
        }

        if (!q2.next()) {
            // ถ้าไม่มีแถว ให้สร้าง id=1 ก่อน (ค่าคอลัมน์อื่นปล่อย NULL หรือเซ็ต default เองได้)
            QSqlQuery ins2(db);
            if (!ins2.exec("INSERT INTO userMode (id) VALUES (1)")) {
                qWarning() << "[getLocalNetwork] insert default userMode failed:" << ins2.lastError().text();
                return;
            }
            if (!q2.exec("SELECT id, USER, IP_MASTER, IP_SLAVE, swversion, IP_SNMP, IP_TIMERSERVER "
                         "FROM userMode WHERE id=1 LIMIT 1")) {
                qWarning() << "[getLocalNetwork] reselect userMode failed:" << q2.lastError().text();
                return;
            }
            if (!q2.next()) {
                qWarning() << "[getLocalNetwork] userMode no row after insert (unexpected)";
                return;
            }
        }

        USER          = asStr(q2.value("USER"));
        IP_MASTER     = asStr(q2.value("IP_MASTER"));
        IP_SLAVE      = asStr(q2.value("IP_SLAVE"));
        swversion     = asStr(q2.value("swversion"));
        IP_SNMP       = asStr(q2.value("IP_SNMP"));
        IP_TIMERSERVER= asStr(q2.value("IP_TIMERSERVER"));

        QJsonObject u;
        u["menuID"]        = "userMode";
        u["USER"]          = USER;
        u["IP_MASTER"]     = IP_MASTER;
        u["IP_SLAVE"]      = IP_SLAVE;
        u["IP_SNMP"]       = IP_SNMP;
        u["IP_TIMERSERVER"]= IP_TIMERSERVER;
        u["swversion"]     = swversion;

        const QString raw_user = QString::fromUtf8(QJsonDocument(u).toJson(QJsonDocument::Compact));
        if(wClient){
            emit getUserMode(raw_user, wClient);
            qDebug() << "[getLocalNetwork] emitted userMode:" << raw_user;
        }

    }
}
void Database::updateSwVersion(QString version)
{
    swversion = version;   // อัพเดต RAM

    QSqlQuery query;
    query.prepare("UPDATE userMode SET swversion=? WHERE id=1");
    query.addBindValue(version);

    if(!query.exec())
    {
        qDebug() << "DB update failed:" << query.lastError().text();
    }
    else
    {
        qDebug() << "DB updated version:" << version;
    }
}
void Database::getLocalMonitor() {
    qDebug() << "getLocalMonitor()";

    // เปิด DB ถ้ายังไม่เปิด
    if (!db.isOpen()) {
        qDebug() << "Opening database...";
        if (!db.open()) {
            qWarning() << "Failed to open database:" << db.lastError().text();
            return;
        }
    }

    // ----------------------------
    // 1) ดึง updateLocalNetwork (id=1) แล้ว emit menuID="network"
    // ----------------------------
    {
        QSqlQuery q(db);
        if (!q.exec("SELECT id, dhcpmethod, ipaddress, gateway, subnet, pridns, secdns, phyNetworkName, updated_at "
                    "FROM updateLocalNetwork WHERE id=1 LIMIT 1")) {
            qWarning() << "[getLocalNetwork] select updateLocalNetwork failed:" << q.lastError().text();
            return;
        }

        if (!q.next()) {
            // ถ้าไม่มีแถว ให้สร้าง id=1 ตาม default ของตาราง
            QSqlQuery ins(db);
            if (!ins.exec("INSERT INTO updateLocalNetwork (id) VALUES (1)")) {
                qWarning() << "[getLocalNetwork] insert default updateLocalNetwork failed:" << ins.lastError().text();
                return;
            }
            // select ใหม่
            if (!q.exec("SELECT id, dhcpmethod, ipaddress, gateway, subnet, pridns, secdns, phyNetworkName, updated_at "
                        "FROM updateLocalNetwork WHERE id=1 LIMIT 1")) {
                qWarning() << "[getLocalNetwork] reselect updateLocalNetwork failed:" << q.lastError().text();
                return;
            }
            if (!q.next()) {
                qWarning() << "[getLocalNetwork] updateLocalNetwork no row after insert (unexpected)";
                return;
            }
        }

        dhcpmethodMonitor  = q.value("dhcpmethod").toString();
        iPaddressMonitor   = q.value("ipaddress").toString();
        gatewayMonitor     = q.value("gateway").toString();
        subnetMonitor      = q.value("subnet").toString();
        pridnsMonitor      = q.value("pridns").toString();
        secdnsMonitor      = q.value("secdns").toString();
        phyNameMonitor     = q.value("phyNetworkName").toString();
        // const QDateTime updatedAt = q.value("updated_at").toDateTime(); // ถ้าจะส่งก็เติมได้

        QJsonObject o;
        o["menuID"]         = "network";
        o["objectName"]     = "network";
        o["dhcpmethod"]     = dhcpmethodMonitor;
        o["ipaddress"]      = iPaddressMonitor;
        o["gateway"]        = gatewayMonitor;
        o["subnet"]         = subnetMonitor;
        o["pridns"]         = pridnsMonitor;
        o["secdns"]         = secdnsMonitor;
        o["phyNetworkName"] = phyNameMonitor;
        // o["updated_at"]   = updatedAt.isValid()? updatedAt.toUTC().toString(Qt::ISODate) : QString();

        const QString raw_network = QString::fromUtf8(QJsonDocument(o).toJson(QJsonDocument::Compact));
        qDebug() << "[getLocalNetwork] emitted network:" << raw_network;
        emit sendtoMonitor(raw_network);
    }

    // ----------------------------
    // 2) ดึง userMode (id=1) แล้ว emit menuID="userMode"
    // ----------------------------
    {
        auto asStr = [](const QVariant &v)->QString {
            return v.isNull() ? QString() : v.toString();
        };

        QSqlQuery q2(db);
        if (!q2.exec("SELECT id, USER, IP_MASTER, IP_SLAVE, swversion, IP_SNMP, IP_TIMERSERVER "
                     "FROM userMode WHERE id=1 LIMIT 1")) {
            qWarning() << "[getLocalNetwork] select userMode failed:" << q2.lastError().text();
            return;
        }

        if (!q2.next()) {
            // ถ้าไม่มีแถว ให้สร้าง id=1 ก่อน (ค่าคอลัมน์อื่นปล่อย NULL หรือเซ็ต default เองได้)
            QSqlQuery ins2(db);
            if (!ins2.exec("INSERT INTO userMode (id) VALUES (1)")) {
                qWarning() << "[getLocalNetwork] insert default userMode failed:" << ins2.lastError().text();
                return;
            }
            if (!q2.exec("SELECT id, USER, IP_MASTER, IP_SLAVE, swversion, IP_SNMP, IP_TIMERSERVER "
                         "FROM userMode WHERE id=1 LIMIT 1")) {
                qWarning() << "[getLocalNetwork] reselect userMode failed:" << q2.lastError().text();
                return;
            }
            if (!q2.next()) {
                qWarning() << "[getLocalNetwork] userMode no row after insert (unexpected)";
                return;
            }
        }

        USER          = asStr(q2.value("USER"));
        IP_MASTER     = asStr(q2.value("IP_MASTER"));
        IP_SLAVE      = asStr(q2.value("IP_SLAVE"));
        swversion     = asStr(q2.value("swversion"));
        IP_SNMP       = asStr(q2.value("IP_SNMP"));
        IP_TIMERSERVER= asStr(q2.value("IP_TIMERSERVER"));

        QJsonObject u;
        u["menuID"]        = "userMode";
        u["USER"]          = USER;
        u["IP_MASTER"]     = IP_MASTER;
        u["IP_SLAVE"]      = IP_SLAVE;
        u["IP_SNMP"]       = IP_SNMP;
        u["IP_TIMERSERVER"]= IP_TIMERSERVER;
        u["swversion"]     = swversion;

        const QString raw_user = QString::fromUtf8(QJsonDocument(u).toJson(QJsonDocument::Compact));
        qDebug() << "sendtoMonitor_raw_user:" << raw_user;
        QJsonObject SwVersion;
        SwVersion["objectName"]        = "system";
        SwVersion["USER"]          = USER;
        SwVersion["IP_MASTER"]     = IP_MASTER;
        SwVersion["IP_SLAVE"]      = IP_SLAVE;
        SwVersion["IP_SNMP"]       = IP_SNMP;
        SwVersion["IP_TIMERSERVER"]= IP_TIMERSERVER;
        SwVersion["swversion"]     = swversion;
        const QString swversionUpdate = QString::fromUtf8(QJsonDocument(SwVersion).toJson(QJsonDocument::Compact));
        qDebug() << "swversionUpdate:" << swversionUpdate;

        emit sendtoMonitor(swversionUpdate);
    }
}


void Database::setSwVersion(const QString& ver) {
    if (!db.isOpen() && !db.open()) {
        qWarning() << "[DB] open failed:" << db.lastError().text();
        return;
    }
    QSqlQuery q(db);
    q.prepare("UPDATE userMode SET swversion = :v WHERE id = 1");
    q.bindValue(":v", ver);
    if (!q.exec()) {
        qWarning() << "[DB] setSwVersion failed:" << q.lastError().text();
        return;
    }
    qDebug() << "[DB] setSwVersion ok:" << ver;
}

//void Database::checkDatabaseAndUpdate() {
//    qDebug() << "Database checkDatabaseAndUpdate!";

//    QSqlDatabase db = QSqlDatabase::database();
//    if (!db.isOpen()) {
//        qDebug() << "[ZoomCheck] Database not open—attempting to open…";
//        if (!db.open()) {
//            qWarning() << "[ZoomCheck] Failed to open database:" << db.lastError().text();
//            return;
//        }
//        qDebug() << "[ZoomCheck] Database opened successfully.";
//    }

//    QSqlQuery query(db);
//    const QString schema = db.databaseName();

//    // ================================================
//    // 1) ตรวจสอบตาราง zoomValueRecord
//    // ================================================
//    qDebug() << "[ZoomCheck] Verifying whether zoomValueRecord exists…";
//    query.prepare(R"(
//        SELECT COUNT(*)
//          FROM INFORMATION_SCHEMA.TABLES
//         WHERE TABLE_SCHEMA = :schema
//           AND TABLE_NAME   = 'zoomValueRecord'
//    )");
//    query.bindValue(":schema", schema);
//    if (!query.exec()) {
//        qWarning() << "[ZoomCheck] EXISTENCE CHECK FAILED:" << query.lastError().text();
//        return;
//    }
//    query.next();
//    const bool tableExists = query.value(0).toInt() > 0;
//    qDebug() << "[ZoomCheck] INFORMATION_SCHEMA says tableExists =" << tableExists;

//    if (!tableExists) {
//        qDebug() << "[ZoomCheck] ⚠ zoomValueRecord not found. Creating table…";
//        if (!query.exec(R"(
//            CREATE TABLE zoomValueRecord (
//              ID              INT NOT NULL PRIMARY KEY,
//              valueOfZoom     DOUBLE NOT NULL DEFAULT 1.000,
//              lastZoomVoltage INT UNSIGNED NOT NULL DEFAULT 1000
//            )
//        )")) {
//            qWarning() << "[ZoomCheck] Failed to CREATE zoomValueRecord:" << query.lastError().text();
//            return;
//        }
//        qDebug() << "[ZoomCheck] Table zoomValueRecord created.";

//        if (!query.exec(R"(INSERT INTO zoomValueRecord (ID, valueOfZoom, lastZoomVoltage)
//                           VALUES (1, 1.000, 1000))")) {
//            qWarning() << "[ZoomCheck] Failed to INSERT default row:" << query.lastError().text();
//            return;
//        }
//        qDebug() << "[ZoomCheck] ✅ Default zoomValueRecord seeded successfully.";
//    }

//    // 2) ตรวจสอบว่ามี column lastZoomVoltage หรือยัง
//    QSqlQuery qcol(db);
//    qcol.prepare(R"(
//        SELECT COUNT(*)
//          FROM INFORMATION_SCHEMA.COLUMNS
//         WHERE TABLE_SCHEMA = :schema
//           AND TABLE_NAME   = 'zoomValueRecord'
//           AND COLUMN_NAME  = 'lastZoomVoltage'
//    )");
//    qcol.bindValue(":schema", schema);
//    if (!qcol.exec()) {
//        qWarning() << "[ZoomCheck] COLUMN CHECK FAILED:" << qcol.lastError().text();
//        return;
//    }
//    qcol.next();
//    const bool hasLastCol = qcol.value(0).toInt() > 0;

//    if (!hasLastCol) {
//        qDebug() << "[ZoomCheck] Adding missing column lastZoomVoltage…";
//        QSqlQuery alter(db);
//        if (!alter.exec(R"(
//            ALTER TABLE zoomValueRecord
//            ADD COLUMN lastZoomVoltage INT UNSIGNED NOT NULL DEFAULT 1000
//            AFTER valueOfZoom
//        )")) {
//            qWarning() << "[ZoomCheck] ALTER TABLE add lastZoomVoltage failed:" << alter.lastError().text();
//            return;
//        }
//        qDebug() << "[ZoomCheck] Column lastZoomVoltage added.";
//    }

//    // 3) ตรวจสอบ row ID=1
//    QSqlQuery qrow(db);
//    if (!qrow.exec("SELECT COUNT(*) FROM zoomValueRecord WHERE ID = 1")) {
//        qWarning() << "[ZoomCheck] Row existence check failed:" << qrow.lastError().text();
//        return;
//    }
//    qrow.next();
//    const bool hasRow = qrow.value(0).toInt() > 0;
//    if (!hasRow) {
//        if (!qrow.exec("INSERT INTO zoomValueRecord (ID, valueOfZoom, lastZoomVoltage) "
//                       "VALUES (1, 1.000, 1000)")) {
//            qWarning() << "[ZoomCheck] Failed to seed row ID=1:" << qrow.lastError().text();
//            return;
//        }
//        qDebug() << "[ZoomCheck] Seeded row ID=1.";
//    }

//    // 4) ถ้า lastZoomVoltage ยัง NULL/0 → init จาก valueOfZoom*1000
//    QSqlQuery qup(db);
//    if (!qup.exec(R"(
//        UPDATE zoomValueRecord
//           SET lastZoomVoltage = ROUND(valueOfZoom * 1000)
//         WHERE ID = 1
//           AND (lastZoomVoltage IS NULL OR lastZoomVoltage = 0)
//    )")) {
//        qWarning() << "[ZoomCheck] Initialize lastZoomVoltage failed:" << qup.lastError().text();
//        return;
//    }
//    qDebug() << "[ZoomCheck] ✅ zoomValueRecord ready.";

//    // ================================================
//    // 5) ตรวจสอบตาราง maxminValue
//    // ================================================
//    qDebug() << "[ZoomCheck] Verifying whether maxminValue exists…";
//    QSqlQuery qmax(db);
//    qmax.prepare(R"(
//        SELECT COUNT(*)
//          FROM INFORMATION_SCHEMA.TABLES
//         WHERE TABLE_SCHEMA = :schema
//           AND TABLE_NAME   = 'maxminValue'
//    )");
//    qmax.bindValue(":schema", schema);
//    if (!qmax.exec()) {
//        qWarning() << "[ZoomCheck] EXISTENCE CHECK for maxminValue FAILED:" << qmax.lastError().text();
//        return;
//    }
//    qmax.next();
//    const bool maxminExists = qmax.value(0).toInt() > 0;

//    if (!maxminExists) {
//        qDebug() << "[ZoomCheck] ⚠ maxminValue not found. Creating table…";
//        if (!qmax.exec(R"(
//            CREATE TABLE maxminValue (
//              id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
//              minDistance DOUBLE NOT NULL DEFAULT 0.0,
//              maxDistance DOUBLE NOT NULL DEFAULT 0.0,
//              minVoltage  DOUBLE NOT NULL DEFAULT 0.0,
//              maxVoltage  DOUBLE NOT NULL DEFAULT 0.0,
//              voltageOffset DOUBLE NOT NULL DEFAULT 0.0,
//              maxVoltagePlusOffset DOUBLE NOT NULL DEFAULT 0.0
//            )
//        )")) {
//            qWarning() << "[ZoomCheck] Failed to CREATE maxminValue:" << qmax.lastError().text();
//            return;
//        }
//        qDebug() << "[ZoomCheck] Table maxminValue created.";

//        if (!qmax.exec(R"(INSERT INTO maxminValue
//                           (minDistance, maxDistance, minVoltage, maxVoltage, voltageOffset, maxVoltagePlusOffset)
//                           VALUES (0.0, 0.0, 0.0, 0.0, 0.0, 0.0))")) {
//            qWarning() << "[ZoomCheck] Failed to seed maxminValue row:" << qmax.lastError().text();
//            return;
//        }
//        qDebug() << "[ZoomCheck] ✅ Default row in maxminValue seeded.";
//    } else {
//        QSqlQuery qrow2(db);
//        if (!qrow2.exec("SELECT COUNT(*) FROM maxminValue")) {
//            qWarning() << "[ZoomCheck] Row existence check in maxminValue failed:" << qrow2.lastError().text();
//            return;
//        }
//        qrow2.next();
//        if (qrow2.value(0).toInt() == 0) {
//            if (!qrow2.exec("INSERT INTO maxminValue (minDistance,maxDistance,minVoltage,maxVoltage,voltageOffset,maxVoltagePlusOffset) "
//                            "VALUES (0.0,0.0,0.0,0.0,0.0,0.0)")) {
//                qWarning() << "[ZoomCheck] Failed to insert default row into maxminValue:" << qrow2.lastError().text();
//                return;
//            }
//            qDebug() << "[ZoomCheck] ✅ Seeded default row into maxminValue.";
//        }
//    }

//    qDebug() << "[ZoomCheck] ✅ All database checks completed.";
//}


//void Database::getzoomValueRecord() {
//    qDebug() << "<<getzoomValueRecord>>";

//    if (!db.isOpen()) {
//        qDebug() << "[DB] opening...";
//        if (!db.open()) {
//            qWarning() << "[DB] open failed:" << db.lastError().text();
//            return;
//        }
//    }

//    QSqlQuery q(db);

//    q.prepare("SELECT valueOfZoom, lastZoomVoltage FROM zoomValueRecord WHERE ID=1 LIMIT 1");

//    if (!q.exec()) {
//        qWarning() << "[DB] select zoomValueRecord failed:" << q.lastError().text();
//        return;
//    }
//    if (!q.next()) {
//        qWarning() << "[DB] zoomValueRecord: no row found";
//        return;
//    }

//    const double valueOfZoom      = q.value(0).toDouble();
//    const int    lastZoomVoltage  = q.value(1).toInt();

//    QJsonObject obj;
//    obj.insert("menuID", "zoomValueRecord");
//    obj.insert("valueOfZoom", valueOfZoom);
//    obj.insert("lastZoomVoltage", lastZoomVoltage);
//    const QString raw = QJsonDocument(obj).toJson(QJsonDocument::Compact);
//    qDebug() << raw;

//    emit sendtoMonitor(raw);
//}


void Database::updateDataMaxMin(QString msg){
    qDebug() << "[updateDateMaxMin] raw:" << msg;

    QJsonParseError perr;
    const QJsonDocument doc = QJsonDocument::fromJson(msg.toUtf8(), &perr);
    if (perr.error != QJsonParseError::NoError || !doc.isObject()) {
        qWarning() << "[updateDateMaxMin] JSON parse error:" << perr.errorString();
        return;
    }
    const QJsonObject o = doc.object();

    // required
    if (!o.contains("minDistance") || !o.value("minDistance").isDouble()
     || !o.contains("maxDistance") || !o.value("maxDistance").isDouble()
     || !o.contains("minVoltage")  || !o.value("minVoltage").isDouble()
     || !o.contains("maxVoltage")  || !o.value("maxVoltage").isDouble()) {
        qWarning() << "[updateDateMaxMin] missing required keys";
        return;
    }

    const double minDistance = o.value("minDistance").toDouble();
    const double maxDistance = o.value("maxDistance").toDouble();
    const double minVoltage  = o.value("minVoltage").toDouble();
    const double maxVoltage  = o.value("maxVoltage").toDouble();
    const double voltageOffset = (o.contains("voltageOffset") && o.value("voltageOffset").isDouble())
                                 ? o.value("voltageOffset").toDouble() : 1.0;  // factor => default 1.0
    const int id = o.contains("id") ? o.value("id").toInt() : 1;

    if (!db.isOpen() && !db.open()) {
        qWarning() << "[updateDateMaxMin] DB open failed:" << db.lastError().text();
        return;
    }

    // ตรวจ schema: มีคอลัมน์ plus และเป็น generated หรือไม่
    bool hasPlusCol=false, plusIsGenerated=false;
    {
        QSqlQuery meta(db);
        meta.prepare(
            "SELECT EXTRA FROM INFORMATION_SCHEMA.COLUMNS "
            "WHERE TABLE_SCHEMA = DATABASE() "
            "  AND TABLE_NAME   = 'maxminValue' "
            "  AND COLUMN_NAME  = 'maxVoltagePlusOffset'"
        );
        if (meta.exec() && meta.next()) {
            hasPlusCol = true;
            plusIsGenerated = meta.value(0).toString().contains("GENERATED", Qt::CaseInsensitive);
        }
    }

    QSqlQuery q(db);
    if (hasPlusCol && !plusIsGenerated) {
        // คอลัมน์ธรรมดา -> เราคำนวณเอง (คูณ)
        q.prepare(
            "INSERT INTO maxminValue "
            "(id, minDistance, maxDistance, minVoltage, maxVoltage, voltageOffset, maxVoltagePlusOffset) "
            "VALUES (:id, :minD, :maxD, :minV, :maxV, :off, ROUND(:maxV * :off, 6)) "
            "ON DUPLICATE KEY UPDATE "
            "minDistance = VALUES(minDistance), "
            "maxDistance = VALUES(maxDistance), "
            "minVoltage  = VALUES(minVoltage),  "
            "maxVoltage  = VALUES(maxVoltage),  "
            "voltageOffset = VALUES(voltageOffset), "
            "maxVoltagePlusOffset = ROUND(VALUES(maxVoltage) * VALUES(voltageOffset), 6)"
        );
    } else {
        // ไม่มีคอลัมน์ หรือเป็น generated -> ห้ามแตะ plus; DB คูณให้เอง
        q.prepare(
            "INSERT INTO maxminValue "
            "(id, minDistance, maxDistance, minVoltage, maxVoltage, voltageOffset) "
            "VALUES (:id, :minD, :maxD, :minV, :maxV, :off) "
            "ON DUPLICATE KEY UPDATE "
            "minDistance = VALUES(minDistance), "
            "maxDistance = VALUES(maxDistance), "
            "minVoltage  = VALUES(minVoltage),  "
            "maxVoltage  = VALUES(maxVoltage),  "
            "voltageOffset = VALUES(voltageOffset)"
        );
    }

    q.bindValue(":id",   id);
    q.bindValue(":minD", minDistance);
    q.bindValue(":maxD", maxDistance);
    q.bindValue(":minV", minVoltage);
    q.bindValue(":maxV", maxVoltage);
    q.bindValue(":off",  voltageOffset);

    if (!q.exec()) {
        qWarning() << "[updateDateMaxMin] upsert failed:" << q.lastError().text();
        return;
    }

    qDebug() << "[updateDateMaxMin] upsert OK for id=" << id << " (factor=" << voltageOffset << ")";
    getDataMaxMin();
}

void Database::getDataMaxMin(){
    qDebug() << "getDataMaxMin";

    // เปิด DB หากยังไม่เปิด
    if (!db.isOpen() && !db.open()) {
        qWarning() << "[getDataMaxMin] DB open failed:" << db.lastError().text();
        return;
    }

    QSqlQuery q(db);

    // โหมดคูณ: ใช้ COALESCE(voltageOffset, 1) และคำนวณ maxVoltagePlusOffset = maxVoltage * voltageOffset
    if (!q.exec(
        "SELECT id, "
        "       minDistance, maxDistance, minVoltage, maxVoltage, "
        "       COALESCE(voltageOffset, 1) AS voltageOffset, "
        "       ROUND(maxVoltage * COALESCE(voltageOffset, 1), 6) AS maxVoltagePlusOffset "
        "FROM maxminValue "
        "ORDER BY id DESC LIMIT 1"
    )) {
        qWarning() << "[getDataMaxMin] query failed:" << q.lastError().text();
        return;
    }

    if (!q.next()) {
        qWarning() << "[getDataMaxMin] no rows in maxminValue";
        return;
    }

    const int    id                 = q.value("id").toInt();
    const double minDistance        = q.value("minDistance").toDouble();
    const double maxDistance        = q.value("maxDistance").toDouble();
    const double minVoltage         = q.value("minVoltage").toDouble();
    const double maxVoltage         = q.value("maxVoltage").toDouble();
    const double voltageOffset      = q.value("voltageOffset").toDouble();         // factor
    const double maxVPlusOffsetCalc = q.value("maxVoltagePlusOffset").toDouble();  // maxVoltage * factor

    QJsonObject obj;
    obj["objectName"]            = "getMaxMinValue";
    obj["id"]                    = id;
    obj["minDistance"]           = minDistance;
    obj["maxDistance"]           = maxDistance;
    obj["minVoltage"]            = minVoltage;
    obj["maxVoltage"]            = maxVoltage;
    obj["voltageOffset"]         = voltageOffset;           // factor
    obj["maxVoltagePlusOffset"]  = maxVPlusOffsetCalc;      // product

    // ใส่ string แบบ fixed-decimal เพื่อการแสดงผลที่แน่นอน
    obj["minDistanceStr"]        = QString::number(minDistance, 'f', 3);
    obj["maxDistanceStr"]        = QString::number(maxDistance, 'f', 3);
    obj["minVoltageStr"]         = QString::number(minVoltage,  'f', 6);
    obj["maxVoltageStr"]         = QString::number(maxVoltage,  'f', 6);
    obj["voltageOffsetStr"]      = QString::number(voltageOffset, 'f', 6);
    obj["maxVoltagePlusOffsetStr"]= QString::number(maxVPlusOffsetCalc, 'f', 6);

    const QString json = QString::fromUtf8(QJsonDocument(obj).toJson(QJsonDocument::Compact));
    qDebug() << "[getDataMaxMin] payload:" << json;
    emit cmdmsg(json);
}

void Database::setLocation(const QString& location) {
    // เปิด DB ถ้ายังไม่เปิด
    if (!db.isOpen() && !db.open()) {
        qWarning() << "[DB] open failed:" << db.lastError().text();
        return;  // จบเลย ไม่ต้องคืนค่า
    }

    QSqlQuery q(db);
    q.prepare("UPDATE userMode SET LOCATION = :loc WHERE id = 1");
    q.bindValue(":loc", location);

    if (!q.exec()) {
        qWarning() << "[DB] setLocation failed:" << q.lastError().text();
        return;  // จบ ไม่ต้องคืนค่า
    }

    qDebug() << "[DB] setLocation ok:" << location;
}

void Database::setTimeServerIP(const QString& ip) {
    if (!db.isOpen() && !db.open()) {
        qWarning() << "[DB] open failed:" << db.lastError().text();
        return;
    }

    QSqlQuery q(db);
    q.prepare("UPDATE userMode SET IP_TIMERSERVER = :ip WHERE id = 1");
    q.bindValue(":ip", ip);

    if (!q.exec()) {
        qWarning() << "[DB] setTimeServerIP failed:" << q.lastError().text();
        return;
    }

    qDebug() << "[DB] setTimeServerIP ok:" << ip;
}

void Database::fetchUserModeInfo() {
    qDebug() << "fetchUserModeInfo";

    if (!db.isOpen()) {
        qDebug() << "Opening database...";
        if (!db.open()) {
            qWarning() << "Failed to open database:" << db.lastError().text();
            return;
        }
    }

    QSqlQuery query(db);
    QString sql = "SELECT USER, IP_MASTER, IP_SLAVE, IP_SNMP, IP_TIMERSERVER, swversion FROM userMode";

    if (!query.exec(sql)) {
        qWarning() << "Query failed:" << query.lastError().text();
        return;
    }

    if (query.first()) {
        USER = query.value("USER").toString();
        IP_MASTER = query.value("IP_MASTER").toString();
        IP_SLAVE = query.value("IP_SLAVE").toString();
        IP_SNMP = query.value("IP_SNMP").toString();
        IP_TIMERSERVER = query.value("IP_TIMERSERVER").toString();
        swversion = query.value("swversion").toString();

        qDebug() << "userMode info sent:" ;
    } else {
        qDebug() << "⚠️ No userMode data found. ";
    }

    //.db.close();
}

void Database::recordZoomInOutValue(QString msg) {
    qDebug() << "recordZoomInOutValue:" << msg;

    // 1) parse JSON
    const QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    const QJsonObject command = d.object();

    const QString objectName = command.value("objectName").toString().trimmed();
    const QString menuID     = command.value("menuID").toString().trimmed();

    bool hasZoom = command.contains("zoomValuerecord") && command.value("zoomValuerecord").isDouble();
    double valueOfZoom = hasZoom ? command.value("zoomValuerecord").toDouble() : 0.0; // หน่วย V

    // รองรับทั้ง key: pendingYZoomMv (จาก QML) และ lastZoomVoltage
    bool hasLastMv = false;
    double lastZoomMv = 0; // หน่วย mV
    if (command.contains("pendingYZoomMv") && command.value("pendingYZoomMv").isDouble()) {
        lastZoomMv = command.value("pendingYZoomMv").toInt();
        hasLastMv  = true;
    } else if (command.contains("lastZoomVoltage") && command.value("lastZoomVoltage").isDouble()) {
        lastZoomMv = command.value("lastZoomVoltage").toInt();
        hasLastMv  = true;
    }

    qDebug() << "objectName:" << objectName
             << " menuID:" << menuID
             << " hasZoom:" << hasZoom << " valueOfZoom:" << valueOfZoom
             << " hasLastMv:" << hasLastMv << " lastZoomMv:" << lastZoomMv;

    // 2) เปิด DB
    if (!db.isOpen()) {
        qDebug() << "Opening database...";
        if (!db.open()) {
            qWarning() << "Failed to open database:" << db.lastError().text();
            return;
        }
    }

    // 3) ensure แถว ID=1 มีอยู่เสมอ (ค่า default: 1.000V, 1000mV)
    {
        QSqlQuery ensure(db);
        // ต้องมี PRIMARY KEY(ID) ถึงจะใช้ INSERT IGNORE ได้
        if (!ensure.exec("INSERT IGNORE INTO zoomValueRecord (ID, valueOfZoom, lastZoomVoltage) "
                         "VALUES (1, 1.000, 1000)")) {
            qWarning() << "Failed to ensure row exists:" << ensure.lastError().text();
            // ไม่ return ต่อให้ fail ก็ลองอัปเดตต่อ เผื่อแถวมีอยู่แล้ว
        }
    }

    // 4) อัปเดตเฉพาะคอลัมน์ที่ส่งมา
    bool ok = true;

    if (hasZoom && hasLastMv) {
        // รวมเป็น query เดียวเมื่อทั้งสองค่าเข้ามาพร้อมกัน
        QSqlQuery upd(db);
        upd.prepare("UPDATE zoomValueRecord SET valueOfZoom = :zoom, lastZoomVoltage = :mv WHERE ID = 1");
        upd.bindValue(":zoom", valueOfZoom);
        upd.bindValue(":mv",   lastZoomMv);
        if (!upd.exec()) {
            qWarning() << "Failed to update both columns:" << upd.lastError().text();
            ok = false;
        } else {
            qDebug() << "Updated valueOfZoom & lastZoomVoltage successfully.";
        }
    } else if (hasZoom) {
        QSqlQuery upd(db);
        upd.prepare("UPDATE zoomValueRecord SET valueOfZoom = :zoom WHERE ID = 1");
        upd.bindValue(":zoom", valueOfZoom);
        if (!upd.exec()) {
            qWarning() << "Failed to update valueOfZoom:" << upd.lastError().text();
        } else {
            qDebug() << "Updated valueOfZoom successfully.";
        }
    } else if (hasLastMv) {
        QSqlQuery upd(db);
        upd.prepare("UPDATE zoomValueRecord SET lastZoomVoltage = :mv WHERE ID = 1");
        upd.bindValue(":mv", lastZoomMv);
        if (!upd.exec()) {
            qWarning() << "Failed to update lastZoomVoltage:" << upd.lastError().text();
        } else {
            qDebug() << "Updated lastZoomVoltage successfully.";
        }
    } else {
        qWarning() << "Nothing to update: neither zoomValuerecord nor lastZoomVoltage present.";
        ok = false;
    }

    if (!ok) {
        // ถ้าต้องการ แจ้งกลับผ่าน WebSocket/สัญญาณก็ทำตรงนี้
    }
    getDataRecordZoomValue();
}


//void Database::recordZoomInOutValue(QString msg) {
//    qDebug() << "recordZoomInOutValue:" << msg;
//    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
//    QJsonObject command = d.object();
//    QString getCommand = command.value("objectName").toString().trimmed();
//    QString menuID = command.value("menuID").toString().trimmed();
//    double valueOfZoom = command.value("zoomValuerecord").toDouble();
//    qDebug() << "valueOfZoom:" << valueOfZoom;

//    if (!db.isOpen()) {
//        qDebug() << "Opening database...";
//        if (!db.open()) {
//            qWarning() << "Failed to open database:" << db.lastError().text();
//            return;
//        }
//    }

//    QSqlQuery query(db);
//    query.prepare("SELECT COUNT(*) FROM zoomValueRecord");
//    if (!query.exec()) {
//        qWarning() << "Failed to check zoomValueRecord:" << query.lastError().text();
//        return;
//    }
//    int recordCount = 0;
//    if (query.next()) {
//        recordCount = query.value(0).toInt();
//    }

//    if (recordCount == 0) {
//        QSqlQuery insertQuery(db);
//        insertQuery.prepare("INSERT INTO zoomValueRecord (valueOfZoom) VALUES (:zoom)");
//        insertQuery.bindValue(":zoom", valueOfZoom);
//        if (!insertQuery.exec()) {
//            qWarning() << "Failed to insert zoomValueRecord:" << insertQuery.lastError().text();
//        } else {
//            qDebug() << "Inserted zoomValueRecord successfully.";
//        }
//    } else {
//        QSqlQuery updateQuery(db);
//        updateQuery.prepare("UPDATE zoomValueRecord SET valueOfZoom = :zoom WHERE ID = 1");
//        updateQuery.bindValue(":zoom", valueOfZoom);
//        if (!updateQuery.exec()) {
//            qWarning() << "Failed to update zoomValueRecord:" << updateQuery.lastError().text();
//        } else {
//            qDebug() << "Updated zoomValueRecord successfully.";
//        }
//    }
//}
void Database::getDataRecordZoomValue()
{
    qDebug() << "getDataRecordZoomValue";

    // 1) Ensure DB open
    if (!db.isOpen()) {
        qDebug() << "Database is not open.getDataRecordZoomValue Trying to open...getDataRecordZoomValue";
        if (!db.open()) {
            qDebug() << "Failed to open database:" << db.lastError().text();
            return;
        }
    }

    // 2) Check table exists
    {
        QSqlQuery checkTableQuery(db);
        checkTableQuery.prepare(
            "SELECT COUNT(*) FROM information_schema.tables "
            "WHERE table_schema = :schema AND table_name = 'zoomValueRecord'");
        checkTableQuery.bindValue(":schema", db.databaseName());

        if (!checkTableQuery.exec()) {
            qDebug() << "Error checking table:" << checkTableQuery.lastError().text();
            return;
        }
        if (checkTableQuery.next() && checkTableQuery.value(0).toInt() == 0) {
            qDebug() << "Table `zoomValueRecord` does not exist.";
            return;
        }
    }

    // 3) Query row ID=1 (ดึงทั้งสองคอลัมน์)
    QSqlQuery query(db);
    const QString sql = "SELECT ID, valueOfZoom, lastZoomVoltage "
                        "FROM zoomValueRecord WHERE ID = 1 LIMIT 1";
    if (!query.exec(sql)) {
        qDebug() << "Error executing query:" << query.lastError().text();
        return;
    }

    if (query.next()) {
        const int    id        = query.value("ID").toInt();
        const double zoomValue = query.value("valueOfZoom").toDouble();      // V
        const int    lastMv    = query.value("lastZoomVoltage").toInt();     // mV

        // string 6 ตำแหน่งทศนิยมสำหรับ valueOfZoom
        const QString zoomStr = QString::number(zoomValue, 'f', 6);

        // 4) Build & emit JSON
        QJsonObject jsonObj;
        jsonObj["objectName"]         = "getZoomValueRecord";
        jsonObj["ID"]                 = id;
        jsonObj["valueOfZoom"]        = zoomValue;   // V
        jsonObj["valueOfZoomString"]  = zoomStr;     // "0.600000" เป็นต้น
        jsonObj["lastZoomVoltage"]    = lastMv;      // mV
        jsonObj["pendingYZoomMv"]     = lastMv;      // alias ให้ QML ใช้ตั้งค่า SpinBox ได้ทันที

        const QJsonDocument jsonDoc(jsonObj);
        const QString jsonString = jsonDoc.toJson(QJsonDocument::Compact);

        qDebug() << "zoomValueRecord Data:" << jsonString;
        emit cmdmsg(jsonString);
    } else {
        qDebug() << "⚠️ No record found in `zoomValueRecord` with ID = 1!";
    }
}

void Database::updateDataBaseUSER() {
    qDebug() << "updateDataBaseUSER called";

    if (!db.isOpen()) {
        qDebug() << "Opening database...";
        if (!db.open()) {
            qWarning() << "Failed to open database:" << db.lastError().text();
            return;
        }
    }
    QStringList updateFields;
    QMap<QString, QString> bindings;
    if (!USER.isEmpty()) {
        updateFields << "USER = :user";
        bindings[":user"] = USER;
    }

    if (!IP_MASTER.isEmpty()) {
        updateFields << "IP_MASTER = :ipMaster";
        bindings[":ipMaster"] = IP_MASTER;
    }
    if (!IP_SLAVE.isEmpty()) {
        updateFields << "IP_SLAVE = :ipSlave";
        bindings[":ipSlave"] = IP_SLAVE;
    }
    if (!IP_SNMP.isEmpty()) {
        updateFields << "IP_SNMP = :ipSnmp";
        bindings[":ipSnmp"] = IP_SNMP;
    }
    if (!IP_TIMERSERVER.isEmpty()) {
        updateFields << "IP_TIMERSERVER = :ipTimeServer";
        bindings[":ipTimeServer"] = IP_TIMERSERVER;
    }

    if (updateFields.isEmpty()) {
        qDebug() << "No data to update.";
        return;
    }
    QString sql = QString("UPDATE userMode SET %1 WHERE id = 1").arg(updateFields.join(", "));
    QSqlQuery query(db);
    query.prepare(sql);

    for (auto it = bindings.constBegin(); it != bindings.constEnd(); ++it) {
        query.bindValue(it.key(), it.value());
    }

    if (!query.exec()) {
        qWarning() << "Failed to update userMode:" << query.lastError().text();
    } else {
        qDebug() << "userMode updated with fields:" << updateFields.join(", ");
    }

    //.db.close();
}

bool Database::tableExists(const QString &tableName) {
    QSqlQuery query;
    QString checkTable = QString(
        "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES "
        "WHERE TABLE_NAME = '%1'"
    ).arg(tableName);

    if (query.exec(checkTable) && query.next()) {
        return query.value(0).toInt() > 0;
    } else {
        qWarning() << "Failed to check table" << tableName << ":" << query.lastError().text();
        return false;
    }
}

void Database::updateDataBase() {
    qDebug() << "updateDataBase successfully!";

    if (!db.isOpen()) {
        qDebug() << "Database not open, attempting to open...";
        if (!db.open()) {
            qWarning() << "Failed to open database:" << db.lastError().text();
            return;
        }
        qDebug() << "Database connection opened successfully.";
    }

    QSqlQuery query;

    if (!tableExists("updateButtonHiding")) {
        QString createButtonTable =
            "CREATE TABLE updateButtonHiding ("
            "id INTEGER PRIMARY KEY AUTO_INCREMENT, "
            "buttonA TINYINT(1), "
            "buttonB TINYINT(1), "
            "buttonC TINYINT(1), "
            "buttonPatternA TINYINT(1), "
            "buttonPatternB TINYINT(1), "
            "buttonPatternC TINYINT(1))";

        if (!query.exec(createButtonTable)) {
            qWarning() << "Failed to create updateButtonHiding:" << query.lastError().text();
        } else {
            qDebug() << "Created table updateButtonHiding";
        }
    }

    if (!tableExists("userMode")) {
        QString createUserModeTable =
            "CREATE TABLE userMode ("
            "id INTEGER PRIMARY KEY AUTO_INCREMENT, "
            "`USER` VARCHAR(10), "
            "IP_MASTER VARCHAR(30), "
            "IP_SLAVE VARCHAR(30), "
            "swversion VARCHAR(30))";

        if (!query.exec(createUserModeTable)) {
            qWarning() << "Failed to create userMode:" << query.lastError().text();
        } else {
            qDebug() << "Created table userMode";
        }
    }

    addMissingColumn("userMode", "IP_SNMP", "VARCHAR(50)");
    addMissingColumn("userMode", "IP_TIMERSERVER", "VARCHAR(50)");

    if (query.exec("SELECT COUNT(*) FROM updateButtonHiding")) {
        if (query.next() && query.value(0).toInt() == 0) {
            QString insertButtonDefaults = R"(
                INSERT INTO updateButtonHiding (buttonA, buttonB, buttonC, buttonPatternA, buttonPatternB, buttonPatternC)
                VALUES (1, 1, 1, 1, 1, 1)
            )";
            if (!query.exec(insertButtonDefaults)) {
                qWarning() << "Failed to insert into updateButtonHiding:" << query.lastError().text();
            } else {
                qDebug() << "Inserted default row into updateButtonHiding";
            }
        }
    }

    if (query.exec("SELECT id FROM userMode WHERE id = 1")) {
        if (!query.next()) {
            QString insertUserMode = R"(
                INSERT INTO userMode (id, USER, IP_MASTER, IP_SLAVE, swversion, IP_SNMP, IP_TIMERSERVER)
                VALUES (1, 'MASTER', '192.168.10.62', '192.168.10.51', '11032025 1.1', '192.168.10.62', '192.168.10.94')
            )";
            if (!query.exec(insertUserMode)) {
                qWarning() << "Failed to insert into userMode:" << query.lastError().text();
            } else {
                qDebug() << "Inserted MASTER row with id=1 into userMode";
            }
        } else {
            qDebug() << "ℹ️ userMode with id=1 already exists, skipping insert.";
        }
    } else {
        qWarning() << "Failed to check userMode by id:" << query.lastError().text();
    }

    //.db.close();
    qDebug() << "Database update completed and connection closed.";
}


void Database::addMissingColumn(const QString &tableName, const QString &columnName, const QString &columnType) {
    QSqlQuery query;
    QString checkColumn = QString(
        "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS "
        "WHERE TABLE_NAME = '%1' AND COLUMN_NAME = '%2' AND TABLE_SCHEMA = DATABASE()"
    ).arg(tableName, columnName);
    if (query.exec(checkColumn) && query.next()) {
        if (query.value(0).toInt() == 0) {
            QString alterTable = QString("ALTER TABLE %1 ADD COLUMN %2 %3")
                                     .arg(tableName, columnName, columnType);
            if (!query.exec(alterTable)) {
                qWarning() << "Failed to add column" << columnName << ":" << query.lastError().text();
            } else {
                qDebug() << "Added column" << columnName;
            }
        } else {
            qDebug() << "Column already exists:" << columnName;
        }
    } else {
        qWarning() << "Failed to check column" << columnName << ":" << query.lastError().text();
    }
}

void Database::updataStatusTagging(int taggingPoint, bool status) {
    qDebug() << "updataStatusTagging: taggingPoint =" << taggingPoint << ", status =" << status;

    if (!db.isOpen()) {
        qDebug() << "Database not open, attempting to open...";
        if (!db.open()) {
            qWarning() << "Failed to open database:" << db.lastError().text();
            return;
        }
        qDebug() << "Database connection opened successfully.";
    }

    QSqlQuery query;
    QString updateQueryStr = "UPDATE DataTagging SET status = :status WHERE No = :No";
    query.prepare(updateQueryStr);
    query.bindValue(":status", status ? 1 : 0);
    query.bindValue(":No", taggingPoint);

    if (!query.exec()) {
        qWarning() << "Failed to update status:" << query.lastError().text();
    } else {
        qDebug() << "Successfully updated status for No =" << taggingPoint;
    }
    //.db.close();
}


void Database::selectMasterMode(){
    if (!db.isOpen()) {
        qDebug() << "Database not open, attempting to open...";
        if (!db.open()) {
            qWarning() << "Failed to open database:" << db.lastError().text();
            return;
        }
        qDebug() << "Database connection opened successfully.";
    }
    QSqlQuery query("SELECT * FROM userMode");

    while (query.next()) {
//        int id = query.value("id").toInt();
        QString user = query.value("USER").toString();
        QString ipMaster = query.value("IP_MASTER").toString();
        QString ipSlave = query.value("IP_SLAVE").toString();
        QString ipSNMP = query.value("IP_SNMP").toString();
        QString ipTimeServer = query.value("IP_TIMERSERVER").toString();
        QString swVersion = query.value("swversion").toString();
//        qDebug() << "ID:" << id
          qDebug() << "User:" << user
                 << "IP Master:" << ipMaster
                 << "IP Slave:" << ipSlave << swVersion;
         emit selectMasterMode(user,ipMaster,ipSlave,ipSNMP,ipTimeServer,swVersion);
    }
    // //.db.close();
}

void Database::updateIpNetwork(const QString &newUser,
                               const QString &newIpMaster,
                               const QString &newIpSlave,
                               const QString &snmp,
                               const QString &timeserver)
{

    if (newUser.trimmed().isEmpty() ||
        newIpMaster.trimmed().isEmpty() ||
        newIpSlave.trimmed().isEmpty() ||
        snmp.trimmed().isEmpty() ||
        timeserver.trimmed().isEmpty())
    {
        qWarning() << "updateIpNetwork aborted: one or more input values are empty.";
        return;
    }


    if (!db.isOpen()) {
        qDebug() << "Database not open, attempting to open...";
        if (!db.open()) {
            qWarning() << "Failed to open database:" << db.lastError().text();
            return;
        }
        qDebug() << "Database connection opened successfully.";
    }


    QSqlQuery query;
    query.prepare(R"(
        UPDATE userMode
        SET USER = :user,
            IP_MASTER = :ipMaster,
            IP_SLAVE = :ipSlave,
            IP_SNMP = :snmp,
            IP_TIMERSERVER = :timeserver
        WHERE id = 1
    )");


    query.bindValue(":user", newUser);
    query.bindValue(":ipMaster", newIpMaster);
    query.bindValue(":ipSlave", newIpSlave);
    query.bindValue(":snmp", snmp);
    query.bindValue(":timeserver", timeserver);


    if (query.exec()) {
        qDebug() << "Record updated successfully!";
    } else {
        qWarning() << "Update failed:" << query.lastError().text();
    }


    selectMasterMode();
}

void Database::updateMasterMode(const QString &newUser, const QString &newIpMaster, const QString &newIpSlave,  const QString &sw){
    if (!db.isOpen()) {
        qDebug() << "Database not open, attempting to open...";
        if (!db.open()) {
            qWarning() << "Failed to open database:" << db.lastError().text();
            return;
        }
        qDebug() << "Database connection opened successfully.";
    }
    QSqlQuery query;
    query.prepare("UPDATE userMode SET USER = :user, IP_MASTER = :ipMaster, IP_SLAVE = :ipSlave, swversion = :sw WHERE id = 1");
    query.bindValue(":user", newUser);
    query.bindValue(":ipMaster", newIpMaster);
    query.bindValue(":ipSlave", newIpSlave);
      query.bindValue(":sw", sw);

    if (query.exec()) {
        qDebug() << "Record updated successfully!";
    } else {
        qDebug() << "Update failed:" << query.lastError().text();
    }
}

void Database::GetStatusOfButtonHidding() {
    qDebug() << "GetStatusOfButtonHidding";

    if (!db.isOpen()) {
        qDebug() << "Database is not open. Trying to open...";
        if (!db.open()) {
            qDebug() << "Failed to open database: " << db.lastError().text();
            return;
        }
    }

    QSqlQuery checkTableQuery(db);
    QString checkTableSQL = QString(
        "SELECT COUNT(*) FROM information_schema.tables "
        "WHERE table_schema = '%1' AND table_name = 'updateButtonHiding'")
        .arg(db.databaseName());

    if (!checkTableQuery.exec(checkTableSQL)) {
        qDebug() << "Error checking table:" << checkTableQuery.lastError().text();
        return;
    }

    if (checkTableQuery.next() && checkTableQuery.value(0).toInt() == 0) {
        qDebug() << "Table `updateButtonHiding` does not exist.";
        return;
    }

    QSqlQuery query(db);
    QString sql = "SELECT buttonA, buttonB, buttonC, buttonPatternA, buttonPatternB, buttonPatternC FROM updateButtonHiding";

    if (!query.exec(sql)) {
        qDebug() << "Error executing query:" << query.lastError().text();
        return;
    }

    if (query.first()) {
        bool buttonA = query.value("buttonA").toBool();
        bool buttonB = query.value("buttonB").toBool();
        bool buttonC = query.value("buttonC").toBool();
        bool buttonPatternA = query.value("buttonPatternA").toBool();
        bool buttonPatternB = query.value("buttonPatternB").toBool();
        bool buttonPatternC = query.value("buttonPatternC").toBool();

        QJsonObject jsonObj;
        jsonObj["objectName"] = "getButtonStatus";
        jsonObj["buttonA"] = buttonA;
        jsonObj["buttonB"] = buttonB;
        jsonObj["buttonC"] = buttonC;
        jsonObj["buttonPatternA"] = buttonPatternA;
        jsonObj["buttonPatternB"] = buttonPatternB;
        jsonObj["buttonPatternC"] = buttonPatternC;

        QJsonDocument jsonDoc(jsonObj);
        QString jsonString = jsonDoc.toJson(QJsonDocument::Compact);

        qDebug() << "buttonStatusUpdated:" << jsonString;
        emit buttonStatusUpdated(jsonString);
    } else {
        qDebug() << "⚠️ No data found in `updateButtonHidding`.";
    }
}

void Database::UpdateStatusOfButtonHidding(QString msg) {
    qDebug() << "UpdateStatusOfButtonHidding:" << msg;

    // ===== Helper: เปิดคอนเนกชัน (หรือรีโอเพ็นถ้าหลุด) =====
    auto ensureOpen = [this]() -> bool {
        if (db.isOpen()) {
            QSqlQuery ping(db);
            if (ping.exec("SELECT 1")) return true;
            qWarning() << "[DB] Lost connection detected by ping. Reopening...";
            db.close();
        }
        // เปิด auto-reconnect ถ้าไดรเวอร์รองรับ (ไม่มีผลก็ไม่เป็นไร)
        db.setConnectOptions("MYSQL_OPT_RECONNECT=1");
        if (!db.open()) {
            qWarning() << "[DB] reopen failed:" << db.lastError().text();
            return false;
        }
        return true;
    };

    // ===== Helper: exec พร้อม retry 1 ครั้งหลังรีโอเพ็น =====
    auto execWithRetry = [this, &ensureOpen](const QString &sql, QSqlQuery *out = nullptr) -> bool {
        QSqlQuery q(db);
        if (q.exec(sql)) {
            if (out) *out = q;
            return true;
        }
        const auto err1 = q.lastError().text();
        qWarning() << "[DB] Exec failed:" << err1 << " -> retry after reopen";
        if (!ensureOpen()) return false;

        QSqlQuery q2(db);
        if (!q2.exec(sql)) {
            qWarning() << "[DB] Exec failed again:" << q2.lastError().text();
            return false;
        }
        if (out) *out = q2;
        return true;
    };

    // ===== เดิม: ตัวแปรสถานะ =====
    bool update = false;
    bool updateAll = false;
    bool showAll = false;

    // ===== เปิด DB ถ้ายังไม่เปิด =====
    if (!db.isOpen()) {
        qDebug() << "Database is not open. Trying to open...";
        if (!ensureOpen()) {
            qWarning() << "Failed to open database:" << db.lastError().text();
            return;
        }
    }

    // ===== เดิม: Parse JSON =====
    QJsonDocument jsonDoc = QJsonDocument::fromJson(msg.toUtf8());
    if (jsonDoc.isNull() || !jsonDoc.isObject()) {
        qDebug() << "Invalid JSON format!";
        return;
    }

    QJsonObject jsonObj = jsonDoc.object();
    if (!jsonObj.contains("objectName") || jsonObj["objectName"].toString().isEmpty()) {
        qDebug() << "JSON missing 'objectName'!";
        return;
    }

    // ===== เดิม: สร้างเงื่อนไข update =====
    QStringList updateParts;
    if (jsonObj.contains("updateStatusisGreenButA"))
        updateParts.append(QString("buttonA = %1").arg(jsonObj["updateStatusisGreenButA"].toBool() ? "1" : "0"));
    else if (jsonObj.contains("updateStatusisGreenButB"))
        updateParts.append(QString("buttonB = %1").arg(jsonObj["updateStatusisGreenButB"].toBool() ? "1" : "0"));
    else if (jsonObj.contains("updateStatusisGreenButC"))
        updateParts.append(QString("buttonC = %1").arg(jsonObj["updateStatusisGreenButC"].toBool() ? "1" : "0"));
    else if (jsonObj.contains("updateStatusisGreenPatternA"))
        updateParts.append(QString("buttonPatternA = %1").arg(jsonObj["updateStatusisGreenPatternA"].toBool() ? "1" : "0"));
    else if (jsonObj.contains("updateStatusisGreenPatternB"))
        updateParts.append(QString("buttonPatternB = %1").arg(jsonObj["updateStatusisGreenPatternB"].toBool() ? "1" : "0"));
    else if (jsonObj.contains("updateStatusisGreenPatternC"))
        updateParts.append(QString("buttonPatternC = %1").arg(jsonObj["updateStatusisGreenPatternC"].toBool() ? "1" : "0"));
    else if (jsonObj.contains("updateStatusisGreenAll")) {
        update = true;
    }
    else if (jsonObj.contains("updateStatusisGreenAllPattern")) {
        updateAll = true;
    }
    else if (jsonObj.contains("updateStatusAll")) {
        showAll = true;
    }

    qDebug() << "update" << update << " updateAll" << updateAll << " showAll" << showAll;
    if (updateParts.isEmpty() && update == false && updateAll == false && showAll == false) {
        qDebug() << "No valid fields to update!" << (updateParts.isEmpty() || update == false || updateAll == false);
        return;
    }

    // ===== เดิม (แต่เพิ่ม retry): ตรวจว่ามีตาราง =====
    {
        QSqlQuery checkQuery(db);
        // ครั้งที่ 1
        if (!checkQuery.exec("SHOW TABLES LIKE 'updateButtonHiding'") || !checkQuery.next()) {
            qWarning() << "Table `updateButtonHiding` check failed or not found. Retrying after reopen...";
            // รีโอเพ็น แล้วลองใหม่
            if (!ensureOpen()) {
                qWarning() << "Failed to reopen database for SHOW TABLES.";
                return;
            }
            QSqlQuery checkQuery2(db);
            if (!checkQuery2.exec("SHOW TABLES LIKE 'updateButtonHiding'") || !checkQuery2.next()) {
                qWarning() << "Table `updateButtonHiding` does not exist (after retry).";
                return;
            }
        }
    }

    // ===== เดิม: สร้าง SQL =====
    QString updateSQL;
    if (update == true) {
        updateSQL = QString("UPDATE updateButtonHiding SET "
                            "buttonA=0, buttonB=0, buttonC=0, "
                            "buttonPatternA=0, buttonPatternB=0, buttonPatternC=0 "
                            "WHERE id = 1");
    } else if (updateAll == true) {
        updateSQL = QString("UPDATE updateButtonHiding SET "
                            "buttonPatternA=0, buttonPatternB=0, buttonPatternC=0 "
                            "WHERE id = 1");
    } else if (showAll == true) {
        updateSQL = QString("UPDATE updateButtonHiding SET "
                            "buttonA=1, buttonB=1, buttonC=1, "
                            "buttonPatternA=1, buttonPatternB=1, buttonPatternC=1 "
                            "WHERE id = 1");
    } else {
        updateSQL = QString("UPDATE updateButtonHiding SET %1 WHERE id = 1").arg(updateParts.join(", "));
    }

    qDebug() << "Executing SQL:" << updateSQL;

    // ===== เดิม (แต่ exec แบบมี retry) =====
    {
        QSqlQuery q(db);
        if (!q.exec(updateSQL)) {
            qWarning() << "SQL Update Failed:" << q.lastError().text() << " -> retry after reopen";
            if (!ensureOpen()) {
                qWarning() << "Failed to reopen DB for UPDATE.";
                return;
            }
            QSqlQuery q2(db);
            if (!q2.exec(updateSQL)) {
                qWarning() << "SQL Update Failed (after retry):" << q2.lastError().text();
                return;
            } else {
                // อัปเดตสำเร็จหลังรีโอเพ็น
                qDebug() << "Successfully updated button status! (after retry)";
            }
        } else {
            qDebug() << "Successfully updated button status!";
        }

        // ทางเลือก: แจ้งเตือนถ้าไม่มีแถวไหนถูกอัปเดต (เช่น id=1 ไม่มี)
        if (q.numRowsAffected() == 0) {
            qWarning() << "[DB] UPDATE affected 0 rows. Check if row id=1 exists.";
            // ไม่ insert/สร้างตารางใหม่ ตาม requirement
        }
    }

    // ===== เดิม: ส่งผลลัพธ์ออกต่อ =====
    GetStatusOfButtonHidding();
}

//void Database::UpdateStatusOfButtonHidding(QString msg) {
//    qDebug() << "UpdateStatusOfButtonHidding:" << msg;
//    // db.close();
//    bool update=false;
//    bool updateAll=false;
//    bool showAll=false;

//    if (!db.isOpen()) {
//        qDebug() << "Database is not open. Trying to open...";
//        if (!db.open()) {
//            qWarning() << "Failed to open database:" << db.lastError().text();
//            return;
//        }
//    }

//    QJsonDocument jsonDoc = QJsonDocument::fromJson(msg.toUtf8());
//    if (jsonDoc.isNull() || !jsonDoc.isObject()) {
//        qDebug() << "Invalid JSON format!";
//        return;
//    }

//    QJsonObject jsonObj = jsonDoc.object();
//    if (!jsonObj.contains("objectName") || jsonObj["objectName"].toString().isEmpty()) {
//        qDebug() << "JSON missing 'objectName'!";
//        return;
//    }

//    QStringList updateParts;
//    if (jsonObj.contains("updateStatusisGreenButA"))
//        updateParts.append(QString("buttonA = %1").arg(jsonObj["updateStatusisGreenButA"].toBool() ? "1" : "0"));
//    else if (jsonObj.contains("updateStatusisGreenButB"))
//        updateParts.append(QString("buttonB = %1").arg(jsonObj["updateStatusisGreenButB"].toBool() ? "1" : "0"));
//    else if (jsonObj.contains("updateStatusisGreenButC"))
//        updateParts.append(QString("buttonC = %1").arg(jsonObj["updateStatusisGreenButC"].toBool() ? "1" : "0"));
//    else if (jsonObj.contains("updateStatusisGreenPatternA"))
//        updateParts.append(QString("buttonPatternA = %1").arg(jsonObj["updateStatusisGreenPatternA"].toBool() ? "1" : "0"));
//    else if (jsonObj.contains("updateStatusisGreenPatternB"))
//        updateParts.append(QString("buttonPatternB = %1").arg(jsonObj["updateStatusisGreenPatternB"].toBool() ? "1" : "0"));
//    else if (jsonObj.contains("updateStatusisGreenPatternC"))
//        updateParts.append(QString("buttonPatternC = %1").arg(jsonObj["updateStatusisGreenPatternC"].toBool() ? "1" : "0"));
//    else if(jsonObj.contains("updateStatusisGreenAll")){
//        update = true;
//    }
//    else if(jsonObj.contains("updateStatusisGreenAllPattern")){
//        updateAll = true;
//    }else if(jsonObj.contains("updateStatusAll")){
//        showAll = true;
//    }

//    qDebug() << "update" << update << " updateAll" << updateAll << " showAll" << showAll;
//    if (updateParts.isEmpty() && update == false && updateAll == false && showAll ==false) {
//        qDebug() << "No valid fields to update!" << (updateParts.isEmpty() || update == false || updateAll == false);
//        return;
//    }

//    QSqlQuery checkQuery(db);
//    if (!checkQuery.exec("SHOW TABLES LIKE 'updateButtonHiding'") || !checkQuery.next()) {
//        qWarning() << "Table `updateButtonHiding` does not exist.";
//        return;
//    }

//    QString updateSQL = "";
//    if(update == true){
//        updateSQL = QString("UPDATE updateButtonHiding SET buttonA=0, buttonB=0, buttonC=0,buttonPatternA=0, buttonPatternB=0,buttonPatternC=0 WHERE id = 1");
//    }else if(updateAll == true){
//        updateSQL = QString("UPDATE updateButtonHiding SET buttonPatternA=0, buttonPatternB=0,buttonPatternC=0 WHERE id = 1");
//    }else if(showAll == true){
//        updateSQL = QString("UPDATE updateButtonHiding SET buttonA=1, buttonB=1, buttonC=1,buttonPatternA=1, buttonPatternB=1,buttonPatternC=1 WHERE id = 1");

//    }else{
//        updateSQL = QString("UPDATE updateButtonHiding SET %1 WHERE id = 1").arg(updateParts.join(", "));
//}
//    QSqlQuery query(db);
//    qDebug() << "Executing SQL:" << updateSQL;

//    if (!query.exec(updateSQL)) {
//        qWarning() << "SQL Update Failed:" << query.lastError().text();
//    } else {
//        qDebug() << "Successfully updated button status!";
//    }

//    // //.db.close();

//    GetStatusOfButtonHidding();
//}


void Database::taggingpoint(QString msg) {
    qDebug() << "taggingpoint:" << msg;
    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();
    QString getCommand = QJsonValue(command["objectName"]).toString();
    int taggingPoint = QJsonValue(command["checklist"]).toInt();
    bool statuslist = QJsonValue(command["statuslist"]).toBool();
    qDebug() << "tagging data:" << taggingPoint << statuslist;

    updataStatusTagging(taggingPoint, statuslist);

    if (getCommand.contains("taggingdata")) {
        qDebug() << "Processing taggingdata command with taggingpoint:" << taggingPoint;

        if (!db.isOpen()) {
            qDebug() << "Database not open, attempting to open...";
            if (!db.open()) {
                qWarning() << "Failed to open database:" << db.lastError().text();
                return;
            }
            qDebug() << "Database connection opened successfully.";
        }

        // ดึงข้อมูลที่อัปเดตแล้ว
        QString checkQueryStr = QString("SELECT * FROM DataTagging WHERE No = '%1'").arg(taggingPoint);
        QSqlQuery query;

        if (query.exec(checkQueryStr)) {
            if (query.next()) {
                QVariant statusVar = query.value("status");
                QVariant numListVar = query.value("No");
                QVariant tempNoVar = query.value("temp_no");
                QVariant distanceVar = query.value("Distance(Km)");
                QVariant detailVar = query.value("Detail");
                QVariant phaseVar = query.value("Phase");

                bool status = statusVar.toInt() != 0;
                int num_list = numListVar.toInt();
                int temp_no = tempNoVar.toInt();
                double Distance = distanceVar.toDouble();
                QString Detail = detailVar.toString();
                QString Phase = phaseVar.toString();

                QString message = QString("{\"objectName\"  :\"taggingdata\", "
                                          "\"status\"       :%1, "
                                          "\"num_list\"     :%2, "
                                          "\"temp_no\"      :%3, "
                                          "\"Distance\"     :\"%4\", "
                                          "\"Detail\"       :\"%5\", "
                                          "\"Phase\"        :\"%6\"}")
                                      .arg(status ? "true" : "false")
                                      .arg(num_list)
                                      .arg(temp_no)
                                      .arg(Distance, 0, 'f', 2) // format Distance to 2 decimal places
                                      .arg(Detail)
                                      .arg(Phase);
                qDebug() << "Sent message get PhaseA:" << message;

                emit showtaggingpoint(message);
            } else {
                qDebug() << "No record found with No =" << taggingPoint;
            }
        } else {
            qWarning() << "Failed to execute query:" << query.lastError().text();
        }
    } else {
        qDebug() << "Unknown command received.";
    }

    if (db.isOpen()) {
        //.db.close();
        qDebug() << "Database is open. Closing all connections...";
    }
}



void Database::getChangeDistance(QString msg) {
    qDebug() << "getChangeDistance:" << msg;

    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();

    QString getCommand = QJsonValue(command["objectName"]).toString();
    double rangeDistance = QJsonValue(command["rangedistance"]).toDouble();

    if (getCommand.contains("rangedistance")) {
        qDebug() << "Received rangedistance value:" << rangeDistance;

        if (!db.isOpen()) {
            qDebug() << "Database not open, attempting to open...";
            if (!db.open()) {
                qWarning() << "Failed to open database:" << db.lastError().text();
                return;
            }
            qDebug() << "Database connection opened successfully.";
        }

        QSqlQuery checkQuery;
        checkQuery.prepare("SELECT MAX(AutoNumber) FROM DistanceData");

        if (!checkQuery.exec()) {
            qWarning() << "Failed to execute checkQuery:" << checkQuery.lastError().text();
            return;
        }

        if (checkQuery.next()) {
            QVariant maxAutoNumber = checkQuery.value(0);

            if (!maxAutoNumber.isNull()) {
                int recordAutoNumber = maxAutoNumber.toInt();
                qDebug() << "Existing record found with AutoNumber:" << recordAutoNumber;

                QSqlQuery updateQuery;
                updateQuery.prepare("UPDATE DistanceData "
                                    "SET DistanceKm = :distance "
                                    "WHERE AutoNumber = :autoNumber");
                updateQuery.bindValue(":distance", rangeDistance);
                updateQuery.bindValue(":autoNumber", recordAutoNumber);

                if (updateQuery.exec()) {
                    qDebug() << "Record with AutoNumber =" << recordAutoNumber
                             << "updated successfully with new DistanceKm =" << rangeDistance;
                } else {
                    qWarning() << "Failed to update the record:" << updateQuery.lastError().text();
                }
            } else {
                qDebug() << "No records found in DistanceData table.";
            }
        } else {
            qWarning() << "Failed to retrieve records from DistanceData table.";
        }
    } else {
        qDebug() << "Invalid command received in message.";
    }
    if (db.isOpen()) {
        //.db.close();
        qDebug() << "Database connection closed.";
    }
    updateDistance(rangeDistance);
}

void Database::updateDistance(double updatedistance) {
    qDebug() << "Taking data from table..." << updatedistance;

    QString newCursor = QString("{\"objectName\"          :\"updateCursor\","
                                "\"distance\"        :\"%1\""
                                "}").arg(updatedistance);
    qDebug() << "updateDistance:" << newCursor;
    emit updatanewdistance(newCursor);
}



void Database::controlCursor(QString msg) {
    qDebug() << "controlCursor:" << msg;
    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();
    QString getCommand = QJsonValue(command["objectName"]).toString();
    if(getCommand.contains("decreaseValue")){
        double leftmove = QJsonValue(command["decreaseValue"]).toDouble();
        qDebug() << "cursorPosition:" << leftmove;
        QString cutsorleftMove = QString("{\"objectName\"          :\"updatedecreaseValue\","
                                            "\"decreaseValue\"        :%1"
                                            "}").arg(leftmove);
        qDebug() << "cutsorleftMove:" << cutsorleftMove;
        emit positionCursorChange(cutsorleftMove);
    }else if(getCommand.contains("increaseValue")){
        double rigth = QJsonValue(command["increaseValue"]).toDouble();
        qDebug() << "cursorPosition:" << rigth;
        QString cutsorrightMove = QString("{\"objectName\"          :\"updateincreaseValue\","
                                            "\"increaseValue\"        :%1"
                                            "}").arg(rigth);
        qDebug() << "cutsorrigthMove:" << cutsorrightMove;
        emit positionCursorChange(cutsorrightMove);
    }
}

void Database::getPositionDistance(QString msg) {
    qDebug() << "getPositionDistance:" << msg;
    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();
    QString getCommand = QJsonValue(command["objectName"]).toString();
    if(getCommand.contains("distance")){
        QString distance = QJsonValue(command["distance"]).toString();
        QString cutsor = QString("{\"objectName\"          :\"positonCursor\","
                                    "\"distance\"        :\"%1\""
                                    "}").arg(distance);
        qDebug() << "cursorPosition:" << cutsor;
        emit cursorPosition(cutsor);
    }
}

void Database::initialCursorPosition(){

    qDebug() << "initialCursorPosition:";

    if (!db.isOpen()) {
        qDebug() << "[initialCursorPosition] DB not open -> opening…";
        if (!db.open()) {
            qDebug() << "[initialCursorPosition] open failed:" << db.lastError().text();
            QJsonObject obj; obj["objectName"] = "positonCursor"; obj["distance"] = "0";
            emit cursorPosition(QString::fromUtf8(QJsonDocument(obj).toJson(QJsonDocument::Compact)));
            return;
        }
    }

    QSqlQuery q(db);
    QString distanceStr = "0";
    if (q.exec("SELECT DistanceKm FROM DistanceData ORDER BY AutoNumber DESC LIMIT 1") && q.next()) {
        distanceStr = q.value(0).toString();
    } else {
        qDebug() << "[initialCursorPosition] query/rows issue:" << q.lastError().text();
    }

    QJsonObject obj;
    obj["objectName"] = "positionDistance";  // แก้เป็น "positionCursor" ถ้าฝั่งรับต้องการสะกดถูกต้อง
    obj["distance"]   = distanceStr.toDouble();      // ส่งเป็น string ตามที่คุณต้องการ

    const QString payload = QString::fromUtf8(QJsonDocument(obj).toJson(QJsonDocument::Compact));
    qDebug() << "cursorPosition:" << payload;
    emit positionCursorChange(payload);
}

bool Database::ensureDistanceDataTable()
{
    if (!db.isOpen()) {
        qDebug() << "[DistanceData] DB closed → try open()";
        if (!db.open()) {
            qDebug() << "[DistanceData] open failed:" << db.lastError().text();
            return false;
        }
    }

    // เก็บเป็น string ก็ได้ ตามที่ต้องการ
    // (ถ้าอยากเก็บเป็นตัวเลข ให้ใช้ DOUBLE แทน VARCHAR)
    QSqlQuery q(db);
    const char* createSql =
        "CREATE TABLE IF NOT EXISTS DistanceData ("
        "  AutoNumber INT PRIMARY KEY,"
        "  DistanceKm VARCHAR(64)"
        ")";
    if (!q.exec(QString::fromLatin1(createSql))) {
        qDebug() << "[DistanceData] CREATE TABLE failed:" << q.lastError().text();
        return false;
    }
    return true;
}

void Database::upDateCursorPosition(QString msg)
{
    qDebug() << "[upDateCursorPosition] raw:" << msg;

    if (!db.isOpen() && !db.open()) {
        qDebug() << "[upDateCursorPosition] DB open failed:" << db.lastError().text();
        return;
    }

    // สร้างตารางถ้ายังไม่มี (ง่าย ๆ)
    QSqlQuery qc(db);
    if (!qc.exec("CREATE TABLE IF NOT EXISTS DistanceData ("
                 "  AutoNumber INT PRIMARY KEY,"
                 "  DistanceKm VARCHAR(64)"
                 ")")) {
        qDebug() << "[upDateCursorPosition] CREATE TABLE failed:" << qc.lastError().text();
        return;
    }

    // parse JSON
    QJsonParseError perr;
    QJsonDocument doc = QJsonDocument::fromJson(msg.toUtf8(), &perr);
    if (perr.error != QJsonParseError::NoError || !doc.isObject()) {
        qDebug() << "[upDateCursorPosition] JSON parse error:" << perr.errorString();
        return;
    }
    QJsonObject o = doc.object();

    // รองรับทั้ง "distance" เป็น string หรือ number และ fallback เป็น "DistanceKm"
    QString distanceStr;
    QJsonValue v = o.value("distance");
    if (v.isUndefined()) v = o.value("DistanceKm");

    if (v.isString()) {
        distanceStr = v.toString().trimmed();
    } else if (v.isDouble()) {
        // เก็บเป็นสตริงตามที่ต้องการ
        distanceStr = QString::number(v.toDouble(), 'f', 2);
    }

    if (distanceStr.isEmpty()) {
        qDebug() << "[upDateCursorPosition] distance empty -> skip";
        return;
    }

    // เซฟแบบง่าย: แทรกถ้าไม่มี / อัปเดตถ้ามี
    QSqlQuery q(db);
    q.prepare("INSERT INTO DistanceData (AutoNumber, DistanceKm) VALUES (1, :dist) "
              "ON DUPLICATE KEY UPDATE DistanceKm = VALUES(DistanceKm)");
    q.bindValue(":dist", distanceStr);

    if (!q.exec()) {
        qDebug() << "[upDateCursorPosition] UPSERT failed:" << q.lastError().text();
        return;
    }

    qDebug() << "[upDateCursorPosition] saved DistanceKm =" << distanceStr;

    // debug อ่านกลับ
    QSqlQuery qr(db);
    if (qr.exec("SELECT AutoNumber, DistanceKm FROM DistanceData WHERE AutoNumber=1") && qr.next()) {
        qDebug() << "[upDateCursorPosition] read-back:" << qr.value(0).toInt()
                 << qr.value(1).toString();
    }
}

void Database::userMode(QString msg) {
    qDebug() << "Database_userMode:" << msg;

    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();

    if (!command.contains("userType")) {
        qDebug() << "Invalid message format: Missing 'userType'.";
        return;
    }

    QString userType = command["userType"].toString();  // Extract Master/Slave
    QString userStatusSlave = command["userStatusSlave"].toString(); // Extract status (if Slave)

    if (userType != "Master" && userType != "Slave") {
        qDebug() << "Invalid userType value:" << userType;
        return;
    }

    int userStatus = userStatusSlave.toInt();

    if (!db.isOpen()) {
        qDebug() << "Database is not open. Attempting to open...";
        if (!db.open()) {
            qDebug() << "Failed to open database:" << db.lastError().text();
            return;
        }
    }

    QSqlQuery query(db);

    query.prepare("UPDATE UserModeTable SET userMode = :userMode, userStatus = :userStatus WHERE Num = 1");
    query.bindValue(":userMode", userType);
    query.bindValue(":userStatus", userStatus);

    if (!query.exec()) {
        qDebug() << "Failed to update UserModeTable:" << query.lastError().text();
    } else {
        qDebug() << "UserModeTable updated successfully. userMode:" << userType << ", userStatus:" << userStatus;
    }

    closeMySQL();
    getUpdateUserMode();
}

void Database::getUpdateUserMode() {
    qDebug() << "Fetching current UserMode from UserModeTable...";

    if (!db.isOpen()) {
        qDebug() << "Database is not open. Attempting to open...";
        if (!db.open()) {
            qDebug() << "Failed to open database:" << db.lastError().text();
            return;
        }
    }

    QSqlQuery query(db);

    query.prepare("SELECT Num, userMode, userStatus FROM UserModeTable WHERE Num = 1");

    if (!query.exec()) {
        qDebug() << "Failed to fetch data from UserModeTable:" << query.lastError().text();
    } else if (query.next()) {
        int num = query.value("Num").toInt();
        QString userMode = query.value("userMode").toString();
        bool userStatus = query.value("userStatus").toInt() != 0; // Convert int to bool

        qDebug() << "Current UserModeTable Data:";
        qDebug() << "Num:" << num << ", userMode:" << userMode << ", userStatus:" << userStatus;
    } else {
        qDebug() << "No data found in UserModeTable.";
    }

    closeMySQL();
}

void Database::getEventandAlarm(QString msg){
//    qDebug() << "Database:" << msg;

    if(msg == "getEventandAlarm"){

        QSqlQuery checkTableQuery(db);
        QString checkTableSQL = QString(
            "SELECT COUNT(*) FROM information_schema.tables "
            "WHERE table_schema = '%1' AND table_name = 'eventandalarm'")
            .arg(db.databaseName());

        if (!checkTableQuery.exec(checkTableSQL)) {
            qDebug() << "Failed to check if table exists:" << checkTableQuery.lastError().text();
            return;
        }

        if (checkTableQuery.next() && checkTableQuery.value(0).toInt() > 0) {
            qDebug() << "Table `eventandalarm` exists. Fetching data...";

            QSqlQuery query(db);
            if (!query.exec("SELECT date, time, event_name, status FROM eventandalarm")) {
                qDebug() << "Query execution failed:" << query.lastError().text();
                return;
            }

            if (query.first()) {
                QString date = query.value("date").toString();
                QString time = query.value("time").toString();
                QString eventName = query.value("event_name").toString();
                QString status = query.value("status").toString();

                QString EventandAlarm = QString("{\"objectName\"    :\"getEventandAlarm\","
                                                "\"Date\"           :\"%1\","
                                                "\"Time\"           :\"%2\","
                                                "\"EventName\"      :\"%3\","
                                                "\"Status\"         :\"%4\""
                                        ).arg(date).arg(time).arg(eventName).arg(status);
                qDebug() << EventandAlarm;
                emit eventmsg(EventandAlarm);
            } else {
                qDebug() << "No data found in `eventandalarm` table.";
            }
        } else {
            qDebug() << "Table `eventandalarm` does not exist.";
        }
    }
}

void Database::getMySqlPhaseA(QString msg) {
    qDebug() << "getMySqlPhase:" << msg;

    if (!db.isOpen()) {
        qDebug() << "Database is not open. Attempting to open...";
        //.db.close();
        if (!db.open()) {
            qDebug() << "Failed to open database:" << db.lastError().text();
            //.db.close();
            return;
        }
    }

    QSqlQuery query;
    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();
    QString getCommand = QJsonValue(command["objectName"]).toString();

    if (getCommand.contains("TaggingPhaseA")) {
        if (query.exec("SELECT * FROM DataTagging WHERE Phase = 'A'")) {
            while (query.next()) {
                QVariant statusVar = query.value("status");
                QVariant numListVar = query.value("No");
                QVariant tempNoVar = query.value("temp_no");
                QVariant distanceVar = query.value("Distance(Km)");
                QVariant detailVar = query.value("Detail");
                QVariant phaseVar = query.value("Phase");

                bool status = statusVar.toInt() != 0;
                int num_list = numListVar.toInt();
                int temp_no = tempNoVar.toInt();
                double Distance = distanceVar.toDouble();
                QString Detail = detailVar.toString();
                QString Phase = phaseVar.toString();

                qDebug() << "Debug Variables and Types:";
                qDebug() << "status (as bool):" << (status ? "true" : "false") << "type: bool";
                qDebug() << "num_list:" << num_list << "type:" << numListVar.typeName();
                qDebug() << "temp_no:" << temp_no << "type:" << tempNoVar.typeName();
                qDebug() << "Distance:" << Distance << "type:" << distanceVar.typeName();
                qDebug() << "Detail:" << Detail << "type:" << detailVar.typeName();
                qDebug() << "Phase:" << Phase << "type:" << phaseVar.typeName();

                if (Phase.isEmpty() || Detail.isEmpty()) {
                    qWarning() << "Warning: Empty Phase or Detail. Skipping this row.";
                    continue;
                }

                QString message = QString("{\"objectName\"  :\"getMySqlPhaseA\", "
                                          "\"status\"       :%1, "
                                          "\"num_list\"     :%2, "
                                          "\"temp_no\"      :%3, "
                                          "\"Distance\"     :\"%4\", "
                                          "\"Detail\"       :\"%5\", "
                                          "\"Phase\"        :\"%6\"}")
                                      .arg(status ? "true" : "false")
                                      .arg(num_list)
                                      .arg(temp_no)
                                      .arg(Distance)
                                      .arg(Detail)
                                      .arg(Phase);

                qDebug() << "Sent message get PhaseA:" << message;
                emit cmdmsg(message);
            }
        } else {
            qDebug() << "Failed to execute query:" << query.lastError().text();
        }
        closeMySQL();
    }
}


void Database::getMySqlPhaseB(QString msg) {
    qDebug() << "getMySqlPhaseB:" << msg;

    if (!db.isOpen()) {
        qDebug() << "Database is not open. Attempting to open...";
        //.db.close();
        if (!db.open()) {
            qDebug() << "Failed to open database:" << db.lastError().text();
            //.db.close();
            return;
        }
    }

    QSqlQuery query;
    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();
    QString getCommand = QJsonValue(command["objectName"]).toString();
    if(getCommand.contains("TaggingPhaseB")) {
           if (query.exec("SELECT * FROM DataTagging WHERE Phase = 'B'")) {
               while (query.next()) {
                   QVariant statusVar = query.value("status");
                   QVariant numListVar = query.value("No");
                   QVariant tempNoVar = query.value("temp_no");
                   QVariant distanceVar = query.value("Distance(Km)");
                   QVariant detailVar = query.value("Detail");
                   QVariant phaseVar = query.value("Phase");

                   bool status = statusVar.toInt() != 0;
                   int num_list = numListVar.toInt();
                   int temp_no = tempNoVar.toInt();
                   double Distance = distanceVar.toDouble();
                   QString Detail = detailVar.toString();
                   QString Phase = phaseVar.toString();

                   qDebug() << "Debug Variables and Types:";
                   qDebug() << "status (as bool):" << (status ? "true" : "false") << "type: bool";
                   qDebug() << "num_list:" << num_list << "type:" << numListVar.typeName();
                   qDebug() << "temp_no:" << temp_no << "type:" << tempNoVar.typeName();
                   qDebug() << "Distance:" << Distance << "type:" << distanceVar.typeName();
                   qDebug() << "Detail:" << Detail << "type:" << detailVar.typeName();
                   qDebug() << "Phase:" << Phase << "type:" << phaseVar.typeName();

                   if (Phase.isEmpty() || Detail.isEmpty()) {
                       qWarning() << "Warning: Empty Phase or Detail. Skipping this row.";
                       continue;
                   }

                   QString message = QString("{\"objectName\"  :\"getMySqlPhaseB\", "
                                             "\"status\"       :%1, "
                                             "\"num_list\"     :%2, "
                                             "\"temp_no\"      :%3, "
                                             "\"Distance\"     :\"%4\", "
                                             "\"Detail\"       :\"%5\", "
                                             "\"Phase\"        :\"%6\"}")
                                         .arg(status ? "true" : "false")
                                         .arg(num_list)
                                         .arg(temp_no)
                                         .arg(Distance)
                                         .arg(Detail)
                                         .arg(Phase);
                   qDebug() << "Sent message get PhaseB:" << message;
                   emit cmdmsg(message);
               }
           } else {
               qDebug() << "Failed to execute query:" << query.lastError().text();
           }
           closeMySQL();
       }
}

void Database::getMySqlPhaseC(QString msg) {
    qDebug() << "getMySqlPhaseC:" << msg;
    if (!db.isOpen()) {
        qDebug() << "Database is not open. Attempting to open...";
        //.db.close();
        if (!db.open()) {
            qDebug() << "Failed to open database:" << db.lastError().text();
            //.db.close();
            return;
        }
    }
    QSqlQuery query;
    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();
    QString getCommand = QJsonValue(command["objectName"]).toString();
    if(getCommand.contains("TaggingPhaseC")){
            if (query.exec("SELECT * FROM DataTagging WHERE Phase = 'C'")) {
                while (query.next()) {
                    bool status = query.value("status").toBool();
                    int num_list = query.value("No").toInt(); // ดึงค่าของ No
                    int temp_no = query.value("temp_no").toInt();
                    double Distance = query.value("Distance(Km)").toDouble();
                    QString Detail = query.value("Detail").toString();
                    QString Phase = query.value("Phase").toString();

                    QString message = QString("{\"objectName\":\"getMySqlPhaseC\", "
                                              "\"status\":%1, "
                                              "\"num_list\":%2, "
                                              "\"temp_no\":%3, "
                                              "\"Distance\":\"%4\", "
                                              "\"Detail\":\"%5\", "
                                              "\"Phase\":\"%6\"}")
                                          .arg(status ? "true" : "false")
                                          .arg(num_list)       // ใส่ค่า num_list
                                          .arg(temp_no)
                                          .arg(Distance)
                                          .arg(Detail)
                                          .arg(Phase);

                    qDebug() << "Sent message get PhaseB:" << message;
                    emit cmdmsg(message);
                }
            } else {
                qDebug() << "Failed to execute query:" << query.lastError().text();
            }
           closeMySQL();
        }

}



void Database::updateDataBaseDisplay(QString msg) {
    qDebug() << "getMySqlPhaseA:" << msg;
    QSqlQuery query;

    if (query.exec("SELECT * FROM DataTagging")) {
        QString clearMessage = "{\"objectName\":\"updateDataDisplay\"}";
        updateTableDisplay(clearMessage);

        while (query.next()) {
            bool status = query.value("status").toBool();
            int num_list = query.value("No").toInt();
            int temp_no = query.value("temp_no").toInt();
            double Distance = query.value("Distance(Km)").toDouble();
            QString Detail = query.value("Detail").toString();
            QString Phase = query.value("Phase").toString();

            QString message = QString("{\"objectName\":\"updateDataDisplay\", "
                                      "\"status\":%1, "
                                      "\"num_list\":%2, "
                                      "\"temp_no\":%3, "
                                      "\"Distance\":\"%4\", "
                                      "\"Detail\":\"%5\", "
                                      "\"Phase\":\"%6\"}")
                                  .arg(status ? "true" : "false")
                                  .arg(num_list)
                                  .arg(temp_no)
                                  .arg(Distance)
                                  .arg(Detail)
                                  .arg(Phase);

            qDebug() << "Sent message:" << message;
            updateTableDisplay(message);
        }
    } else {
        qDebug() << "Failed to execute query:" << query.lastError().text();
    }
    //.db.close();
}

void Database::DistanceandDetailPhaseA(QString msg) {
    qDebug() << "DistanceandDetailPhaseA:" << msg;
    if (!db.isOpen()) {
        qDebug() << "Database is not open. Attempting to open.";
        //.db.close();
        if (!db.open()) {
            qDebug() << "Failed to open database:" << db.lastError().text();
            return;
        }
    }

    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();
    QString getCommand = QJsonValue(command["objectName"]).toString();

    if (getCommand.contains("getDistanceDetailA")) {
        QString phase = QJsonValue(command["PHASE"]).toString();
        double distancecmd = QJsonValue(command["Distance"]).toDouble();
        QString detailcmd = QJsonValue(command["Detail"]).toString();

        qDebug() << "getDistanceDetailA:" << distancecmd << detailcmd << "Phase:" << phase;

        if (phase.isEmpty() || detailcmd.isEmpty()) {
            qDebug() << "Invalid data: Phase or Detail is empty!";
            return;
        }

        QSqlQuery query;

        query.prepare("SELECT MAX(temp_no) FROM DataTagging WHERE Phase = :phase");
        query.bindValue(":phase", phase);

        int newTempNo = 1;
        if (!query.exec()) {
            qDebug() << "Failed to execute query:" << query.lastQuery();
            qDebug() << "Error:" << query.lastError().text();
            return;
        }

        if (query.next()) {
            QVariant maxTempNo = query.value(0);
            if (maxTempNo.isValid() && !maxTempNo.isNull()) {
                newTempNo = maxTempNo.toInt() + 1;
            }
        } else {
            qDebug() << "No data found for phase:" << phase;
        }

        query.prepare("INSERT INTO DataTagging (status, `Distance(Km)`, Detail, Phase, temp_no) "
                      "VALUES (:status, :distance, :detail, :phase, :temp_no)");

        query.bindValue(":status", 0);
        query.bindValue(":distance", distancecmd);
        query.bindValue(":detail", detailcmd);
        query.bindValue(":phase", phase);
        query.bindValue(":temp_no", newTempNo);

        if (!query.exec()) {
            qDebug() << "Failed to insert data:" << query.lastError().text();
            //.db.close();  // Close the database to avoid leaving it in an undefined state
            return;
        }

        qDebug() << "Data inserted successfully with temp_no:" << newTempNo;
        QString tableTaggingPhaseA = QJsonValue(command["tableTaggingPhaseA"]).toString();
        QString getTaggingPhaseA = QString("{"
                                           "\"objectName\":\"TaggingPhaseA\","
                                           "\"tableTaggingPhaseA\":\"%1\""
                                           "}").arg(tableTaggingPhaseA);

        qDebug() << "getTaggingPhaseA:" << getTaggingPhaseA;
        getMySqlPhaseA(getTaggingPhaseA);
    }
    //.db.close();
}




void Database::DistanceandDetailPhaseB(QString msg){
    qDebug() << "DistanceandDetailPhaseB:" << msg;

    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();
    QString getCommand = QJsonValue(command["objectName"]).toString();

    if (getCommand.contains("getDistanceDetailB")) {
        QString phase = QJsonValue(command["PHASE"]).toString();
        double distancecmd = QJsonValue(command["Distance"]).toDouble();
        QString detailcmd = QJsonValue(command["Detail"]).toString();

        qDebug() << "getDistanceDetailB:" << distancecmd << detailcmd << "Phase:" << phase;

        QSqlQuery query;
        query.prepare("SELECT MAX(temp_no) FROM DataTagging WHERE Phase = :phase");
        query.bindValue(":phase", phase);

        int newTempNo = 1;
        if (query.exec() && query.next()) {
            QVariant maxTempNo = query.value(0);
            if (maxTempNo.isValid()) {
                newTempNo = maxTempNo.toInt() + 1;
            }
        } else {
            qDebug() << "Failed to fetch max temp_no:" << query.lastError().text();
        }

        query.prepare("INSERT INTO DataTagging (status, `Distance(Km)`, Detail, Phase, temp_no) "
                      "VALUES (:status, :distance, :detail, :phase, :temp_no)");

        query.bindValue(":status", false);
        query.bindValue(":distance", distancecmd);
        query.bindValue(":detail", detailcmd);
        query.bindValue(":phase", phase);
        query.bindValue(":temp_no", newTempNo);

        if (query.exec()) {
            qDebug() << "Data inserted successfully with temp_no:" << newTempNo;
        } else {
            qDebug() << "Failed to insert data:" << query.lastError().text();
        }
    }
    //.db.close();
}
void Database::DistanceandDetailPhaseC(QString msg){
    qDebug() << "DistanceandDetailPhaseC:" << msg;

    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();
    QString getCommand = QJsonValue(command["objectName"]).toString();

    if (getCommand.contains("getDistanceDetailC")) {
        QString phase = QJsonValue(command["PHASE"]).toString();
        double distancecmd = QJsonValue(command["Distance"]).toDouble();
        QString detailcmd = QJsonValue(command["Detail"]).toString();

        qDebug() << "getDistanceDetailC:" << distancecmd << detailcmd << "Phase:" << phase;

        QSqlQuery query;
        query.prepare("SELECT MAX(temp_no) FROM DataTagging WHERE Phase = :phase");
        query.bindValue(":phase", phase);

        int newTempNo = 1;
        if (query.exec() && query.next()) {
            QVariant maxTempNo = query.value(0);
            if (maxTempNo.isValid()) {
                newTempNo = maxTempNo.toInt() + 1;
            }
        } else {
            qDebug() << "Failed to fetch max temp_no:" << query.lastError().text();
        }

        query.prepare("INSERT INTO DataTagging (status, `Distance(Km)`, Detail, Phase, temp_no) "
                      "VALUES (:status, :distance, :detail, :phase, :temp_no)");

        query.bindValue(":status", false);
        query.bindValue(":distance", distancecmd);
        query.bindValue(":detail", detailcmd);
        query.bindValue(":phase", phase);
        query.bindValue(":temp_no", newTempNo);

        if (query.exec()) {
            qDebug() << "Data inserted successfully with temp_no:" << newTempNo;
        } else {
            qDebug() << "Failed to insert data:" << query.lastError().text();
        }
    }
    //.db.close();

}

void Database::updateTablePhaseA(QString msg) {
    qDebug() << "updateTablePhaseA:" << msg;

    if (!db.isOpen()) {
        if (!db.open()) {
            qDebug() << "Failed to open database:" << db.lastError().text();
            return;
        }
    }

    QSqlQuery query;
    if (query.exec("SELECT * FROM DataTagging WHERE Phase = 'A'")) {
        while (query.next()) {
            QVariant statusVar = query.value("status");
            QVariant numListVar = query.value("No");
            QVariant tempNoVar = query.value("temp_no");
            QVariant distanceVar = query.value("Distance(Km)");
            QVariant detailVar = query.value("Detail");
            QVariant phaseVar = query.value("Phase");

            bool status = statusVar.toInt() != 0;
            int num_list = numListVar.toInt();
            int temp_no = tempNoVar.toInt();
            double distance = distanceVar.toDouble();
            QString detail = detailVar.toString();
            QString phase = phaseVar.toString();

            qDebug() << "Debug Variables and Types:";
            qDebug() << "status (as bool):" << (status ? "true" : "false") << "type: bool";
            qDebug() << "num_list:" << num_list << "type:" << numListVar.typeName();
            qDebug() << "temp_no:" << temp_no << "type:" << tempNoVar.typeName();
            qDebug() << "Distance:" << distance << "type:" << distanceVar.typeName();
            qDebug() << "Detail:" << detail << "type:" << detailVar.typeName();
            qDebug() << "Phase:" << phase << "type:" << phaseVar.typeName();

            QString newMessage = QString("{\"objectName\":\"updatedataTableA\", "
                                         "\"status\":%1, "
                                         "\"num_list\":%2, "
                                         "\"temp_no\":%3, "
                                         "\"Distance\":%4, "
                                         "\"Detail\":\"%5\", "
                                         "\"Phase\":\"%6\"}")
                                     .arg(status ? "true" : "false")
                                     .arg(num_list)
                                     .arg(temp_no)
                                     .arg(distance)
                                     .arg(detail)
                                     .arg(phase);

            qDebug() << "newMessage:" << newMessage;
            emit updatedataTableA(newMessage);
            //.db.close();
        }
    } else {
        qDebug() << "Failed to execute query for Phase A:" << query.lastError().text();
    }
}



void Database::updateTablePhaseB(QString msg) {
    qDebug() << "updateTablePhaseB:" << msg;

    static QSet<int> sentNumLists;

    QSqlQuery query;
    if (query.exec("SELECT * FROM DataTagging WHERE Phase = 'B' ORDER BY temp_no DESC LIMIT 1")) {
        if (query.next()) {
            bool status = query.value("status").toBool();
            int num_list = query.value("No").toInt();
            int temp_no = query.value("temp_no").toInt();
            double distance = query.value("Distance(Km)").toDouble();
            QString detail = query.value("Detail").toString();
            QString phase = query.value("Phase").toString();

            QString newMessage = QString("{\"objectName\":\"updatedataTableB\", "
                                         "\"statusB\":%1, "
                                         "\"num_listB\":%2, "
                                         "\"temp_noB\":%3, "
                                         "\"DistanceB\":\"%4\", "
                                         "\"DetailB\":\"%5\", "
                                         "\"PhaseB\":\"%6\"}")
                                     .arg(status ? "true" : "false")
                                     .arg(num_list)
                                     .arg(temp_no)
                                     .arg(distance)
                                     .arg(detail)
                                     .arg(phase);

            if (!sentNumLists.contains(num_list)) {
                emit updatedataTableB(newMessage);

                sentNumLists.insert(num_list);
            }
        }
    } else {
        qDebug() << "Failed to execute query for Phase B:" << query.lastError().text();
    }
}

void Database::updateTablePhaseC(QString msg) {
    qDebug() << "updateTablePhaseC:" << msg;

    static QSet<int> sentNumLists;

    QSqlQuery query;
    if (query.exec("SELECT * FROM DataTagging WHERE Phase = 'C' ORDER BY temp_no DESC LIMIT 1")) {
        if (query.next()) {
            bool status = query.value("status").toBool();
            int num_list = query.value("No").toInt();
            int temp_no = query.value("temp_no").toInt();
            double distance = query.value("Distance(Km)").toDouble();
            QString detail = query.value("Detail").toString();
            QString phase = query.value("Phase").toString();

            QString newMessage = QString("{\"objectName\":\"updatedataTableC\", "
                                         "\"statusC\":%1, "
                                         "\"num_listC\":%2, "
                                         "\"temp_noC\":%3, "
                                         "\"DistanceC\":\"%4\", "
                                         "\"DetailC\":\"%5\", "
                                         "\"PhaseC\":\"%6\"}")
                                     .arg(status ? "true" : "false")
                                     .arg(num_list)
                                     .arg(temp_no)
                                     .arg(distance)
                                     .arg(detail)
                                     .arg(phase);

            if (!sentNumLists.contains(num_list)) {
                emit updatedataTableC(newMessage);

                sentNumLists.insert(num_list);
            }
        }
    } else {
        qDebug() << "Failed to execute query for Phase C:" << query.lastError().text();
    }
}


void Database::deletedDataMySQLPhaseA(QString msg) {
    qDebug() << "deletedDataMySQLPhaseA:" << msg;

    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();

    QString numListStr = command["num_listA"].toString();
    int list_deviceID = numListStr.toInt();
    bool checkedStates = (command["checkedStates"].toString() == "1" || command["checkedStates"].toBool());

    qDebug() << "Parsed JSON: list_deviceID =" << list_deviceID << ", checkedStates =" << checkedStates;

    if (checkedStates) {
        if (!db.isOpen() && !db.open()) {
            qWarning() << "Database is not open and failed to reopen!";
            emit databaseError();
            return;
        }

        QSqlQuery checkQuery;
        checkQuery.prepare("SELECT COUNT(*) FROM DataTagging WHERE No = :No AND Phase = 'A'");
        checkQuery.bindValue(":No", list_deviceID);

        if (!checkQuery.exec()) {
            qWarning() << "Failed to execute checkQuery:" << checkQuery.lastError().text();
            return;
        }
        if (checkQuery.next()) {
            int recordCount = checkQuery.value(0).toInt();
            qDebug() << "checkQuery result: recordCount =" << recordCount;

            if (recordCount > 0) {
                QSqlQuery deleteQuery;
                deleteQuery.prepare("DELETE FROM DataTagging WHERE No = :No AND Phase = 'A'");
                deleteQuery.bindValue(":No", list_deviceID);
                if (deleteQuery.exec()) {
                    qDebug() << "Phase A: Record with No =" << list_deviceID << "deleted successfully.";
                } else {
                    qWarning() << "Phase A: ERROR! Failed to delete the record:" << deleteQuery.lastError().text();
                    emit databaseError();
                }
            } else {
                qDebug() << "Phase A: No record found with No =" << list_deviceID;
            }
            //.db.close();
        }
    } else {
        qDebug() << "Phase A: checkedStates is false. No deletion performed.";
    }

    updateTablePhaseA("updatedataTableA");

}

void Database::deletedDataMySQLPhaseB(QString msg) {
    qDebug() << "deletedDataMySQLPhaseB:" << msg;

    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();

    QString numListStr = command["num_listB"].toString();
    int list_deviceID = numListStr.toInt();
    bool checkedStates = (command["checkedStates"].toString() == "1" || command["checkedStates"].toBool());

    if (checkedStates) {
        if (!db.isOpen() && !db.open()) {
            qWarning() << "Failed to open the database!";
            emit databaseError();
            return;
        }

        QSqlQuery checkQuery;
        checkQuery.prepare("SELECT COUNT(*) FROM DataTagging WHERE No = :No AND Phase = 'B'");
        checkQuery.bindValue(":No", list_deviceID);

        if (checkQuery.exec() && checkQuery.next() && checkQuery.value(0).toInt() > 0) {
            QSqlQuery deleteQuery;
            deleteQuery.prepare("DELETE FROM DataTagging WHERE No = :No AND Phase = 'B'");
            deleteQuery.bindValue(":No", list_deviceID);

            if (deleteQuery.exec()) {
                qDebug() << "Phase B: Record with No" << list_deviceID << "deleted successfully.";
            } else {
                qWarning() << "Phase B: ERROR! Failed to delete the record:" << deleteQuery.lastError().text();
                emit databaseError();
            }
        } else {
            qDebug() << "Phase B: No record found with No =" << list_deviceID;
        }
    } else {
        qDebug() << "Phase B: checkedStates is false. No deletion performed.";
    }
}

void Database::deletedDataMySQLPhaseC(QString msg) {
    qDebug() << "deletedDataMySQLPhaseC:" << msg;

    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();

    QString numListStr = command["num_listC"].toString();
    int list_deviceID = numListStr.toInt();
    bool checkedStates = (command["checkedStates"].toString() == "1" || command["checkedStates"].toBool());

    if (checkedStates) {
        if (!db.isOpen() && !db.open()) {
            qWarning() << "Failed to open the database!";
            emit databaseError();
            return;
        }

        QSqlQuery checkQuery;
        checkQuery.prepare("SELECT COUNT(*) FROM DataTagging WHERE No = :No AND Phase = 'C'");
        checkQuery.bindValue(":No", list_deviceID);

        if (checkQuery.exec() && checkQuery.next() && checkQuery.value(0).toInt() > 0) {
            QSqlQuery deleteQuery;
            deleteQuery.prepare("DELETE FROM DataTagging WHERE No = :No AND Phase = 'C'");
            deleteQuery.bindValue(":No", list_deviceID);

            if (deleteQuery.exec()) {
                qDebug() << "Phase C: Record with No" << list_deviceID << "deleted successfully.";
            } else {
                qWarning() << "Phase C: ERROR! Failed to delete the record:" << deleteQuery.lastError().text();
                emit databaseError();
            }
        } else {
            qDebug() << "Phase C: No record found with No =" << list_deviceID;
        }
    } else {
        qDebug() << "Phase C: checkedStates is false. No deletion performed.";
    }
}

void Database::edittingMysqlA(QString msg) {
    qDebug() << "edittingMysqlA received message:" << msg;

    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();

    QString getCommand = QJsonValue(command["objectName"]).toString();
    if (getCommand.contains("editDataPhaseA")) {
        int IndexNum = command["IndexNum"].toInt();
        QString phase = QJsonValue(command["PHASE"]).toString().trimmed();

        qDebug() << "edittingMysqlA:" << IndexNum << phase;

        if (!db.isOpen() && !db.open()) {
            qDebug() << "Database connection failed:" << db.lastError().text();
            return;
        }

        QString select = "SELECT * FROM DataTagging WHERE No = :IndexNum AND Phase = :phase";
        QSqlQuery query;
        query.prepare(select);
        query.bindValue(":IndexNum", IndexNum);
        query.bindValue(":phase", phase);

        if (!query.exec()) {
            qDebug() << "Query execution failed:" << query.lastError().text();
            //.db.close();
            return;
        }

        while (query.next()) {
            QVariant statusVar = query.value("status");
            QVariant numListVar = query.value("No");
            QVariant tempNoVar = query.value("temp_no");
            QVariant distanceVar = query.value("Distance(Km)");
            QVariant detailVar = query.value("Detail");
            QVariant phaseVar = query.value("Phase");

            bool status = statusVar.toInt() != 0;
            int num_list = numListVar.toInt();
            int temp_no = tempNoVar.toInt();
            double distance = distanceVar.toDouble();
            QString detail = detailVar.toString();
            QString phase = phaseVar.toString();

            qDebug() << "Debug Variables and Types:";
            qDebug() << "status (as bool):" << (status ? "true" : "false") << "type: bool";
            qDebug() << "num_list:" << num_list << "type:" << numListVar.typeName();
            qDebug() << "temp_no:" << temp_no << "type:" << tempNoVar.typeName();
            qDebug() << "Distance:" << distance << "type:" << distanceVar.typeName();
            qDebug() << "Detail:" << detail << "type:" << detailVar.typeName();
            qDebug() << "Phase:" << phase << "type:" << phaseVar.typeName();

            QString newMessage = QString("{\"objectName\":\"updatedataTableA\", "
                                         "\"status\":%1, "
                                         "\"num_list\":%2, "
                                         "\"temp_no\":%3, "
                                         "\"Distance\":%4, "
                                         "\"Detail\":\"%5\", "
                                         "\"Phase\":\"%6\"}")
                                     .arg(status ? "true" : "false")
                                     .arg(num_list)
                                     .arg(temp_no)
                                     .arg(distance)
                                     .arg(detail)
                                     .arg(phase);

            qDebug() << "newMessage:" << newMessage;
        }
        //.db.close();
        qDebug() << "Database connection closed.";
    }
}


void Database::closeMySQL() {
    if (db.isOpen()) {
        qDebug() << "Database is open. Closing all connections...";
        //.db.close();
        qDebug() << "All database connections are closed.";
    } else {
        qDebug() << "Database is already closed. ";
    }
}

void Database::UpdateMarginSettingParameter(QString msg) {
    qDebug() << "Updating MarginSettingParameter with data:" << msg;

    QJsonDocument doc = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject obj = doc.object();
    int margin = obj["marginA"].toInt() ?  obj["marginA"].toInt() : obj["marginB"].toInt() ? obj["marginB"].toInt() : obj["marginC"].toInt();
    double valueVoltage = obj["valueVoltageA"].toDouble() ? obj["valueVoltageA"].toDouble() : obj["valueVoltageB"].toDouble() ?obj["valueVoltageB"].toDouble():obj["valueVoltageC"].toDouble();
    int focusIndex = obj["focusIndex"].toInt();
    QString phase = obj["PHASE"].toString();
    qDebug() << "UPhase update Margin:" << margin << valueVoltage << focusIndex << phase;

    if (!db.open()) {
        qDebug() << "Error: Unable to open database" << db.lastError().text();
        return;
    }
    QSqlQuery query(db);
    QString selectSQL = "SELECT id FROM MarginSettingParameter WHERE PHASE = :phase";
    query.prepare(selectSQL);
    query.bindValue(":phase", phase);

    if (!query.exec()) {
        qDebug() << "Error: Unable to query database" << query.lastError().text();
        //.db.close();
        return;
    }

    if (query.next()) {
        int id = query.value(0).toInt();
        QString updateSQL = R"(
            UPDATE MarginSettingParameter
            SET margin = :margin, valueVoltage = :valueVoltage, focusIndex = :focusIndex
            WHERE id = :id
        )";
        query.prepare(updateSQL);
        query.bindValue(":margin", margin);
        query.bindValue(":valueVoltage", valueVoltage);
        query.bindValue(":focusIndex", focusIndex);
        query.bindValue(":id", id);

        if (!query.exec()) {
            qDebug() << "Error: Unable to update data" << query.lastError().text();
        } else {
            qDebug() << "Updated MarginSettingParameter for PHASE:" << phase;
        }
    } else {

        if (!query.exec()) {
            qDebug() << "Error: Unable to insert data" << query.lastError().text();
        } else {
            qDebug() << "Inserted new MarginSettingParameter for PHASE: " << phase;
        }
    }

    //.db.close();
    updateMargin();
}

void Database::updateMargin() {
    qDebug() << "Fetching margin data from database...";

    if (!db.isOpen()) {
        qDebug() << "Database is not open. Attempting to open...";
        if (!db.open()) {
            qDebug() << "Failed to open database:" << db.lastError().text();
            return;
        }
    }

    QSqlQuery query(db);
    QString queryString = "SELECT margin, valueVoltage, focusIndex, PHASE FROM MarginSettingParameter";

    if (!query.exec(queryString)) {
        qDebug() << "Failed to fetch data from MarginSettingParameter:" << query.lastError().text();
        return;
    }

    while (query.next()) {
        int margin = query.value("margin").toInt();
        double valueVoltage = query.value("valueVoltage").toDouble();
        int focusIndex = query.value("focusIndex").toInt();
        QString phase = query.value("PHASE").toString();

        QString updateMargin = QString(
                                        "{""\"objectName\": \"updateParameterMargin\","
                                        "\"margin\":%1,"
                                        "\"valueVoltage\":%2,"
                                        "\"focusIndex\":%3,"
                                        "\"PHASE\":\"%4\""
                                        "}")
                                        .arg(margin)
                                        .arg(valueVoltage)
                                        .arg(focusIndex)
                                        .arg(phase);

        qDebug() << "Generated JSON for update Margin:" << updateMargin;

        emit sendMarginUpdate(updateMargin);
        if(phase == "A"){
            QString updateMarginA = QString("{"
                                           "\"objectName\":\"marginCountA\","
                                           "\"marginA\":%1,"
                                           "\"valueVoltage\":%2,"
                                           "\"focusIndex\":%3,"
                                           "\"PHASE\":\"%4\""
                                           "}")
                                       .arg(margin)
                                       .arg(valueVoltage)
                                       .arg(focusIndex)
                                       .arg(phase);

            configParemeterMarginA(updateMarginA);
        }
        if(phase == "B"){
            QString updateMarginB = QString("{"
                                           "\"objectName\":\"marginCountB\","
                                           "\"marginB\":%1,"
                                           "\"valueVoltage\":%2,"
                                           "\"focusIndex\":%3,"
                                           "\"PHASE\":\"%4\""
                                           "}")
                                       .arg(margin)
                                       .arg(valueVoltage)
                                       .arg(focusIndex)
                                       .arg(phase);

            configParemeterMarginB(updateMarginB);
        }
        if(phase == "C"){
            QString updateMarginC = QString("{"
                                           "\"objectName\":\"marginCountC\","
                                           "\"marginC\":%1,"
                                           "\"valueVoltage\":%2,"
                                           "\"focusIndex\":%3,"
                                           "\"PHASE\":\"%4\""
                                           "}")
                                       .arg(margin)
                                       .arg(valueVoltage)
                                       .arg(focusIndex)
                                       .arg(phase);

            configParemeterMarginC(updateMarginC);
        }
    }
    //.db.close();
}


void Database::configParemeterMarginA(QString msg) {
    qDebug() << "configParemeterMarginA:" << msg;

    if (!db.isOpen() && !db.open()) {
        qDebug() << "Failed to open the database:" << db.lastError().text();
        return;
    }

    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();
    QString getCommand = command["objectName"].toString();
    int numOfMarginA = command["marginA"].toInt();
    QString phase = command["PHASE"].toString();
    int focusIndex = command.contains("focusIndex") ? command["focusIndex"].toInt() : -1;

    if (phase == "A" && command.contains("marginA") && command.contains("PHASE")) {
        qDebug() << "Updating MarginSettingParameter with marginA: " << numOfMarginA;

        QSqlQuery updateQuery(db);
        updateQuery.prepare("UPDATE MarginSettingParameter SET margin = :numOfMarginA WHERE PHASE = 'A'");
        updateQuery.bindValue(":numOfMarginA", numOfMarginA);

        if (!updateQuery.exec()) {
            qDebug() << "Error: Unable to update MarginSettingParameter" << updateQuery.lastError().text();
            //.db.close();            return;
        }
        qDebug() << "Updated MarginSettingParameter for Phase A.";
    }

    if (phase == "A" && command.contains("focusIndex")) {
        qDebug() << "Updating focusIndex for MarginSettingParameter...";

        QSqlQuery updateFocusQuery(db);
        updateFocusQuery.prepare("UPDATE MarginSettingParameter SET focusIndex = :focusIndex WHERE PHASE = 'A'");
        updateFocusQuery.bindValue(":focusIndex", focusIndex);

        if (!updateFocusQuery.exec()) {
            qDebug() << "Error: Unable to update focusIndex in MarginSettingParameter" << updateFocusQuery.lastError().text();
            //.db.close();
            return;
        }
        qDebug() << "Updated focusIndex for Phase A to:" << focusIndex;
    }

    if (getCommand.contains("marginCountA") && phase == "A") {
        qDebug() << "Fetching MarginA Data: " << numOfMarginA;

        QSqlQuery fetchQuery(db);
        fetchQuery.prepare("SELECT * FROM MarginTable WHERE No <= :numOfMarginA ORDER BY No ASC");
        fetchQuery.bindValue(":numOfMarginA", numOfMarginA);

        if (!fetchQuery.exec()) {
            qDebug() << "Query execution failed:" << fetchQuery.lastError().text();
            //.db.close();
            return;
        }

        while (fetchQuery.next()) {
            int no = fetchQuery.value("No").toInt();
            QString marginNo = fetchQuery.value("Margin(No.)").toString();
            int valueOfMargin = fetchQuery.value("value of margin").toInt();
            QString unit = fetchQuery.value("unit").toString();

            QString singleMarginData = QString("{\"objectName\":\"marginlistCountA\", "
                                               "\"no\":%1, "
                                               "\"marginNo\":\"%2\", "
                                               "\"valueOfMargin\":%3, "
                                               "\"unit\":\"%4\"}")
                                           .arg(no)
                                           .arg(marginNo)
                                           .arg(valueOfMargin)
                                           .arg(unit);


            qDebug() << "Sending single margin data:" << singleMarginData;
            emit listOfMarginA(singleMarginData);
        }
    }

    //.db.close();
    qDebug() << "Database closed successfully.";
}

void Database::configParemeterMarginB(QString msg) {
    qDebug() << "configParemeterMarginB:" << msg;

    if (!db.isOpen() && !db.open()) {
        qDebug() << "Failed to open the database:" << db.lastError().text();
        return;
    }

    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();
    QString getCommand = command["objectName"].toString();
    int numOfMarginB = command["marginB"].toInt();
    QString phase = command["PHASE"].toString();
    int focusIndex = command.contains("focusIndex") ? command["focusIndex"].toInt() : -1;

    if (phase == "B" && command.contains("marginB") && command.contains("PHASE")) {
        qDebug() << "Updating MarginSettingParameter with marginB: " << numOfMarginB;

        QSqlQuery updateQuery(db);
        updateQuery.prepare("UPDATE MarginSettingParameter SET margin = :numOfMarginB WHERE PHASE = 'B'");
        updateQuery.bindValue(":numOfMarginB", numOfMarginB);

        if (!updateQuery.exec()) {
            qDebug() << "Error: Unable to update MarginSettingParameter" << updateQuery.lastError().text();
            //.db.close();            return;
        }
        qDebug() << "Updated MarginSettingParameter for Phase B.";
    }

    if (phase == "B" && command.contains("focusIndex")) {
        qDebug() << "Updating focusIndex for MarginSettingParameter...";

        QSqlQuery updateFocusQuery(db);
        updateFocusQuery.prepare("UPDATE MarginSettingParameter SET focusIndex = :focusIndex WHERE PHASE = 'B'");
        updateFocusQuery.bindValue(":focusIndex", focusIndex);

        if (!updateFocusQuery.exec()) {
            qDebug() << "Error: Unable to update focusIndex in MarginSettingParameter" << updateFocusQuery.lastError().text();
            //.db.close();
            return;
        }
        qDebug() << "Updated focusIndex for Phase B to:" << focusIndex;
    }

    if (getCommand.contains("marginCountB") && phase == "B") {
        qDebug() << "Fetching MarginB Data: " << numOfMarginB;

        QSqlQuery fetchQuery(db);
        fetchQuery.prepare("SELECT * FROM MarginTable WHERE No <= :numOfMarginB ORDER BY No ASC");
        fetchQuery.bindValue(":numOfMarginB", numOfMarginB);

        if (!fetchQuery.exec()) {
            qDebug() << "Query execution failed:" << fetchQuery.lastError().text();
            //.db.close();
            return;
        }

        while (fetchQuery.next()) {
            int no = fetchQuery.value("No").toInt();
            QString marginNo = fetchQuery.value("Margin(No.)").toString();
            int valueOfMargin = fetchQuery.value("value of margin").toInt();
            QString unit = fetchQuery.value("unit").toString();

            QString singleMarginData = QString("{\"objectName\":\"marginlistCountB\", "
                                               "\"no\":%1, "
                                               "\"marginNo\":\"%2\", "
                                               "\"valueOfMargin\":%3, "
                                               "\"unit\":\"%4\"}")
                                           .arg(no)
                                           .arg(marginNo)
                                           .arg(valueOfMargin)
                                           .arg(unit);


            qDebug() << "Sending single margin data:" << singleMarginData;
            emit listOfMarginB(singleMarginData);
        }
    }

    //.db.close();
    qDebug() << "Database closed successfully.";
}

void Database::configParemeterMarginC(QString msg) {
    qDebug() << "configParemeterMarginC:" << msg;

    if (!db.isOpen() && !db.open()) {
        qDebug() << "Failed to open the database:" << db.lastError().text();
        return;
    }

    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();
    QString getCommand = command["objectName"].toString();
    int numOfMarginC = command["marginC"].toInt();
    QString phase = command["PHASE"].toString();
    int focusIndex = command.contains("focusIndex") ? command["focusIndex"].toInt() : -1;

    if (phase == "C" && command.contains("marginC") && command.contains("PHASE")) {
        qDebug() << "Updating MarginSettingParameter with marginC: " << numOfMarginC;

        QSqlQuery updateQuery(db);
        updateQuery.prepare("UPDATE MarginSettingParameter SET margin = :numOfMarginC WHERE PHASE = 'C'");
        updateQuery.bindValue(":numOfMarginC", numOfMarginC);

        if (!updateQuery.exec()) {
            qDebug() << "Error: Unable to update MarginSettingParameter" << updateQuery.lastError().text();
            //.db.close();
            return;
        }
        qDebug() << "Updated MarginSettingParameter for Phase C.";
    }

    if (phase == "B" && command.contains("focusIndex")) {
        qDebug() << "Updating focusIndex for MarginSettingParameter...";

        QSqlQuery updateFocusQuery(db);
        updateFocusQuery.prepare("UPDATE MarginSettingParameter SET focusIndex = :focusIndex WHERE PHASE = 'C'");
        updateFocusQuery.bindValue(":focusIndex", focusIndex);

        if (!updateFocusQuery.exec()) {
            qDebug() << "Error: Unable to update focusIndex in MarginSettingParameter" << updateFocusQuery.lastError().text();
            //.db.close();
            return;
        }
        qDebug() << "Updated focusIndex for Phase C to:" << focusIndex;
    }

    if (getCommand.contains("marginCountC") && phase == "C") {
        qDebug() << "Fetching MarginC Data: " << numOfMarginC;

        QSqlQuery fetchQuery(db);
        fetchQuery.prepare("SELECT * FROM MarginTable WHERE No <= :numOfMarginC ORDER BY No ASC");
        fetchQuery.bindValue(":numOfMarginC", numOfMarginC);

        if (!fetchQuery.exec()) {
            qDebug() << "Query execution failed:" << fetchQuery.lastError().text();
            //.db.close();
            return;
        }

        while (fetchQuery.next()) {
            int no = fetchQuery.value("No").toInt();
            QString marginNo = fetchQuery.value("Margin(No.)").toString();
            int valueOfMargin = fetchQuery.value("value of margin").toInt();
            QString unit = fetchQuery.value("unit").toString();

            QString singleMarginData = QString("{\"objectName\":\"marginlistCountC\", "
                                               "\"no\":%1, "
                                               "\"marginNo\":\"%2\", "
                                               "\"valueOfMargin\":%3, "
                                               "\"unit\":\"%4\"}")
                                           .arg(no)
                                           .arg(marginNo)
                                           .arg(valueOfMargin)
                                           .arg(unit);


            qDebug() << "Sending single margin data:" << singleMarginData;
            emit listOfMarginC(singleMarginData);
        }
    }

    //.db.close();
    qDebug() << "Database closed successfully.";
}
void Database::updataListOfMarginA(QString msg) {
    qDebug() << "updataListOfMarginA:" << msg;

    if (!db.isOpen() && !db.open()) {
        qDebug() << "Database is not open. Attempting to open...";
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject obj = doc.object();

    int marginA = obj.contains("marginA") ? obj["marginA"].toInt() : obj["rangeofmargin"].toInt();
    int valueVoltageA = obj.contains("valueVoltageA") ? obj["valueVoltageA"].toInt() : obj["autoValueVoltage"].toInt();
    int focusIndex = obj.contains("focusIndex") ? obj["focusIndex"].toInt() : -1;

    qDebug() << "Processing MarginA:" << marginA << " ValueVoltageA:" << valueVoltageA
             << " FocusIndex:" << focusIndex;

    if (focusIndex > 0) {
        // ✅ **Update a specific row**
        int targetNo = focusIndex + 1;
        QSqlQuery updateQuery(db);
        updateQuery.prepare("UPDATE MarginTable SET `value of margin` = :valueVoltageA WHERE No = :targetNo");
        updateQuery.bindValue(":valueVoltageA", valueVoltageA);
        updateQuery.bindValue(":targetNo", targetNo);

        if (!updateQuery.exec()) {
            qDebug() << "Error: Unable to update MarginTable at No:" << targetNo << updateQuery.lastError().text();
            //.db.close();
            return;
        }
        qDebug() << "Updated MarginTable at No:" << targetNo << " with ValueVoltageA:" << valueVoltageA;

    } else if (focusIndex == 0) {
        // ✅ **Update only first row (No = 1)**
        QSqlQuery updateFirstQuery(db);
        updateFirstQuery.prepare("UPDATE MarginTable SET `value of margin` = :valueVoltageA WHERE No = 1");
        updateFirstQuery.bindValue(":valueVoltageA", valueVoltageA);

        if (!updateFirstQuery.exec()) {
            qDebug() << "Error: Unable to update MarginTable at No 1" << updateFirstQuery.lastError().text();
            //.db.close();
            return;
        }
        qDebug() << "Updated **only** first row (No = 1) with ValueVoltageA:" << valueVoltageA;

    } else if (focusIndex == -1) {
        // ✅ **Auto Fill All (Update all rows up to marginA)**
        QSqlQuery updateAllQuery(db);
        updateAllQuery.prepare("UPDATE MarginTable SET `value of margin` = :valueVoltageA WHERE No <= :marginA");
        updateAllQuery.bindValue(":valueVoltageA", valueVoltageA);
        updateAllQuery.bindValue(":marginA", marginA);

        if (!updateAllQuery.exec()) {
            qDebug() << "Error: Unable to update all MarginTable rows" << updateAllQuery.lastError().text();
            //.db.close();
            return;
        }
        qDebug() << "Auto-filled first" << marginA << " rows with ValueVoltageA:" << valueVoltageA;
    }

    // ✅ **Retrieve updated rows**
    QSqlQuery selectQuery(db);
    selectQuery.prepare("SELECT No, `Margin(No.)`, `value of margin`, unit FROM MarginTable WHERE No <= :marginA");
    selectQuery.bindValue(":marginA", marginA);

    if (!selectQuery.exec()) {
        qDebug() << "Error: Unable to retrieve MarginTable data" << selectQuery.lastError().text();
        //.db.close();
        return;
    }

    // ✅ **Pack results into JSON**
    QJsonArray marginList;
    while (selectQuery.next()) {
        QJsonObject marginData;
        marginData["No"] = selectQuery.value(0).toInt();
        marginData["MarginName"] = selectQuery.value(1).toString();
        marginData["Value"] = selectQuery.value(2).toInt();
        marginData["Unit"] = selectQuery.value(3).toString();
        marginList.append(marginData);
    }

    QJsonObject output;
    output["objectName"] = "MarginTableUpdated";
    output["Margins"] = marginList;

    QJsonDocument jsonDoc(output);
    QString jsonData = jsonDoc.toJson(QJsonDocument::Compact);

    qDebug() << "Formatted JSON sendUpdatedMarginList:" << jsonData;
//    emit sendUpdatedMarginList(jsonData);

    // ✅ Close the database
    //.db.close();
    qDebug() << "Database closed successfully.";
}


void Database::updataListOfMarginB(QString msg) {
    qDebug() << "updataListOfMarginB:" << msg;

    if (!db.isOpen() && !db.open()) {
        qDebug() << "Database is not open. Attempting to open...";
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject obj = doc.object();

    int marginB = obj.contains("marginB") ? obj["marginB"].toInt() : obj["rangeofmargin"].toInt();
    int valueVoltageB = obj.contains("valueVoltageB") ? obj["valueVoltageB"].toInt() : obj["autoValueVoltage"].toInt();
    int focusIndex = obj.contains("focusIndex") ? obj["focusIndex"].toInt() : -1;

    qDebug() << "Processing marginB:" << marginB << " ValueVoltageA:" << valueVoltageB
             << " FocusIndex:" << focusIndex;

    if (focusIndex > 0) {
        // ✅ **Update a specific row**
        int targetNo = focusIndex + 1;
        QSqlQuery updateQuery(db);
        updateQuery.prepare("UPDATE MarginTableB SET `value of margin` = :valueVoltageB WHERE No = :targetNo");
        updateQuery.bindValue(":valueVoltageB", valueVoltageB);
        updateQuery.bindValue(":targetNo", targetNo);

        if (!updateQuery.exec()) {
            qDebug() << "Error: Unable to update MarginTableB at No:" << targetNo << updateQuery.lastError().text();
            //.db.close();
            return;
        }
        qDebug() << "Updated MarginTable at No:" << targetNo << " with ValueVoltageA:" << valueVoltageB;

    } else if (focusIndex == 0) {
        // ✅ **Update only first row (No = 1)**
        QSqlQuery updateFirstQuery(db);
        updateFirstQuery.prepare("UPDATE MarginTableB SET `value of margin` = :valueVoltageB WHERE No = 1");
        updateFirstQuery.bindValue(":valueVoltageB", valueVoltageB);

        if (!updateFirstQuery.exec()) {
            qDebug() << "Error: Unable to update MarginTableB at No 1" << updateFirstQuery.lastError().text();
            //.db.close();
            return;
        }
        qDebug() << "Updated **only** first row (No = 1) with valueVoltageB:" << valueVoltageB;

    } else if (focusIndex == -1) {
        // ✅ **Auto Fill All (Update all rows up to marginA)**
        QSqlQuery updateAllQuery(db);
        updateAllQuery.prepare("UPDATE MarginTableB SET `value of margin` = :valueVoltageB WHERE No <= :marginB");
        updateAllQuery.bindValue(":valueVoltageB", valueVoltageB);
        updateAllQuery.bindValue(":marginB", marginB);

        if (!updateAllQuery.exec()) {
            qDebug() << "Error: Unable to update all MarginTableB rows" << updateAllQuery.lastError().text();
            //.db.close();
            return;
        }
        qDebug() << "Auto-filled first" << marginB << " rows with valueVoltageB:" << valueVoltageB;
    }

    // ✅ **Retrieve updated rows**
    QSqlQuery selectQuery(db);
    selectQuery.prepare("SELECT No, `Margin(No.)`, `value of margin`, unit FROM MarginTableB WHERE No <= :marginB");
    selectQuery.bindValue(":marginB", marginB);

    if (!selectQuery.exec()) {
        qDebug() << "Error: Unable to retrieve MarginTableB data" << selectQuery.lastError().text();
        //.db.close();
        return;
    }

    QJsonArray marginList;
    while (selectQuery.next()) {
        QJsonObject marginData;
        marginData["No"] = selectQuery.value(0).toInt();
        marginData["MarginName"] = selectQuery.value(1).toString();
        marginData["Value"] = selectQuery.value(2).toInt();
        marginData["Unit"] = selectQuery.value(3).toString();
        marginList.append(marginData);
    }

    QJsonObject output;
    output["objectName"] = "MarginTableUpdated";
    output["Margins"] = marginList;

    QJsonDocument jsonDoc(output);
    QString jsonData = jsonDoc.toJson(QJsonDocument::Compact);

    qDebug() << "Formatted JSON sendUpdatedMarginList:" << jsonData;
//    emit sendUpdatedMarginList(jsonData);

    // ✅ Close the database
    //.db.close();
    qDebug() << "Database closed successfully.";
}

void Database::updataListOfMarginC(QString msg) {
    qDebug() << "updataListOfMarginC:" << msg;

    if (!db.isOpen() && !db.open()) {
        qDebug() << "Database is not open. Attempting to open...";
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject obj = doc.object();

    int marginC = obj.contains("marginC") ? obj["marginC"].toInt() : obj["rangeofmargin"].toInt();
    int valueVoltageC = obj.contains("valueVoltageC") ? obj["valueVoltageC"].toInt() : obj["autoValueVoltage"].toInt();
    int focusIndex = obj.contains("focusIndex") ? obj["focusIndex"].toInt() : -1;

    qDebug() << "Processing marginC:" << marginC << " valueVoltageC:" << valueVoltageC
             << " FocusIndex:" << focusIndex;

    if (focusIndex > 0) {
        // ✅ **Update a specific row**
        int targetNo = focusIndex + 1;
        QSqlQuery updateQuery(db);
        updateQuery.prepare("UPDATE MarginTableC SET `value of margin` = :valueVoltageC WHERE No = :targetNo");
        updateQuery.bindValue(":valueVoltageC", valueVoltageC);
        updateQuery.bindValue(":targetNo", targetNo);

        if (!updateQuery.exec()) {
            qDebug() << "Error: Unable to update MarginTableB at No:" << targetNo << updateQuery.lastError().text();
            //.db.close();
            return;
        }
        qDebug() << "Updated MarginTable at No:" << targetNo << " with ValueVoltageA:" << valueVoltageC;

    } else if (focusIndex == 0) {
        // ✅ **Update only first row (No = 1)**
        QSqlQuery updateFirstQuery(db);
        updateFirstQuery.prepare("UPDATE MarginTableC SET `value of margin` = :valueVoltageC WHERE No = 1");
        updateFirstQuery.bindValue(":valueVoltageC", valueVoltageC);

        if (!updateFirstQuery.exec()) {
            qDebug() << "Error: Unable to update MarginTableC at No 1" << updateFirstQuery.lastError().text();
            //.db.close();
            return;
        }
        qDebug() << "Updated **only** first row (No = 1) with valueVoltageC:" << valueVoltageC;

    } else if (focusIndex == -1) {
        QSqlQuery updateAllQuery(db);
        updateAllQuery.prepare("UPDATE MarginTableC SET `value of margin` = :valueVoltageC WHERE No <= :marginC");
        updateAllQuery.bindValue(":valueVoltageC", valueVoltageC);
        updateAllQuery.bindValue(":marginC", marginC);

        if (!updateAllQuery.exec()) {
            qDebug() << "Error: Unable to update all MarginTableC rows" << updateAllQuery.lastError().text();
            //.db.close();
            return;
        }
        qDebug() << "Auto-filled first" << marginC << " rows with valueVoltageC:" << valueVoltageC;
    }

    QSqlQuery selectQuery(db);
    selectQuery.prepare("SELECT No, `Margin(No.)`, `value of margin`, unit FROM MarginTableC WHERE No <= :marginC");
    selectQuery.bindValue(":marginC", marginC);

    if (!selectQuery.exec()) {
        qDebug() << "Error: Unable to retrieve MarginTableC data" << selectQuery.lastError().text();
        //.db.close();
        return;
    }

    QJsonArray marginList;
    while (selectQuery.next()) {
        QJsonObject marginData;
        marginData["No"] = selectQuery.value(0).toInt();
        marginData["MarginName"] = selectQuery.value(1).toString();
        marginData["Value"] = selectQuery.value(2).toInt();
        marginData["Unit"] = selectQuery.value(3).toString();
        marginList.append(marginData);
    }

    QJsonObject output;
    output["objectName"] = "MarginTableUpdated";
    output["Margins"] = marginList;

    QJsonDocument jsonDoc(output);
    QString jsonData = jsonDoc.toJson(QJsonDocument::Compact);

    qDebug() << "Formatted JSON sendUpdatedMarginList:" << jsonData;
//    emit sendUpdatedMarginList(jsonData);

    // ✅ Close the database
    //.db.close();
    qDebug() << "Database closed successfully.";
}

void Database::configParemeterThreshold(QString msg) {
    qDebug() << "configParameterThreshold:" << msg;

    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();
    QString Phase = QJsonValue(command["Phase"]).toString();

    if (!db.isOpen() && !db.open()) {
        qDebug() << "Failed to open the database:" << db.lastError().text();
        return;
    }

    QSqlQuery query;

    QStringList phases = {"A", "B", "C"};
    for (const QString &phase : phases) {
        QString thresholdKey = "thresholdInit" + phase;
        if (!command.contains(thresholdKey)) {
            qDebug() << "No threshold data for phase:" << phase << ", skipping...";
            continue;
        }

        double paraOfThreshold = command[thresholdKey].toDouble();
        qDebug() << "Processing phase:" << phase << "with threshold:" << paraOfThreshold;

        query.prepare("SELECT COUNT(*) FROM ParamThreshold WHERE Phase = :Phase");
        query.bindValue(":Phase", phase);

        if (!query.exec()) {
            qDebug() << "Failed to check existing data for phase" << phase << ":" << query.lastError().text();
            continue;
        }

        query.next();
        int count = query.value(0).toInt();

        if (count > 0) {
            query.prepare("UPDATE ParamThreshold SET ThresholdValue = :ThresholdValue WHERE Phase = :Phase");
            query.bindValue(":ThresholdValue", paraOfThreshold);
            query.bindValue(":Phase", phase);

            if (!query.exec()) {
                qDebug() << "Failed to update data for phase" << phase << ":" << query.lastError().text();
            } else {
                qDebug() << "Data updated successfully for phase:" << phase;
            }
        } else {
            qDebug() << "No existing data for phase:" << phase << ". Update skipped.";
        }
    }

    closeMySQL();
    getThreshold();

}

void Database::getThreshold() {
    qDebug() << "getThreshold!";

    if (!db.isOpen()) {
        qDebug() << "Database is not open, opening now...";
        if (!db.open()) {
            qDebug() << "Failed to open the database:" << db.lastError().text();
            return;
        }
    }

    QSqlQuery checkTableQuery(db);
    QString checkTableSQL = QString(
        "SELECT COUNT(*) FROM information_schema.tables "
        "WHERE table_schema = '%1' AND table_name = 'ParamThreshold'")
        .arg(db.databaseName());

    if (!checkTableQuery.exec(checkTableSQL)) {
        qDebug() << "Failed to check if table exists:" << checkTableQuery.lastError().text();
        return;
    }

    if (checkTableQuery.next() && checkTableQuery.value(0).toInt() > 0) {
        qDebug() << "Table `ParamThreshold` exists. Fetching data...";

        QSqlQuery query(db);
        if (!query.exec("SELECT Phase, ThresholdValue FROM ParamThreshold WHERE Phase IN ('A', 'B', 'C')")) {
            qDebug() << "Query execution failed:" << query.lastError().text();
            return;
        }

        double thresholdA = 0.0, thresholdB = 0.0, thresholdC = 0.0;

        while (query.next()) {
            QString phase = query.value("Phase").toString();
            double thresholdValue = query.value("ThresholdValue").toDouble();

            if (phase == "A") {
                thresholdA = thresholdValue;
            } else if (phase == "B") {
                thresholdB = thresholdValue;
            } else if (phase == "C") {
                thresholdC = thresholdValue;
            }
        }

        QString getThresholds = QString(
            "{\"objectName\":\"getThreshold\", "
            "\"thresholdInitA\":%1, "
            "\"thresholdInitB\":%2, "
            "\"thresholdInitC\":%3}")
            .arg(thresholdA)
            .arg(thresholdB)
            .arg(thresholdC);

        qDebug() << "updateThreshold:" << getThresholds;
        updateThresholdA(getThresholds);
    } else {
        qDebug() << "Table `ParamThreshold` does not exist.";
    }

    closeMySQL();
}

void Database::updateSettingInfo(QString msg) {
    qDebug() << "updateSettingInfo:" << msg;
    static int receivedVoltage = 0;
    static QString receivedSubstation = "";
    static QString receivedDirection = "";
    static int receivedLineNo = 0;

    static bool hasVoltage = false;
    static bool hasSubstation = false;
    static bool hasDirection = false;
    static bool hasLineNo = false;

    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    if (d.isNull() || !d.isObject()) {
        qDebug() << "Invalid JSON format!";
        return;
    }

    QJsonObject command = d.object();

    if (command.contains("Voltage")) {
        receivedVoltage = command["Voltage"].toInt();
        hasVoltage = true;
        qDebug() << "Received Voltage:" << receivedVoltage;
    }

    if (command.contains("Substation")) {
        receivedSubstation = command["Substation"].toString();
        hasSubstation = true;
        qDebug() << "Received Substation:" << receivedSubstation;
    }

    if (command.contains("Direction")) {
        receivedDirection = command["Direction"].toString();
        hasDirection = true;
        qDebug() << "Received Direction:" << receivedDirection;
    }

    if (command.contains("LineNo")) {
        receivedLineNo = command["LineNo"].toInt();
        hasLineNo = true;
        qDebug() << "Received LineNo:" << receivedLineNo;
    }

    if (hasVoltage && hasSubstation && hasDirection && hasLineNo) {
        qDebug() << "All values received, updating database...";

        if (!db.isOpen()) {
            qDebug() << "Database is not open, attempting to open...";
            if (!db.open()) {
                qDebug() << "Failed to open the database:" << db.lastError().text();
                return;
            }
        }

        QSqlQuery query(db);
        query.prepare("UPDATE SettingGaneral SET voltage = :voltage, substation = :substation, direction = :direction, line_no = :line_no WHERE id = 1");
        query.bindValue(":voltage", receivedVoltage);
        query.bindValue(":substation", receivedSubstation);
        query.bindValue(":direction", receivedDirection);
        query.bindValue(":line_no", receivedLineNo);

        if (query.exec()) {
            qDebug() << "Database updated successfully.";
        } else {
            qDebug() << "Failed to update database:" << query.lastError().text();
        }

        QString getSettingInfo = QString(
            "{\"objectName\":\"getSettingInfo\", "
            "\"voltage\":%1, "
            "\"substation\":\"%2\", "
            "\"direction\":\"%3\", "
            "\"line_no\":%4}")
            .arg(receivedVoltage)
            .arg(receivedSubstation)
            .arg(receivedDirection)
            .arg(receivedLineNo);

        qDebug() << "Setting Info JSON:" << getSettingInfo;
        emit UpdateSettingInfo(getSettingInfo);
        ToShowSettingInfo(getSettingInfo);
        //.db.close();
        qDebug() << "Database closed successfully.";

        hasVoltage = hasSubstation = hasDirection = hasLineNo = false;
    } else {
        qDebug() << "Waiting for all values before updating...";
    }
}


void Database::ToShowSettingInfo(QString msg) {
    qDebug() << "ToShowSettingInfo Received:" << msg;

    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();
    QString getCommand =  QJsonValue(command["objectName"]).toString();
    double actualVoltage = QJsonValue(command["voltage"]).toDouble();
    QString actualSubstation = QJsonValue(command["substation"]).toString();
    QString actualDirection = QJsonValue(command["direction"]).toString();
    int actualLineNo = QJsonValue(command["line_no"]).toInt();
    QString formattedString = QString("%1 kV %2 - %3 #%4")
                                    .arg(actualVoltage)
                                    .arg(actualSubstation)
                                    .arg(actualDirection)
                                    .arg(actualLineNo);

    QJsonObject jsonOutput;
    jsonOutput["objectName"] = "detailInfoSetting";
    jsonOutput["data"] = formattedString;

    QJsonDocument doc(jsonOutput);
    QString combinedData = doc.toJson(QJsonDocument::Compact);

    qDebug() << "Final JSON Output:" << combinedData;
    emit showUpdateInfoSetting(combinedData);
}


void Database::getSettingInfo() {
    qDebug() << "getSettingInfo!";

    if (!db.isOpen()) {
        qDebug() << "Database is not open, opening now...";
        if (!db.open()) {
            qDebug() << "Failed to open the database:" << db.lastError().text();
            return;
        }
    }

    QSqlQuery checkTableQuery(db);
    QString checkTableSQL = QString(
        "SELECT COUNT(*) FROM information_schema.tables "
        "WHERE table_schema = '%1' AND table_name = 'SettingGaneral'")
        .arg(db.databaseName());

    if (!checkTableQuery.exec(checkTableSQL)) {
        qDebug() << "Failed to check if table exists:" << checkTableQuery.lastError().text();
        return;
    }

    if (checkTableQuery.next() && checkTableQuery.value(0).toInt() > 0) {
        qDebug() << "Table `SettingGaneral` exists. Fetching data...";

        QSqlQuery query(db);
        if (!query.exec("SELECT voltage, substation, direction, line_no FROM SettingGaneral")) {
            qDebug() << "Query execution failed:" << query.lastError().text();
            return;
        }

        double voltage = 0.0;
        QString substation;
        QString direction;
        int lineNo = 0;

        while (query.next()) {
            voltage = query.value("voltage").toDouble();
            substation = query.value("substation").toString();
            direction = query.value("direction").toString();
            lineNo = query.value("line_no").toInt();
        }

        // ✅ ข้อมูล JSON แบบดั้งเดิม (ส่งไปที่ UpdateSettingInfo)
        QString getSettingInfo = QString(
            "{\"objectName\":\"getSettingInfo\", "
            "\"voltage\":%1, "
            "\"substation\":\"%2\", "
            "\"direction\":\"%3\", "
            "\"line_no\":%4}")
            .arg(voltage)
            .arg(substation)
            .arg(direction)
            .arg(lineNo);

        qDebug() << "Setting Info JSON:" << getSettingInfo;
        emit UpdateSettingInfo(getSettingInfo);

        // ✅ ฟอร์แมตข้อมูลเป็น "230 kV CR - PY #1"
        QString formattedString = QString("%1 kV %2 - %3 #%4")
                                      .arg(voltage)
                                      .arg(substation)
                                      .arg(direction)
                                      .arg(lineNo);

        // ✅ ห่อข้อมูลใน JSON ใหม่ (objectName: "getSettingInfo")
        QJsonObject jsonOutput;
        jsonOutput["objectName"] = "detailInfoSetting";
        jsonOutput["data"] = formattedString;  // ✅ ใส่ string ใน key "data"

        // ✅ แปลง JSON เป็น QString
        QJsonDocument doc(jsonOutput);
        QString combinedData = doc.toJson(QJsonDocument::Compact);

        qDebug() << "Formatted JSON Output:" << combinedData;
        emit showUpdateInfoSetting(combinedData);  // ✅ ส่งข้อมูลอีกรูปแบบ
    } else {
        qDebug() << "Table `SettingGaneral` does not exist.";
    }

    closeMySQL();
}

void Database::getpreiodicInfo() {
    qDebug() << "getPeriodicInfo!";

    if (!db.isOpen()) {
        qDebug() << "Database is not open, opening now...";
        if (!db.open()) {
            qDebug() << "Failed to open the database:" << db.lastError().text();
            return;
        }
    }

    QSqlQuery checkTableQuery(db);
    QString checkTableSQL = QString(
        "SELECT COUNT(*) FROM information_schema.tables "
        "WHERE table_schema = '%1' AND table_name = 'PeriodicInfo'")
        .arg(db.databaseName());

    if (!checkTableQuery.exec(checkTableSQL)) {
        qDebug() << "Failed to check if table exists:" << checkTableQuery.lastError().text();
        return;
    }

    if (checkTableQuery.next() && checkTableQuery.value(0).toInt() > 0) {
        qDebug() << "Table `PeriodicInfo` exists. Fetching data...";

        QSqlQuery query(db);
        if (!query.exec("SELECT Time, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday FROM PeriodicInfo")) {
            qDebug() << "Query execution failed:" << query.lastError().text();
            return;
        }

        double time = 0.0;
        bool Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday;

        while (query.next()) {
            time = query.value("Time").toDouble();
            Monday = query.value("Monday").toBool();
            Tuesday = query.value("Tuesday").toBool();
            Wednesday = query.value("Wednesday").toBool();
            Thursday = query.value("Thursday").toBool();
            Friday = query.value("Friday").toBool();
            Saturday = query.value("Saturday").toBool();
            Sunday = query.value("Sunday").toBool();

            QString getPeriodicInfo = QString(
                "{\"objectName\":\"getPeriodicInfo\", "
                "\"Time\":%1, "
                "\"Monday\":%2, "
                "\"Tuesday\":%3, "
                "\"Wednesday\":%4, "
                "\"Thursday\":%5, "
                "\"Friday\":%6, "
                "\"Saturday\":%7, "
                "\"Sunday\":%8}")
                .arg(time)
                .arg(Monday ? "true" : "false")
                .arg(Tuesday ? "true" : "false")
                .arg(Wednesday ? "true" : "false")
                .arg(Thursday ? "true" : "false")
                .arg(Friday ? "true" : "false")
                .arg(Saturday ? "true" : "false")
                .arg(Sunday ? "true" : "false");

            qDebug() << "Periodic Info: " << getPeriodicInfo;

             emit UpdatepreiodicInfo(getPeriodicInfo);
        }
    } else {
        qDebug() << "Table `PeriodicInfo` does not exist.";
    }

     //.db.close();
}



void Database::getUpdatePeriodic(QString msg) {
    qDebug() << "getUpdatePreiodic" << msg;

    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();

    double timer = command["Time"].toDouble();
    qDebug() << "getUpdatePreiodic - Extracted Time:" << timer;

    if (!db.isOpen()) {
        qDebug() << "Database is not open, opening now...";
        if (!db.open()) {
            qDebug() << "Failed to open the database:" << db.lastError().text();
            return;
        }
    }

    QSqlQuery query(db);
    query.prepare("UPDATE PeriodicInfo SET Time = :newTime");
    query.bindValue(":newTime", timer);

    if (!query.exec()) {
        qDebug() << "Failed to update Time in PeriodicInfo table:" << query.lastError().text();
    } else {
        qDebug() << "Time updated successfully in PeriodicInfo table to" << timer;
    }
    closeMySQL();

}


void Database::getUpdateWeekly(QString msg) {
    qDebug() << "getUpdateWeekly:" << msg;

    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();

    // Extracting the values as strings
    QString mondayStr   = command["Monday"].toString();
    QString tuesdayStr  = command["Tuesday"].toString();
    QString wednesdayStr= command["Wednesday"].toString();
    QString thursdayStr = command["Thursday"].toString();
    QString fridayStr   = command["Friday"].toString();
    QString saturdayStr = command["Saturday"].toString();
    QString sundayStr   = command["Sunday"].toString();

    // Converting strings to bool (1 -> true, else false)
    bool monday     = (mondayStr == "1");
    bool tuesday    = (tuesdayStr == "1");
    bool wednesday  = (wednesdayStr == "1");
    bool thursday   = (thursdayStr == "1");
    bool friday     = (fridayStr == "1");
    bool saturday   = (saturdayStr == "1");
    bool sunday     = (sundayStr == "1");

    // Open the database if it's not already open
    if (!db.isOpen()) {
        qDebug() << "Database is not open, opening now...";
        if (!db.open()) {
            qDebug() << "Failed to open the database:" << db.lastError().text();
            return;
        }
    }

    // Checking each day individually and updating only the days that changed
    if (mondayStr != "") {
        QSqlQuery query(db);
        query.prepare("SELECT Monday FROM PeriodicInfo LIMIT 1");
        if (!query.exec() || !query.next()) {
            qDebug() << "Failed to fetch current value for Monday:" << query.lastError().text();
            closeMySQL();
            return;
        }
        bool currentMonday = query.value("Monday").toBool();
        qDebug() << "Current Monday value in database:" << currentMonday << monday;

        if (currentMonday != monday) {
            qDebug() << "Monday value changed. Updating database...";
            query.prepare("UPDATE PeriodicInfo SET Monday = :newMonday");
            query.bindValue(":newMonday", monday);

            if (!query.exec()) {
                qDebug() << "Failed to update Monday in PeriodicInfo table:" << query.lastError().text();
            } else {
                qDebug() << "Monday updated successfully in PeriodicInfo table to" << monday;
            }
        }
    }

    if (tuesdayStr != "") {
        QSqlQuery query(db);
        query.prepare("SELECT Tuesday FROM PeriodicInfo LIMIT 1");
        if (!query.exec() || !query.next()) {
            qDebug() << "Failed to fetch current value for Tuesday:" << query.lastError().text();
            closeMySQL();
            return;
        }

        bool currentTuesday = query.value("Tuesday").toBool();
        qDebug() << "Current Tuesday value in database:" << currentTuesday << tuesday;

        if (currentTuesday != tuesday) {
            qDebug() << "Tuesday value changed. Updating database...";
            query.prepare("UPDATE PeriodicInfo SET Tuesday = :newTuesday");
            query.bindValue(":newTuesday", tuesday);

            if (!query.exec()) {
                qDebug() << "Failed to update Tuesday in PeriodicInfo table:" << query.lastError().text();
            } else {
                qDebug() << "Tuesday updated successfully in PeriodicInfo table to" << tuesday;
            }
        }
    }

    if (wednesdayStr != "") {
        QSqlQuery query(db);
        query.prepare("SELECT Wednesday FROM PeriodicInfo LIMIT 1");
        if (!query.exec() || !query.next()) {
            qDebug() << "Failed to fetch current value for Wednesday:" << query.lastError().text();
            closeMySQL();
            return;
        }

        bool currentWednesday = query.value("Wednesday").toBool();
        qDebug() << "Current Wednesday value in database:" << currentWednesday << wednesday;

        if (currentWednesday != wednesday) {
            qDebug() << "Wednesday value changed. Updating database...";
            query.prepare("UPDATE PeriodicInfo SET Wednesday = :newWednesday");
            query.bindValue(":newWednesday", wednesday);

            if (!query.exec()) {
                qDebug() << "Failed to update Wednesday in PeriodicInfo table:" << query.lastError().text();
            } else {
                qDebug() << "Wednesday updated successfully in PeriodicInfo table to" << wednesday;
            }
        }
    }

    if (thursdayStr != "") {
        QSqlQuery query(db);
        query.prepare("SELECT Thursday FROM PeriodicInfo LIMIT 1");
        if (!query.exec() || !query.next()) {
            qDebug() << "Failed to fetch current value for Thursday:" << query.lastError().text();
            closeMySQL();
            return;
        }

        bool currentThursday = query.value("Thursday").toBool();
        qDebug() << "Current Thursday value in database:" << currentThursday << thursday;

        if (currentThursday != thursday) {
            qDebug() << "Thursday value changed. Updating database...";
            query.prepare("UPDATE PeriodicInfo SET Thursday = :newThursday");
            query.bindValue(":newThursday", thursday);

            if (!query.exec()) {
                qDebug() << "Failed to update Thursday in PeriodicInfo table:" << query.lastError().text();
            } else {
                qDebug() << "Thursday updated successfully in PeriodicInfo table to" << thursday;
            }
        }
    }

    if (fridayStr != "") {
        QSqlQuery query(db);
        query.prepare("SELECT Friday FROM PeriodicInfo LIMIT 1");
        if (!query.exec() || !query.next()) {
            qDebug() << "Failed to fetch current value for Friday:" << query.lastError().text();
            closeMySQL();
            return;
        }

        bool currentFriday = query.value("Friday").toBool();
        qDebug() << "Current Friday value in database:" << currentFriday << friday;

        if (currentFriday != friday) {
            qDebug() << "Friday value changed. Updating database...";
            query.prepare("UPDATE PeriodicInfo SET Friday = :newFriday");
            query.bindValue(":newFriday", friday);

            if (!query.exec()) {
                qDebug() << "Failed to update Friday in PeriodicInfo table:" << query.lastError().text();
            } else {
                qDebug() << "Friday updated successfully in PeriodicInfo table to" << friday;
            }
        }
    }

    if (saturdayStr != "") {
        QSqlQuery query(db);
        query.prepare("SELECT Saturday FROM PeriodicInfo LIMIT 1");
        if (!query.exec() || !query.next()) {
            qDebug() << "Failed to fetch current value for Saturday:" << query.lastError().text();
            closeMySQL();
            return;
        }

        bool currentSaturday = query.value("Saturday").toBool();
        qDebug() << "Current Saturday value in database:" << currentSaturday << saturday;

        if (currentSaturday != saturday) {
            qDebug() << "Saturday value changed. Updating database...";
            query.prepare("UPDATE PeriodicInfo SET Saturday = :newSaturday");
            query.bindValue(":newSaturday", saturday);

            if (!query.exec()) {
                qDebug() << "Failed to update Saturday in PeriodicInfo table:" << query.lastError().text();
            } else {
                qDebug() << "Saturday updated successfully in PeriodicInfo table to" << saturday;
            }
        }
    }

    if (sundayStr != "") {
        QSqlQuery query(db);
        query.prepare("SELECT Sunday FROM PeriodicInfo LIMIT 1");
        if (!query.exec() || !query.next()) {
            qDebug() << "Failed to fetch current value for Sunday:" << query.lastError().text();
            closeMySQL();
            return;
        }

        bool currentSunday = query.value("Sunday").toBool();
        qDebug() << "Current Sunday value in database:" << currentSunday << sunday;

        if (currentSunday != sunday) {
            qDebug() << "Sunday value changed. Updating database...";
            query.prepare("UPDATE PeriodicInfo SET Sunday = :newSunday");
            query.bindValue(":newSunday", sunday);

            if (!query.exec()) {
                qDebug() << "Failed to update Sunday in PeriodicInfo table:" << query.lastError().text();
            } else {
                qDebug() << "Sunday updated successfully in PeriodicInfo table to" << sunday;
            }
        }
    }

    closeMySQL();
}


void Database::storeStatusAux(QString msg) {
    qDebug() << "storeStatusAux:" << msg;

    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();
    QString getCommand = QJsonValue(command["objectName"]).toString();

    if (getCommand == "statusOperate") {
        QString statusOperate = command["LFLOPERATE"].toString();
        int LFLStatus = statusOperate.toInt(); // แปลงค่าจาก QString เป็น int
        qDebug() << "statusOperate:" << statusOperate << ", LFLStatus:" << LFLStatus;

        if (statusOperate == "1") {
            if (!db.isOpen()) {
                qDebug() << "Database is not open. Attempting to open...";
                if (!db.open()) {
                    qDebug() << "Failed to open database:" << db.lastError().text();
                    return;
                }
            }

            QSqlQuery query(db);
            query.prepare("UPDATE OperateTable SET activated = :activated, status = :LFLStatus WHERE Num = 1");
            query.bindValue(":activated", "LFLOPERATE"); // เปลี่ยน activated เป็น "LFLOPERATE"
            query.bindValue(":LFLStatus", LFLStatus);

            if (!query.exec()) {
                qDebug() << "Failed to update OperateTable for statusOperate:" << query.lastError().text();
            } else {
                qDebug() << "OperateTable updated successfully. statusOperate:" << statusOperate;
            }

            closeMySQL();
        }
    } else if (getCommand == "statusFail") {
        QString statusFail = command["LFLFAIL"].toString();
        int failStatus = statusFail.toInt(); // แปลงค่าจาก QString เป็น int
        qDebug() << "statusFail:" << statusFail << ", failStatus:" << failStatus;

        if (statusFail == "1") {
            if (!db.isOpen()) {
                qDebug() << "Database is not open. Attempting to open...";
                if (!db.open()) {
                    qDebug() << "Failed to open database:" << db.lastError().text();
                    return;
                }
            }

            QSqlQuery query(db);
            query.prepare("UPDATE OperateTable SET activated = :activated, status = :failStatus WHERE Num = 1");
            query.bindValue(":activated", "LFLFAIL"); // เปลี่ยน activated เป็น "LFLFAIL"
            query.bindValue(":failStatus", failStatus);

            if (!query.exec()) {
                qDebug() << "Failed to update OperateTable for statusFail:" << query.lastError().text();
            } else {
                qDebug() << "OperateTable updated successfully. statusFail:" << statusFail;
            }

            closeMySQL();
        }
    } else {
        qDebug() << "Invalid message format: Unknown 'objectName'.";
    }
}

void Database::SettingNetworkSNMP(QString msg) {
     qDebug() << "SettingNetworkSNMP:" << msg;
     QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
     QJsonObject command = d.object();
     QString getCommand = QJsonValue(command["objectName"]).toString();
     QJsonDocument jsonDoc;
     QJsonObject Param;
     QString raw_data;
     if(getCommand.contains("updateSettingNetwork")){

        if(command.value("ipaddress").toString() != ""){
            IPaddress      = command.value("ipaddress").toString();
        }
        if(command.value("gateway").toString() != ""){
            GateWsys       = command.value("gateway").toString();
        }
        if(command.value("ip_snmp").toString() != ""){
            snmpIP         = command.value("ip_snmp").toString();
        }
        if(command.value("ntpServer").toString() != ""){
            timeServer     = command.value("ntpServer").toString();
        }
        if(command.value("PLC_DO_ERROR").toString() != ""){
            plcDoError        = command.value("PLC_DO_ERROR").toString();
        }
        if(command.value("PLC_DI_ERROR").toString() != ""){
            plcDiError        =  command.value("PLC_DI_ERROR").toString();
        }
        if(command.value("MODULE_HI_SPEED_PHASE_A_ERROR").toString() != ""){
            hispeedPhaseA     = command.value("MODULE_HI_SPEED_PHASE_A_ERROR").toString();
        }
        if(command.value("MODULE_HI_SPEED_PHASE_B_ERROR").toString() != ""){
            hispeedPhaseB     = command.value("MODULE_HI_SPEED_PHASE_B_ERROR").toString();
            qDebug() << "hispeedPhaseB:" << hispeedPhaseB;
        }
        if(command.value("MODULE_HI_SPEED_PHASE_C_ERROR").toString() != ""){
            hispeedPhaseC     = command.value("MODULE_HI_SPEED_PHASE_C_ERROR").toString();
        }
        if(command.value("INTERNAL_PHASE_A_ERROR").toString() != ""){
            commuPhaseA       =   command.value("INTERNAL_PHASE_A_ERROR").toString();
        }
        if(command.value("INTERNAL_PHASE_B_ERROR").toString() != ""){
            commuPhaseB       =  command.value("INTERNAL_PHASE_B_ERROR").toString();
        }
        if(command.value("INTERNAL_PHASE_C_ERROR").toString() != ""){
            commuPhaseC       =  command.value("INTERNAL_PHASE_C_ERROR").toString();
        }
        if(command.value("GPS_MODULE_FAIL").toString() != ""){
            gpsModule         =  command.value("GPS_MODULE_FAIL").toString();
        }
        if(command.value("SYSTEM_INITIAL").toString() != ""){
            systemInti        =  command.value("SYSTEM_INITIAL").toString();
        }
        if(command.value("COMMUNICATION_ERROR").toString() != ""){
            commuError        =  command.value("COMMUNICATION_ERROR").toString();
        }
        if(command.value("RELAY_START_EVENT").toString() != ""){
            relayStart        = command.value("RELAY_START_EVENT").toString();
        }
        if(command.value("SURGE_START_EVENT").toString() != ""){
            surageStart       = command.value("SURGE_START_EVENT").toString();
        }
        if(command.value("PERIODIC_TEST_EVENT").toString() != ""){
            preiodicStart     = command.value("PERIODIC_TEST_EVENT").toString();
        }
        if(command.value("MANUAL_TEST_EVENT").toString() != ""){
            manualTest        = command.value("MANUAL_TEST_EVENT").toString();
        }
        if(command.value("LFL_FAIL").toString() != ""){
            lflfail           = command.value("LFL_FAIL").toString();
        }
        if(command.value("LFL_OPERATE").toString() != ""){
            lfloperate        = command.value("LFL_OPERATE").toString();
        }
//         GateWsys       = command.value("gateway").toString();
//         snmpIP         = command.value("ip_snmp").toString();
//         timeServer     = command.value("ntpServer").toString();
//         plcDoError        = command.value("PLC_DO_ERROR").toString();
//         plcDiError        =  command.value("PLC_DI_ERROR").toString();
//         hispeedPhaseA     = command.value("MODULE_HI_SPEED_PHASE_A_ERROR").toString();
//         hispeedPhaseB     = command.value("MODULE_HI_SPEED_PHASE_B_ERROR").toString();
//         hispeedPhaseC     = command.value("MODULE_HI_SPEED_PHASE_C_ERROR").toString();
//         commuPhaseA       =   command.value("INTERNAL_PHASE_A_ERROR").toString();
//         commuPhaseB       =  command.value("INTERNAL_PHASE_B_ERROR").toString();
//         commuPhaseC       =  command.value("INTERNAL_PHASE_C_ERROR").toString();
//         gpsModule         =  command.value("GPS_MODULE_FAIL").toString();
//         systemInti        =  command.value("SYSTEM_INITIAL").toString();
//         commuError        =  command.value("COMMUNICATION_ERROR").toString();
//         relayStart        = command.value("RELAY_START_EVENT").toString();
//         surageStart       = command.value("SURGE_START_EVENT").toString();
//         preiodicStart     = command.value("PERIODIC_TEST_EVENT").toString();
//         manualTest        = command.value("MANUAL_TEST_EVENT").toString();
//         lflfail           = command.value("LFL_FAIL").toString();
//         lfloperate        = command.value("LFL_OPERATE").toString();
        Param.insert("objectName","updateSettingNetwork");	             //Name
        Param.insert("ipaddress",IPaddress);
        Param.insert("gateway",GateWsys);
        Param.insert("ip_snmp",snmpIP);
        Param.insert("ntpServer",timeServer);
        Param.insert("PLC_DO_ERROR",plcDoError);
        Param.insert("PLC_DI_ERROR",plcDiError);
        Param.insert("MODULE_HI_SPEED_PHASE_A_ERROR",hispeedPhaseA);
        Param.insert("MODULE_HI_SPEED_PHASE_B_ERROR",hispeedPhaseB);
        Param.insert("MODULE_HI_SPEED_PHASE_C_ERROR",hispeedPhaseC);
        Param.insert("INTERNAL_PHASE_A_ERROR",commuPhaseA);
        Param.insert("INTERNAL_PHASE_B_ERROR",commuPhaseB);
        Param.insert("INTERNAL_PHASE_C_ERROR",commuPhaseC);
        Param.insert("GPS_MODULE_FAIL",gpsModule);
        Param.insert("SYSTEM_INITIAL",systemInti);
        Param.insert("COMMUNICATION_ERROR",commuError);
        Param.insert("RELAY_START_EVENT",relayStart);
        Param.insert("SURGE_START_EVENT",surageStart);
        Param.insert("PERIODIC_TEST_EVENT",preiodicStart);
        Param.insert("MANUAL_TEST_EVENT",manualTest);
        Param.insert("LFL_FAIL",lflfail);
        Param.insert("LFL_OPERATE",lfloperate);
        jsonDoc.setObject(Param);
        raw_data = QJsonDocument(Param).toJson(QJsonDocument::Compact).toStdString().c_str();
        qDebug() << "NetWork and SNMP settin:" << raw_data;
        emit SetNetworkSNMP(raw_data);
     }
}


void Database::SettingDisplay(QString msg) {
    qDebug() << "SettingDisplay:" << msg;

    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();
    QString getCommand = QJsonValue(command["objectName"]).toString();

    if (getCommand != "displaySetting") {
        qDebug() << "Invalid command. Expected 'displaySetting'.";
        return;
    }

    if (!db.isOpen()) {
        qDebug() << "Database is not open. Attempting to open...";
        if (!db.open()) {
            qDebug() << "Failed to open database:" << db.lastError().text();
            return;
        }
    }
    qDebug() << "Database connection successful";

    QSqlQuery query(db);

    if (command.contains("sagFactor")) {
        QJsonValue sagValue = command["sagFactor"];

        if (!sagValue.isNull() && !sagValue.isUndefined()) {
            double sagFactor = sagValue.toDouble(); // แปลงเป็น double
            qDebug() << "Received sagFactor:" << sagFactor;

            if (sagFactor != 0) {
                qDebug() << "Updating database with sagFactor:" << sagFactor;
                query.prepare("UPDATE DisplaySetting SET SAG = :sagFactor WHERE number = 1");
                query.bindValue(":sagFactor", sagFactor);
                if (!query.exec()) {
                    qDebug() << "Failed to update SAG in DisplaySetting table:" << query.lastError().text();
                } else {
                    qDebug() << "SAG updated successfully to" << sagFactor;
                }
            } else {
                qDebug() << "Received sagFactor is 0. Updating database anyway.";
                query.prepare("UPDATE DisplaySetting SET SAG = 0 WHERE number = 1");
                if (!query.exec()) {
                    qDebug() << "Failed to update SAG in DisplaySetting table:" << query.lastError().text();
                } else {
                    qDebug() << "SAG updated successfully to 0.";
                }
            }
        } else {
            qDebug() << "sagFactor is null or undefined. Skipping update.";
        }
    }

    if (command.contains("samplingRate")) {
        QJsonValue samplingRate = command["samplingRate"];

        if (!samplingRate.isNull() && !samplingRate.isUndefined()) {
            double sampling = samplingRate.toDouble(); // แปลงเป็น double
            qDebug() << "Received samplingRate:" << sampling;

            if (sampling != 0) {
                qDebug() << "Updating database with sagFactor:" << sampling;
                query.prepare("UPDATE DisplaySetting SET Sampling_rate = :samplingRate WHERE number = 1");
                query.bindValue(":samplingRate", sampling);
                if (!query.exec()) {
                    qDebug() << "Failed to update samplingRate in DisplaySetting table:" << query.lastError().text();
                } else {
                    qDebug() << "samplingRate updated successfully to" << sampling;
                }
            } else {
                qDebug() << "Received samplingRate is 0. Updating database anyway.";
                query.prepare("UPDATE DisplaySetting SET Sampling_rate = 0 WHERE number = 1");
                if (!query.exec()) {
                    qDebug() << "Failed to update Sampling_rate in DisplaySetting table:" << query.lastError().text();
                } else {
                    qDebug() << "Sampling_rate updated successfully to 0.";
                }
            }
        } else {
            qDebug() << "sagFactor is null or undefined. Skipping update.";
        }
    }

    if (command.contains("distancetostartText")) {
        QJsonValue distanceStartValue = command["distancetostartText"];

        if (!distanceStartValue.isNull() && !distanceStartValue.isUndefined()) {
            int distanceStart = distanceStartValue.toInt();
            qDebug() << "Updating DistanceStart to:" << distanceStart;

            query.prepare("UPDATE DisplaySetting SET DistanceStart = :distanceStart WHERE number = 1");
            query.bindValue(":distanceStart", distanceStart);

            if (!query.exec()) {
                qDebug() << "Failed to update DistanceStart in DisplaySetting table:" << query.lastError().text();
            } else {
                qDebug() << "DistanceStart updated successfully to" << distanceStart;
            }
        } else {
            qDebug() << "distancetostartText is null or undefined. Skipping update.";
        }
    }

    if (command.contains("distancetoshowText")) {
        QJsonValue distanceStopValue = command["distancetoshowText"];

        if (!distanceStopValue.isNull() && !distanceStopValue.isUndefined()) {
            double distanceStop = distanceStopValue.toDouble();
            qDebug() << "Updating DistanceStop to:" << distanceStop;

            query.prepare("UPDATE DisplaySetting SET DistanceStop = :distanceStop WHERE number = 1");
            query.bindValue(":distanceStop", distanceStop);

            if (!query.exec()) {
                qDebug() << "Failed to update DistanceStop in DisplaySetting table:" << query.lastError().text();
            } else {
                qDebug() << "DistanceStop updated successfully to" << distanceStop;
            }
        } else {
            qDebug() << "distancetoshowText is null or undefined. Skipping update.";
        }
    }

    if (command.contains("fulldistanceText")) {
        QJsonValue fullDistanceValue = command["fulldistanceText"];

        if (!fullDistanceValue.isNull() && !fullDistanceValue.isUndefined()) {
            double fullDistance = fullDistanceValue.toDouble();
            qDebug() << "Updating FullDistance to:" << fullDistance;

            query.prepare("UPDATE DisplaySetting SET FullDistance = :fullDistance WHERE number = 1");
            query.bindValue(":fullDistance", fullDistance);

            if (!query.exec()) {
                qDebug() << "Failed to update FullDistance in DisplaySetting table:" << query.lastError().text();
            } else {
                qDebug() << "FullDistance updated successfully to" << fullDistance;
            }
        } else {
            qDebug() << "fulldistanceText is null or undefined. Skipping update.";
        }
    }


    closeMySQL(); // Close the database connection if necessary
    GetSettingDisplay();
}

void Database::GetSettingDisplay() {
    qDebug() << "GetSettingDisplay:";

    if (!db.isOpen()) {
        qDebug() << "Database is not open. Attempting to open...";
        if (!db.open()) {
            qDebug() << "Failed to open the database:" << db.lastError().text();
            return;
        }
        qDebug() << "Database opened successfully.";
    }

    // เตรียมคำสั่ง SQL สำหรับดึงข้อมูล
    QSqlQuery query;
    QString sql = "SELECT SAG, Sampling_rate, DistanceStart, DistanceStop, FullDistance FROM DisplaySetting";

    if (!query.exec(sql)) {
        qDebug() << "Failed to execute query:" << query.lastError().text();
        return;
    }

    while (query.next()) {
        double SAG = query.value("SAG").toDouble();
        double Sampling_rate = query.value("Sampling_rate").toDouble();
        double DistanceStart = query.value("DistanceStart").toDouble();
        double DistanceStop = query.value("DistanceStop").toDouble();
        double FullDistance = query.value("FullDistance").toDouble();

        qDebug() << "DEBUG GetSettingDisplay" << "SAG:" << SAG << "Sampling_rate:" << Sampling_rate << "DistanceStart:" << DistanceStart << "DistanceStop:" << DistanceStop << "FullDistance:" << FullDistance;

        QString getPeriodicInfo = QString(
            "{\"objectName\":\"GetSettingDisplay\", "
            "\"sagFactorInit\":%1, "
            "\"samplingRateInit\":%2, "
            "\"distanceToStartInit\":%3, "
            "\"distanceToShowInit\":%4, "
            "\"fulldistancesInit\":%5}")
            .arg(SAG)
            .arg(Sampling_rate)
            .arg(DistanceStart)
            .arg(DistanceStop)
            .arg(FullDistance);
        emit settingDisplayInfo(getPeriodicInfo);
    }
    closeMySQL();
}

void Database::calculateDisplay(double msg) {
    qDebug() << "CalculateGraph:" << msg;
}


//    if (getCommand == "displaySetting") {
//        double sagFactor = command.value("sagFactor").toDouble();
//        double samplingText = command.value("samplingText").toDouble();
//        double distanceToStart = command.value("distancetostartText").toDouble();
//        double distanceToShow = command.value("distancetoshowText").toDouble();
//        double fullDistance = command.value("fulldistanceText").toDouble();

//        Param.insert("objectName","displaySetting");	             //Name
//        Param.insert("sagFactor",sagFactor);
//        Param.insert("samplingText",samplingText);
//        Param.insert("distancetostartText",distanceToStart);
//        Param.insert("distancetoshowText",distanceToShow);
//        Param.insert("fulldistanceText",fullDistance);

//        jsonDoc.setObject(Param);
//        raw_data = QJsonDocument(Param).toJson(QJsonDocument::Compact).toStdString().c_str();
//        qDebug() << "Display Setting:" << raw_data << sagFactor << samplingText << distanceToStart << distanceToShow << fullDistance;
//        emit updateDisplaySetting(raw_data);
//    }


//void Database::getUpdateWeekly(QString msg) {
//    qDebug() << "getUpdateWeekly:" << msg;

//    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
//    QJsonObject command = d.object();

//    QString mondayStr   = command["Monday"].toString();
//    QString tuesdayStr  = command["Tuesday"].toString();
//    QString wednesdayStr= command["Wednesday"].toString();
//    QString thursdayStr = command["Thursday"].toString();
//    QString fridayStr   = command["Friday"].toString();
//    QString saturdayStr = command["Saturday"].toString();
//    QString sundayStr   = command["Sunday"].toString();

//    bool monday     = (mondayStr == "1");
//    bool tuesday    = (tuesdayStr == "1");
//    bool wednesday  = (wednesdayStr == "1");
//    bool thursday   = (thursdayStr == "1");
//    bool friday     = (fridayStr == "1");
//    bool saturday   = (saturdayStr == "1");
//    bool sunday     = (sundayStr == "1");

//    if (mondayStr != "") {
//        qDebug() << "Processing Monday value..." << monday;

//        if (!db.isOpen()) {
//            qDebug() << "Database is not open, opening now...";
//            if (!db.open()) {
//                qDebug() << "Failed to open the database:" << db.lastError().text();
//                return;
//            }
//        }

//        QSqlQuery query(db);
//        query.prepare("SELECT Monday FROM PeriodicInfo LIMIT 1");
//        if (!query.exec() || !query.next()) {
//            qDebug() << "Failed to fetch current value for Monday:" << query.lastError().text();
//            closeMySQL();
//            return;
//        }

//        bool currentMonday = query.value("Monday").toBool();
//        qDebug() << "Current Monday value in database:" << currentMonday << monday;

//        if (currentMonday != monday) {
//            qDebug() << "Monday value changed. Updating database...";
//            query.prepare("UPDATE PeriodicInfo SET Monday = :newMonday");
//            query.bindValue(":newMonday", monday);

//            if (!query.exec()) {
//                qDebug() << "Failed to update Monday in PeriodicInfo table:" << query.lastError().text();
//            } else {
//                qDebug() << "Monday updated successfully in PeriodicInfo table to" << monday;
//            }
//        } else {
//            qDebug() << "Monday value has not changed. No update needed.";
//        }

//        closeMySQL();
//    }
//}


//void Database::getUpdateWeekly(QString msg) {
//    qDebug() << "getUpdateWeekly:" << msg;

//    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
//    QJsonObject command = d.object();
//    bool monday = command["Monday"].toBool();
//    bool tuesday = command["Tuesday"].toBool();
//    bool wednesday = command["Wednesday"].toBool();
//    bool thursday = command["Thursday"].toBool();
//    bool friday = command["Friday"].toBool();
//    bool saturday = command["Saturday"].toBool();
//    bool sunday = command["Sunday"].toBool();

//    if(command.contains("Monday")){
//        qDebug() << "monday check:" << msg;
//        if (!db.isOpen()) {
//            qDebug() << "Database is not open, opening now...";
//            if (!db.open()) {
//                qDebug() << "Failed to open the database:" << db.lastError().text();
//                return;
//            }
//        }
//        QSqlQuery query(db);
//        query.prepare("UPDATE PeriodicInfo SET Monday = :newMonday");
//        query.bindValue(":newMonday", monday);

//        if (!query.exec()) {
//            qDebug() << "Failed to update Time in PeriodicInfo table:" << query.lastError().text();
//        } else {
//            qDebug() << "Time updated successfully in PeriodicInfo table to" << monday;
//        }
//    }
//    closeMySQL();

//}


void Database::reloadDatabase()
{
//    system("/etc/init.d/mysql stop");
//    system("/etc/init.d/mysql start");
}

void Database::hashletPersonalize()
{
    QString prog = "/bin/bash";//shell
    QStringList arguments;
    QProcess getAddressProcess;
    QString output;

    QString filename = "/tmp/newhashlet/personalize.sh";
    QString data = QString("#!/bin/bash\n"
                           "su - nano2g -s /bin/bash -c \"hashlet -b /dev/i2c-2 personalize\"\n"
                           "echo $? > /tmp/newhashlet/personalize.txt\n");
    system("mkdir -p /tmp/newhashlet");
    QByteArray dataAyyay(data.toLocal8Bit());
    QFile file(filename);
    file.open(QIODevice::WriteOnly | QIODevice::Text);
    QTextStream out(&file);
    out << dataAyyay;
    file.close();

    arguments << "-c" << QString("sh /tmp/newhashlet/personalize.sh");
    getAddressProcess.start(prog , arguments);
    getAddressProcess.waitForFinished(1000);
    output = getAddressProcess.readAll();
    arguments.clear();
}

void Database::genHashKey()
{
   QString mac = "", challenge = "", meta = "", password = "", serial = "";
   QStringList macList = getMac();
   if (macList.size() >= 3){
       Q_FOREACH (QString macStr, macList)
       {
           if (macStr.contains("mac")){
               mac = macStr.split(":").at(1);
           }
           else if(macStr.contains("challenge")){
               challenge = macStr.split(":").at(1);
           }
           else if(macStr.contains("meta")){
               meta = macStr.split(":").at(1);
           }
       }
       password = getPassword().replace("\n","");
       serial = getSerial().replace("\n","");
   }

   updateHashTable(mac, challenge, meta, serial, password);
}
bool Database::checkHashletNotData()
{
    QString mac = "", challenge = "", meta = "", password = "", serial = "";
    QString query = QString("SELECT mac, challenge, meta, password, serial  FROM hashlet LIMIT 1");
    if (!db.open()) {
        qWarning() << "c++: ERROR! "  << "database error! database can not open.";
        emit databaseError();
        return false;
    }
    QSqlQuery qry;
    qry.prepare(query);
    if (!qry.exec()){
        qWarning() << "c++: ERROR! "  << qry.lastError();
    }else{
        while (qry.next()) {
            mac         = qry.value(0).toString();
            challenge   = qry.value(1).toString();
            meta        = qry.value(2).toString();
            password    = qry.value(3).toString();
            serial      = qry.value(4).toString();
        }
    }
    //.db.close();

    return ((mac == "")||(challenge == "")||(meta == "")||(serial == "")||(password == ""));
}

void Database::updateHashTable(QString mac, QString challenge ,QString meta, QString serial, QString password)
{
    if ((mac != "")&(challenge != "")&(meta != "")&(serial != "")&(password != "")){
        QString query = QString("UPDATE hashlet SET mac='%1', challenge='%2', meta='%3', serial='%4', password='%5'")
                .arg(mac).arg(challenge).arg(meta).arg(serial).arg(password);
        if (!db.open()) {
            qWarning() << "c++: ERROR! "  << "database error! database can not open.";
            emit databaseError();
            return ;
        }
        QSqlQuery qry;
        qry.prepare(query);
        if (!qry.exec()){
            qWarning() << "c++: ERROR! "  << qry.lastError();
        }
        //.db.close();
    }
}

QStringList Database::getMac()
{
    QString prog = "/bin/bash";//shell
    QStringList arguments;
    QProcess getAddressProcess;
    QString output;

    QString filename = "/tmp/newhashlet/getmac.sh";
    QString data = QString("#!/bin/bash\n"
                           "su - nano2g -s /bin/bash -c \"hashlet -b /dev/i2c-2 mac --file /home/nano2g/.hashlet\"\n"
                           "echo $? > /tmp/newhashlet/mac.txt\n");
    system("mkdir -p /tmp/newhashlet");
    QByteArray dataAyyay(data.toLocal8Bit());
    QFile file(filename);
    file.open(QIODevice::WriteOnly | QIODevice::Text);
    QTextStream out(&file);
    out << dataAyyay;
    file.close();

    arguments << "-c" << QString("sh /tmp/newhashlet/getmac.sh");
    getAddressProcess.start(prog , arguments);
    getAddressProcess.waitForFinished(1000);
    output = getAddressProcess.readAll();
    arguments.clear();
    output = output.replace(" ","");
    return output.split("\n");
}
QString Database::getPassword()
{
    QString prog = "/bin/bash";//shell
    QStringList arguments;
    QProcess getAddressProcess;
    QString output;

    QString filename = "/tmp/newhashlet/getpassword.sh";
    QString data = QString("#!/bin/bash\n"
                           "su - nano2g -s /bin/bash -c \"echo ifz8zean6969** | hashlet -b /dev/i2c-2 hmac\"\n"
                           "echo $? > /tmp/newhashlet/password.txt\n");
    system("mkdir -p /tmp/newhashlet");
    QByteArray dataAyyay(data.toLocal8Bit());
    QFile file(filename);
    file.open(QIODevice::WriteOnly | QIODevice::Text);
    QTextStream out(&file);
    out << dataAyyay;
    file.close();

    arguments << "-c" << QString("sh /tmp/newhashlet/getpassword.sh");
    getAddressProcess.start(prog , arguments);
    getAddressProcess.waitForFinished(1000);
    output = getAddressProcess.readAll();
    arguments.clear();
    return output;
}
QString Database::getSerial()
{
    QString prog = "/bin/bash";//shell
    QStringList arguments;
    QProcess getAddressProcess;
    QString output;

    QString filename = "/tmp/newhashlet/getserial.sh";
    QString data = QString("#!/bin/bash\n"
                           "su - nano2g -s /bin/bash -c \"hashlet -b /dev/i2c-2 serial-num\"\n"
                           "echo $? > /tmp/newhashlet/password.txt\n");
    system("mkdir -p /tmp/newhashlet");
    QByteArray dataAyyay(data.toLocal8Bit());
    QFile file(filename);
    file.open(QIODevice::WriteOnly | QIODevice::Text);
    QTextStream out(&file);
    out << dataAyyay;
    file.close();

    arguments << "-c" << QString("sh /tmp/newhashlet/getserial.sh");
    getAddressProcess.start(prog , arguments);
    getAddressProcess.waitForFinished(1000);
    output = getAddressProcess.readAll();
    arguments.clear();
    return output;
}

bool Database::passwordVerify(QString password){
    QString query = QString("SELECT password FROM hashlet LIMIT 1");
    if (!db.open()) {
        qWarning() << "c++: ERROR! "  << "database error! database can not open.";
        emit databaseError();
        return false;
    }
    QString hashPassword;
    QSqlQuery qry;
    qry.prepare(query);
    if (!qry.exec()){
        qDebug() << qry.lastError();
    }else{
        while (qry.next()) {
            hashPassword = qry.value(0).toString();
        }
    }
    //.db.close();
    QString prog = "/bin/bash";//shell
    QStringList arguments;
    QProcess getAddressProcess;
    QString output;

    arguments.clear();
    arguments << "-c" << QString("echo %1 | hashlet hmac").arg(password);
    getAddressProcess.start(prog , arguments);
    getAddressProcess.waitForFinished(3000);
    output = getAddressProcess.readAll();
    if (output == "") {
        qDebug() << "output == \"\"";
        return false;
    }else if(!output.contains(hashPassword)){
        qDebug() << "output != hashPassword";
        return false;
    }

    system("mkdir -p /etc/ed137");
    if (verifyMac()){
        qDebug() << "mac true";


        if (hashPassword != ""){
            QString filename = "/etc/ed137/checkpass.sh";
            QString data = QString("#!/bin/bash\n"
                                   "su - nano2g -s /bin/bash -c \"echo $1 | hashlet offline-hmac -r $2\"\n"
                                   "echo $? > /etc/ed137/checkpass\n");
            system("mkdir -p /etc/ed137");

            QByteArray dataAyyay(data.toLocal8Bit());
            QFile file(filename);
            file.open(QIODevice::WriteOnly | QIODevice::Text);
            QTextStream out(&file);
            out << dataAyyay;
            file.close();
            arguments.clear();
            arguments << "-c" << QString("sh /etc/ed137/checkpass.sh %1 %2").arg(password).arg(hashPassword);
            getAddressProcess.start(prog , arguments);
            getAddressProcess.waitForFinished(-1);
            output = getAddressProcess.readAll();
            qDebug() << output;

            arguments.clear();
            arguments << "-c" << QString("cat /etc/ed137/checkpass");
            getAddressProcess.start(prog , arguments);
            getAddressProcess.waitForFinished(-1);
            output = getAddressProcess.readAll();
            qDebug() << output;
            system("rm -r /etc/ed137");
            if (output.contains("0\n")){
                return true;
            }
            return false;
        }

    }else{
        qDebug() << "mac false";
    }
    system("rm -r /etc/ed137");
    return false;
}

bool Database::verifyMac(){
    QString query = QString("SELECT mac, challenge FROM hashlet LIMIT 1");
    if (!db.open()) {
        qWarning() << "c++: ERROR! "  << "database error! database can not open.";
        emit databaseError();
        return false;
    }
    QString mac, challenge;
    QSqlQuery qry;
    qry.prepare(query);
    if (!qry.exec()){
        qDebug() << qry.lastError();
    }else{
        while (qry.next()) {
            mac = qry.value(0).toString();
            challenge = qry.value(1).toString();
        }
    }
    //.db.close();

    QString prog = "/bin/bash";//shell
    QStringList arguments;
    QProcess getAddressProcess;
    QString output;

    QString filename = "/etc/ed137/checkmac.sh";
    QString data = QString("#!/bin/bash\n"
                           "su - nano2g -s /bin/bash -c \"hashlet offline-verify -c $1 -r $2\"\n"
                           "echo $? > /etc/ed137/checkmac\n");
    system("mkdir -p /etc/ed137");
    QByteArray dataAyyay(data.toLocal8Bit());
    QFile file(filename);
    file.open(QIODevice::WriteOnly | QIODevice::Text);
    QTextStream out(&file);
    out << dataAyyay;
    file.close();

    arguments << "-c" << QString("sh /etc/ed137/checkmac.sh %1 %2").arg(challenge).arg(mac);
    getAddressProcess.start(prog , arguments);
    getAddressProcess.waitForFinished(1000);
    output = getAddressProcess.readAll();

    arguments.clear();
    arguments << "-c" << QString("cat /etc/ed137/checkmac");
    getAddressProcess.start(prog , arguments);
    getAddressProcess.waitForFinished(1000);
    output = getAddressProcess.readAll();
    arguments.clear();

    if (output.contains("0\n"))
        return true;
    return false;
}

////////////////////pattern datastorage//////////////////////////
/// \brief Database::getTimeDuration
void Database::getdatapatternDataDb() {
    qDebug() << "Fetching all event records from database...";

    if (!db.isOpen()) {
        qDebug() << "Database is not open! Attempting to reconnect...";
        if (!db.open()) {
            qDebug() << "Failed to reconnect database:" << db.lastError().text();
            return;
        }
    }
    QSqlQuery query("SELECT e.event_datetime, e.filename, c.name AS category_name FROM event_records e JOIN categories c ON e.category_id = c.id ORDER BY e.event_datetime", db);
    if (!query.exec()) {
        qDebug() << "Failed to execute query:" << query.lastError().text();
        return;
    }

    int count = 0;
    while (query.next()) {
        QJsonObject recordObject;
        recordObject["objectName"] = "PatternData";
        recordObject["event_datetime"] = query.value("event_datetime").toString();
        recordObject["filename"] = query.value("filename").toString();
        recordObject["category_name"] = query.value("category_name").toString();
        QJsonDocument jsonDoc(recordObject);
        QString jsonString = jsonDoc.toJson(QJsonDocument::Compact);

        // qDebug() << "Sending JSON Data:" << jsonString;
        // emit patternDataReceived(jsonString);
        emit cmdmsg(jsonString);
        count++;
    }

    if (count == 0) {
        qDebug() << "No data found in database!";
    } else {
        qDebug() << "All records have been sent!";
    }
}
void Database::patternDataDb(QSqlQuery query) {
    qDebug() << "Fetching sorted event records from database...";

    int count = 0;
    while (query.next()) {
        QJsonObject recordObject;
        recordObject["objectName"] = "PatternData";
        recordObject["event_datetime"] = query.value("event_datetime").toString();
        recordObject["filename"] = query.value("filename").toString();
        recordObject["category_name"] = query.value("category_name").toString();
        QJsonDocument jsonDoc(recordObject);
        QString jsonString = jsonDoc.toJson(QJsonDocument::Compact);
        emit cmdmsg(jsonString);
        count++;
    }

    if (count == 0) {
        qDebug() << "No data found in database!";
    } else {
        qDebug() << "All records have been sent!";
    }
}

void Database::sortByName(bool ascending, const QString &categoryName) {
    qDebug()<<"sortByName"<<categoryName;
    if (!db.isOpen()) {
        qDebug() << "Database is not open! Attempting to reconnect...";
        if (!db.open()) {
            qDebug() << "Failed to reconnect database:" << db.lastError().text();
            return;
        }
    }

    QSqlQuery query(db);
    QString queryStr = QString("SELECT e.event_datetime, e.filename, c.name AS category_name FROM event_records e JOIN categories c ON e.category_id = c.id WHERE c.name = '%1' ORDER BY e.filename %2")
                           .arg(categoryName).arg(ascending ? "ASC" : "DESC");

    if (!query.exec(queryStr)) {
        qDebug() << "Query failed:" << query.lastError().text();
        return;
    }

    qDebug() << "Sorting by filename" << (ascending ? " ASC" : " DESC");

    patternDataDb(query);
}
void Database::sortByDate(bool ascending, const QString &categoryName) {
    qDebug()<<"sortByName"<<categoryName;
    if (!db.isOpen()) {
        qDebug() << "Database is not open! Attempting to reconnect...";
        if (!db.open()) {
            qDebug() << "Failed to reconnect database:" << db.lastError().text();
            return;
        }
    }

    QSqlQuery query(db);
    QString queryStr = QString("SELECT e.event_datetime, e.filename, c.name AS category_name FROM event_records e JOIN categories c ON e.category_id = c.id WHERE c.name = '%1'   ORDER BY e.event_datetime %2")
                           .arg(categoryName).arg(ascending ? "ASC" : "DESC");

    if (!query.exec(queryStr)) {
        qDebug() << "Query failed:" << query.lastError().text();
        return;
    }

    qDebug() << "Sorting by filename" << (ascending ? " ASC" : " DESC");

    patternDataDb(query);
}
void Database::searchByName(const QString &name, const QString &categoryName) {
    if (!db.isOpen()) {
        qDebug() << "Database is not open! Attempting to reconnect...";
        if (!db.open()) {
            qDebug() << "Failed to reconnect database:" << db.lastError().text();
            return;
        }
    }

    QSqlQuery query(db);
    QString queryStr = QString("SELECT e.event_datetime, e.filename, c.name AS category_name  FROM event_records e  JOIN categories c ON e.category_id = c.id  WHERE c.name = '%1'  AND e.filename LIKE '%%2%'   ORDER BY e.event_datetime ASC")
                           .arg(categoryName).arg(name);

    if (!query.exec(queryStr)) {
        qDebug() << "Query failed:" << query.lastError().text();
        return;
    }

    qDebug() << "Searching for filename:" << name;

    patternDataDb(query);
}
void Database::searchByDate(const QString &date, const QString &categoryDate) {
    if (!db.isOpen()) {
        qDebug() << "Database is not open! Attempting to reconnect...";
        if (!db.open()) {
            qDebug() << "Failed to reconnect database:" << db.lastError().text();
            return;
        }
    }

    QSqlQuery query(db);
    QString queryStr = QString("SELECT e.event_datetime, e.filename, c.name AS category_name  FROM event_records e  JOIN categories c ON e.category_id = c.id  WHERE c.name = '%1'  AND e.event_datetime LIKE '%%2%'   ORDER BY e.event_datetime ASC")
                           .arg(categoryDate).arg(date);

    if (!query.exec(queryStr)) {
        qDebug() << "Query failed:" << query.lastError().text();
        return;
    }

    qDebug() << "Searching for filename:" << date;

    patternDataDb(query);
}


bool Database::database_createConnection()
{
    if (!db.open()) {
        qWarning() << "c++: ERROR! "  << "database error! database can not open.";
        //emit databaseError();
        return false;
    }
    //.db.close();
    qDebug() << "Database connected";
    return true;
}
qint64 Database::getTimeDuration(QString filePath)
{
#ifdef HWMODEL_JSNANO
    QString query = QString("SELECT timestamp FROM fileCATISAudio WHERE path='%1' LIMIT 1").arg(filePath);
    if (!db.open()) {
        qWarning() << "c++: ERROR! "  << "database error! database can not open.";
        emit databaseError();
        return 0;

    }
    QDateTime timestamp;
    QSqlQuery qry;
    qry.prepare(query);
    if (!qry.exec()){
        qDebug() << qry.lastError();
    }else{
        while (qry.next()) {
            timestamp = qry.value(0).toDateTime();
        }
    }
    //.db.close();
    qint64 duration = QDateTime::currentDateTime().toSecsSinceEpoch() - timestamp.toSecsSinceEpoch();
    if (duration <= 0) duration=5;
    return duration;
#else
    return 0;
#endif

}
void Database::getLastEvent()
{
#ifdef HWMODEL_JSNANO
    QString lastEvent;
    QDateTime timestamp;
    int timeDuration;
    int id;
    QString query = QString("SELECT timestamp, event, id, duration_sec FROM fileCATISAudio ORDER BY id DESC LIMIT 1");
    if (!db.open()) {
        qWarning() << "c++: ERROR! "  << "database error! database can not open.";
        emit databaseError();
        return ;

    }
    QSqlQuery qry;
    qry.prepare(query);
    if (!qry.exec()){
        qDebug() << qry.lastError();
    }else{
        while (qry.next()) {
            timestamp = qry.value(0).toDateTime();
            lastEvent = qry.value(1).toString();
            id = qry.value(2).toInt();
            timeDuration = qry.value(3).toInt();
        }
    }
    //.db.close();

    if ((lastEvent == "Standby") & (timeDuration == 0)){
        qint64 duration = QDateTime::currentDateTime().toSecsSinceEpoch() - timestamp.toSecsSinceEpoch();
        QString timeStamp = QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss");
        QString query = QString("UPDATE fileCATISAudio SET duration_sec='%1' WHERE id='%2'").arg(duration).arg(id);
        if (!db.open()) {
            qWarning() << "c++: ERROR! "  << "database error! database can not open.";
            emit databaseError();
            return ;
        }
        QSqlQuery qry;
        qry.prepare(query);
        if (!qry.exec()){
            qDebug() << qry.lastError();
        }
        //.db.close();
    }
#else
    return;
#endif
}
void Database::startProject(QString filePath, QString radioEvent)
{

#ifdef HWMODEL_JSNANO
    QString timeStamp = QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss");
    QString query = QString("INSERT INTO fileCATISAudio (path, timestamp, duration_sec, event) "
                            "VALUES ('%1', '%2', '%3', '%4')").arg(filePath).arg(timeStamp).arg(0).arg(radioEvent);
    if (!db.open()) {
        qWarning() << "c++: ERROR! "  << "database error! database can not open.";
        emit databaseError();
        return ;
    }
    QSqlQuery qry;
    qry.prepare(query);
    if (!qry.exec()){
        qDebug() << qry.lastError();
    }
    //.db.close();
#else
    return;
#endif
}

void Database::insertNewAudioRec(QString filePath, QString radioEvent)
{
#ifdef HWMODEL_JSNANO
    if (radioEvent != "Standby")
    {
        getLastEvent();
    }
    QString timeStamp = QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss");
    QString query = QString("INSERT INTO fileCATISAudio (path, timestamp, duration_sec, event) "
                            "VALUES ('%1', '%2', '%3', '%4')").arg(filePath).arg(timeStamp).arg(0).arg(radioEvent);
    if (!db.open()) {
        qWarning() << "c++: ERROR! "  << "database error! database can not open.";
        emit databaseError();
        return ;
    }
    QSqlQuery qry;
    qry.prepare(query);
    if (!qry.exec()){
        qDebug() << qry.lastError();
    }
    //.db.close();
#else
    return;
#endif
}

void Database::updateAudioRec(QString filePath, float avg_level, float max_level)
{
#ifdef HWMODEL_JSNANO
    qint64 duration = getTimeDuration(filePath);
    QString timeStamp = QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss");
    QString query = QString("UPDATE fileCATISAudio SET duration_sec='%1',avg_level=%2, max_level=%3 WHERE path='%4'").arg(duration).arg(avg_level).arg(max_level).arg(filePath);
    if (!db.open()) {
        qWarning() << "c++: ERROR! "  << "database error! database can not open.";
        emit databaseError();
        return ;
    }
    QSqlQuery qry;
    qry.prepare(query);
    if (!qry.exec()){
        qDebug() << qry.lastError();
    }
    //.db.close();
#else
    return;
#endif
}
void Database::removeAudioFile(int lastMin)
{
#ifdef HWMODEL_JSNANO
    QString filePath = "";
    QString timestamp = QDateTime::currentDateTime().addSecs(-(60*lastMin)).toString("yyyy-MM-dd hh:mm:ss");
    QString query = QString("SELECT path FROM fileCATISAudio WHERE timestamp<'%1' ORDER BY id ASC").arg(timestamp);
    if (!db.open()) {
        qWarning() << "c++: ERROR! "  << "database error! database can not open.";
        emit databaseError();
        return ;

    }
    QSqlQuery qry;
    qry.prepare(query);
    if (!qry.exec()){
        qDebug() << qry.lastError();
    }else{
        while (qry.next()) {
            filePath = qry.value(0).toString();
            if (filePath.contains("/home/pi/")){
                QString commanRm = QString("rm -f %1*").arg(filePath);
                system(commanRm.toStdString().c_str());
            }
        }
    }
    query = QString("DELETE FROM fileCATISAudio WHERE timestamp<'%1'").arg(timestamp);
    qry.prepare(query);
    if (!qry.exec()){
       qDebug() << qry.lastError();
    }else{
       while (qry.next()) {
           filePath = qry.value(0).toString();
           QString commanRm = QString("rm -f %1*").arg(filePath);
           system(commanRm.toStdString().c_str());
       }
    }
    //.db.close();
#else
    return;
#endif
}

QString Database::getNewFile(int warnPercentFault)
{
#ifdef HWMODEL_JSNANO
    QString filePath = "";
    QString query = QString("SELECT path, id FROM fileCATISAudio WHERE event='PTT On' AND id>%1 AND avg_level>%2 ORDER BY id ASC LIMIT 1").arg(currentFileID).arg(warnPercentFault);
    if (!db.open()) {
        qWarning() << "c++: ERROR! "  << "database error! database can not open.";
        emit databaseError();
        return "";

    }
    QSqlQuery qry;
    qry.prepare(query);
    if (!qry.exec()){
        qDebug() << qry.lastError();
    }else{
        while (qry.next()) {
            filePath = qry.value(0).toString();
            currentFileID = qry.value(1).toInt();
        }
    }
    //.db.close();
    return filePath;
#else
    return "";
#endif
}

qint64 Database::getStandbyDuration()
{
#ifdef HWMODEL_JSNANO
    qint64 duration_sec = 0;
    QString query = QString("SELECT duration_sec, id FROM fileCATISAudio WHERE event='Standby' AND id>%1  ORDER BY id ASC LIMIT 1").arg(currentFileID);
    if (!db.open()) {
        qWarning() << "c++: ERROR! "  << "database error! database can not open.";
        emit databaseError();
        return 0;

    }
    QSqlQuery qry;
    qry.prepare(query);
    if (!qry.exec()){
        qDebug() << qry.lastError();
    }else{
        while (qry.next()) {
            duration_sec = qry.value(0).toLongLong();
            currentFileID = qry.value(1).toInt();
        }
    }
    //.db.close();
    return duration_sec;
#else
    return 0;
#endif
}

bool Database::getLastEventCheckAudio(int time, int percentFault, int lastPttMinute)
{
#ifdef HWMODEL_JSNANO
//    qDebug() << "check Last Event And Audio Fault.";
    float avg_level = 0;
    float max_level = 0;
    float last_avg_level = 0;
    float last_max_level = 0;
    QDateTime timestamp = QDateTime::fromSecsSinceEpoch(0);
    QString refDateTime = QDateTime::currentDateTime().addSecs(-(60*lastPttMinute)).toString("yyyy-MM-dd hh:mm:ss");
    float count = 0;
    QString query = QString("SELECT avg_level, max_level, timestamp FROM fileCATISAudio WHERE event='PTT On' AND timestamp>'%2' ORDER BY timestamp DESC LIMIT %1").arg(time).arg(refDateTime);
    if (!db.open()) {
        qWarning() << "c++: ERROR! "  << "database error! database can not open.";
        emit databaseError();
        return false;

    }
    QSqlQuery qry;
    qry.prepare(query);
    if (!qry.exec()){
        qDebug() << qry.lastError();
    }else{
        while (qry.next()) {
            avg_level += qry.value(0).toFloat();
            max_level += qry.value(1).toFloat();
            last_avg_level = qry.value(0).toFloat();
            last_max_level = qry.value(1).toFloat();
            if (qry.value(2).toDateTime() > timestamp)
                timestamp = qry.value(2).toDateTime();
            count += 1;
        }
    }
    //.db.close();

    avg_level = avg_level/count;
    max_level = max_level/count;

    if ((last_avg_level >= percentFault) & (QDateTime::currentDateTime().addSecs(-(lastPttMinute*60)) > timestamp)) {
        emit audioFault(false);
        return true;
    }

    if (avg_level < percentFault) {
        emit audioFault(true);
        return false;
    }

    if (QDateTime::currentDateTime().addSecs(-(lastPttMinute*60)) > timestamp) {
        emit audioFault(true);
        return false;
    }
    emit audioFault(false);
    return true;
#else
    return false;
#endif
}

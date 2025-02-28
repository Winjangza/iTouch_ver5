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
    query.bindValue(":status", status ? 1 : 0); // Convert bool to int (true = 1, false = 0)
    query.bindValue(":No", taggingPoint);

    if (!query.exec()) {
        qWarning() << "Failed to update status:" << query.lastError().text();
    } else {
        qDebug() << "Successfully updated status for No =" << taggingPoint;
    }
}

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
        db.close();
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
        db.close();
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
    updatanewdistance(newCursor);
}



void Database::controlCursor(QString msg) {
    qDebug() << "controlCursor:" << msg;
    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();
    QString getCommand = QJsonValue(command["objectName"]).toString();
    if(getCommand.contains("decreaseValue")){
        double leftmove = QJsonValue(command["decreaseValue"]).toDouble();
        qDebug() << "cursorPosition:" << leftmove;
        QString cutsorleftMove = QString("{\"objectName\"          :\"decreaseValue\","
                                            "\"decreaseValue\"        :%1"
                                            "}").arg(leftmove);
        qDebug() << "cutsorleftMove:" << cutsorleftMove;
        positionCursorChange(cutsorleftMove);
    }else if(getCommand.contains("increaseValue")){
        double rigth = QJsonValue(command["increaseValue"]).toDouble();
        qDebug() << "cursorPosition:" << rigth;
        QString cutsorrightMove = QString("{\"objectName\"          :\"increaseValue\","
                                            "\"increaseValue\"        :%1"
                                            "}").arg(rigth);
        qDebug() << "cutsorrigthMove:" << cutsorrightMove;
        positionCursorChange(cutsorrightMove);
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
        cursorPosition(cutsor);
    }
}


void Database::getRawData(QString msg) {
    qDebug() << "getRawData:" << msg;
    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();
    QString getCommand = QJsonValue(command["objectName"]).toString();
//    if((msg=="testRawData") && getCommand.contains("patternPhaseA")) {

    if(getCommand.contains("getpatternPhaseA")) {
        qDebug() << "getpatternPhaseA:";
        double totalTime = 0.3333e-3;
        double totalDistance = 101.0;
        double speed = totalDistance / totalTime;
        int points = 202;
        double timeStep = totalTime / points;

        QVector<double> voltageDataA = {//1ตัวหาย
//            0, 80, 150, 330, 400, 550, 660, 770, 990, 1150, 1350, 1550, 1600, 1550,
//            1600, 1550, 1350, 1150, 990, 770, 660, 550, 400, 330, 150, 80, 90, 120,
//            150, 150, 150, 150, 160, 170, 180, 190, 180, 170, 160, 150, 150, 150, 152,
//            153, 155, 160, 200, 250, 280, 350, 400, 500, 400, 350, 250, 200, 190, 150,
//            152, 153, 154, 155, 155, 154, 153, 152, 200, 250, 350, 400, 500, 600, 700,
//            800, 900, 1150, 1280, 1390, 1280, 1150, 900, 800, 700, 600, 500, 400, 350, 400,
//            250, 200, 150, 154, 153, 154, 152, 154, 150, 154, 151, 150, 150
            0,150,330,450,565,600,660,720,810,990,1150,1220,1250,1280,1320,1470,1650,1750,1800,1750,
            1650,1470,1320,1280,1250,1220,1150,990,810,720,660,600,565,450,330,150,150,150,150,150,
            150,150,150,150,250,350,450,550,450,350,250,150,150,155,165,175,185,195,185,175,
            165,155,150,150,150,150,150,150,150,150,150,150,150,150,155,160,165,170,175,180,
            175,170,165,160,155,150,150,150,150,150,150,150,150,150,155,160,165,170,175,180,
            185,190,195,200,210,220,230,240,250,260,270,280,290,300,320,340,360,380,430,460,
            490,500,525,550,600,650,700,750,800,850,900,950,1000,1050,1100,1150,1200,1250,1300,1350,
            1400,1450,1500,1450,1400,1350,1300,1250,1200,1150,1100,1050,1000,950,900,850,800,750,700,650,
            600,550,500,450,400,350,300,250,200,150,150,150,150,150,150,150,150,150,150,150,
            150,160,155,153,150,154,155,160,151,152,149,153,155,151,152,154,156,153,150,150,
        };

        if (voltageDataA.size() != points) {
            qWarning() << "Voltage data size does not match the number of points. Rescaling...";

            QVector<double> interpolatedData;
            int originalSize = voltageDataA.size();
            QVector<int> originalIndices;
            for (int i = 0; i < originalSize; ++i) {
                originalIndices.append(i);
            }

            QVector<int> newIndices;
            for (int i = 0; i < points; ++i) {
                newIndices.append(i * (originalSize - 1) / (points - 1));
            }

            for (int i = 0; i < points; ++i) {
                int index = newIndices[i];
                interpolatedData.append(voltageDataA[index]);
            }

            voltageDataA = interpolatedData;
        }

        QString rawDataString = "[";

        for (int i = 0; i < points; ++i) {
            double time = i * timeStep;
            double distance = time * speed;
            double voltage = voltageDataA[i];

            QString pointData = QString("{\"objectName\"          :\"patthernA\","
                                        "\"distance\"       :%1," // Distance
                                        "\"voltage\"        :%2"  // Voltage
                                        "}")
                                    .arg(distance, 0, 'f', 6)
                                    .arg(voltage, 0, 'f', 6);

            rawDataString += pointData;

            if (i < points - 1) {
                rawDataString += ",";
            }
        }

        rawDataString += "]";

        QString rawdataArray = QString("{\"objectName\"  :\"patthernA\","
                                       "\"data\"         :%1}").arg(rawDataString);

//        qDebug() << "Full Jetson Package:" << rawdataArray;
        packageRawData(rawdataArray);
    }else if(getCommand.contains("getpatternPhaseB")) {
        qDebug() << "getpatternPhaseB:";
        double totalTime = 0.3333e-3;
        double totalDistance = 101.0;
        double speed = totalDistance / totalTime;
        int points = 101;
        double timeStep = totalTime / points;

        QVector<double> voltageDataB = {
            0, 100, 150, 330, 465, 660, 765, 990, 1150, 1320, 1450, 1650, 1750, 1800,
            1750, 1650, 1450, 1320, 1150, 990, 765, 660, 465, 330, 150, 165, 175, 160,
            150, 150, 150, 150, 160, 170, 180, 190, 200, 250, 300, 400, 500, 600, 800,
            990, 950, 930, 900, 800, 700, 600, 500, 400, 300, 250, 200, 190, 170, 160,
            159, 158, 157, 156, 155, 154, 153, 152, 151, 150, 150, 151, 152, 180, 190,
            200, 250, 300, 350, 400, 350, 300, 250, 200, 180, 160, 170, 180, 190, 250,
            350, 480, 600, 700, 800, 700, 600, 500, 450, 350, 200, 150,
        };

        if (voltageDataB.size() != points) {
            qWarning() << "Voltage data size does not match the number of points. Rescaling...";

            QVector<double> interpolatedData;
            int originalSize = voltageDataB.size();
            QVector<int> originalIndices;
            for (int i = 0; i < originalSize; ++i) {
                originalIndices.append(i);
            }

            QVector<int> newIndices;
            for (int i = 0; i < points; ++i) {
                newIndices.append(i * (originalSize - 1) / (points - 1));
            }

            for (int i = 0; i < points; ++i) {
                int index = newIndices[i];
                interpolatedData.append(voltageDataB[index]);
            }

            voltageDataB = interpolatedData;
        }

        QString rawDataString = "[";

        for (int i = 0; i < points; ++i) {
            double time = i * timeStep;
            double distance = time * speed;
            double voltage = voltageDataB[i];

            QString pointData = QString("{\"objectName\"          :\"patthernB\","
                                        "\"distance\"       :%1," // Distance
                                        "\"voltage\"        :%2"  // Voltage
                                        "}")
                                    .arg(distance, 0, 'f', 6)
                                    .arg(voltage, 0, 'f', 6);

            rawDataString += pointData;

            if (i < points - 1) {
                rawDataString += ",";
            }
        }

        rawDataString += "]";

        QString rawdataArray = QString("{\"objectName\"  :\"patthernB\","
                                       "\"data\"         :%1}").arg(rawDataString);

//        qDebug() << "Full Jetson Package:" << rawdataArray;
        packageRawData(rawdataArray);
    }else if(getCommand.contains("getpatternPhaseC")) {
        qDebug() << "getpatternPhaseC:";
        double totalTime = 0.3333e-3;
        double totalDistance = 101.0;
        double speed = totalDistance / totalTime;
        int points = 101;
        double timeStep = totalTime / points;

        QVector<double> voltageDataC = {
            0, 200, 250, 350, 465, 660, 765, 990, 1250, 1420, 1550, 1650, 1750, 1800,
            1950, 2200, 1950, 1800, 1750, 1650, 1550, 1420, 1250, 990, 765, 660, 465, 350,
            200, 150, 150, 150, 160, 170, 180, 190, 200, 250, 300, 400, 500, 600, 800,
            1150, 950, 930, 900, 800, 700, 600, 500, 400, 300, 250, 200, 190, 170, 160,
            159, 158, 157, 156, 155, 154, 153, 152, 151, 150, 150, 151, 152, 180, 190,
            200, 250, 300, 350, 400, 500, 600, 400, 350, 300, 250, 200, 190, 180, 250,
            350, 480, 500, 550, 600, 550, 500, 400, 300, 200, 100, 150,
        };

        if (voltageDataC.size() != points) {
            qWarning() << "Voltage data size does not match the number of points. Rescaling...";

            QVector<double> interpolatedData;
            int originalSize = voltageDataC.size();
            QVector<int> originalIndices;
            for (int i = 0; i < originalSize; ++i) {
                originalIndices.append(i);
            }

            QVector<int> newIndices;
            for (int i = 0; i < points; ++i) {
                newIndices.append(i * (originalSize - 1) / (points - 1));
            }

            for (int i = 0; i < points; ++i) {
                int index = newIndices[i];
                interpolatedData.append(voltageDataC[index]);
            }

            voltageDataC = interpolatedData;
        }

        QString rawDataString = "[";

        for (int i = 0; i < points; ++i) {
            double time = i * timeStep;
            double distance = time * speed;
            double voltage = voltageDataC[i];

            QString pointData = QString("{\"objectName\"          :\"patthernC\","
                                        "\"distance\"       :%1," // Distance
                                        "\"voltage\"        :%2"  // Voltage
                                        "}")
                                    .arg(distance, 0, 'f', 6)
                                    .arg(voltage, 0, 'f', 6);

            rawDataString += pointData;

            if (i < points - 1) {
                rawDataString += ",";
            }
        }

        rawDataString += "]";

        QString rawdataArray = QString("{\"objectName\"  :\"patthernC\","
                                       "\"data\"         :%1}").arg(rawDataString);

//        qDebug() << "Full Jetson Package:" << rawdataArray;
        packageRawData(rawdataArray);
    }else if(getCommand.contains("getDatabuttonPhaseA")){
        qDebug() << "getDatabuttonPhaseA:";
        double totalTime = 0.3333e-3;
        double totalDistance = 101.0;
        double speed = totalDistance / totalTime;
        int points = 101;
        double timeStep = totalTime / points;

        QVector<double> voltageDataRawA = {
            0, 80, 150, 330, 400, 550, 660, 770, 990, 1150, 1350, 1550, 1600, 1550,
            1600, 1550, 1350, 1150, 990, 770, 660, 550, 400, 330, 150, 80, 90, 120,
            150, 150, 150, 150, 160, 170, 180, 190, 180, 170, 160, 150, 150, 150, 152,
            153, 155, 160, 200, 250, 280, 350, 400, 500, 400, 350, 250, 200, 190, 150,
            152, 153, 154, 155, 155, 154, 153, 152, 200, 250, 350, 400, 500, 600, 700,
            800, 900, 1150, 1280, 1390, 1280, 1150, 900, 800, 700, 600, 500, 400, 350, 400,
            250, 200, 150, 154, 153, 154, 152, 154, 150, 154, 151, 150, 150
        };

        if (voltageDataRawA.size() != points) {
            qWarning() << "Voltage data size does not match the number of points. Rescaling...";

            QVector<double> interpolatedData;
            int originalSize = voltageDataRawA.size();
            QVector<int> originalIndices;
            for (int i = 0; i < originalSize; ++i) {
                originalIndices.append(i);
            }

            QVector<int> newIndices;
            for (int i = 0; i < points; ++i) {
                newIndices.append(i * (originalSize - 1) / (points - 1));
            }

            for (int i = 0; i < points; ++i) {
                int index = newIndices[i];
                interpolatedData.append(voltageDataRawA[index]);
            }

            voltageDataRawA = interpolatedData;
        }

        QString rawDataString = "[";

        for (int i = 0; i < points; ++i) {
            double time = i * timeStep;
            double distance = time * speed;
            double voltage = voltageDataRawA[i];

            QString pointData = QString("{\"objectName\"          :\"RawdataA\","
                                        "\"distance\"       :%1," // Distance
                                        "\"voltage\"        :%2"  // Voltage
                                        "}")
                                    .arg(distance, 0, 'f', 6)
                                    .arg(voltage, 0, 'f', 6);

            rawDataString += pointData;

            if (i < points - 1) {
                rawDataString += ",";
            }
        }

        rawDataString += "]";

        QString rawdataArray = QString("{\"objectName\"  :\"RawdataA\","
                                       "\"packageRawDataA\"         :%1}").arg(rawDataString);

//        qDebug() << "Full Jetson Package:" << rawdataArray;
        packageRawData(rawdataArray);
    }else if(getCommand.contains("getDatabuttonPhaseB")){
        qDebug() << "getDatabuttonPhaseB:";
        double totalTime = 0.3333e-3;
        double totalDistance = 101.0;
        double speed = totalDistance / totalTime;
        int points = 101;
        double timeStep = totalTime / points;

        QVector<double> voltageDataRawB = {
            0, 80, 150, 330, 400, 550, 660, 770, 990, 1150, 1350, 1550, 1600, 1550,
            1600, 1550, 1350, 1150, 990, 770, 660, 550, 400, 330, 150, 80, 90, 120,
            150, 150, 150, 150, 160, 170, 180, 190, 180, 170, 160, 150, 150, 150, 152,
            153, 155, 160, 200, 250, 280, 350, 400, 500, 400, 350, 250, 200, 190, 150,
            152, 153, 154, 155, 155, 154, 153, 152, 200, 250, 350, 400, 500, 600, 700,
            800, 900, 1150, 1280, 1390, 1280, 1150, 900, 800, 700, 600, 500, 400, 350, 400,
            250, 200, 150, 154, 153, 154, 152, 154, 150, 154, 151, 150, 150
        };

        if (voltageDataRawB.size() != points) {
            qWarning() << "Voltage data size does not match the number of points. Rescaling...";

            QVector<double> interpolatedData;
            int originalSize = voltageDataRawB.size();
            QVector<int> originalIndices;
            for (int i = 0; i < originalSize; ++i) {
                originalIndices.append(i);
            }

            QVector<int> newIndices;
            for (int i = 0; i < points; ++i) {
                newIndices.append(i * (originalSize - 1) / (points - 1));
            }

            for (int i = 0; i < points; ++i) {
                int index = newIndices[i];
                interpolatedData.append(voltageDataRawB[index]);
            }

            voltageDataRawB = interpolatedData;
        }

        QString rawDataString = "[";

        for (int i = 0; i < points; ++i) {
            double time = i * timeStep;
            double distance = time * speed;
            double voltage = voltageDataRawB[i];

            QString pointData = QString("{\"objectName\"          :\"RawdataB\","
                                        "\"distance\"       :%1," // Distance
                                        "\"voltage\"        :%2"  // Voltage
                                        "}")
                                    .arg(distance, 0, 'f', 6)
                                    .arg(voltage, 0, 'f', 6);

            rawDataString += pointData;

            if (i < points - 1) {
                rawDataString += ",";
            }
        }

        rawDataString += "]";

        QString rawdataArray = QString("{\"objectName\"  :\"RawdataB\","
                                       "\"packageRawDataB\"         :%1}").arg(rawDataString);

//        qDebug() << "Full Jetson Package:" << rawdataArray;
        packageRawData(rawdataArray);
    }else if(getCommand.contains("getDatabuttonPhaseC")){
        qDebug() << "getDatabuttonPhaseC:";
        double totalTime = 0.3333e-3;
        double totalDistance = 101.0;
        double speed = totalDistance / totalTime;
        int points = 101;
        double timeStep = totalTime / points;

        QVector<double> voltageDataRawC = {
            0, 50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750,
            700, 650, 600, 550, 500, 450, 400, 350, 300, 250, 200, 150, 100, 50, 0, 50,
            100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750, 800, 850,
            800, 750, 700, 650, 600, 550, 500, 450, 400, 350, 300, 250, 200, 150, 100, 50,
            0, 50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750,
            800, 850, 900, 950, 1000, 950, 900, 850, 800, 750, 700, 650, 600, 550, 500, 450,
            400, 350, 300, 250, 200, 150, 100
        };

        if (voltageDataRawC.size() != points) {
            qWarning() << "Voltage data size does not match the number of points. Rescaling...";

            QVector<double> interpolatedData;
            int originalSize = voltageDataRawC.size();
            QVector<int> originalIndices;
            for (int i = 0; i < originalSize; ++i) {
                originalIndices.append(i);
            }

            QVector<int> newIndices;
            for (int i = 0; i < points; ++i) {
                newIndices.append(i * (originalSize - 1) / (points - 1));
            }

            for (int i = 0; i < points; ++i) {
                int index = newIndices[i];
                interpolatedData.append(voltageDataRawC[index]);
            }

            voltageDataRawC = interpolatedData;
        }

        QString rawDataString = "[";

        for (int i = 0; i < points; ++i) {
            double time = i * timeStep;
            double distance = time * speed;
            double voltage = voltageDataRawC[i];

            QString pointData = QString("{\"objectName\"          :\"RawdataC\","
                                        "\"distance\"       :%1," // Distance
                                        "\"voltage\"        :%2"  // Voltage
                                        "}")
                                    .arg(distance, 0, 'f', 6)
                                    .arg(voltage, 0, 'f', 6);

            rawDataString += pointData;

            if (i < points - 1) {
                rawDataString += ",";
            }
        }

        rawDataString += "]";

        QString rawdataArray = QString("{\"objectName\"  :\"RawdataC\","
                                       "\"packageRawDataC\"         :%1}").arg(rawDataString);

    //    qDebug() << "Full Jetson Package:" << rawdataArray;
        packageRawData(rawdataArray);
    }


}

void Database::cleanDataInGraph(QString msg) {
    qDebug() << "cleanDataInGraph:" << msg;
    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();
    QString getCommand = QJsonValue(command["objectName"]).toString();

    if (getCommand.contains("clearpatternPhaseA")) {
        qDebug() << "Clearing data for Phase A";
        QVector<double> voltageDataA;
        QString rawDataString = "[]";

        QString rawdataArray = QString("{\"objectName\"  :\"clearpatternPhaseA\","
                                       "\"dataA\"         :%1}").arg(rawDataString);

        emit packageRawData(rawdataArray);
    } else if (getCommand.contains("clearpatternPhaseB")) {
        qDebug() << "Clearing data for Phase B";
        QVector<double> voltageDataB;
        QString rawDataString = "[]";

        QString rawdataArray = QString("{\"objectName\"  :\"clearpatternPhaseB\","
                                       "\"dataB\"         :%1}").arg(rawDataString);

        emit packageRawData(rawdataArray);
    } else if (getCommand.contains("clearpatternPhaseC")) {
        qDebug() << "Clearing data for Phase C";
        QVector<double> voltageDataC;
        QString rawDataString = "[]";

        QString rawdataArray = QString("{\"objectName\"  :\"clearpatternPhaseC\","
                                       "\"dataC\"         :%1}").arg(rawDataString);

        qDebug() << "Clearing Patthern for Phase C" << rawdataArray;
        emit packageRawData(rawdataArray);
    } else if(getCommand.contains("clearDatabuttonPhaseA")){
        qDebug() << "Clearing data for Phase A";
        QVector<double> voltageDataA;
        QString rawDataString = "[]";

        QString rawdataArray = QString("{\"objectName\"  :\"clearGraphDataPhaseA\","
                                       "\"cleardataA\"         :%1}").arg(rawDataString);

        qDebug() << "Clearing Pattern for Phase A" << rawdataArray;
        emit packageRawData(rawdataArray);
    }else if(getCommand.contains("clearDatabuttonPhaseB")){
        qDebug() << "Clearing data for Phase B";
        QVector<double> voltageDataB;
        QString rawDataString = "[]";

        QString rawdataArray = QString("{\"objectName\"  :\"clearGraphDataPhaseB\","
                                       "\"cleardataB\"         :%1}").arg(rawDataString);

        qDebug() << "Clearing Pattern for Phase B" << rawdataArray;
        emit packageRawData(rawdataArray);
    }else if(getCommand.contains("clearDatabuttonPhaseC")){
        qDebug() << "Clearing data for Phase C";
        QVector<double> voltageDataC;
        QString rawDataString = "[]";

        QString rawdataArray = QString("{\"objectName\"  :\"clearGraphDataPhaseC\","
                                       "\"cleardataC\"         :%1}").arg(rawDataString);

        qDebug() << "Clearing Pattern for Phase C" << rawdataArray;
        emit packageRawData(rawdataArray);
    }
}


//void Database::getRawData(QString msg) {
//    qDebug() << "getRawData:" << msg;

//    double totalTime = 0.3333e-3;
//    double totalDistance = 100.0;
//    double speed = totalDistance / totalTime;
//    int points = 100;

//    double timeStep = totalTime / points;

//    QVector<double> voltageData = {
//        0, 100, 150, 330, 465, 660, 765, 990, 1150, 1320, 1450, 1650, 1750, 1800,
//        1750, 1650, 1450, 1320, 1150, 990, 765, 660, 465, 330, 150, 165, 175, 160,
//        150, 150, 150, 150, 160, 170, 180, 190, 200, 250, 300, 400, 500, 600, 800,
//        990, 950, 930, 900, 800, 700, 600, 500, 400, 300, 250, 200, 190, 170, 160,
//        159, 158, 157, 156, 155, 154, 153, 152, 151, 150, 150, 151, 152, 180, 190,
//        200, 250, 300, 350, 400, 350, 300, 250, 200, 180, 160, 170, 180, 190, 250,
//        350, 480, 600, 700, 800, 700, 600, 500, 450, 350, 200, 150
//    };

//    if (voltageData.size() != points) {
//        qWarning() << "Voltage data size does not match the number of points. Rescaling...";
//        voltageData.resize(points);
//    }

//    QString rawDataString = "[";

//    for (int i = 0; i < points; ++i) {
//        double time = i * timeStep;
//        double distance = time * speed;
//        double voltage = voltageData[i];

//        QString pointData = QString("{\"objectName\"          :\"RawData\","
//                                    "\"distance\"       :%1," // Distance
//                                    "\"voltage\"        :%2"  // Voltage
//                                    "}")
//                                .arg(distance, 0, 'f', 6)
//                                .arg(voltage, 0, 'f', 6);

//        rawDataString += pointData;

//        if (i < points - 1) {
//            rawDataString += ",";
//        }
//    }

//    rawDataString += "]";

//    QString rawdataArray = QString("{\"objectName\"  :\"RawData\","
//                                   "\"data\"         :%1}").arg(rawDataString);

//    qDebug() << "Full Jetson Package:" << rawdataArray;
//    packageRawData(rawdataArray);
//}


void Database::userMode(QString msg) {
    qDebug() << "userMode:" << msg;

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
        db.close();
        if (!db.open()) {
            qDebug() << "Failed to open database:" << db.lastError().text();
            db.close();
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

                // Debug ค่าของตัวแปร
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
        db.close();
        if (!db.open()) {
            qDebug() << "Failed to open database:" << db.lastError().text();
            db.close();
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

                   // Debug ค่าของตัวแปร
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
        db.close();
        if (!db.open()) {
            qDebug() << "Failed to open database:" << db.lastError().text();
            db.close();
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
    db.close();
}

void Database::DistanceandDetailPhaseA(QString msg) {
    qDebug() << "DistanceandDetailPhaseA:" << msg;

    // Ensure the database is open
    if (!db.isOpen()) {
        qDebug() << "Database is not open. Attempting to open.";
        db.close();
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

        // Fetch the maximum temp_no for the given phase
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

        // Insert the new data
        query.prepare("INSERT INTO DataTagging (status, `Distance(Km)`, Detail, Phase, temp_no) "
                      "VALUES (:status, :distance, :detail, :phase, :temp_no)");

        query.bindValue(":status", 0);
        query.bindValue(":distance", distancecmd);
        query.bindValue(":detail", detailcmd);
        query.bindValue(":phase", phase);
        query.bindValue(":temp_no", newTempNo);

        if (!query.exec()) {
            qDebug() << "Failed to insert data:" << query.lastError().text();
            db.close();  // Close the database to avoid leaving it in an undefined state
            return;
        }

        qDebug() << "Data inserted successfully with temp_no:" << newTempNo;

//        QThread::msleep(150);
        QString tableTaggingPhaseA = QJsonValue(command["tableTaggingPhaseA"]).toString();
        QString getTaggingPhaseA = QString("{"
                                           "\"objectName\":\"TaggingPhaseA\","
                                           "\"tableTaggingPhaseA\":\"%1\""
                                           "}").arg(tableTaggingPhaseA);

        qDebug() << "getTaggingPhaseA:" << getTaggingPhaseA;
        getMySqlPhaseA(getTaggingPhaseA);
    }

    // Ensure the database is closed if it is no longer needed
    db.close();
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
    db.close();
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
    db.close();

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
            db.close();
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
            db.close();
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
            db.close();
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
        db.close();
        qDebug() << "Database connection closed.";
    }
}


void Database::closeMySQL() {
    if (db.isOpen()) {
        qDebug() << "Database is open. Closing all connections...";
        db.close();
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
        db.close();
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

    db.close();
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
    db.close();
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
            db.close();            return;
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
            db.close();
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
            db.close();
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

    db.close();
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
            db.close();            return;
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
            db.close();
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
            db.close();
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

    db.close();
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
            db.close();
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
            db.close();
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
            db.close();
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

    db.close();
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
            db.close();
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
            db.close();
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
            db.close();
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
        db.close();
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
    db.close();
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
            db.close();
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
            db.close();
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
            db.close();
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
        db.close();
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
    db.close();
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
            db.close();
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
            db.close();
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
            db.close();
            return;
        }
        qDebug() << "Auto-filled first" << marginC << " rows with valueVoltageC:" << valueVoltageC;
    }

    QSqlQuery selectQuery(db);
    selectQuery.prepare("SELECT No, `Margin(No.)`, `value of margin`, unit FROM MarginTableC WHERE No <= :marginC");
    selectQuery.bindValue(":marginC", marginC);

    if (!selectQuery.exec()) {
        qDebug() << "Error: Unable to retrieve MarginTableC data" << selectQuery.lastError().text();
        db.close();
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
    db.close();
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

    // ✅ Store received values until all are available
    static int receivedVoltage = 0;
    static QString receivedSubstation = "";
    static QString receivedDirection = "";
    static int receivedLineNo = 0;

    static bool hasVoltage = false;
    static bool hasSubstation = false;
    static bool hasDirection = false;
    static bool hasLineNo = false;

    // ✅ Convert msg into JSON
    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    if (d.isNull() || !d.isObject()) {
        qDebug() << "Invalid JSON format!";
        return;
    }

    QJsonObject command = d.object();

    // ✅ Store received values but do not update until all are received
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

    // ✅ If all values are received, update the database and send JSON
    if (hasVoltage && hasSubstation && hasDirection && hasLineNo) {
        qDebug() << "All values received, updating database...";

        // ✅ Open the database
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

        // ✅ Pack updated values as JSON
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

        // ✅ Call ToShowSettingInfo to verify and send final JSON
        ToShowSettingInfo(getSettingInfo);

        // ✅ Close the database
        db.close();
        qDebug() << "Database closed successfully.";

        // ✅ Reset received data flags
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

     db.close();
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
    db.close();

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
        db.close();
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
    db.close();
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
    db.close();

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
    db.close();
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
    db.close();
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
    db.close();

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
        db.close();
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
    db.close();
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
    db.close();
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
    db.close();
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
    db.close();
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
    db.close();
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
    db.close();
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
    db.close();

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

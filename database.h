#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QSqlDatabase>
#include <QtSql>
#include <QString>
#include <QWebSocket>
class Database : public QObject
{
    Q_OBJECT
public:
    explicit Database(QString dbName, QString user, QString password, QString host, QObject *parent = nullptr);
    bool database_createConnection();
    bool passwordVerify(QString password);
    void genHashKey();
    void hashletPersonalize();
    bool checkHashletNotData();
    void insertNewAudioRec(QString filePath, QString radioEvent);
    void updateAudioRec(QString filePath, float avg_level, float max_level);
    bool getLastEventCheckAudio(int time, int percentFault, int lastPttMinute);
    QString getNewFile(int warnPercentFault);
    qint64 getStandbyDuration();
    void removeAudioFile(int lastMin);
    int currentFileID = 0;
    QString loadlog = "load_";
    QString filelog;
    QString logdata;
    int Serial_ID;
    bool isCheck = false;

signals:
    void audioFault(bool fault);
    void setupinitialize(QString);
    void databaseError();
    void eventmsg(QString);
    void cmdmsg(QString);
    void deletedmydatabase(QString);
    void updateTableDisplay(QString);
    void updatedataTableA(QString message);
    void updatedataTableB(QString message);
    void updatedataTableC(QString message);
    void updataEditDataA(QString);
    void listOfMarginA(QString);
    void listOfMarginB(QString);
    void listOfMarginC(QString);
    void updateThresholdA(QString);
    void updateThresholdB(QString);
    void updateThresholdC(QString);
    void UpdateSettingInfo(QString);
    void UpdatepreiodicInfo(QString);
    void packageRawData(QString);
    void cursorPosition(QString);
    void positionCursorChange(QString);
    void updatanewdistance(QString);
    void showtaggingpoint(QString);
    void SetNetworkSNMP(QString);
    void updateDisplaySetting(QString);
    void settingDisplayInfo(QString);
    void sendMarginUpdate(QString);
    void showUpdateInfoSetting(QString);
    void sendUpdatedMarginList(QString);
    void sendUpdatedMarginListB(QString);
    void sendUpdatedMarginListC(QString);
//--------------------------------------------------------------------//
    void MydataBaseToCpp(QString);

public slots:
    void getEventandAlarm(QString msg);
    void DistanceandDetailPhaseA(QString msg);
    void DistanceandDetailPhaseB(QString msg);
    void DistanceandDetailPhaseC(QString msg);
    void getMySqlPhaseA(QString msg);
    void getMySqlPhaseB(QString msg);
    void getMySqlPhaseC(QString msg);
    void deletedDataMySQLPhaseA(QString msg);
    void deletedDataMySQLPhaseB(QString msg);
    void deletedDataMySQLPhaseC(QString msg);
    void updateDataBaseDisplay(QString msg);
    void updateTablePhaseA(QString);
    void updateTablePhaseB(QString);
    void updateTablePhaseC(QString);

    void edittingMysqlA(QString);
    void closeMySQL();

    void configParemeterMarginA(QString);
    void configParemeterMarginB(QString);
    void configParemeterMarginC(QString);

    void configParemeterThreshold(QString);

    void getThreshold();

    void getSettingInfo();
    void updateSettingInfo(QString);
    void ToShowSettingInfo(QString);

    void getpreiodicInfo();

    void getUpdatePeriodic(QString);

    void getUpdateWeekly(QString);

    void userMode(QString);
    void getUpdateUserMode();

    void storeStatusAux(QString);
    void getRawData(QString);
    void getPositionDistance(QString);

    void controlCursor(QString);
    void getChangeDistance(QString);
    void updateDistance(double);
    void taggingpoint(QString);
    void updataStatusTagging(int,bool);
    void cleanDataInGraph(QString);
    void SettingNetworkSNMP(QString);
    void SettingDisplay(QString);
    void GetSettingDisplay();
    void calculateDisplay(double);
    void UpdateMarginSettingParameter(QString);
    void updateMargin();
    void updataListOfMarginA(QString);
    void updataListOfMarginB(QString);
    void updataListOfMarginC(QString);

    ////////////////////pattern datastorage//////////////////////////
    void getdatapatternDataDb();
    void sortByName(bool ascending,const QString &categoryName);
    void sortByDate(bool descending,const QString &categoryDate);
    void searchByName(const QString &name, const QString &categoryName);
    void searchByDate(const QString &date, const QString &categoryDate);
    void patternDataDb(QSqlQuery query);
    // void getdataStorage(QString &category);
//    void emitEvent();

private:
    QSqlDatabase db;
    bool verifyMac();
    QString getPassword();
    qint64 getTimeDuration(QString filePath);
    void getLastEvent();
    void startProject(QString filePath, QString radioEvent);

    QString getSerial();
    QStringList getMac();
    void updateHashTable(QString mac, QString challenge ,QString meta, QString serial, QString password);
    QString mySQL;
    QString IPaddress;
    QString GateWsys;
    QString snmpIP;
    QString timeServer;
    QString plcDoError;
    QString plcDiError;
    QString hispeedPhaseA;
    QString hispeedPhaseB;
    QString hispeedPhaseC;
    QString commuPhaseA;
    QString commuPhaseB;
    QString commuPhaseC;
    QString gpsModule;
    QString systemInti;
    QString commuError;
    QString relayStart;
    QString surageStart;
    QString preiodicStart;
    QString manualTest;
    QString lflfail;
    QString lfloperate;
private slots:
    void reloadDatabase();
//    void getEventandAlarm(QString msg);
};

#endif // DATABASE_H

#ifndef MAINWINDOWS_H
#define MAINWINDOWS_H
#include <QTimer>
#include <QDateTime>
#include <QString>
#include <QStringList>
#include <QFileInfoList>
#include <QDir>
#include <QSettings>
#include <database.h>
#include "ChatServer.h"
#include "QWebSocket"
#include <iostream>
#include <sstream>
#include <fstream>
#include <dirent.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <QProcess>
#include <QCoreApplication>
#include <SocketClient.h>
#include <screencapture.h>
#include <vector>
#include <algorithm>
#include <QFile>
#include <QTextStream>
#include <QPointer>
#include <QtMath>
#include <QTextStream>
#include <QGuiApplication>

#include <QNetworkInterface>
#include <QHostAddress>

#include <QScreen>
#include <QPixmap>

#define SwVersion "V0.2 26122024"
#define HwVersion "Raspberry Pi"
#define HwName "Monitor"
#define PATH_BIN "/opt/OpenPLC/bin/"
#define PATH_UPDATE "/home/pi/update_firmware/OpenPLC"
#define PATH_DOWNLOAD "/home/pi/update_firmware"
#define USERS "pi"
#define PASSWORD "11111"
#define IP_ADDRESS "192.168.10.52"
#define FILES "/opt/OpenPLC/bin/OpenPLC"
#define FILESETTINGMASTER "/home/pi/.config/monitor/master.ini"
#define FILESETTINGSLAVE "/home/pi/.config/monitor/slave.ini"
#define NETWORK_SERVER "NETWORK"
#define SNMP_SERVER "SNMP_SERVER"
#define TIME_SERVER "TIME_SERVER"
typedef int		pj_status_t;
class mainwindows : public QObject
{
    Q_OBJECT

signals:
     void getEventandAlarm(QString msg);
     void cppCommand(QVariant jsonMsg);
     void getDistanceandDetailA(QString msg);
     void getDistanceandDetailB(QString msg);
     void getDistanceandDetailC(QString msg);
     void getTablePhaseA(QString msg);
     void getTablePhaseB(QString msg);
     void getTablePhaseC(QString msg);
     void updateTablePhaseA(QString msg);
     void updateTablePhaseB(QString msg);
     void updateTablePhaseC(QString msg);
     void deletedMySQLA(QString msg);
     void deletedMySQLB(QString msg);
     void deletedMySQLC(QString msg);
     void getEditDatafromMySQLA(QString msg);
     void parameterMarginA(QString msg);
     void parameterMarginB(QString msg);
     void parameterMarginC(QString msg);
     void parameterThreshold(QString msg);
     void getDataThreshold();
     void settingGeneral();
     void preiodicSetting();
     void updateTimer(QString);
     void updateWeekly(QString);
     void updateUser(QString);
     void updateRelay(QString);
     void rawdataPlot(QString);
     void cursorDistance(QString);
     void moveCursor(QString);
     void changeDistanceRange(QString);
     void sendToSocket(QString);
     void taggingpoint(QString);
     void clearDisplay(QString);
     void clearPatternGraph(QString);
     void settingNetWorkandSNMP(QString);
     void settingdisplay(QString);
     void getsettingdisplay();
     void plotingDataPhaseA(QString);
     void plotingDataPhaseB(QString);
     void plotingDataPhaseC(QString);
     void sendMessage(QString);
     void UpdateMarginSettingParameter(QString);
     void getMarginUpdate();
     void updateDisplayInfoSetting(QString);
     void updataListOfMarginA(QString);
     void updataListOfMarginB(QString);
     void updataListOfMarginC(QString);
     void SettingAndUpdateMargin(QString);

     ////////////////////pattern datastorage//////////////////////////
     void getdatapatternDataDb();
     void sortnamePattern(bool Sort, const QString &categoryName);
     void sortdatePattern(bool Sort, const QString &categoryDate);
     void searchByName(const QString &name, const QString &categoryName);
     void searchByDate(const QString &date, const QString &categoryDate);
     void ButtonPattern(QString);
     // void sendMessage(QString);
     void captureScreenshot();


public:
    explicit mainwindows(QObject *parent = nullptr);
    static mainwindows *instance();

    static void* ThreadFuncA(void* pTr);
    static void* ThreadFuncB(void* pTr);
    static void* ThreadFuncC(void* pTr);

    void startThreads(double sagFactorInit, double samplingRateInit, double distanceToStartInit,
                      double distanceToShowInit, double fulldistance, double thresholdInitA,
                      double thresholdInitB, double thresholdInitC);

public slots:
//    void boardcasttomessaege(QString msg);
//    void receivemessaege(QString msg);
    void cppSubmitTextFiled(QString qmlJson);
    void ServerCommand(QString qmlJson);

    QString getSystemDateTime();
    void updateDateTime();
    void connectToPLC();
    void reconnectTimerTimeout();
    void connectTimeOut();
    void calculate(QString);
    void manualtest(QString);
    void patterntest(int);
    void plotGraphA(double,double,double,double,double,double);
    void plotGraphB(double,double,double,double,double,double);
    void plotGraphC(double,double,double,double,double,double);
    void plotPatternA(double,double,double,double,double,double);
    void plotPatternB(double,double,double,double,double,double);
    void plotPatternC(double,double,double,double,double,double);
    void reSamplingNormalizationA(const std::vector<std::pair<float, float>>& result);
    void reSamplingNormalizationB(const std::vector<std::pair<float, float>>& result);
    void reSamplingNormalizationC(const std::vector<std::pair<float, float>>& result);
    void reSamplingNormalizationPatternA(const std::vector<std::pair<float, float>>& result);
    void reSamplingNormalizationPatternB(const std::vector<std::pair<float, float>>& result);
    void reSamplingNormalizationPatternC(const std::vector<std::pair<float, float>>& result);
    void RecalculateWithMargin(QString);
    void getSetting();
    void updateNetwork();
    void captureScreenshotseand();
private:
    ChatServer *SocketServer;
    Database *mysql;
    SocketClient *client;
    ImageProvider* screenShot;
    QString serverAddress;
    int serverPort;
    QTimer *reconnectTimer;
    QTimer *Timer;
    QTimer *TimerVerify;

    double sagFactor = 0.0;       // SAG factor
    double samplingRate = 0.0; // Sampling rate (meters per sample)
    double distanceToStart = 0.0; // ระยะตั้งต้น (เมตร)
    double distanceToShow = 0.0;   // ระยะปลายทาง (เมตร)
    double fulldistance = 0.0;
    double thresholdA = 0.0;
    double thresholdB = 0.0;
    double thresholdC = 0.0;
    double distancePointBetweenPoint = 60.0f;
    bool isVersion = false;
    double offset;
    int point;
    double valuetheshold; //เป็นตัวแปรที่เปลี่ยนแปลงได้
    int samplingrate; //เป็นตัวแปรที่เปลี่ยนแปลงได้ 225
    double SAG; //0.983
    double speedOfligth = 3e8; //m/s
    double timeWholepoint = 200e-9; //s
    double distance = (speedOfligth * timeWholepoint)/100;
    int initiation;//km เป็นตัวแปรที่เปลี่ยนแปลงได้
    double destination;//=8500/distance;//km เป็นตัวแปรที่เปลี่ยนแปลงได้
    int totalpoint = destination - initiation;     //1จุดห่างกัน60เมตร
    int sagfactor;
    int resamplingpoint; //= samplingrate % sagfactor
    double totalDurationOfData = 2e-3;
    double durationofTime;
    QString rawdataArrayA;
    QString rawdataArrayB;
    QString rawdataArrayC;
    QString temp;
    QString temp2;
    QString temp3;
    int count=0;
    int count2=0;
    int count3=0;
    bool enablePhaseA=false;
    bool enablePhaseB=false;
    bool enablePhaseC=false;
    QString cppManual;
    QString cppPattern;
    double pointsPerWave;
    int thelistNumOfMarginA;
    int thelistNumOfMarginB;
    int thelistNumOfMarginC;


    struct Network{
        // network
        QString dhcpmethod;
        QString ip_address = "127.0.0.1";
        QString subnet;
        QString ip_gateway = "";
        QString pridns;
        QString secdns;
        QString phyName = "eth0";

        QString ip_snmp = "";
        QString location_snmp = "";

        QString ip_timeserver = "";

        void printinfo(){
            qDebug() << "dhcpmethod:" << dhcpmethod << " ip_address:" << ip_address
                     << " subnet:" << subnet << " ip_gateway:" << ip_gateway << " pridns:" << pridns
                     << " secdns:" << secdns << " phyName:" << phyName << " ip_timeserver:" << ip_timeserver;
        }
    };
    Network *networks;
    pthread_t idThreadA, idThreadB, idThreadC;

    struct ThreadData {
        mainwindows* instance;
        double sagFactorInit;
        double samplingRateInit;
        double distanceToStartInit;
        double distanceToShowInit;
        double fulldistance;
        double thresholdInit;
    };

    ThreadData dataA, dataB, dataC;

    int storedVoltage = 0;
    QString storedSubstation = "";
    QString storedDirection = "";
    int storedLineNo = 0;

    bool hasVoltage = false;
    bool hasSubstation = false;
    bool hasDirection = false;
    bool hasLineNo = false;

    bool isFirstEvent_DO = true;
    bool isFirstEvent_DI = true;
    bool isFirstEvent_PHASE_A_ERROR = true;
    bool isFirstEvent_PHASE_B_ERROR = true;
    bool isFirstEvent_PHASE_C_ERROR = true;
    bool isFirstEvent_GPS_MODULE = true;
    bool isFirstEvent_SYSTEM_INITIAL = true;
    bool isFirstEvent_COMMUNICATION_ERROR = true;
    bool isFirstEvent_RELAY_START_EVENT = true;
    bool isFirstEvent_SURGE_START_EVENT = true;
    bool isFirstEvent_PERIODIC_TEST_EVENT = true;
    bool isFirstEvent_MANUAL_TEST_EVENT = true;
    bool isFirstEvent_LFL_FAIL = true;
    bool isFirstEvent_LEL_OPERATE = true;

    bool previousStates_DO = false;
    bool previousStates_DI = false;
    bool previousStates_PHASE_A_ERROR = false;
    bool previousStates_PHASE_B_ERROR = false;
    bool previousStates_PHASE_C_ERROR = false;
    bool previousStates_GPS_MODULE = false;
    bool previousStates_SYSTEM_INITIAL = false;
    bool previousStates_COMMUNICATION_ERROR = false;
    bool previousStates_RELAY_START_EVENT = false;
    bool previousStates_SURGE_START_EVENT = false;
    bool previousStates_PERIODIC_TEST_EVENT = false;
    bool previousStates_MANUAL_TEST_EVENT = false;
    bool previousStates_LFL_FAIL = false;
    bool previousStates_LEL_OPERATE = false;
};

#endif // MAINWINDOWS_H

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
#include "NetworkMng.h"
#include <QNetworkInterface>
#include <QNetworkAddressEntry>
#include <QHostAddress>
#include <algorithm>
#include <QScreen>
#include <QPixmap>
#include "FileDownloader.h"
#include <QVariantList>
#include <QRegularExpression>
#include <QtCharts/QChartView>
#include <QtCharts/QLineSeries>
#include <QtCharts/QDateTimeAxis>
#include <QtCharts/QCategoryAxis>
#include <QDateTime>
#include <QtQuick/QQuickPaintedItem>
#include <QColor>
#include <QObject>
#include <QAbstractSeries>
#include <QScreen>
#include <QPixmap>
#include <QSaveFile>
#include <QImageReader>
#include <QFileInfo>
#include <QProcess>
#include <QThread>
#include <QDateTime>
#include <QJsonObject>
#include <QJsonDocument>
#include <webserver.h>
#include "peerws.h"
#include <sys/statvfs.h>
#include <unistd.h>
#include <pthread.h>
#include <atomic>
#include <QMetaObject>
#include <QFile>
#include <QVariantList>
#include <QPointF>
#include <unistd.h>
#if defined(__GLIBC__)
#include <malloc.h>
#endif

#define HwVersion "Raspberry Pi"
#define HwName "Monitor"
//#define HwNameVNC "MonitorVNC"
#define PATH_BIN "/opt/OpenPLC/bin/"
#define PATH_UPDATE "/home/pi/update_firmware/OpenPLC"
#define PATH_DOWNLOAD "/home/pi/update_firmware"
#define USERS "pi"
#define PASSWORD "11111"
#define IP_ADDRESS "192.168.10.52"
#define FILES "/opt/OpenPLC/bin/OpenPLC"
//#define FILESETTINGMASTER "/home/pi/.config/monitor"
//#define FILESETTINGSLAVE "/home/pi/.config/monitor"
#define FILESETTINGMASTER "/home/pi/.config/monitor/master.ini"
#define FILESETTINGSLAVE "/home/pi/.config/monitor/slave.ini"
#define NETWORK_SERVER "NETWORK"
#define SNMP_SERVER "SNMP_SERVER"
#define TIME_SERVER "TIME_SERVER"
#define USER_MODE "USER"
#define USER_TYPE "USER_TYPE"
//#define FILESETTINGIPNETWORK "/home/pi/.config/monitor/"
//#define FILESETTING "/etc/systemd/"
#define FILESETTINGIPNETWORK "/home/pi/.config/monitor/IPnetwork.ini"
#define FILESETTING "/etc/systemd/timesyncd.conf"


#ifdef Q_OS_UNIX
  #include <unistd.h>   // for ::sync()
#endif
QT_CHARTS_USE_NAMESPACE

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
     void getStatusOfButtonHidding();
     void updateStatusOfButtonHidding(QString);
     void updateMasterMode(QString,QString,QString,QString);
     void sendToWeb(QString);
     void updateIpNetwork(QString,QString,QString,QString,QString);
     void sendToServer(QString);
     void taggingVoltageFound(const QString &replyJson);
     void positionCursorChange(QString);
     void broadcastMessage(QString);
     void updateMasterMode(QString);
//======================Message to display================================
     void sendDisplay(QString);

public:
     ~mainwindows();

    static void* ThreadFuncClearCache(void* pTr);
    Q_INVOKABLE void clearAppCache();

    std::atomic_bool clearCacheThreadRunning{true};
    bool clearCacheThreadStarted = false;
    pthread_t idThreadClearCache;

    std::atomic_bool loopGetInfoRunning{true};
    std::atomic_bool removeFileThreadRunning{true};
    bool peerSignalsConnected = false;

    QObject* m_root;
    ChatServer *SocketServer;
    Database *mysql;
    SocketClient *client,*clientNetwork, *clientNetworkIP;
    ImageProvider* screenShot;
    WebServer *wedSocket;
    PeerWs *peer = nullptr;
    explicit mainwindows(QString platform, QObject *parent = nullptr);
    static mainwindows *instance();
    void loopGetInfo();
    QString lastGetCurrentTime = "";

    static void* ThreadFuncRemoveFile(void* pTr);
    typedef void * (*THREADFUNCPTRREMOVEFILE)(void *);
    pthread_t idThread5;

    bool removedBootFiles = false;
    QString lastPicCleanupDate = "";

    static void* ThreadFunc(void* pTr);
    typedef void * (*THREADFUNCPTR)(void *);
    pthread_t idThread;

    static void* ThreadFunc4(void* pTr);
    typedef void * (*THREADFUNCPTR4)(void *);
    pthread_t idThread4;

    static void* ThreadFuncA(void* pTr);
    static void* ThreadFuncB(void* pTr);
    static void* ThreadFuncC(void* pTr);

    void startThreads(double sagFactorInit, double samplingRateInit, double distanceToStartInit,
                      double distanceToShowInit, double fulldistance, double thresholdInitA,
                      double thresholdInitB, double thresholdInitC);
    QVector<QPointF> pointsA;
    QVector<QPointF> pointsB;
    QVector<QPointF> pointsC;
    Q_INVOKABLE void getLineSeriesA(QObject *qmlReceiver);
    Q_INVOKABLE void getLineSeriesB(QObject *qmlReceiver);
    Q_INVOKABLE void getLineSeriesC(QObject *qmlReceiver);

//    Q_INVOKABLE void getLineSeriesA(QAbstractSeries *series);
//    Q_INVOKABLE void getLineSeriesB(QAbstractSeries *series);
//    Q_INVOKABLE void getLineSeriesC(QAbstractSeries *series);
    QVector<QPointF> pointsPA;
    QVector<QPointF> pointsPB;
    QVector<QPointF> pointsPC;
//    Q_INVOKABLE void getLineSeriesPA(QAbstractSeries *series);
//    Q_INVOKABLE void getLineSeriesPB(QAbstractSeries *series);
//    Q_INVOKABLE void getLineSeriesPC(QAbstractSeries *series);
    Q_INVOKABLE void getLineSeriesPA(QObject* receiver);
    Q_INVOKABLE void getLineSeriesPB(QObject* receiver);
    Q_INVOKABLE void getLineSeriesPC(QObject* receiver);
    QString fileNames;
    QString fileNamesPattern;

    QString getUPTime();
    QString readLine(QString fileName);
    void boardcasttomessaege(QString msg);
    QString monitorIP;
    QString monitorGateWay;
    // ===== Periodic time state =====
    QString PeriodicTime = "";            // เวลาของเครื่องนี้เองเท่านั้น
    QString recordPeriodic = "";          // เวลาที่รับมาจากอีกฝั่งผ่าน display peer
    QString displayPeriodicTime = "";     // เวลาที่ GUI ต้องแสดง ณ ตอนนี้
    QString peerRemoteIp = "";            // IP ของ display อีกฝั่ง
    bool periodicInitialChecked = false;

    QString targetIpByUserMode(const QString &mode,
                               const QString &ipMaster,
                               const QString &ipSlave);

    void handleSelectUserMode(const QJsonObject &command,
                              const QString &getCommand,
                              const QString &qmlJson);

public slots:
    void updateDisplayOpp(QString);

    void manageData(QString, QWebSocket*);
    void updateNetwork(quint8 DHCP, QString LocalAddress, QString Netmask, QString Gateway, QString DNS1, QString DNS2,QString phyNetworkName);
    void sendNetworkAndUserModeToWeb();
//    void boardcasttomessaege(QString msg);
//    void receivemessaege(QString msg);
    void setDefaultIPDataBase(QString);
    void cppSubmitTextFiled(QString qmlJson);
    void ServerCommand(QString qmlJson);
//    void WebCommand(QString qmlJson);
    void FileIPMonitor();

    QString getSystemDateTime();
    void updateDateTime();
    void connectToPLC();
    void reconnectTimerTimeoutSlave();

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
    void captureScreenshotseand();
    void updateNTP();
    void updateSystemiTouch(QString);
    void updateUserMode(QString);
    void processData(const QString& jsonStr, QString phase, const QString& fileName);
    void processSurge(const QString& jsonStr, QString phase, const QString& fileName);

    void findMinMaxValues();
    void processPatternData(const QString& jsonStr, QString phase,const QString& fileName);
    void findMinMaxPatternValues();
    void findMinMaxSurgeValues();

    void downloadCompleted(const QString &outputPath);
    QStringList findFile();
    void selectMasterMode(QString,QString,QString,QString,QString,QString);
    void disconnected(QWebSocket *);
    void clearPhaseData(const QString& phase);
    void iScreenIPNetwork();
    void UpdateiScreenIPNetwork(QString);
    Q_INVOKABLE void findVoltageValueTagging(const QString &msg);
    // void clearPhasePattern(const QString& phase);
//    void processPatternData(const QString& jsonStr, QString phase);

    void updateLocalNetworkFromJson(const QString &jsonString);
    void clearDiskStorage();
    void updateFirmware();
    bool pingHost(const QString &ip);
    void sendRequestDisplay();

private:


    QString serverAddress;
    int serverPort;
    QTimer *reconnectTimerMaster;
    QTimer *reconnectTimerSlave;
    QTimer *reconnectPing;

    FileDownloader *downloader = nullptr;
    QTimer *Timer;
    QTimer *TimerVerify;
    QTimer *TimerPlotGraph;
    QTimer *TimerPlotSurgeGraph;
    QTimer *TimerPlotPatternGraph;

    QTimer *setIPDisplay;
    NetworkMng *networking;
    QString SwVersion = "";

    bool foundfileupdate = false;
    bool interlockUser = false;
    int countUser = 0;
    int countReconnect = 0;

    int updateStatus = 0;
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
    int port = 1234;
    double FullDistance;

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
        QString ip_master = "";
        QString ip_slave = "";
        QString userTypeSelect = "";
        void printinfo(){
            qDebug() << "dhcpmethod:" << dhcpmethod << " ip_address:" << ip_address
                     << " subnet:" << subnet << " ip_gateway:" << ip_gateway << " pridns:" << pridns
                     << " secdns:" << secdns << " phyName:" << phyName << " ip_timeserver:" << ip_timeserver
                     << "ip_master:" << ip_master << "ip_slave:" << ip_slave << "user_type:" << userTypeSelect;
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
    bool isFirstEvent_LFL_OPERATE = true;

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
    bool previousStates_LFL_OPERATE = false;
    QString userMode;
    QString Ipaddress_Master;
    QString Ipaddress_Slave;
    int cal_thresholdA;
    QString temp_ip_master;
    QString temp_ip_slave;
    QDateTime currentDateTime = QDateTime::currentDateTime();
//    QJsonDocument d;
//    QJsonObject command;
//    QString getCommand ;
//    QString getCommand2 ;
//    QString getEventAndAlert;
//    QString qmlJson;
    QString UserTypes ;
    bool userStatus ;
    QString selectMaster;
    QString user;
    QString password;
    QString User;
    QString Name;
//    QString categories;
    QVector<double> distanceA, distanceB, distanceC;
    QVector<double> voltageA, voltageB, voltageC;
    bool isDataAReady = false, isDataBReady = false, isDataCReady = false;
    QVector<double> patternDistanceA, patternDistanceB, patternDistanceC;
    QVector<double> patternVoltageA, patternVoltageB, patternVoltageC;
    double minDistance,maxDistance,minVoltage,maxVoltage;
    double voltageOffset = 2.83707;
    double maxVoltagePlusOffset = maxVoltage*voltageOffset;
    bool isPatternAReady = false, isPatternBReady = false, isPatternCReady = false;
    int countA=0;
    int countB=0;
    int countC=0;
    bool isProcessingA = false;
    bool isProcessingB = false;
    bool isProcessingC = false;
    bool isProcessingPatternA = false;
    bool isProcessingPatternB = false;
    bool isProcessingPatternC = false;
    bool isProcessingSurgeA = false;
    bool isProcessingSurgeB = false;
    bool isProcessingSurgeC = false;
    // ใน class mainwindows:
    bool isPatternProcessing = false;
    QString lastProcessedPatternFileName;
    QJsonObject patternObject;
    QJsonArray jsonArrayVoltA,jsonArrayVoltB,jsonArrayVoltC,jsonArrayDistA,jsonArrayDistB,jsonArrayDistC;
    void appendVectorToJsonArray(QJsonArray& jsonArray, const QVector<double>& vec);
    bool marginInterlog = false;
    double distanceShow;
    double distanceToShowInit;
    double fulldistancesInit;
    double samplingRateInit;
    double sagFactorInit;
    double distanceToStartInit;
    double delMaxDistance;
    bool interlogPopup = false;
    void showEvent();
    bool isVNCViewerRunningWindows()
    {
        QProcess process;
        process.start("tasklist", QStringList() << "/FI" << "IMAGENAME eq vncviewer.exe");
        process.waitForFinished();
        QString output = process.readAllStandardOutput();
        return output.contains("vncviewer.exe", Qt::CaseInsensitive);
    }
    bool isVNCViewerRunningLinux()
    {
        QProcess process;
        process.start("pgrep", QStringList() << "vncviewer");
        process.waitForFinished();
        QString output = process.readAllStandardOutput();
        return !output.isEmpty();
    }
    bool selectVNCHW;
    bool checkStatusCaptre=false;
//    QVariantList lastDistRawA, lastvoltRawA, lastDistRawB, lastvoltRawB, lastDistRawC, lastvoltRawC;
//    QVariantList lastDistPTA, lastvoltPTA, lastDistPTB, lastvoltPTB, lastDistPTC, lastvoltPTC;
    int baselineSizeRawData=0;
    int baselineSizePattern=0;
    QVariantList distA, voltA, distB, voltB, distC, voltC;
    QVariantList distPTA, voltPTA, distPTB, voltPTB, distPTC, voltPTC;

    QVector<qreal>  distanceRawA, voltageRawA;
    QVector<qreal>  distanceRawB, voltageRawB;
    QVector<qreal>  distanceRawC, voltageRawC;
    qreal x_A,y_A;
    double backupyZoomFactor=0.0;
    bool readyForWebsock=false;
    QString update_userMode;

    QString update_ip_PCL;
    QString update_ip_Master_PCL;
    QString update_ip_SLAVE_PCL;
    QString update_ip_gatewayPLC ;
    QString update_ip_monitor;
    QString update_ip_snmp;
    QString update_ip_timeserver;
    QString mainIP_address;
    bool popupSent = false;
    int counttimerDisconnect = 0;
    bool interlockValue = true;
    bool remoteMode = false;
    QString remoteTargetIP;

    QString socketInfo = "wClient=null";
    void sendDisplayJson(const QJsonObject &o);
    void ensurePeerCreated();
    void startDisplayPeer();
    void handlePeerRx(const QString &msg);
    bool m_processingRemotePeriodicCommand = false;
    void sendPeerMessageReliable(const QString &msg);

    QString NEW_IP_MASTER;
    QString NEW_IP_SLAVE;
    QString NEW_USER;
};

#endif // MAINWINDOWS_H

#include "mainwindows.h"

mainwindows::mainwindows(QObject *parent) : QObject(parent){
    qDebug() << "hello windows";
    system("sudo pigpiod");
    QThread::msleep(100);
    system("sudo pigs p 13 255");

    SocketServer = new ChatServer(1234);
    mysql = new Database("ITouch", "pi", "rpi3!2024", "localhost", this);
    client = new SocketClient();
    reconnectTimer = new QTimer();
    networks = new Network;
    Timer = new QTimer();
    screenShot = new ImageProvider();
    QTimer *timer = new QTimer(this);
    TimerVerify = new QTimer();
    getSetting();
    connect(reconnectTimer,SIGNAL(timeout()),this,SLOT(reconnectTimerTimeout()));
    connect(Timer,SIGNAL(timeout()),this,SLOT(connectTimeOut()));
//    connect(this, SIGNAL(updateRelay(QString)), mysql, SLOT(storeStatusAux(QString)));
//    connect(this,SIGNAL(getEditDatafromMySQLA(QString)),mysql,SLOT(closeMySQL(QString)));

//    connect(mysql,SIGNAL(listOfMarginA(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
//    connect(mysql,SIGNAL(listOfMarginB(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
//    connect(mysql,SIGNAL(listOfMarginC(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
//    connect(this,SIGNAL(parameterThreshold(QString)),mysql,SLOT(configParemeterThreshold(QString)));
//    connect(mysql,SIGNAL(updateThresholdA(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
//    connect(mysql,SIGNAL(updateThresholdB(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
//    connect(mysql,SIGNAL(updateThresholdC(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
//    connect(this,SIGNAL(updateTimer(QString)),mysql,SLOT(getUpdatePeriodic(QString)));
//    connect(this,SIGNAL(updateWeekly(QString)),mysql,SLOT(getUpdateWeekly(QString)));
//    connect(this, SIGNAL(rawdataPlot(QString)), mysql, SLOT(getRawData(QString)));
//    connect(mysql,SIGNAL(packageRawData(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
//    connect(this, SIGNAL(changeDistanceRange(QString)), mysql, SLOT(getChangeDistance(QString)));
//    connect(this,SIGNAL(clearDisplay(QString)),mysql,SLOT(cleanDataInGraph(QString)));
//    connect(this,SIGNAL(clearDisplay(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));  //SetNetworkSNMP
//    connect(this,SIGNAL(settingdisplay(QString)),mysql,SLOT(SettingDisplay(QString)));
//    connect(this,SIGNAL(settingdisplay(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
//    connect(this,SIGNAL(getsettingdisplay()),mysql,SLOT(GetSettingDisplay()));
//    connect(mysql,SIGNAL(settingDisplayInfo(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
//    connect(mysql,SIGNAL(settingDisplayInfo(QString)),this,SLOT(calculate(QString)));
//    connect(mysql,SIGNAL(updateThresholdA(QString)),this,SLOT(calculate(QString)));
//    connect(this,SIGNAL(getMarginUpdate()),mysql,SLOT(updateMargin()));
    connect(this, SIGNAL(updateUser(QString)), mysql, SLOT(userMode(QString)));
    connect(this, SIGNAL(getDistanceandDetailA(QString)), mysql, SLOT(DistanceandDetailPhaseA(QString)));
    connect(this, SIGNAL(getDistanceandDetailB(QString)), mysql, SLOT(DistanceandDetailPhaseB(QString)));
    connect(this, SIGNAL(getDistanceandDetailC(QString)), mysql, SLOT(DistanceandDetailPhaseC(QString)));
    connect(this, SIGNAL(getTablePhaseA(QString)), mysql, SLOT(getMySqlPhaseA(QString)));
    connect(this, SIGNAL(getTablePhaseB(QString)), mysql, SLOT(getMySqlPhaseB(QString)));
    connect(this, SIGNAL(getTablePhaseC(QString)), mysql, SLOT(getMySqlPhaseC(QString)));
    connect(this, SIGNAL(deletedMySQLA(QString)), mysql, SLOT(deletedDataMySQLPhaseA(QString)));
    connect(this, SIGNAL(deletedMySQLB(QString)), mysql, SLOT(deletedDataMySQLPhaseB(QString)));
    connect(this, SIGNAL(deletedMySQLC(QString)), mysql, SLOT(deletedDataMySQLPhaseC(QString)));
    connect(this, SIGNAL(updateTablePhaseA(QString)), mysql, SLOT(updateTablePhaseA(QString)));
    connect(this, SIGNAL(updateTablePhaseB(QString)), mysql, SLOT(updateTablePhaseB(QString)));
    connect(this, SIGNAL(updateTablePhaseC(QString)), mysql, SLOT(updateTablePhaseC(QString)));
    connect(this,SIGNAL(settingNetWorkandSNMP(QString)),mysql,SLOT(SettingNetworkSNMP(QString)));
    connect(this, SIGNAL(sendToSocket(QString)), client, SLOT(sendMessage(QString)));
    connect(this,SIGNAL(taggingpoint(QString)),mysql,SLOT(taggingpoint(QString)));
    connect(this, SIGNAL(cursorDistance(QString)), mysql, SLOT(getPositionDistance(QString)));
    connect(this, SIGNAL(moveCursor(QString)), mysql, SLOT(controlCursor(QString)));
    connect(this, SIGNAL(changeDistanceRange(QString)), mysql, SLOT(getChangeDistance(QString)));
    connect(this,SIGNAL(getDataThreshold()),mysql,SLOT(getThreshold()));
    connect(this,SIGNAL(settingGeneral()),mysql,SLOT(getSettingInfo()));
    connect(this,SIGNAL(preiodicSetting()),mysql,SLOT(getpreiodicInfo()));
    connect(this,SIGNAL(plotingDataPhaseA(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
    connect(this,SIGNAL(plotingDataPhaseB(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
    connect(this,SIGNAL(plotingDataPhaseC(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
    connect(this,SIGNAL(settingdisplay(QString)),this,SLOT(calculate(QString)));
    connect(this,SIGNAL(updateDisplayInfoSetting(QString)),mysql,SLOT(updateSettingInfo(QString)));

//    connect(this,SIGNAL(parameterMarginA(QString)),mysql,SLOT(configParemeterMarginA(QString)));
//    connect(this,SIGNAL(parameterMarginB(QString)),mysql,SLOT(configParemeterMarginB(QString)));
//    connect(this,SIGNAL(parameterMarginC(QString)),mysql,SLOT(configParemeterMarginC(QString)));
//    connect(this,SIGNAL(UpdateMarginSettingParameter(QString)),mysql,SLOT(UpdateMarginSettingParameter(QString)));
//    connect(this,SIGNAL(updataListOfMarginA(QString)),mysql,SLOT(updataListOfMarginA(QString)));
//    connect(this,SIGNAL(updataListOfMarginB(QString)),mysql,SLOT(updataListOfMarginB(QString)));
//    connect(this,SIGNAL(updataListOfMarginC(QString)),mysql,SLOT(updataListOfMarginC(QString)));

    connect(mysql,SIGNAL(sendUpdatedMarginList(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
    connect(mysql,SIGNAL(UpdatepreiodicInfo(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
    connect(mysql,SIGNAL(sendMarginUpdate(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
    connect(mysql,SIGNAL(SetNetworkSNMP(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
    connect(mysql,SIGNAL(updateDisplaySetting(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
    connect(mysql,SIGNAL(cursorPosition(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
    connect(mysql,SIGNAL(showtaggingpoint(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
    connect(mysql,SIGNAL(updatanewdistance(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
    connect(mysql,SIGNAL(positionCursorChange(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
    connect(mysql, SIGNAL(cmdmsg(QString)), SocketServer, SLOT(boardcasttomessaege(QString)));
    connect(mysql, SIGNAL(updateTableDisplay(QString)), SocketServer, SLOT(boardcasttomessaege(QString)));
    connect(mysql, SIGNAL(eventmsg(QString)), SocketServer, SLOT(boardcasttomessaege(QString)));
    connect(mysql,SIGNAL(deletedmydatabase(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
    connect(mysql,SIGNAL(updatedataTableA(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
    connect(mysql,SIGNAL(updatedataTableB(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
    connect(mysql,SIGNAL(updatedataTableC(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
    connect(mysql,SIGNAL(updataEditDataA(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
//------------------------------show information on Gerneral and graph ----------------------------------//displaysetting
    connect(mysql,SIGNAL(SetNetworkSNMP(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
    connect(mysql,SIGNAL(UpdateSettingInfo(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));
    connect(mysql,SIGNAL(showUpdateInfoSetting(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));

//------------------------------client command to Display----------------------------------//displaysetting
    connect(client,SIGNAL(newCommandProcess(QString)),this,SLOT(ServerCommand(QString)));
    connect(client,SIGNAL(newCommandProcess(QString)),this,SLOT(cppSubmitTextFiled(QString)));

    // connect(client,SIGNAL(newCommandProcess(QString)),SocketServer,SLOT(boardcasttomessaege(QString)));

//------------------------------Send command to client----------------------------------//
    connect(this, SIGNAL(rawdataPlot(QString)),client, SLOT(sendMessage(QString)));
    connect(this,SIGNAL(clearPatternGraph(QString)),client, SLOT(sendMessage(QString)));
    connect(this,SIGNAL(clearDisplay(QString)),client, SLOT(sendMessage(QString)));
    connect(mysql,SIGNAL(SetNetworkSNMP(QString)),client,SLOT(sendMessage(QString)));
    connect(this,SIGNAL(settingdisplay(QString)),client,SLOT(sendMessage(QString)));
    connect(this,SIGNAL(parameterThreshold(QString)),client,SLOT(sendMessage(QString)));
    connect(this,SIGNAL(sendMessage(QString)),client,SLOT(sendMessage(QString)));
    connect(this,SIGNAL(updateWeekly(QString)),client,SLOT(sendMessage(QString)));
    connect(this,SIGNAL(updateTimer(QString)),client,SLOT(sendMessage(QString)));
    connect(this, SIGNAL(updateRelay(QString)),client,SLOT(sendMessage(QString)));
    connect(this, SIGNAL(SettingAndUpdateMargin(QString)),client,SLOT(sendMessage(QString)));
    connect(this, SIGNAL(parameterMarginA(QString)),client,SLOT(sendMessage(QString)));
    connect(this, SIGNAL(parameterMarginB(QString)),client,SLOT(sendMessage(QString)));
    connect(this, SIGNAL(parameterMarginC(QString)),client,SLOT(sendMessage(QString)));
    connect(this,SIGNAL(updataListOfMarginA(QString)),client,SLOT(sendMessage(QString)));
    connect(this,SIGNAL(updataListOfMarginB(QString)),client,SLOT(sendMessage(QString)));
    connect(this,SIGNAL(updataListOfMarginC(QString)),client,SLOT(sendMessage(QString)));



    //------------------------------Send command to client----------------------------------//
    connect(this, SIGNAL(rawdataPlot(QString)),client, SLOT(sendMessage(QString)));
    connect(this,SIGNAL(clearPatternGraph(QString)),client, SLOT(sendMessage(QString)));
    connect(this,SIGNAL(clearDisplay(QString)),client, SLOT(sendMessage(QString)));
    connect(mysql,SIGNAL(SetNetworkSNMP(QString)),client,SLOT(sendMessage(QString)));
    connect(this,SIGNAL(settingdisplay(QString)),client,SLOT(sendMessage(QString)));
    connect(this,SIGNAL(parameterThreshold(QString)),client,SLOT(sendMessage(QString)));
    connect(this,SIGNAL(ButtonPattern(QString)),client,SLOT(sendMessage(QString)));

    //----------------------------get pattern datastorag from DB ---------------------------//
    connect(this,&mainwindows::getdatapatternDataDb,mysql,&Database::getdatapatternDataDb);
    connect(this,&mainwindows::sortnamePattern,mysql,&Database::sortByName);
    connect(this,&mainwindows::sortdatePattern,mysql,&Database::sortByDate);
    connect(this,&mainwindows::searchByName,mysql,&Database::searchByName);
    connect(this,&mainwindows::searchByDate,mysql,&Database::searchByDate);

    connect(this,&mainwindows::captureScreenshot,this,&mainwindows::captureScreenshotseand);
    // connect(this,SIGNAL(sendMessage(QString)),client,SLOT(sendMessage(QString)));
    // connect(screenShot,SIGNAL(sendlinkPicturesToServer(QString)),this,SLOT(sendlinkPictures(QString)));

        serverAddress = "192.168.10.52";
        serverPort = 5520;
//        qDebug() << "serverAddress:" << serverAddress << " serverPort:" << serverPort;
        client->createConnection(serverAddress,serverPort);

    if (client->isConnected == true){
        connectToPLC();
        qDebug() << "TimeOutTimer timer->stop()";
    }

    mysql->getEventandAlarm("getEventandAlarm");  //rawdataPlot

    connect(timer, &QTimer::timeout, this, &mainwindows::updateDateTime);
    timer->start(1000); // Update every 1000 milliseconds (1 second)
    reconnectTimer->start(3000);
    Timer->start(100);
    updateDateTime();
}


void mainwindows::reconnectTimerTimeout(){
    if (client->isConnected == false){
    if ((serverAddress != "") & (serverPort > 0) & (serverPort < 65536)){
        isVersion= false;
        cppCommand(isVersion);
        client->createConnection(serverAddress,serverPort);
    }
//    qDebug() << "reconnectTimerTimeout" << isVersion;

}
if (client->isConnected == true){

        if(!isVersion){
            connectToPLC();
            qDebug() << "isVersion" << isVersion;
        }
    }
cppCommand(isVersion);
//qDebug() << "reconnectTimerTimeout" << isVersion;
//qDebug() << "isVersion" << isVersion;
}

void mainwindows::connectTimeOut(){
if (client->isConnected == true){
        if(!isVersion){
            connectToPLC();
            Timer->stop();
            cppCommand(isVersion);
        }
    }
}

QString mainwindows::getSystemDateTime() {
    QProcess process;
    process.start("sudo date");
    process.waitForFinished();
    QString dateTime = process.readAllStandardOutput().trimmed();
    return dateTime;
}


void mainwindows::updateDateTime() {
    // Get current date and time
    QDateTime currentDateTime = QDateTime::currentDateTime();

    // Convert to string format (Example: "2025/02/20 14:30:45")
    QString formattedDateTime = currentDateTime.toString("yyyy/MM/dd HH:mm:ss");
    QString datetime = QString("{"
                               "\"objectName\"        :\"DateTime\","
                               "\"formattedDateTime\"  :\"%1\""
                               "}")
                           .arg(formattedDateTime);
    qDebug() << "Current Date and Time:" << formattedDateTime;
    cppCommand(datetime);
}


// void mainwindows::updateDateTime() {
//     QString dateTimeRaw = getSystemDateTime();
// //   qDebug() << "Raw Date and Time: " << dateTimeRaw;

//     QDateTime dateTime = QDateTime::fromString(dateTimeRaw, "ddd MMM dd HH:mm:ss t yyyy");
//     if (dateTime.isValid()) {
//         QString formattedDateTime = dateTime.toString("HH:mm yyyy/MM/dd");
        // QString datetime = QString("{"
        //                          "\"objectName\"        :\"DateTime\","
        //                          "\"formattedDateTime\"  :\"%1\""
        //                          "}")
        //                   .arg(formattedDateTime);

// //        qDebug() << "Formatted Date and Time: " << formattedDateTime;
//         cppCommand(datetime);
//     } else {
// //        qDebug() << "Failed to parse date and time!";
//     }
// }

void mainwindows::cppSubmitTextFiled(QString qmlJson){
    QJsonDocument d = QJsonDocument::fromJson(qmlJson.toUtf8());
    QJsonObject command = d.object();
    QString getCommand =  QJsonValue(command["objectName"]).toString();
    QString getCommand2 =  QJsonValue(command["objectNames"]).toString();
    QString getEventAndAlert =  QJsonValue(command["TrapsAlert"]).toString();
    getCommand = getCommand.trimmed();

    QJsonDocument doc = QJsonDocument::fromJson(qmlJson.toUtf8());
//    qDebug() << "cppSubmitTextFiled:" << qmlJson;
     qDebug() << "cppSubmitTextFiled:" << qmlJson << QJsonValue(command["objectNames"]).toString() << QJsonValue(command["objectName"]).toString() << d.object() << "getEventAndAlert:" << getEventAndAlert << command << command.contains("PLC_DO_ERROR");
     if(getCommand == "updateParameterMargin"){
             qDebug()<< "updateParameterMargin:" << qmlJson;
             cppCommand(qmlJson);
    }else if(qmlJson == "testRawData"){
        rawdataPlot("testRawData");
    }else if(getCommand.contains("UserSelectM")){
        QString userType = QJsonValue(command["userType"]).toString();
        bool userStatus = QJsonValue(command["userStatusMaster"]).toBool();
        QString selectMaster = QString("{"
                                       "\"objectName\"  :\"UserSelectM\","
                                       "\"userType\"    :\"%1\","
                                       "\"userStatusMaster\"  :\"%2\""
                                       "}")
                                .arg(userType).arg(userStatus);
//        qDebug() << "cppSubmitTextFiled UserM:" << selectMaster << userStatus << userType;
        cppCommand(selectMaster);
        emit updateUser(selectMaster);
    }
    else if(getCommand == "PatternData"){
        // qDebug() << "patternA:";
        cppCommand(qmlJson);
        qDebug()<<"iiiiixx"<<qmlJson;
    }
    else if (getCommand ==  "Screenshot"){

        emit captureScreenshot();
    }
    else if (getCommand == "SearchName"){
        // bool Sort = QJsonValue(command["Sort"]).toBool();
        QString Name = QJsonValue(command["text"]).toString();
        QString categories = QJsonValue(command["categories"]).toString();
        QString massage = QString("{"
                                  "\"objectName\":\"SearchName\","
                                  "\"categories\":\"%1\","
                                  "\"text\":\"%2\""
                                  "}").arg(categories).arg(Name);
        emit sendMessage(massage);
               qDebug()<<"iiiiixxxxxNAME"<<Name<<categories;
        //        emit searchByName(Name,categories);

    }
    else if (getCommand == "SearchDate"){
        // qDebug()<<"iiiiixxxxx";
        QString Date = QJsonValue(command["text"]).toString();
        QString categories = QJsonValue(command["categories"]).toString();
        QString massage = QString("{"
                                  "\"objectName\":\"SearchDate\","
                                  "\"categories\":\"%1\","
                                  "\"text\":\"%2\""
                                  "}").arg(categories).arg(Date);
        emit sendMessage(massage);
               qDebug()<<"iiiiixxxxxDate"<<Date<<categories;
        //        emit searchByDate(Date,categories);
    }
    else if (getCommand == "sortnamePattern"){

        bool Sort = QJsonValue(command["Sort"]).toBool();
        QString categories = QJsonValue(command["categories"]).toString();

        QString message = QString("{"
                                  "\"objectName\":\"sortnamePattern\","
                                  "\"Sort\":%1,"
                                  "\"categories\":\"%2\""
                                  "}").arg(Sort ? "true" : "false").arg(categories);

        emit sendMessage(message);
        qDebug()<<"iiiii"<<message;
        //        emit sortnamePattern(Sort,categories);
    }
    else if (getCommand == "sortdatePattern"){
        bool Sort = QJsonValue(command["Sort"]).toBool();
        QString categories = QJsonValue(command["categories"]).toString();

        QString message = QString("{"
                                  "\"objectName\":\"sortdatePattern\","
                                  "\"Sort\":%1,"
                                  "\"categories\":\"%2\""
                                  "}").arg(Sort ? "true" : "false").arg(categories);

        emit sendMessage(message);

        // qDebug()<<"sortdatePattern"<<massage;
        //        emit sortdatePattern(Sort,categories);
    }
    else if (getCommand == "ButtonPattern"){
        QString state = QJsonValue(command["Onclicked"]).toString();
        QString category = QJsonValue(command["category"]).toString();
        QString event_time = QJsonValue(command["event_datetime"]).toString();
        QString filename = QJsonValue(command["filename"]).toString();
        qDebug()<<"ButtonPattern"<<state<<event_time<<filename;
        QString buttonPattern = QString("{"
                                        "\"objectName\":\"ButtonPattern\","
                                        "\"category\":\"%1\","
                                        "\"Onclicked\":\"%2\","
                                        "\"event_datetime\":\"%3\","
                                        "\"filename\":\"%4\""
                                        "}").arg(category).arg(state).arg(event_time).arg(filename);
        qDebug() << "testl"<< buttonPattern;
        emit ButtonPattern(buttonPattern);

    }
    else if(getCommand.contains("UserSelectS")){
        QString userType = QJsonValue(command["userType"]).toString();
        bool userStatus = QJsonValue(command["userStatusSlave"]).toBool();
        QString selectSlave = QString("{"
                                      "\"objectName\"  :\"UserSelectS\","
                                      "\"userType\"    :\"%1\","
                                      "\"userStatusSlave\"  :\"%2\""
                                      "}").arg(userType).arg(userStatus);
//        qDebug() << "cppSubmitTextFiled UserS:" << selectSlave << userStatus << userType;
        cppCommand(selectSlave);
        emit updateUser(selectSlave);
    }else if(getCommand == "VoltageInfo"){
        int valueVoltage = QJsonValue(command["Voltage"]).toInt();
        QString Voltage = QString("{"
                                      "\"objectName\"   :\"valueVoltage\","
                                      "\"Voltage\"      :%1"
                                      "}").arg(valueVoltage);
        qDebug() << "cppSubmitTextFiled Voltage:" << Voltage << valueVoltage;
        emit updateDisplayInfoSetting(Voltage);
    }else if(getCommand == "Substations"){
        QString subsationName = QJsonValue(command["Substation"]).toString();
        QString subsation = QString("{"
                                      "\"objectName\"   :\"ValueSubstations\","
                                      "\"Substation\"      :\"%1\""
                                      "}").arg(subsationName);
        qDebug() << "cppSubmitTextFiled Voltage:" << subsation << subsationName;
        emit updateDisplayInfoSetting(subsation);
    }else if(getCommand == "Direction"){
        QString valueDirection = QJsonValue(command["Direction"]).toString();
        QString Direction = QString("{"
                                      "\"objectName\"   :\"valueDirection\","
                                      "\"Direction\"      :\"%1\""
                                      "}").arg(valueDirection);
        qDebug() << "cppSubmitTextFiled Direction:" << Direction << valueDirection;
        emit updateDisplayInfoSetting(Direction);
    }else if(getCommand == "LineNo"){
        int valueLineNo = QJsonValue(command["LineNo"]).toInt();
        QString LineNo = QString("{"
                                      "\"objectName\"   :\"valueLineNo\","
                                      "\"LineNo\"      :%1"
                                      "}").arg(valueLineNo);
        qDebug() << "cppSubmitTextFiled LineNo:" << LineNo << valueLineNo;
        emit updateDisplayInfoSetting(LineNo);
    }else if(getCommand.contains("updatetextTime")){
        double timer = QJsonValue(command["Time"]).toDouble();
        QString timerupdate = QString("{"
                                      "\"objectName\"   :\"updateTime\","
                                      "\"Time\"      :%1"
                                      "}").arg(timer);
        qDebug() << "cppSubmitTextFiled Time:" << timerupdate << timer;
        emit updateTimer(timerupdate);
    }else if(getCommand.contains("distanceField")){
        int distanceField = QJsonValue(command["distanceField"]).toInt();
        QString distance = QString("{"
                                      "\"objectName\"   :\"distanceField\","
                                      "\"distanceField\"      :\"%1\""
                                      "}").arg(distanceField);
        qDebug() << "cppSubmitTextFiled distance:" << distance << distanceField;
//        cppCommand(distance);
    }else if(getCommand.contains("detailField")){
        double detailField = QJsonValue(command["detailField"]).toDouble();
        QString Details = QString("{"
                                      "\"objectName\"   :\"detailField\","
                                      "\"detailField\"      :\"%1\""
                                      "}").arg(Details);
        qDebug() << "cppSubmitTextFiled Details:" << Details << detailField;
//        cppCommand(Details);
    }else if (getCommand.contains("getDistanceDetailA")) {
        double distancecmd = QJsonValue(command["Distance"]).toDouble();
        QString detailcmd = QJsonValue(command["Detail"]).toString();
        QString phase = QJsonValue(command["PHASE"]).toString();
        QString DetailsAndDistance = QString("{"
                                             "\"objectName\":\"getDistanceDetailA\","
                                             "\"Distance\":\%1,"
                                             "\"Detail\":\"%2\","
                                             "\"PHASE\":\"%3\""
                                             "}").arg(distancecmd).arg(detailcmd).arg(phase);

        qDebug() << "cppSubmitTextFiled DetailsAndDistance:" << DetailsAndDistance << phase << distancecmd << detailcmd;
        emit getDistanceandDetailA(DetailsAndDistance);
    }else if (getCommand.contains("getDistanceDetailB")) {
        double distancecmd = QJsonValue(command["Distance"]).toDouble();
        QString detailcmd = QJsonValue(command["Detail"]).toString();
        QString phase = QJsonValue(command["PHASE"]).toString();
        QString DetailsAndDistance = QString("{"
                                             "\"objectName\":\"getDistanceDetailB\","
                                             "\"Distance\":\%1,"
                                             "\"Detail\":\"%2\","
                                             "\"PHASE\":\"%3\""
                                             "}").arg(distancecmd).arg(detailcmd).arg(phase);

        qDebug() << "cppSubmitTextFiled DetailsAndDistance:" << DetailsAndDistance << phase << distancecmd << detailcmd;
        emit getDistanceandDetailB(DetailsAndDistance);
    }else if (getCommand.contains("getDistanceDetailC")) {
        double distancecmd = QJsonValue(command["Distance"]).toDouble();
        QString detailcmd = QJsonValue(command["Detail"]).toString();
        QString phase = QJsonValue(command["PHASE"]).toString();
        QString DetailsAndDistance = QString("{"
                                             "\"objectName\":\"getDistanceDetailC\","
                                             "\"Distance\":\%1,"
                                             "\"Detail\":\"%2\","
                                             "\"PHASE\":\"%3\""
                                             "}").arg(distancecmd).arg(detailcmd).arg(phase);

        qDebug() << "cppSubmitTextFiled DetailsAndDistance:" << DetailsAndDistance << phase << distancecmd << detailcmd;
        emit getDistanceandDetailC(DetailsAndDistance);
    }else if (getCommand.contains("TaggingPhaseA")) {
        QString tableTaggingPhaseA = QJsonValue(command["tableTaggingPhaseA"]).toString();
        QString getTaggingPhaseA = QString("{"
                                             "\"objectName\":\"TaggingPhaseA\","
                                             "\"tableTaggingPhaseA\":\"%1\""
                                             "}").arg(tableTaggingPhaseA);

        qDebug() << "getTaggingPhaseA:" << getTaggingPhaseA;
        emit getTablePhaseA(getTaggingPhaseA);
    }else if (getCommand.contains("TaggingPhaseB")) {
        QString tableTaggingPhaseB = QJsonValue(command["tableTaggingPhaseB"]).toString();
        QString getTaggingPhaseB = QString("{"
                                           "\"objectName\":\"TaggingPhaseB\","
                                           "\"tableTaggingPhaseB\":\"%1\""
                                           "}").arg(tableTaggingPhaseB);

        qDebug() << "getTaggingPhaseB:" << tableTaggingPhaseB;
        emit getTablePhaseB(getTaggingPhaseB);
    }else if (getCommand.contains("TaggingPhaseC")) {
        QString tableTaggingPhaseC = QJsonValue(command["tableTaggingPhaseC"]).toString();
        QString getTaggingPhaseC = QString("{"
                                           "\"objectName\":\"TaggingPhaseC\","
                                           "\"tableTaggingPhaseC\":\"%1\""
                                           "}").arg(tableTaggingPhaseC);

        qDebug() << "getTaggingPhaseC:" << tableTaggingPhaseC;
        emit getTablePhaseC(getTaggingPhaseC);
    }else if (getCommand.contains("delectmysqlA")) {
        bool checkedStates = QJsonValue(command["checkedStates"]).toBool();
        int num_list = QJsonValue(command["num_listA"]).toInt();

        QString deletedtmySQLA = QString("{"
                                         "\"objectName\":\"delectmysqlA\","
                                          "\"checkedStates\":\"%1\","
                                          "\"num_listA\":\"%2\""
                                         "}").arg(checkedStates).arg(num_list);

        qDebug() << "delectmySQLA:" << deletedtmySQLA;
        emit deletedMySQLA(deletedtmySQLA);
    }else if (getCommand.contains("delectmysqlB")) {
        bool checkedStates = QJsonValue(command["checkedStates"]).toBool();
        int num_list = QJsonValue(command["num_listB"]).toInt();

        QString deletedtmySQLB = QString("{"
                                        "\"objectName\":\"delectmysqlB\","
                                        "\"checkedStates\":\"%1\","
                                        "\"num_listB\":\"%2\""
                                        "}").arg(checkedStates).arg(num_list);

        qDebug() << "delectmySQLB:" << deletedtmySQLB;
        emit deletedMySQLB(deletedtmySQLB);
    }else if (getCommand.contains("delectmysqlC")) {
        bool checkedStates = QJsonValue(command["checkedStates"]).toBool();
        int num_list = QJsonValue(command["num_listC"]).toInt();

        QString deletedtmySQLC = QString("{"
                                        "\"objectName\":\"delectmysqlC\","
                                        "\"checkedStates\":\"%1\","
                                        "\"num_listC\":\"%2\""
                                        "}").arg(checkedStates).arg(num_list);

        qDebug() << "delectmySQLC:" << deletedtmySQLC;
        emit deletedMySQLC(deletedtmySQLC);
    }else if (getCommand.contains("UpdatePhaseA")) {
        QString updatetablePhaseA = QJsonValue(command["updatetablePhaseA"]).toString();
        QString getupdatePhaseA = QString("{"
                                          "\"objectName\":\"UpdatePhaseA\","
                                          "\"updatetablePhaseA\":\"%1\""
                                          "}").arg(updatetablePhaseA);

        qDebug() << "getupdatePhaseA:" << getupdatePhaseA;
        emit updateTablePhaseA(getupdatePhaseA);
    }else if (getCommand.contains("UpdatePhaseB")) {
        QString updatetablePhaseB = QJsonValue(command["updatetablePhaseB"]).toString();
        QString getupdatePhaseB = QString("{"
                                          "\"objectName\":\"UpdatePhaseB\","
                                          "\"updatetablePhaseB\":\"%1\""
                                          "}").arg(updatetablePhaseB);

        qDebug() << "getupdatePhaseB:" << getupdatePhaseB;
        emit updateTablePhaseA(getupdatePhaseB);
    }else if (getCommand.contains("UpdatePhaseC")) {
        QString updatetablePhaseC = QJsonValue(command["updatetablePhaseC"]).toString();
        QString getupdatePhaseC = QString("{"
                                          "\"objectName\":\"UpdatePhaseC\","
                                          "\"updatetablePhaseC\":\"%1\""
                                          "}").arg(updatetablePhaseC);

        qDebug() << "getupdatePhaseA:" << getupdatePhaseC;
        emit updateTablePhaseA(getupdatePhaseC);
    }else if (getCommand.contains("editDataPhaseA")) {
        double checkedStates = QJsonValue(command["checkedStates"]).toDouble();
        QString phase = QJsonValue(command["PHASE"]).toString();
        int IndexNum = QJsonValue(command["num_listA"]).toInt();
        QString EditDatalist = QString("{"
                                             "\"objectName\":\"editDataPhaseA\","
                                             "\"IndexNum\":%1,"
                                             "\"PHASE\":\"%2\""
                                             "}").arg(IndexNum).arg(phase);

        qDebug() << "Debug editDataPhaseA:" << EditDatalist << phase << checkedStates;
        emit getEditDatafromMySQLA(EditDatalist);
    }else if (getCommand.contains("marginCountA") || getCommand.contains("valueMarginVoltageA")) {
        SettingAndUpdateMargin(qmlJson);
//        int marginA = QJsonValue(command["valueMarginA"]).toInt();
//        int valueVoltageA = QJsonValue(command["valueVoltageA"]).toInt();
//        int focusIndex = QJsonValue(command["focusIndex"]).toInt();
//        int listmarginA = QJsonValue(command["listMarginA"]).toInt();
//        QString phase = QJsonValue(command["PHASE"]).toString();
//        qDebug() << "marginA:" << marginA << listmarginA << valueVoltageA << focusIndex << phase;
//        if (getCommand.contains("marginCountA") && !getCommand.contains("valueMarginVoltageA")) {
//            thelistNumOfMarginA = marginA;
//            qDebug() << "Updated thelistNumOfMargin to:" << thelistNumOfMarginA;
//        } else if (getCommand.contains("valueMarginVoltageA")) {
//            qDebug() << "Received valueMarginVoltageA, skipping marginA update.";
//        }

//        if ((valueVoltageA != 0)&&(marginA != 0)){
//            QString combinedData = QString("{"
//                                            "\"objectName\":\"combinedDataPhaseA\","
//                                            "\"marginA\":%1,"
//                                            "\"valueVoltageA\":%2,"
//                                            "\"focusIndex\":%3,"
//                                            "\"PHASE\":\"%4\""
//                                            "}").arg(thelistNumOfMarginA).arg(valueVoltageA).arg(focusIndex).arg(phase);

//            qDebug() << "Combined Data for Phase A:" << combinedData;

////            RecalculateWithMargin(combinedData);
////            emit UpdateMarginSettingParameter(combinedData);
////            emit updataListOfMarginA(combinedData);
//        }else if(marginA != 0){
////            QString combinedData = QString("{"
////                                            "\"objectName\":\"combinedDataPhaseA\","
////                                            "\"marginA\":%1,"
////                                            "\"PHASE\":\"%4\""
////                                            "}").arg(thelistNumOfMarginA).arg(phase);

////            qDebug() << "Margin for Phase A:" << combinedData;

////            emit UpdateMarginSettingParameter(combinedData);
//        } else if(marginA == 0){
//            marginA = listmarginA;
//            QString combinedData = QString("{"
//                                            "\"objectName\":\"combinedDataPhaseA\","
//                                            "\"marginA\":%1,"
//                                            "\"valueVoltageA\":%2,"
//                                            "\"focusIndex\":%3,"
//                                            "\"PHASE\":\"%4\""
//                                            "}").arg(marginA).arg(valueVoltageA).arg(focusIndex).arg(phase);

//            qDebug() << "new value of marginA:" << combinedData << marginA << listmarginA;

////            RecalculateWithMargin(combinedData);
////            emit UpdateMarginSettingParameter(combinedData);
////            emit updataListOfMarginA(combinedData);
//            SettingAndUpdateMargin(combinedData);

//        }else{
//            qDebug() << "valueVoltageA is not greater than 0. Skipping RecalculateWithMargin.";

//        }
//            QString parameterA = QString("{"
//                                      "\"objectName\":\"marginCountA\","
//                                      "\"marginA\":%1,"
//                                      "\"PHASE\":\"%2\""
//                                      "}").arg(marginA).arg(phase);

//        qDebug() << "Debug marginCountA:" << marginA << phase;
//        emit parameterMarginA(parameterA);
    }else if (getCommand.contains("marginCountB") || getCommand.contains("valueMarginVoltageB")) {
        SettingAndUpdateMargin(qmlJson);

//        int marginB = QJsonValue(command["valueMarginB"]).toInt();
//        int valueVoltageB = QJsonValue(command["valueVoltageB"]).toInt();
//        int focusIndex = QJsonValue(command["focusIndex"]).toInt();
//        int listmarginB = QJsonValue(command["listMarginB"]).toInt();
//        QString phase = QJsonValue(command["PHASE"]).toString();

//        qDebug() << "marginB:" << marginB << listmarginB << valueVoltageB << focusIndex << phase;

//        if (getCommand.contains("marginCountB") && !getCommand.contains("valueMarginVoltageB")) {
//            thelistNumOfMarginB = marginB;
//            qDebug() << "Updated thelistNumOfMarginB to:" << thelistNumOfMarginB;
//        } else if (getCommand.contains("valueMarginVoltageB")) {
//            qDebug() << "Received valueMarginVoltageB, skipping marginB update.";
//        }

//        if ((valueVoltageB != 0) && (marginB != 0)) {
//            QString combinedData = QString("{"
//                                           "\"objectName\":\"combinedDataPhaseB\","
//                                           "\"marginB\":%1,"
//                                           "\"valueVoltageB\":%2,"
//                                           "\"focusIndex\":%3,"
//                                           "\"PHASE\":\"%4\""
//                                           "}").arg(thelistNumOfMarginB).arg(valueVoltageB).arg(focusIndex).arg(phase);

//            qDebug() << "Combined Data for Phase B:" << combinedData;

////            RecalculateWithMargin(combinedData);
////            emit UpdateMarginSettingParameter(combinedData);
////            emit updataListOfMarginB(combinedData);
//            SettingAndUpdateMargin(combinedData);

//        } else if (marginB != 0) {
////            QString combinedData = QString("{"
////                                           "\"objectName\":\"combinedDataPhaseB\","
////                                           "\"marginB\":%1,"
////                                           "\"PHASE\":\"%2\""
////                                           "}").arg(thelistNumOfMarginB).arg(phase);

////            qDebug() << "Combined Data for Phase B:" << combinedData;

////            emit UpdateMarginSettingParameter(combinedData);
//        } else if (marginB == 0) {
//            marginB = listmarginB;
//            QString combinedData = QString("{"
//                                           "\"objectName\":\"combinedDataPhaseB\","
//                                           "\"marginB\":%1,"
//                                           "\"valueVoltageB\":%2,"
//                                           "\"focusIndex\":%3,"
//                                           "\"PHASE\":\"%4\""
//                                           "}").arg(marginB).arg(valueVoltageB).arg(focusIndex).arg(phase);

//            qDebug() << "New value of marginB:" << combinedData << marginB << listmarginB;

////            RecalculateWithMargin(combinedData);
////            emit UpdateMarginSettingParameter(combinedData);
////            emit updataListOfMarginB(combinedData);
//            SettingAndUpdateMargin(combinedData);

//        } else {
//            qDebug() << "valueVoltageB is not greater than 0. Skipping RecalculateWithMargin.";
//        }

//        QString parameterB = QString("{"
//                                     "\"objectName\":\"marginCountB\","
//                                     "\"marginB\":%1,"
//                                     "\"PHASE\":\"%2\""
//                                     "}").arg(marginB).arg(phase);

//        qDebug() << "Debug marginCountB:" << marginB << phase;
//        emit parameterMarginB(parameterB);

    } else if (getCommand.contains("marginCountC") || getCommand.contains("valueMarginVoltageC")) {
        SettingAndUpdateMargin(qmlJson);

//        int marginC = QJsonValue(command["valueMarginC"]).toInt();
//        int valueVoltageC = QJsonValue(command["valueVoltageC"]).toInt();
//        int focusIndex = QJsonValue(command["focusIndex"]).toInt();
//        int listmarginC = QJsonValue(command["listMarginC"]).toInt();
//        QString phase = QJsonValue(command["PHASE"]).toString();

//        qDebug() << "marginC:" << marginC << listmarginC << valueVoltageC << focusIndex << phase;

//        if (getCommand.contains("marginCountC") && !getCommand.contains("valueMarginVoltageC")) {
//            thelistNumOfMarginC = marginC;
//            qDebug() << "Updated thelistNumOfMarginC to:" << thelistNumOfMarginC;
//        } else if (getCommand.contains("valueMarginVoltageC")) {
//            qDebug() << "Received valueMarginVoltageC, skipping marginC update.";
//        }

//        if ((valueVoltageC != 0) && (marginC != 0)) {
//            QString combinedData = QString("{"
//                                           "\"objectName\":\"combinedDataPhaseC\","
//                                           "\"marginC\":%1,"
//                                           "\"valueVoltageC\":%2,"
//                                           "\"focusIndex\":%3,"
//                                           "\"PHASE\":\"%4\""
//                                           "}").arg(thelistNumOfMarginC).arg(valueVoltageC).arg(focusIndex).arg(phase);

//            qDebug() << "Combined Data for Phase C:" << combinedData;

////            RecalculateWithMargin(combinedData);
////            emit UpdateMarginSettingParameter(combinedData);
////            emit updataListOfMarginC(combinedData);
//            SettingAndUpdateMargin(combinedData);

//        }  else if (marginC != 0) {
////            QString combinedData = QString("{"
////                                           "\"objectName\":\"combinedDataPhaseC\","
////                                           "\"marginC\":%1,"
////                                           "\"PHASE\":\"%2\""
////                                           "}").arg(thelistNumOfMarginB).arg(phase);

////            qDebug() << "Combined Data for Phase C:" << combinedData;

////            emit UpdateMarginSettingParameter(combinedData);
//        } else if (marginC == 0) {
//            marginC = listmarginC;
//            QString combinedData = QString("{"
//                                           "\"objectName\":\"combinedDataPhaseC\","
//                                           "\"marginC\":%1,"
//                                           "\"valueVoltageC\":%2,"
//                                           "\"focusIndex\":%3,"
//                                           "\"PHASE\":\"%4\""
//                                           "}").arg(marginC).arg(valueVoltageC).arg(focusIndex).arg(phase);

//            qDebug() << "New value of marginC:" << combinedData << marginC << listmarginC;

////            RecalculateWithMargin(combinedData);
////            emit UpdateMarginSettingParameter(combinedData);
////            emit updataListOfMarginC(combinedData);
//            SettingAndUpdateMargin(combinedData);

//        } else {
//            qDebug() << "valueVoltageC is not greater than 0. Skipping RecalculateWithMargin.";
//        }

//        QString parameterC = QString("{"
//                                     "\"objectName\":\"marginCountC\","
//                                     "\"marginC\":%1,"
//                                     "\"PHASE\":\"%2\""
//                                     "}").arg(marginC).arg(phase);

//        qDebug() << "Debug marginCountC:" << marginC << phase;
//        emit parameterMarginC(parameterC);
    }else if (getCommand.contains("textPhaseA")) {
        int thresholdA = QJsonValue(command["thresholdA"]).toInt();
        QString phase = QJsonValue(command["PHASE"]).toString();
        QString paraThresholdA = QString("{"
                                         "\"objectName\":\"thresholdA\","
                                         "\"thresholdInitA\":%1,"
                                         "\"phase\":\"%2\""
                                         "}").arg(thresholdA).arg(phase);

        qDebug() << "textPhaseA:" << thresholdA << phase;
        emit parameterThreshold(paraThresholdA);
     }else if (getCommand.contains("textPhaseB")) {
        int thresholdB = QJsonValue(command["thresholdB"]).toInt();
        QString phase = QJsonValue(command["PHASE"]).toString();
        QString paraThresholdB = QString("{"
                                         "\"objectName\":\"thresholdB\","
                                         "\"thresholdInitB\":%1,"
                                         "\"phase\":\"%2\""
                                         "}").arg(thresholdB).arg(phase);

        qDebug() << "textPhaseB:" << thresholdB << phase;
        emit parameterThreshold(paraThresholdB);
     }else if (getCommand.contains("textPhaseC")) {
        int thresholdC = QJsonValue(command["thresholdC"]).toInt();
        QString phase = QJsonValue(command["PHASE"]).toString();
        QString paraThresholdC = QString("{"
                                         "\"objectName\":\"thresholdC\","
                                         "\"thresholdInitC\":%1,"
                                         "\"phase\":\"%2\""
                                         "}").arg(thresholdC).arg(phase);

        qDebug() << "textPhaseC:" << thresholdC << phase;
        emit parameterThreshold(paraThresholdC);
     }else if (qmlJson == "getCurrentThreshold") {
        emit getDataThreshold();
     }else if (qmlJson == "SettingGeneral") {
        emit settingGeneral();
     }else if (qmlJson == "getpreiodicInfo") {
        emit preiodicSetting();
     }else if (getCommand.contains("date")) {
        bool monday = command.contains("Monday") ? QJsonValue(command["Monday"]).toBool() : false;
        bool tuesday = command.contains("Tuesday") ? QJsonValue(command["Tuesday"]).toBool() : false;
        bool wednesday = command.contains("Wednesday") ? QJsonValue(command["Wednesday"]).toBool() : false;
        bool thursday = command.contains("Thursday") ? QJsonValue(command["Thursday"]).toBool() : false;
        bool friday = command.contains("Friday") ? QJsonValue(command["Friday"]).toBool() : false;
        bool saturday = command.contains("Saturday") ? QJsonValue(command["Saturday"]).toBool() : false;
        bool sunday = command.contains("Sunday") ? QJsonValue(command["Sunday"]).toBool() : false;

        qDebug() << "date:" << monday << tuesday << wednesday << thursday << friday << saturday << sunday;

        if (command.contains("Monday")) {
            QString weeklyMonday = QString("{"
                                            "\"objectName\"     :\"date\","
                                            "\"Monday\"         :\"%1\""
                                            "}").arg(monday ? "1" : "0"); // Convert bool to string "1" or "0"
            qDebug() << "weeklyMonday:" << weeklyMonday << monday;
            emit updateWeekly(weeklyMonday);
        } else if (command.contains("Tuesday")) {
            QString weeklyTuesday = QString("{"
                                             "\"objectName\"     :\"date\","
                                             "\"Tuesday\"        :\"%1\""
                                             "}").arg(tuesday ? "1" : "0");
            qDebug() << "weeklyTuesday:" << weeklyTuesday << tuesday;
            emit updateWeekly(weeklyTuesday);
        } else if (command.contains("Wednesday")) {
            QString weeklyWednesday = QString("{"
                                               "\"objectName\"     :\"date\","
                                               "\"Wednesday\"      :\"%1\""
                                               "}").arg(wednesday ? "1" : "0");
            qDebug() << "weeklyWednesday:" << weeklyWednesday << wednesday;
            emit updateWeekly(weeklyWednesday);
        } else if (command.contains("Thursday")) {
            QString weeklyThursday = QString("{"
                                              "\"objectName\"     :\"date\","
                                              "\"Thursday\"       :\"%1\""
                                              "}").arg(thursday ? "1" : "0");
            qDebug() << "weeklyThursday:" << weeklyThursday << thursday;
            emit updateWeekly(weeklyThursday);
        } else if (command.contains("Friday")) {
            QString weeklyFriday = QString("{"
                                            "\"objectName\"     :\"date\","
                                            "\"Friday\"         :\"%1\""
                                            "}").arg(friday ? "1" : "0");
            qDebug() << "weeklyFriday:" << weeklyFriday << friday;
            emit updateWeekly(weeklyFriday);
        } else if (command.contains("Saturday")) {
            QString weeklySaturday = QString("{"
                                              "\"objectName\"     :\"date\","
                                              "\"Saturday\"       :\"%1\""
                                              "}").arg(saturday ? "1" : "0");
            qDebug() << "weeklySaturday:" << weeklySaturday << saturday;
            emit updateWeekly(weeklySaturday);
        } else if (command.contains("Sunday")) {
            QString weeklySunday = QString("{"
                                            "\"objectName\"     :\"date\","
                                            "\"Sunday\"         :\"%1\""
                                            "}").arg(sunday ? "1" : "0");
            qDebug() << "weeklySunday:" << weeklySunday << sunday;
            emit updateWeekly(weeklySunday);
        }


     }else if (getCommand.contains("distance") && (command.contains("distance"))) {
        double distance = QJsonValue(command["distance"]).toDouble();
        QString positionDistance = QString("{"
                                        "\"objectName\"     :\"distance\","
                                        "\"distance\"         :\"%1\""
                                        "}").arg(distance);
        qDebug() << "positionDistance:" << positionDistance << distance;
        emit cursorDistance(positionDistance);
    }else if (getCommand.contains("decreaseValue")) {
        double decreaseValue = QJsonValue(command["decreaseValue"]).toDouble();
        QString movetoleft = QString("{"
                                        "\"objectName\"     :\"decreaseValue\","
                                        "\"decreaseValue\"         :%1"
                                        "}").arg(decreaseValue);
        qDebug() << "movetoleft:" << movetoleft << decreaseValue;
        emit moveCursor(movetoleft);
    }else if (getCommand.contains("increaseValue")) {
        double increaseValue = QJsonValue(command["increaseValue"]).toDouble();
        QString movetoright = QString("{"
                                        "\"objectName\"     :\"increaseValue\","
                                        "\"increaseValue\"         :%1"
                                        "}").arg(increaseValue);
        qDebug() << "movetoleft:" << movetoright << increaseValue;
        emit moveCursor(movetoright);
    }else if (getCommand.contains("getDatabuttonPhaseA")) {
//        QString rawdataA = QJsonValue(command["rawdataA"]).toString();
        QString getRawDataPhaseA = QString("{"
                                        "\"objectName\"     :\"dataPlotingA\""
                                        "}");
        qDebug() << "getRawDataPhaseA:" << getRawDataPhaseA;
        emit plotingDataPhaseA(getRawDataPhaseA);
//        storeageDataPhaseA(getRawDataPhaseA);
//        emit rawdataPlot(getRawDataPhaseA);
    } else if (getCommand.contains("getDatabuttonPhaseB")) {
        QString rawdataB = QJsonValue(command["rawdataB"]).toString();
        QString getRawDataPhaseB = QString("{"
                                        "\"objectName\"     :\"getDatabuttonPhaseB\","
                                        "\"rawdataB\"         :\"%1\""
                                        "}").arg(rawdataB);
        qDebug() << "getpatternPhaseB:" << getRawDataPhaseB << rawdataB;
//        emit rawdataPlot(getRawDataPhaseB);
    } else if (getCommand.contains("getDatabuttonPhaseC")) {
        QString rawdataC = QJsonValue(command["rawdataC"]).toString();
        QString getRawDataPhaseC = QString("{"
                                        "\"objectName\"     :\"getDatabuttonPhaseC\","
                                        "\"rawdataC\"         :\"%1\""
                                        "}").arg(rawdataC);
        qDebug() << "getpatternPhaseC:" << getRawDataPhaseC << rawdataC;
//        emit rawdataPlot(getRawDataPhaseC);
    }else if (getCommand.contains("getpatternPhaseA")) {
        QString patternA = QJsonValue(command["patternA"]).toString();
        QString getpatternPhaseA = QString("{"
                                        "\"objectName\"     :\"getpatternPhaseA\","
                                        "\"getpatternA\"         :\"%1\""
                                        "}").arg(patternA);
        qDebug() << "getpatternPhaseA:" << getpatternPhaseA << patternA;
        emit rawdataPlot(getpatternPhaseA);
    }else if (getCommand.contains("getpatternPhaseB")) {
        QString patternB = QJsonValue(command["patternB"]).toString();
        QString getpatternPhaseB = QString("{"
                                        "\"objectName\"     :\"getpatternPhaseB\","
                                        "\"getpatternB\"         :\"%1\""
                                        "}").arg(patternB);
        qDebug() << "getpatternPhaseB:" << getpatternPhaseB << patternB;
        emit rawdataPlot(getpatternPhaseB);
    }else if (getCommand.contains("getpatternPhaseC")) {
        QString patternC = QJsonValue(command["patternC"]).toString();
        QString getpatternPhaseC = QString("{"
                                        "\"objectName\"     :\"getpatternPhaseC\","
                                        "\"getpatternC\"         :\"%1\""
                                        "}").arg(patternC);
        qDebug() << "getpatternPhaseC:" << getpatternPhaseC << patternC;
        emit rawdataPlot(getpatternPhaseC);
    }else if (getCommand.contains("ClearDisplayPhaseA")) { //CLear Display Phase A
        QString patternA = QJsonValue(command["patternA"]).toString();
        QString clearpatternPhaseA = QString("{"
                                        "\"objectName\"     :\"clearpatternPhaseA\","
                                        "\"clearpatternA\"         :\"%1\""
                                        "}").arg(patternA);
        qDebug() << "clearpatternPhaseA:" << clearpatternPhaseA << patternA;
        emit clearDisplay(clearpatternPhaseA);
    }else if (getCommand.contains("ClearDisplayPhaseB")) { //CLear Display Phase B
        QString patternB = QJsonValue(command["patternB"]).toString();
        QString clearpatternPhaseB = QString("{"
                                        "\"objectName\"     :\"clearpatternPhaseB\","
                                        "\"clearpatternB\"         :\"%1\""
                                        "}").arg(patternB);
        qDebug() << "clearpatternPhaseB:" << clearpatternPhaseB << patternB;
        emit clearDisplay(clearpatternPhaseB);
    }else if (getCommand.contains("ClearDisplayPhaseC")) { //CLear Display Phase C
        QString patternC = QJsonValue(command["patternC"]).toString();
        QString clearpatternPhaseC = QString("{"
                                        "\"objectName\"     :\"clearpatternPhaseC\","
                                        "\"clearpatternC\"         :\"%1\""
                                        "}").arg(patternC);
        qDebug() << "clearpatternPhaseC:" << clearpatternPhaseC << patternC;
        emit clearDisplay(clearpatternPhaseC);
    }else if (getCommand.contains("clearDatabuttonPhaseA")) { //CLear Display Phase A
        QString dataA = QJsonValue(command["rawdataA"]).toString();
        QString cleardataA = QString("{"
                                        "\"objectName\"     :\"clearDatabuttonPhaseA\","
                                        "\"cleardataA\"         :\"%1\""
                                        "}").arg(dataA);
        qDebug() << "clearDatabuttonPhaseA:" << cleardataA << dataA;
        emit clearDisplay(cleardataA);
    }else if (getCommand.contains("clearDatabuttonPhaseB")) { //CLear Display Phase B
        QString dataB = QJsonValue(command["rawdataB"]).toString();
        QString cleardataB = QString("{"
                                        "\"objectName\"     :\"clearDatabuttonPhaseB\","
                                        "\"cleardataB\"         :\"%1\""
                                        "}").arg(dataB);
        qDebug() << "clearDatabuttonPhaseB:" << cleardataB << dataB;
        emit clearDisplay(cleardataB);
    }else if (getCommand.contains("clearDatabuttonPhaseC")) { //CLear Display Phase C
        QString dataC = QJsonValue(command["patternC"]).toString();
        QString cleardataC = QString("{"
                                        "\"objectName\"     :\"clearDatabuttonPhaseC\","
                                        "\"cleardataC\"         :\"%1\""
                                        "}").arg(dataC);
        qDebug() << "clearpatternPhaseC:" << cleardataC << dataC;
        emit clearDisplay(cleardataC);
    }else if (getCommand.contains("rangedistance")) {
        double range = QJsonValue(command["rangedistance"]).toDouble();
        QString rangeChange = QString("{"
                                        "\"objectName\"     :\"rangedistance\","
                                        "\"rangedistance\"         :%1"
                                        "}").arg(range);
        qDebug() << "rangeChange:" << rangeChange << range;
        emit changeDistanceRange(rangeChange);
    }else if (getCommand.contains("taggingdata")) {
        int tagging = QJsonValue(command["checklist"]).toInt();
        bool statuslist = QJsonValue(command["statuslist"]).toBool();

        QString taggingdata = QString("{"
                                      "\"objectName\":\"taggingdata\","
                                      "\"checklist\":%1,"
                                      "\"statuslist\":%2"
                                      "}")
                                 .arg(tagging)
                                 .arg(statuslist ? "true" : "false");

        qDebug() << "taggingdata:" << taggingdata << "tagging:" << tagging << "statuslist:" << statuslist;
        emit taggingpoint(taggingdata);
    }else if (getCommand.contains("editSettingNetwork")){
        QString IPaddress = command.value("editsIPAddress").toString();
        QString GateWsys = command.value("editsGateWays").toString();
        qDebug() << "IPaddress:" << IPaddress << "GateWsys:" << GateWsys;

        QString settingNetwork = QString("{"
                                          "\"objectName\":\"updateSettingNetwork\","
                                          "\"ipaddress\":\"%1\","
                                          "\"gateway\":\"%2\""
                                          "}")
                                     .arg(IPaddress)
                                     .arg(GateWsys);

        qDebug() << "settingNetwork:" << settingNetwork;
//         emit settingNetWorkandSNMP(settingNetwork);
    }else if (getCommand == "editSetSNMPServerIP") {
        QString snmpIP = command.value("editsSNMPServer").toString();
        qDebug() << "snmpIP:" << snmpIP;

        QString setIPSNMP = QString("{"
                                     "\"objectName\":\"updateSettingNetwork\","
                                     "\"ip_snmp\":\"%1\""
                                     "}")
                            .arg(snmpIP);

        qDebug() << "setIPSNMP:" << setIPSNMP;
         emit settingNetWorkandSNMP(setIPSNMP);
    }else if (getCommand == "editTimesyncServer") {
            QString timeServer = command.value("editsTimeSyncServer").toString();
            qDebug() << "settimeServer:" << timeServer;

            QString settimeServer = QString("{"
                                         "\"objectName\":\"updateSettingNetwork\","
                                         "\"ntpServer\":\"%1\""
                                         "}")
                                .arg(timeServer);

            qDebug() << "settimeServer:" << settimeServer;
             emit settingNetWorkandSNMP(settimeServer);
        }else if (getCommand == "SNMPenable") {
            bool plcDoError = command.contains("plcDOError") ? QJsonValue(command["plcDoError"]).toBool() : command.value("plcDoError").toBool();
            bool plcDiError = command.contains("plcDiError") ? QJsonValue(command["plcDiError"]).toBool() : command.value("plcDiError").toBool();
            bool hispeedPhaseA = command.contains("hispeedPhaseA") ? QJsonValue(command["hispeedPhaseA"]).toBool() : command.value("hispeedPhaseA").toBool();
            bool hispeedPhaseB = command.contains("hispeedPhaseB") ? QJsonValue(command["hispeedPhaseB"]).toBool() : command.value("hispeedPhaseB").toBool();
            bool hispeedPhaseC = command.contains("hispeedPhaseC") ? QJsonValue(command["hispeedPhaseC"]).toBool() : command.value("hispeedPhaseC").toBool();
            bool commuPhaseA = command.contains("commuPhaseA") ? QJsonValue(command["commuPhaseA"]).toBool() : command.value("commuPhaseA").toBool();
            bool commuPhaseB = command.contains("commuPhaseB") ? QJsonValue(command["commuPhaseB"]).toBool() : command.value("commuPhaseB").toBool();
            bool commuPhaseC = command.contains("commuPhaseC") ? QJsonValue(command["commuPhaseC"]).toBool() : command.value("commuPhaseC").toBool();
            bool gpsModule = command.contains("gpsModule") ? QJsonValue(command["gpsModule"]).toBool() : command.value("gpsModule").toBool();
            bool systemInti = command.contains("systemInti") ? QJsonValue(command["systemInti"]).toBool() : command.value("systemInti").toBool();
            bool commuError = command.contains("commuError") ? QJsonValue(command["commuError"]).toBool() : command.value("commuError").toBool();
            bool relayStart = command.contains("relayStart") ? QJsonValue(command["relayStart"]).toBool() : command.value("relayStart").toBool();
            bool surageStart = command.contains("surageStart") ? QJsonValue(command["surageStart"]).toBool() : command.value("surageStart").toBool();
            bool preiodicStart = command.contains("preiodicStart") ? QJsonValue(command["preiodicStart"]).toBool() : command.value("preiodicStart").toBool();
            bool manualTest = command.contains("manualTest") ? QJsonValue(command["manualTest"]).toBool() : command.value("manualTest").toBool();
            bool lflfail = command.contains("lflfail") ? QJsonValue(command["lflfail"]).toBool() : command.value("lflfail").toBool();
            bool lfloperate = command.contains("lfloperate") ? QJsonValue(command["lfloperate"]).toBool() : command.value("lfloperate").toBool();
            if (command.contains("plcDoError")) {
                QString setSNMP = QString("{"
                                               "\"objectName\"     :\"updateSettingNetwork\","
                                               "\"PLC_DO_ERROR\"         :\"%1\""
                                               "}").arg(plcDoError ? "1" : "0");
                qDebug() << "setSNMP plcDoError:" << setSNMP << plcDoError;
                emit settingNetWorkandSNMP(setSNMP);
            }else if (command.contains("plcDiError")) {
                QString setSNMP = QString("{"
                                               "\"objectName\"     :\"updateSettingNetwork\","
                                               "\"PLC_DI_ERROR\"         :\"%1\""
                                               "}").arg(plcDiError ? "1" : "0");
                qDebug() << "setSNMP plcDiError:" << setSNMP << plcDiError;
                emit settingNetWorkandSNMP(setSNMP);
            }else if (command.contains("hispeedPhaseA")) {
                QString setSNMP = QString("{"
                                               "\"objectName\"     :\"updateSettingNetwork\","
                                               "\"MODULE_HI_SPEED_PHASE_A_ERROR\"         :\"%1\""
                                               "}").arg(hispeedPhaseA ? "1" : "0");
                qDebug() << "setSNMP hispeedPhaseA:" << setSNMP << hispeedPhaseA;
                emit settingNetWorkandSNMP(setSNMP);

            }else if (command.contains("hispeedPhaseB")) {
                QString setSNMP = QString("{"
                                               "\"objectName\"     :\"updateSettingNetwork\","
                                               "\"MODULE_HI_SPEED_PHASE_B_ERROR\"         :\"%1\""
                                               "}").arg(hispeedPhaseB ? "1" : "0");
                qDebug() << "setSNMP hispeedPhaseB:" << setSNMP << hispeedPhaseB;
                emit settingNetWorkandSNMP(setSNMP);

            }else if (command.contains("hispeedPhaseC")) {
                QString setSNMP = QString("{"
                                               "\"objectName\"     :\"updateSettingNetwork\","
                                               "\"MODULE_HI_SPEED_PHASE_C_ERROR\"         :\"%1\""
                                               "}").arg(hispeedPhaseC ? "1" : "0");
                qDebug() << "setSNMP hispeedPhaseC:" << setSNMP << hispeedPhaseC;
                emit settingNetWorkandSNMP(setSNMP);

            }else if (command.contains("commuPhaseA")) {
                QString setSNMP = QString("{"
                                               "\"objectName\"     :\"updateSettingNetwork\","
                                               "\"INTERNAL_PHASE_A_ERROR\"         :\"%1\""
                                               "}").arg(commuPhaseA ? "1" : "0");
                qDebug() << "setSNMP commuPhaseA:" << setSNMP << commuPhaseA;
                emit settingNetWorkandSNMP(setSNMP);

            }else if (command.contains("commuPhaseB")) {
                QString setSNMP = QString("{"
                                               "\"objectName\"     :\"updateSettingNetwork\","
                                               "\"INTERNAL_PHASE_B_ERROR\"         :\"%1\""
                                               "}").arg(commuPhaseB ? "1" : "0");
                qDebug() << "setSNMP commuPhaseB:" << setSNMP << commuPhaseB;
                emit settingNetWorkandSNMP(setSNMP);

            }else if (command.contains("commuPhaseC")) {
                QString setSNMP = QString("{"
                                               "\"objectName\"     :\"updateSettingNetwork\","
                                               "\"INTERNAL_PHASE_C_ERROR\"         :\"%1\""
                                               "}").arg(commuPhaseC ? "1" : "0");
                qDebug() << "setSNMP commuPhaseC:" << setSNMP << commuPhaseC;
                emit settingNetWorkandSNMP(setSNMP);

            }else if (command.contains("gpsModule")) {
                QString setSNMP = QString("{"
                                               "\"objectName\"     :\"updateSettingNetwork\","
                                               "\"GPS_MODULE_FAIL\"         :\"%1\""
                                               "}").arg(gpsModule ? "1" : "0");
                qDebug() << "setSNMP gpsModule:" << setSNMP << gpsModule;
                emit settingNetWorkandSNMP(setSNMP);

            }else if (command.contains("systemInti")) {
                QString setSNMP = QString("{"
                                               "\"objectName\"     :\"updateSettingNetwork\","
                                               "\"SYSTEM_INITIAL\"         :\"%1\""
                                               "}").arg(systemInti ? "1" : "0");
                qDebug() << "setSNMP systemInti:" << setSNMP << systemInti;
                emit settingNetWorkandSNMP(setSNMP);

            }else if (command.contains("commuError")) {
                QString setSNMP = QString("{"
                                               "\"objectName\"     :\"updateSettingNetwork\","
                                               "\"COMMUNICATION_ERROR\"         :\"%1\""
                                               "}").arg(commuError ? "1" : "0");
                qDebug() << "setSNMP commuError:" << setSNMP << commuError;
                emit settingNetWorkandSNMP(setSNMP);

            }else if (command.contains("relayStart")) {
                QString setSNMP = QString("{"
                                               "\"objectName\"     :\"updateSettingNetwork\","
                                               "\"RELAY_START_EVENT\"         :\"%1\""
                                               "}").arg(relayStart ? "1" : "0");
                qDebug() << "setSNMP relayStart:" << setSNMP << relayStart;
                emit settingNetWorkandSNMP(setSNMP);

            }else if (command.contains("surageStart")) {
                QString setSNMP = QString("{"
                                               "\"objectName\"     :\"updateSettingNetwork\","
                                               "\"SURGE_START_EVENT\"         :\"%1\""
                                               "}").arg(surageStart ? "1" : "0");
                qDebug() << "setSNMP surageStart:" << setSNMP << surageStart;
                emit settingNetWorkandSNMP(setSNMP);

            }else if (command.contains("preiodicStart")) {
                QString setSNMP = QString("{"
                                               "\"objectName\"     :\"updateSettingNetwork\","
                                               "\"PERIODIC_TEST_EVENT\"         :\"%1\""
                                               "}").arg(preiodicStart ? "1" : "0");
                qDebug() << "setSNMP preiodicStart:" << setSNMP << preiodicStart;
                emit settingNetWorkandSNMP(setSNMP);

            }else if (command.contains("manualTest")) {
                QString setSNMP = QString("{"
                                               "\"objectName\"     :\"updateSettingNetwork\","
                                               "\"MANUAL_TEST_EVENT\"         :\"%1\""
                                               "}").arg(manualTest ? "1" : "0");
                qDebug() << "setSNMP manualTest:" << setSNMP << manualTest;
                emit settingNetWorkandSNMP(setSNMP);

            }else if (command.contains("lflfail")) {
                QString setSNMP = QString("{"
                                               "\"objectName\"     :\"updateSettingNetwork\","
                                               "\"LFL_FAIL\"         :\"%1\""
                                               "}").arg(lflfail ? "1" : "0");
                qDebug() << "setSNMP lflfail:" << setSNMP << lflfail;
                emit settingNetWorkandSNMP(setSNMP);

            }else if (command.contains("lfloperate")) {
                QString setSNMP = QString("{"
                                               "\"objectName\"     :\"updateSettingNetwork\","
                                               "\"LEL_OPERATE\"         :\"%1\""
                                               "}").arg(lfloperate ? "1" : "0");
                qDebug() << "setSNMP lfloperate:" << setSNMP << lfloperate;
                emit settingNetWorkandSNMP(setSNMP);

            }
            qDebug() << "SNMPenable:" << plcDoError << plcDiError << hispeedPhaseA << hispeedPhaseB << hispeedPhaseC << commuPhaseA << commuPhaseB << commuPhaseC << gpsModule << systemInti << commuError << relayStart << surageStart << preiodicStart << manualTest << lflfail << lfloperate;
    }else if (getCommand.contains("sagText")) {
        double sagFactor = QJsonValue(command["sagText"]).toDouble();
        QString displaySetting = QString("{"
                                        "\"objectName\"     :\"displaySetting\","
                                        "\"samplingRateInit\"         :%1"
                                        "}").arg(sagFactor);
        qDebug() << "displaySetting:" << displaySetting << sagFactor;
        settingdisplay(displaySetting);
    }else if (getCommand.contains("samplingText")) {
        double samplingRate = QJsonValue(command["samplingText"]).toDouble();
        QString displaySetting = QString("{"
                                        "\"objectName\"     :\"displaySetting\","
                                        "\"samplingRate\"         :%1"
                                        "}").arg(samplingRate);
        qDebug() << "displaySetting:" << displaySetting << samplingRate;
        settingdisplay(displaySetting);
    }else if (getCommand.contains("distancetostartText")) {
        double distanceStart = QJsonValue(command["distancetostartText"]).toDouble();
        QString displaySetting = QString("{"
                                        "\"objectName\"     :\"displaySetting\","
                                        "\"distancetostartText\"         :%1"
                                        "}").arg(distanceStart);
        qDebug() << "displaySetting:" << displaySetting << distanceStart;
        settingdisplay(displaySetting);
    }else if (getCommand.contains("distancetoshowText")) {
        double distanceShow = QJsonValue(command["distancetoshowText"]).toDouble();
        QString displaySetting = QString("{"
                                        "\"objectName\"     :\"displaySetting\","
                                        "\"distancetoshowText\"         :%1"
                                        "}").arg(distanceShow);
        qDebug() << "displaySetting:" << displaySetting << distanceShow;
        settingdisplay(displaySetting);
    }else if (getCommand.contains("distancetoshowText")) {
        double distanceShow = QJsonValue(command["distancetoshowText"]).toDouble();
        QString displaySetting = QString("{"
                                        "\"objectName\"     :\"displaySetting\","
                                        "\"distancetoshowText\"         :%1"
                                        "}").arg(distanceShow);
        qDebug() << "displaySetting:" << displaySetting << distanceShow;
        settingdisplay(displaySetting);
    }else if (getCommand.contains("fulldistanceText")) {
        double fulldistance = QJsonValue(command["fulldistanceText"]).toDouble();
        QString displaySetting = QString("{"
                                        "\"objectName\"     :\"displaySetting\","
                                        "\"fulldistanceText\"         :%1"
                                        "}").arg(fulldistance);
        qDebug() << "displaySetting:" << displaySetting << fulldistance;
        settingdisplay(displaySetting);
    }else if (getCommand == "GetSettingDisplay") {
        double sagFactorInit = command["sagFactorInit"].toDouble();
        double samplingRateInit = command["samplingRateInit"].toDouble();
        double distanceToStartInit = command["distanceToStartInit"].toDouble();
        double distanceToShowInit = command["distanceToShowInit"].toDouble();
        double fulldistancesInit = command["fulldistancesInit"].toDouble();

        QString parameterDisplay = QString("{"
                                           "\"objectName\":\"GetSettingDisplay\","
                                           "\"sagFactorInit\":%1,"
                                           "\"samplingRateInit\":%2,"
                                           "\"distanceToStartInit\":%3,"
                                           "\"distanceToShowInit\":%4,"
                                           "\"fulldistancesInit\":%5"
                                           "}").arg(sagFactorInit).arg(samplingRateInit).arg(distanceToStartInit).arg(distanceToShowInit).arg(fulldistancesInit);
        qDebug() << "updataParameterDisplay:" << sagFactorInit << samplingRateInit << distanceToStartInit << distanceToShowInit << fulldistancesInit;
        cppCommand(parameterDisplay);
        calculate(parameterDisplay);
    } else if (getCommand == "getThreshold") {
        double thresholdInitA = command["thresholdInitA"].toDouble();
        double thresholdInitB = command["thresholdInitB"].toDouble();
        double thresholdInitC = command["thresholdInitC"].toDouble();

        QString updatethresholdParam = QString("{"
                                           "\"objectName\":\"getThreshold\","
                                           "\"thresholdInitA\":%1,"
                                           "\"thresholdInitB\":%2,"
                                           "\"thresholdInitC\":%3"
                                           "}").arg(thresholdInitA).arg(thresholdInitB).arg(thresholdInitC);
        qDebug() << "updatethresholdParam:" << thresholdInitA << thresholdInitB << thresholdInitC;
        cppCommand(updatethresholdParam);
        calculate(updatethresholdParam);
    }else if(getCommand == "ManualTest"){
        cppManual = "ManualTest";
        manualtest(cppManual);
    }else if(getCommand == "PatternTest"){
        int patternNum = command["patternNum"].toInt();
        cppPattern = "PatternTest";
        patterntest(patternNum);        
    }else if(getCommand == "CLEAR_ALARM"){
        cppCommand(qmlJson);
    }else if(getCommand == "dataPlotingA"){
        qDebug() << "dataPlotingA:";
        cppCommand(qmlJson);
    }else if(getCommand == "dataPlotingB"){
        qDebug() << "dataPlotingB:";
        cppCommand(qmlJson);
    }else if(getCommand == "dataPlotingC"){
        qDebug() << "dataPlotingC:";
        cppCommand(qmlJson);
    }else if(getCommand == "dataPlotingB"){
        qDebug() << "dataPlotingB:";

       cppCommand(qmlJson);
    }else if(getCommand == "dataPlotingC"){
        qDebug() << "dataPlotingC:";
       cppCommand(qmlJson);
    }else if(getCommand == "patternA"){
        qDebug() << "patternA:";
       cppCommand(qmlJson);
    }else if(getCommand == "patternB"){
//        qDebug() << "patternB:";
       cppCommand(qmlJson);
    }else if(getCommand == "patternC"){
       cppCommand(qmlJson);
    }else if(getCommand == "spinBoxDisplay"){
        int levelofligth = command["displayLight"].toInt();
        qDebug() << "levelofligth:" << levelofligth;
        if(levelofligth == 10){
            system("sudo pigs p 13 255");
        }else if(levelofligth == 9){
            system("sudo pigs p 13 230");
        }else if(levelofligth == 8){
            system("sudo pigs p 13 205");
        }else if(levelofligth == 7){
            system("sudo pigs p 13 180");
        }else if(levelofligth == 6){
            system("sudo pigs p 13 155");
        }else if(levelofligth == 5){
            system("sudo pigs p 13 130");
        }else if(levelofligth == 4){
            system("sudo pigs p 13 80");
        }else if(levelofligth == 3){
            system("sudo pigs p 13 55");
        }else if(levelofligth == 2){
            system("sudo pigs p 13 30");
        }else if(levelofligth == 1){
            system("sudo pigs p 13 5");
        }
    }else if(getCommand == "getPeriodicInfo"){
        cppCommand(qmlJson);
    }else if(getCommand == "TrapsEnabling"){
        networks->ip_address = command["ip_address"].toString();
        networks->ip_gateway = command["ip_gateway"].toString();
        networks->ip_snmp = command["ip_snmp"].toString();
        networks->ip_timeserver = command["ip_timeserver"].toString();
        qDebug() <<networks->ip_address << networks->ip_gateway << networks->ip_snmp<< networks->ip_timeserver << command["ip_address"].toString() << command["ip_snmp"].toString();
        updateNetwork();
        cppCommand(qmlJson);
        qDebug()<< "TrapsEnabling:" << qmlJson;
    }else if(getCommand == "statusFail"){
        cppCommand(qmlJson);
    }else if(getCommand == "statusOperate"){
        cppCommand(qmlJson);
    }else if(getCommand == "autoSetValueMarginA"){
        qDebug()<< "AutoValueA:" << qmlJson;
        emit updataListOfMarginA(qmlJson);
    }else if(getCommand == "autoSetValueMarginB"){
        qDebug()<< "AutoValueB:" << qmlJson;
        emit updataListOfMarginB(qmlJson);
    }else if(getCommand == "autoSetValueMarginC"){
        qDebug()<< "AutoValueC:" << qmlJson;
        emit updataListOfMarginC(qmlJson);
    }else if(getCommand == "updateValueMargin"){
        qDebug()<< "test_updateValueMargin:" << qmlJson;
        emit getMarginUpdate();
    }else if(getCommand == "MarginTableUpdated"){
        qDebug()<< "MarginTableUpdated:" << qmlJson;
        cppCommand(qmlJson);
    }else if(getCommand == "marginlistCountA"){
        qDebug()<< "marginlistCountA:" << qmlJson;
        cppCommand(qmlJson);
    }else if(getCommand == "marginlistCountB"){
        qDebug()<< "marginlistCountB:" << qmlJson;
        cppCommand(qmlJson);
    }else if(getCommand == "marginlistCountC"){
        qDebug()<< "marginlistCountC:" << qmlJson;
        cppCommand(qmlJson);
    }else if(getCommand == "updateParameterMargin"){
        qDebug()<< "updateParameterMargin:" << qmlJson;
        cppCommand(qmlJson);
    }else if(getEventAndAlert == "PLC_DO_ERROR") {
        QJsonDocument jsonDoc = QJsonDocument::fromJson(qmlJson.toUtf8());
        if (!jsonDoc.isObject()) {
            qDebug() << "Invalid JSON format.";
            return;
        }
        QJsonObject command = jsonDoc.object();
        if (command.contains("state") && command["state"].isBool()) {
            bool currentState = command["state"].toBool();
            if (isFirstEvent_DO) {
                qDebug() << "First event - Sending command...";
                cppCommand(qmlJson);
                previousStates_DO = currentState;
                isFirstEvent_DO = false;
                return;
            }
            if (currentState != previousStates_DO) {
                qDebug() << "State changed - Sending command...";
                cppCommand(qmlJson);
                previousStates_DO = currentState;
            } else {
            }
        } else {
        }
    }else if(getEventAndAlert == "PLC_DI_ERROR") {
        QJsonDocument jsonDoc = QJsonDocument::fromJson(qmlJson.toUtf8());
        if (!jsonDoc.isObject()) {
            return;
        }
        QJsonObject command = jsonDoc.object();
        if (command.contains("state") && command["state"].isBool()) {
            bool currentState = command["state"].toBool();
            if (isFirstEvent_DI) {
                qDebug() << "First event - Sending command...";
                cppCommand(qmlJson);
                previousStates_DI = currentState;
                isFirstEvent_DI = false;
                return;
            }

            if (currentState != previousStates_DI) {
                qDebug() << "State changed - Sending command...";
                cppCommand(qmlJson);
                previousStates_DI = currentState;
            } else {
            }
        } else {
            qDebug() << "Missing or invalid 'state' field.";
        }
    }else if(getEventAndAlert == "INTERNAL_PHASE_A_ERROR") {
        QJsonDocument jsonDoc = QJsonDocument::fromJson(qmlJson.toUtf8());
        if (!jsonDoc.isObject()) {
            qDebug() << "Invalid JSON format.";
            return;
        }
        QJsonObject command = jsonDoc.object();
        if (command.contains("state") && command["state"].isBool()) {
            bool currentState = command["state"].toBool();
            if (isFirstEvent_PHASE_A_ERROR) {
                qDebug() << "First event - Sending command...";
                cppCommand(qmlJson);
                previousStates_PHASE_A_ERROR = currentState;
                isFirstEvent_PHASE_A_ERROR = false;
                return;
            }
            if (currentState != previousStates_PHASE_A_ERROR) {
                qDebug() << "State changed - Sending command...";
                cppCommand(qmlJson);
                previousStates_PHASE_A_ERROR = currentState;
            } else {
            }
        } else {
        }
    }else if(getEventAndAlert == "INTERNAL_PHASE_B_ERROR") {
        QJsonDocument jsonDoc = QJsonDocument::fromJson(qmlJson.toUtf8());
        if (!jsonDoc.isObject()) {
            qDebug() << "Invalid JSON format.";
            return;
        }
        QJsonObject command = jsonDoc.object();
        if (command.contains("state") && command["state"].isBool()) {
            bool currentState = command["state"].toBool();
            if (isFirstEvent_PHASE_B_ERROR) {
                qDebug() << "First event - Sending command...";
                cppCommand(qmlJson);
                previousStates_PHASE_B_ERROR = currentState;
                isFirstEvent_PHASE_B_ERROR = false;
                return;
            }
            if (currentState != previousStates_PHASE_B_ERROR) {
                cppCommand(qmlJson);
                previousStates_PHASE_B_ERROR = currentState;
            } else {
            }
        } else {
            qDebug() << "Missing or invalid 'state' field.";
        }
    }else if(getEventAndAlert == "INTERNAL_PHASE_C_ERROR") {
        QJsonDocument jsonDoc = QJsonDocument::fromJson(qmlJson.toUtf8());
        if (!jsonDoc.isObject()) {
            qDebug() << "Invalid JSON format.";
            return;
        }
        QJsonObject command = jsonDoc.object();
        if (command.contains("state") && command["state"].isBool()) {
            bool currentState = command["state"].toBool();
            if (isFirstEvent_PHASE_C_ERROR) {
                cppCommand(qmlJson);
                previousStates_PHASE_C_ERROR = currentState;
                isFirstEvent_PHASE_C_ERROR = false;
                return;
            }
            if (currentState != previousStates_PHASE_C_ERROR) {
                cppCommand(qmlJson);
                previousStates_PHASE_C_ERROR = currentState;
            } else {
                qDebug() << "State unchanged - Ignoring.";
            }
        } else {
            qDebug() << "Missing or invalid 'state' field.";
        }
    }else if(getEventAndAlert == "MODULE_HI_SPEED_PHASE_A_ERROR") {
        QJsonDocument jsonDoc = QJsonDocument::fromJson(qmlJson.toUtf8());
        if (!jsonDoc.isObject()) {
            qDebug() << "Invalid JSON format.";
            return;
        }
        QJsonObject command = jsonDoc.object();
        if (command.contains("state") && command["state"].isBool()) {
            bool currentState = command["state"].toBool();
            if (isFirstEvent_PHASE_A_ERROR) {
                cppCommand(qmlJson);
                previousStates_PHASE_A_ERROR = currentState;
                isFirstEvent_PHASE_A_ERROR = false;
                return;
            }
            if (currentState != previousStates_PHASE_A_ERROR) {
                cppCommand(qmlJson);
                previousStates_PHASE_A_ERROR = currentState;
            } else {
            }
        } else {
            qDebug() << "Missing or invalid 'state' field.";
        }
    }else if(getEventAndAlert == "MODULE_HI_SPEED_PHASE_B_ERROR") {
        QJsonDocument jsonDoc = QJsonDocument::fromJson(qmlJson.toUtf8());
        if (!jsonDoc.isObject()) {
            qDebug() << "Invalid JSON format.";
            return;
        }
        QJsonObject command = jsonDoc.object();
        if (command.contains("state") && command["state"].isBool()) {
            bool currentState = command["state"].toBool();
            if (isFirstEvent_PHASE_B_ERROR) {
                cppCommand(qmlJson);
                previousStates_PHASE_B_ERROR = currentState;
                isFirstEvent_PHASE_B_ERROR = false;
                return;
            }
            if (currentState != previousStates_PHASE_B_ERROR) {
                cppCommand(qmlJson);
                previousStates_PHASE_B_ERROR = currentState;
            } else {
                qDebug() << "State unchanged - Ignoring.";
            }
        } else {
            qDebug() << "Missing or invalid 'state' field.";
        }
    }else if(getEventAndAlert == "MODULE_HI_SPEED_PHASE_C_ERROR") {
        QJsonDocument jsonDoc = QJsonDocument::fromJson(qmlJson.toUtf8());
        if (!jsonDoc.isObject()) {
            qDebug() << "Invalid JSON format.";
            return;
        }
        QJsonObject command = jsonDoc.object();
        if (command.contains("state") && command["state"].isBool()) {
            bool currentState = command["state"].toBool();
            if (isFirstEvent_PHASE_C_ERROR) {
                cppCommand(qmlJson);
                previousStates_PHASE_C_ERROR = currentState;
                isFirstEvent_PHASE_C_ERROR = false;
                return;
            }
            if (currentState != previousStates_PHASE_C_ERROR) {
                cppCommand(qmlJson);
                previousStates_PHASE_C_ERROR = currentState;
            } else {
                qDebug() << "State unchanged - Ignoring.";
            }
        } else {
            qDebug() << "Missing or invalid 'state' field.";
        }
    }else if(getEventAndAlert == "GPS_MODULE_FAIL") {
        QJsonDocument jsonDoc = QJsonDocument::fromJson(qmlJson.toUtf8());
        if (!jsonDoc.isObject()) {
            qDebug() << "Invalid JSON format.";
            return;
        }
        QJsonObject command = jsonDoc.object();
        if (command.contains("state") && command["state"].isBool()) {
            bool currentState = command["state"].toBool();
            if (isFirstEvent_PHASE_C_ERROR) {
                cppCommand(qmlJson);
                previousStates_GPS_MODULE = currentState;
                isFirstEvent_GPS_MODULE = false;
                return;
            }
            if (currentState != previousStates_GPS_MODULE) {
                cppCommand(qmlJson);
                previousStates_GPS_MODULE = currentState;
            } else {
            }
        } else {
        }
    }else if(getEventAndAlert == "SYSTEM_INITIAL") {
        QJsonDocument jsonDoc = QJsonDocument::fromJson(qmlJson.toUtf8());
        if (!jsonDoc.isObject()) {
            qDebug() << "Invalid JSON format.";
            return;
        }
        QJsonObject command = jsonDoc.object();
        if (command.contains("state") && command["state"].isBool()) {
            bool currentState = command["state"].toBool();
            if (isFirstEvent_PHASE_C_ERROR) {
                cppCommand(qmlJson);
                previousStates_SYSTEM_INITIAL = currentState;
                isFirstEvent_SYSTEM_INITIAL = false;
                return;
            }
            if (currentState != previousStates_SYSTEM_INITIAL) {
                cppCommand(qmlJson);
                previousStates_SYSTEM_INITIAL = currentState;
            } else {
            }
        } else {
        }
    }else if(getEventAndAlert == "COMMUNICATION_ERROR") {
        QJsonDocument jsonDoc = QJsonDocument::fromJson(qmlJson.toUtf8());
        if (!jsonDoc.isObject()) {
            qDebug() << "Invalid JSON format.";
            return;
        }
        QJsonObject command = jsonDoc.object();
        if (command.contains("state") && command["state"].isBool()) {
            bool currentState = command["state"].toBool();
            if (isFirstEvent_PHASE_C_ERROR) {
                cppCommand(qmlJson);
                previousStates_COMMUNICATION_ERROR = currentState;
                isFirstEvent_COMMUNICATION_ERROR = false;
                return;
            }
            if (currentState != previousStates_COMMUNICATION_ERROR) {
                cppCommand(qmlJson);
                previousStates_COMMUNICATION_ERROR = currentState;
            } else {
            }
        } else {
        }
    }else if(getEventAndAlert == "RELAY_START_EVENT") {
        QJsonDocument jsonDoc = QJsonDocument::fromJson(qmlJson.toUtf8());
        if (!jsonDoc.isObject()) {
            qDebug() << "Invalid JSON format.";
            return;
        }
        QJsonObject command = jsonDoc.object();
        if (command.contains("state") && command["state"].isBool()) {
            bool currentState = command["state"].toBool();
            if (isFirstEvent_RELAY_START_EVENT) {
                cppCommand(qmlJson);
                previousStates_RELAY_START_EVENT = currentState;
                isFirstEvent_RELAY_START_EVENT = false;
                return;
            }
            if (currentState != previousStates_RELAY_START_EVENT) {
                cppCommand(qmlJson);
                previousStates_RELAY_START_EVENT = currentState;
            } else {
            }
        } else {
        }
    }else if(getEventAndAlert == "SURGE_START_EVENT") {
        QJsonDocument jsonDoc = QJsonDocument::fromJson(qmlJson.toUtf8());
        if (!jsonDoc.isObject()) {
            qDebug() << "Invalid JSON format.";
            return;
        }
        QJsonObject command = jsonDoc.object();
        if (command.contains("state") && command["state"].isBool()) {
            bool currentState = command["state"].toBool();
            if (isFirstEvent_SURGE_START_EVENT) {
                cppCommand(qmlJson);
                previousStates_SURGE_START_EVENT = currentState;
                isFirstEvent_SURGE_START_EVENT = false;
                return;
            }
            if (currentState != previousStates_SURGE_START_EVENT) {
                cppCommand(qmlJson);
                previousStates_SURGE_START_EVENT = currentState;
            } else {
            }
        } else {
        }
    }else if(getEventAndAlert == "PERIODIC_TEST_EVENT") {
        QJsonDocument jsonDoc = QJsonDocument::fromJson(qmlJson.toUtf8());
        if (!jsonDoc.isObject()) {
            qDebug() << "Invalid JSON format.";
            return;
        }
        QJsonObject command = jsonDoc.object();
        if (command.contains("state") && command["state"].isBool()) {
            bool currentState = command["state"].toBool();
            if (isFirstEvent_PERIODIC_TEST_EVENT) {
                cppCommand(qmlJson);
                previousStates_PERIODIC_TEST_EVENT = currentState;
                isFirstEvent_PERIODIC_TEST_EVENT = false;
                return;
            }
            if (currentState != previousStates_PERIODIC_TEST_EVENT) {
                cppCommand(qmlJson);
                previousStates_PERIODIC_TEST_EVENT = currentState;
            } else {
            }
        } else {
        }
    }else if(getEventAndAlert == "MANUAL_TEST_EVENT") {
        QJsonDocument jsonDoc = QJsonDocument::fromJson(qmlJson.toUtf8());
        if (!jsonDoc.isObject()) {
            qDebug() << "Invalid JSON format.";
            return;
        }
        QJsonObject command = jsonDoc.object();
        if (command.contains("state") && command["state"].isBool()) {
            bool currentState = command["state"].toBool();

            if (isFirstEvent_MANUAL_TEST_EVENT) {
                cppCommand(qmlJson);
                previousStates_MANUAL_TEST_EVENT = currentState;
                isFirstEvent_MANUAL_TEST_EVENT = false;
                return;
            }

            if (currentState != previousStates_MANUAL_TEST_EVENT) {
                cppCommand(qmlJson);
                previousStates_MANUAL_TEST_EVENT = currentState;
            } else {
            }
        } else {
        }
    }else if(getEventAndAlert == "LFL_FAIL") {
        QJsonDocument jsonDoc = QJsonDocument::fromJson(qmlJson.toUtf8());
        if (!jsonDoc.isObject()) {
            qDebug() << "Invalid JSON format.";
            return;
        }
        QJsonObject command = jsonDoc.object();
        if (command.contains("state") && command["state"].isBool()) {
            bool currentState = command["state"].toBool();
            if (isFirstEvent_LFL_FAIL) {
                cppCommand(qmlJson);
                previousStates_LFL_FAIL = currentState;
                isFirstEvent_LFL_FAIL = false;
                return;
            }
            if (currentState != previousStates_LFL_FAIL) {
                cppCommand(qmlJson);
                previousStates_LFL_FAIL = currentState;
            } else {
            }
        } else {
        }
    }else if(getEventAndAlert == "LEL_OPERATE") {
        QJsonDocument jsonDoc = QJsonDocument::fromJson(qmlJson.toUtf8());
        if (!jsonDoc.isObject()) {
            qDebug() << "Invalid JSON format.";
            return;
        }
        QJsonObject command = jsonDoc.object();
        if (command.contains("state") && command["state"].isBool()) {
            bool currentState = command["state"].toBool();
            if (isFirstEvent_LEL_OPERATE) {
                cppCommand(qmlJson);
                previousStates_LEL_OPERATE = currentState;
                isFirstEvent_LEL_OPERATE = false;
                return;
            }
            if (currentState != previousStates_LEL_OPERATE) {
                cppCommand(qmlJson);
                previousStates_LEL_OPERATE = currentState;
            } else {
            }
        } else {
        }
    }else if(getCommand == "realDistanceA") {
        qDebug() << "Check Data realDistanceA:" << qmlJson;
        cppCommand(qmlJson);
    }else if(getCommand == "realDistanceB") {
        qDebug() << "Check Data realDistanceB:" << qmlJson;
        cppCommand(qmlJson);
    }else if(getCommand == "realDistanceC") {
        qDebug() << "Check Data realDistanceC:" << qmlJson;
        cppCommand(qmlJson);
    }else if(getCommand == "userLogIn") {
        qDebug() << "Check userLogIn:" << qmlJson;
        cppCommand(qmlJson);
    }

}

QString getLocalIPAddress() {
    // Retrieve all available IP addresses
    const auto addresses = QNetworkInterface::allAddresses();
    for (const QHostAddress &address : addresses) {
        // Return the first non-loopback IPv4 address
        if (address.protocol() == QAbstractSocket::IPv4Protocol && !address.isLoopback()) {
            return address.toString();
        }
    }
    return "127.0.0.1"; // Fallback if no valid IP found
}

void mainwindows::captureScreenshotseand(){

    QString savePath = "/var/www/html/pic/";

    QScreen *screen = QGuiApplication::primaryScreen();
    if (!screen) {
        qDebug() << "Failed to get primary screen";
        return;
    }

    QString fileName = QString("%1.png").arg(QDateTime::currentDateTime().toSecsSinceEpoch());
    QString filePath = QDir::cleanPath(savePath + fileName);

    QPixmap screenshot = screen->grabWindow(0);
    if (screenshot.save(filePath)) {
        qDebug() << "Saved file to:" << filePath;
    } else {
        qDebug() << "❌Can't save file";
        return;
    }

    QString ip = getLocalIPAddress();
    QString link = QString("http://%1/pic/%2").arg(ip, fileName);

    QJsonObject Param;
    Param.insert("objectName", "ScreenPicture");
    Param.insert("fileName", fileName);
    Param.insert("link", link);

    QJsonDocument jsonDoc(Param);
    QString jsonString = jsonDoc.toJson(QJsonDocument::Compact);
    emit sendMessage(jsonString);
    qDebug() << "JSON Payload:" << jsonString;

}

void mainwindows::ServerCommand(QString qmlJson){
    qDebug()<< "ServerCommand" << qmlJson;
    QJsonDocument d = QJsonDocument::fromJson(qmlJson.toUtf8());
    QJsonObject command = d.object();
    QString getCommand =  QJsonValue(command["objectName"]).toString();
    QString getCommand2 =  QJsonValue(command["menuID"]).toString();
    if(getCommand.contains("SwVersion")){
            isVersion = true;
    }
}

void mainwindows::connectToPLC(){
    qDebug() << "------Open websocket to server------";
    QJsonDocument jsonDoc;
    QJsonObject Param;
    Param.insert("objectName","SwVersion");	             //Name
    Param.insert("SwVersion",SwVersion);	             //Name
    Param.insert("HwVersion",HwVersion);	             //Name
    Param.insert("HwName",HwName);	             //Name
    jsonDoc.setObject(Param);
    QString raw_data = QJsonDocument(Param).toJson(QJsonDocument::Compact).toStdString().c_str();
    QThread::msleep(300);
    emit sendToSocket(raw_data);
}

void mainwindows::calculate(QString msg) { // รับค่าจาก Database
    qDebug() << "calculate:" << msg;
    QJsonDocument d = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject command = d.object();
    QString getCommand = QJsonValue(command["objectName"]).toString();

    // เก็บค่าก่อนหน้า
    double prevSagFactor = sagFactor;
    double prevSamplingRate = samplingRate;
    double prevDistanceToStart = distanceToStart;
    double prevDistanceToShow = distanceToShow;
    double prevFulldistance = fulldistance;
    double prevThresholdA = thresholdA;
    double prevThresholdB = thresholdB;
    double prevThresholdC = thresholdC;

    // อัปเดตค่าจาก JSON ถ้ามี
    if (command.contains("sagFactorInit")) sagFactor = command.value("sagFactorInit").toDouble();
    if (command.contains("samplingRateInit")) samplingRate = command.value("samplingRateInit").toDouble();
    if (command.contains("distanceToStartInit")) distanceToStart = command.value("distanceToStartInit").toDouble();
    if (command.contains("distanceToShowInit")) distanceToShow = command.value("distanceToShowInit").toDouble();
    if (command.contains("fulldistancesInit")) fulldistance = command.value("fulldistancesInit").toDouble();
    if (command.contains("thresholdInitA")) thresholdA = command.value("thresholdInitA").toDouble();
    if (command.contains("thresholdInitB")) thresholdB = command.value("thresholdInitB").toDouble();
    if (command.contains("thresholdInitC")) thresholdC = command.value("thresholdInitC").toDouble();

    // ตรวจสอบค่าที่เปลี่ยนแปลง (Threshold)
    bool isThresholdAChanged = (prevThresholdA != thresholdA);
    bool isThresholdBChanged = (prevThresholdB != thresholdB);
    bool isThresholdCChanged = (prevThresholdC != thresholdC);

    // ตรวจสอบค่าที่เปลี่ยนแปลง (Parameter หลัก)
    bool isSagFactorChanged = (prevSagFactor != sagFactor);
    bool isSamplingRateChanged = (prevSamplingRate != samplingRate);
    bool isDistanceToStartChanged = (prevDistanceToStart != distanceToStart);
    bool isDistanceToShowChanged = (prevDistanceToShow != distanceToShow);
    bool isFulldistanceChanged = (prevFulldistance != fulldistance);

    // ตรวจสอบว่ามีการเปลี่ยนแปลงของ Threshold หรือพารามิเตอร์หลัก
    bool isAnyThresholdChanged = isThresholdAChanged || isThresholdBChanged || isThresholdCChanged;
    bool isAnyParameterChanged = isSagFactorChanged || isSamplingRateChanged ||
                                 isDistanceToStartChanged || isDistanceToShowChanged ||
                                 isFulldistanceChanged;

    // ตรวจสอบค่าที่เป็น NaN หรือ Infinity
    bool isValid = true;
    if (std::isnan(sagFactor) || std::isinf(sagFactor)) isValid = false;
    if (std::isnan(samplingRate) || std::isinf(samplingRate)) isValid = false;
    if (std::isnan(distanceToStart) || std::isinf(distanceToStart)) isValid = false;
    if (std::isnan(distanceToShow) || std::isinf(distanceToShow)) isValid = false;
    if (std::isnan(fulldistance) || std::isinf(fulldistance)) isValid = false;
    if (std::isnan(thresholdA) || std::isinf(thresholdA)) isValid = false;
    if (std::isnan(thresholdB) || std::isinf(thresholdB)) isValid = false;
    if (std::isnan(thresholdC) || std::isinf(thresholdC)) isValid = false;

    // **เช็คว่าอย่างน้อยมีการเปลี่ยนแปลงบางอย่าง**
    if (isValid && (isAnyThresholdChanged || isAnyParameterChanged)) {
        qDebug() << "Debug parameter (Valid and Changed):"
                 << sagFactor << samplingRate << distanceToStart << distanceToShow
                 << fulldistance << thresholdA << thresholdB << thresholdC;

        // ✅ **กรณีที่ Threshold หรือ Parameter เปลี่ยนแปลง**
        if ((isThresholdAChanged || isAnyParameterChanged) && thresholdA > 0) {
            qDebug() << "Threshold A triggered.";
//            plotGraphA(sagFactor, samplingRate, distanceToStart, distanceToShow, fulldistance, thresholdA);
            // plotPatternA(sagFactor, samplingRate, distanceToStart, distanceToShow, fulldistance, thresholdA);
        }
        if ((isThresholdBChanged || isAnyParameterChanged) && thresholdB > 0) {
            qDebug() << "Threshold B triggered.";
//            plotGraphB(sagFactor, samplingRate, distanceToStart, distanceToShow, fulldistance, thresholdB);
//            plotPatternB(sagFactor, samplingRate, distanceToStart, distanceToShow, fulldistance, thresholdB);
        }
        if ((isThresholdCChanged || isAnyParameterChanged) && thresholdC > 0) {
            qDebug() << "Threshold C triggered.";
//            plotGraphC(sagFactor, samplingRate, distanceToStart, distanceToShow, fulldistance, thresholdC);
//            plotPatternC(sagFactor, samplingRate, distanceToStart, distanceToShow, fulldistance, thresholdC);
        }

    } else {
        qDebug() << "Debug parameter (Invalid or Unchanged):"
                 << sagFactor << samplingRate << distanceToStart << distanceToShow
                 << fulldistance << thresholdA << thresholdB << thresholdC;
    }
}



void mainwindows::plotGraphA(double sagFactorInit, double samplingRateInit, double distanceToStartInit,
                            double distanceToShowInit, double fulldistance, double thresholdInitA) {
    qDebug() << "Debug plotGraphA:" << sagFactorInit << samplingRateInit << distanceToStartInit
             << distanceToShowInit << fulldistance << thresholdInitA;

    QString filePath = "/home/pi/data1.raw";
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "Unable to open file:" << filePath;
        return;
    }
    QByteArray data = file.readAll();
    file.close();

    std::vector<float> normalizedValues;
    const uint8_t* ptr = reinterpret_cast<const uint8_t*>(data.constData());
    const uint8_t* endPtr = ptr + data.size();

    while (ptr + 2 <= endPtr) {
        uint16_t rawValue = static_cast<uint16_t>((static_cast<uint8_t>(ptr[1]) << 8) | static_cast<uint8_t>(ptr[0]));
        float normalizedValue = static_cast<float>(rawValue) / 32768.0f;

        // **Apply the condition: set to zero if negative or equals 0xE000**
        if (rawValue == 0xE000 || normalizedValue < 0) {
            normalizedValue = 0.0f;
        }

        normalizedValues.push_back(normalizedValue);
        ptr += 2;
    }

    const float threshold = thresholdInitA / 32768.0f;
    auto startIt = std::find_if(normalizedValues.begin(), normalizedValues.end(), [threshold](float val) {
        return val >= threshold;
    });

    if (startIt == normalizedValues.end()) {
        qDebug() << "Threshold value not found in data.";
        return;
    }
    int startIndex = std::distance(normalizedValues.begin(), startIt);

    int resampling = samplingRateInit / (60 * sagFactorInit);
    float totalDistance = (distanceToShowInit - distanceToStartInit) * 1000;
    int fullpoint = static_cast<int>(totalDistance / (60 * sagFactorInit));
    int trueDistancepoint = fullpoint / resampling;

    float pointInterval = totalDistance / trueDistancepoint;

    std::vector<std::pair<float, float>> result;
    float currentDistance = distanceToStartInit * 1000;

    for (int i = 0; i < trueDistancepoint; ++i) {
        float currentValue = (i * resampling + startIndex < normalizedValues.size())
                             ? normalizedValues[i * resampling + startIndex] * 4096 / 2
                             : 0.0f;
        result.emplace_back(currentDistance, currentValue);
        currentDistance += pointInterval;
    }

    qDebug() << "Final Total Points:" << result.size();

    QJsonObject mainObject;
    QJsonArray dist, volt;
    for (const auto& [distance, voltage] : result) {
        dist.push_back(distance / 1000);
        volt.push_back(voltage);
    }

    mainObject.insert("objectName", "dataPlotingA");
    mainObject.insert("distance", dist);
    mainObject.insert("voltage", volt);

    QJsonDocument jsonDoc(mainObject);
    QString raw_data = jsonDoc.toJson(QJsonDocument::Compact);

    rawdataArrayA = raw_data;
    reSamplingNormalizationA(result);

}

void mainwindows::plotGraphB(double sagFactorInit, double samplingRateInit, double distanceToStartInit,
                            double distanceToShowInit, double fulldistance, double thresholdInitB) {
    qDebug() << "Debug plotGraph:" << sagFactorInit << samplingRateInit << distanceToStartInit
             << distanceToShowInit << fulldistance << thresholdInitB;

    QString filePath = "/home/pi/data0.raw";
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "Unable to open file:" << filePath;
        return;
    }
    QByteArray data = file.readAll();
    file.close();

    std::vector<float> normalizedValues;
    const uint8_t* ptr = reinterpret_cast<const uint8_t*>(data.constData());
    const uint8_t* endPtr = ptr + data.size();

    while (ptr + 2 <= endPtr) {
        uint16_t signedValue = static_cast<uint16_t>((static_cast<uint8_t>(ptr[1]) << 8) | static_cast<uint8_t>(ptr[0]));
        float normalizedValue = static_cast<float>(signedValue) / 32768.0f;  // Convert to mV
        normalizedValues.push_back(normalizedValue);
        ptr += 2;
    }

    qDebug() << "Total samples read: " << normalizedValues.size();

    const float threshold = thresholdInitB / 32768.0f;  // Convert to mV
    auto startIt = std::find_if(normalizedValues.begin(), normalizedValues.end(), [threshold](float val) {
        return val >= threshold;
    });

    if (startIt == normalizedValues.end()) {
        qDebug() << "Threshold value not found in data.";
        return;
    }
    int startIndex = std::distance(normalizedValues.begin(), startIt);
//    qDebug() << "Starting index found at position:" << startIndex;

    int resampling = samplingRateInit / (60 * sagFactorInit); // Resampling rate
//    qDebug() << "Resampling rate:" << resampling;

    float totalDistance = (distanceToShowInit - distanceToStartInit) * 1000;
    int fullpoint = static_cast<int>(totalDistance / (60 * sagFactorInit));
    int trueDistancepoint = fullpoint / resampling; // Points after resampling

//    qDebug() << "Full points:" << fullpoint;
//    qDebug() << "True distance points after resampling:" << trueDistancepoint;

    float pointInterval = totalDistance / trueDistancepoint; // Distance interval per point
//    qDebug() << "Point interval (m):" << pointInterval;

    std::vector<std::pair<float, float>> result;
    float currentDistance = distanceToStartInit * 1000; // Start in meters

    for (int i = 0; i < trueDistancepoint; ++i) {
        float currentValue = (i * resampling + startIndex < normalizedValues.size())
                             ? normalizedValues[i * resampling + startIndex] * 4096/2  // Multiply by 4096 here
                             : 0.0f;
        result.emplace_back(currentDistance, currentValue);
        currentDistance += pointInterval;
    }

    qDebug() << "Final Total Points:" << result.size();
    for (const auto& [distance, voltage] : result) {
//        qDebug() << "X:" << distance / 1000.0 << " km, Y:" << voltage << " mV";
    }

    // JSON Output for Plotting
    QJsonObject mainObject;
    QJsonArray dist, volt;
    for (const auto& [distance, voltage] : result) {
        dist.push_back(distance / 1000);  // Convert m to km
        volt.push_back(voltage);  // Already multiplied by 4096
    }

    mainObject.insert("objectName", "dataPlotingB");
    mainObject.insert("distance", dist);
    mainObject.insert("voltage", volt);

    QJsonDocument jsonDoc(mainObject);
    QString raw_data = jsonDoc.toJson(QJsonDocument::Compact);
//    qDebug() << "Generated JSON:" << raw_data;

    rawdataArrayA = raw_data;
//    emit plotingDataPhaseB(raw_data); reSamplingNormalizationB
    reSamplingNormalizationB(result);
}
void mainwindows::plotGraphC(double sagFactorInit, double samplingRateInit, double distanceToStartInit,
                            double distanceToShowInit, double fulldistance, double thresholdInitC) {
    qDebug() << "Debug plotGraph:" << sagFactorInit << samplingRateInit << distanceToStartInit
             << distanceToShowInit << fulldistance << thresholdInitC;

    QString filePath = "/home/pi/data0.raw";
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "Unable to open file:" << filePath;
        return;
    }
    QByteArray data = file.readAll();
    file.close();

    std::vector<float> normalizedValues;
    const uint8_t* ptr = reinterpret_cast<const uint8_t*>(data.constData());
    const uint8_t* endPtr = ptr + data.size();

    while (ptr + 2 <= endPtr) {
        uint16_t signedValue = static_cast<uint16_t>((static_cast<uint8_t>(ptr[1]) << 8) | static_cast<uint8_t>(ptr[0]));
        float normalizedValue = static_cast<float>(signedValue) / 32768.0f;  // Convert to mV
        normalizedValues.push_back(normalizedValue);
        ptr += 2;
    }

//    qDebug() << "Total samples read: " << normalizedValues.size();

    const float threshold = thresholdInitC / 32768.0f;  // Convert to mV
    auto startIt = std::find_if(normalizedValues.begin(), normalizedValues.end(), [threshold](float val) {
        return val >= threshold;
    });

    if (startIt == normalizedValues.end()) {
        qDebug() << "Threshold value not found in data.";
        return;
    }
    int startIndex = std::distance(normalizedValues.begin(), startIt);
//    qDebug() << "Starting index found at position:" << startIndex;

    int resampling = samplingRateInit / (60 * sagFactorInit);
//    qDebug() << "Resampling rate:" << resampling;

    float totalDistance = (distanceToShowInit - distanceToStartInit) * 1000;
    int fullpoint = static_cast<int>(totalDistance / (60 * sagFactorInit));
    int trueDistancepoint = fullpoint / resampling; // Points after resampling

//    qDebug() << "Full points:" << fullpoint;
//    qDebug() << "True distance points after resampling:" << trueDistancepoint;

    float pointInterval = totalDistance / trueDistancepoint;
//    qDebug() << "Point interval (m):" << pointInterval;

    std::vector<std::pair<float, float>> result;
    float currentDistance = distanceToStartInit * 1000;

    for (int i = 0; i < trueDistancepoint; ++i) {
        float currentValue = (i * resampling + startIndex < normalizedValues.size())
                             ? normalizedValues[i * resampling + startIndex] * 4096/2  // Multiply by 4096 here
                             : 0.0f;
        result.emplace_back(currentDistance, currentValue);
        currentDistance += pointInterval;
    }

    qDebug() << "Final Total Points:" << result.size();
    for (const auto& [distance, voltage] : result) {
//        qDebug() << "X:" << distance / 1000.0 << " km, Y:" << voltage << " mV";
    }

    // JSON Output for Plotting
    QJsonObject mainObject;
    QJsonArray dist, volt;
    for (const auto& [distance, voltage] : result) {
        dist.push_back(distance / 1000);  // Convert m to km
        volt.push_back(voltage);  // Already multiplied by 4096
    }

    mainObject.insert("objectName", "dataPlotingC");
    mainObject.insert("distance", dist);
    mainObject.insert("voltage", volt);

    QJsonDocument jsonDoc(mainObject);
    QString raw_data = jsonDoc.toJson(QJsonDocument::Compact);
//    qDebug() << "Generated JSON C:" << raw_data;

    rawdataArrayC = raw_data;
//    emit plotingDataPhaseB(raw_data); reSamplingNormalizationC
    reSamplingNormalizationC(result);
}

void mainwindows::reSamplingNormalizationA(const std::vector<std::pair<float, float>>& result) {
    if (result.size() < 3) {
        qDebug() << "Not enough data points to process.";
        return;
    }
    qDebug() << "Starting peak detection and smoothing...";

    // Step 1: Detect Peaks
    std::vector<std::pair<float, double>> peakPoints;
    std::pair<float, double> startPoint = {0.0, 0.0};

    for (const auto& point : result) {
        if (point.second > 0.0) { // First non-zero voltage
            startPoint = {point.first, point.second};
            break;
        }
    }
    peakPoints.push_back(startPoint);

    for (size_t i = 1; i < result.size() - 1; ++i) {
        float prevVoltage = result[i - 1].second;
        float currentVoltage = result[i].second;
        float nextVoltage = result[i + 1].second;

        if (prevVoltage < currentVoltage && currentVoltage > nextVoltage) {
            peakPoints.emplace_back(result[i]);
        }
    }

    peakPoints.push_back(result.back());

    auto maxPeakIt = std::max_element(peakPoints.begin(), peakPoints.end(),
                                      [](const std::pair<float, double>& a, const std::pair<float, double>& b) {
                                          return a.second < b.second;
                                      });
    std::pair<float, double> maxPeak = *maxPeakIt;
//    qDebug() << "Maximum peak detected at X:" << maxPeak.first / 1000.0 << "km, Y:" << maxPeak.second << "mV";

    if (std::find(peakPoints.begin(), peakPoints.end(), maxPeak) == peakPoints.end()) {
        peakPoints.push_back(maxPeak);
    }

    qDebug() << "Peaks detected. Total peaks:" << peakPoints.size();

    for (const auto& peak : peakPoints) {
//        qDebug() << "Peak at X:" << peak.first / 1000.0 << "km, Y:" << peak.second << "mV";
    }

    // Step 2: Downsample Peak Points
    std::vector<std::pair<float, double>> downsampledPeaks;
    size_t step = std::max<size_t>(1, peakPoints.size() / 50); // Downsample to around 50 points
    for (size_t i = 0; i < peakPoints.size(); i += step) {
        downsampledPeaks.push_back(peakPoints[i]);
    }
    if (peakPoints.back() != downsampledPeaks.back()) {
        downsampledPeaks.push_back(peakPoints.back()); // Ensure the last point is included
    }

    if (std::find(downsampledPeaks.begin(), downsampledPeaks.end(), maxPeak) == downsampledPeaks.end()) {
        downsampledPeaks.push_back(maxPeak);
    }

    std::sort(downsampledPeaks.begin(), downsampledPeaks.end()); // Sort points by X
//    qDebug() << "Downsampling completed. Total downsampled points:" << downsampledPeaks.size();

    // Step 3: Generate Smooth Curve
    std::vector<std::pair<float, double>> smoothCurve;
    for (size_t i = 0; i < downsampledPeaks.size() - 1; ++i) {
        float x1 = downsampledPeaks[i].first;
        float x2 = downsampledPeaks[i + 1].first;
        double y1 = downsampledPeaks[i].second;
        double y2 = downsampledPeaks[i + 1].second;

        for (float x = x1; x <= x2; x += (x2 - x1) / 10.0) { // Add 10 points per segment
            double t = (x - x1) / (x2 - x1); // Normalize x between 0 and 1
            double y = (1 - t) * y1 + t * y2; // Linear interpolation
            smoothCurve.emplace_back(x, y);
        }
    }

    qDebug() << "Smoothing completed. Total points for the curve:" << smoothCurve.size();

    // Step 4: Prepare JSON Output
    QJsonObject mainObject;
    QJsonArray dist, volt;
    for (const auto& point : smoothCurve) {
        dist.push_back(point.first / 1000.0);  // Convert m to km
        volt.push_back(point.second);         // Voltage in mV
    }
    mainObject.insert("objectName", "dataPlotingA");
    mainObject.insert("distance", dist);
    mainObject.insert("voltage", volt);

    QJsonDocument jsonDoc(mainObject);
    QString raw_data = jsonDoc.toJson(QJsonDocument::Compact);
//    qDebug() << "Generated JSON for smoothed curve:" << raw_data;


    // Emit the signal for the curve
    rawdataArrayA = std::move(raw_data);
    emit plotingDataPhaseA(rawdataArrayA);
}


void mainwindows::reSamplingNormalizationB(const std::vector<std::pair<float, float>>& result) {
    if (result.size() < 3) {
        qDebug() << "Not enough data points to process.";
        return;
    }

    qDebug() << "Starting peak detection and smoothing...";

    std::vector<std::pair<float, double>> peakPoints;
    std::pair<float, double> startPoint = {0.0, 0.0};

    for (const auto& point : result) {
        if (point.second > 0.0) { // First non-zero voltage
            startPoint = {point.first, point.second};
            break;
        }
    }
    peakPoints.push_back(startPoint);

    for (size_t i = 1; i < result.size() - 1; ++i) {
        float prevVoltage = result[i - 1].second;
        float currentVoltage = result[i].second;
        float nextVoltage = result[i + 1].second;

        if (prevVoltage < currentVoltage && currentVoltage > nextVoltage) {
            peakPoints.emplace_back(result[i]);
        }
    }

    peakPoints.push_back(result.back());

    auto maxPeakIt = std::max_element(peakPoints.begin(), peakPoints.end(),
                                      [](const std::pair<float, double>& a, const std::pair<float, double>& b) {
                                          return a.second < b.second;
                                      });
    std::pair<float, double> maxPeak = *maxPeakIt;
//    qDebug() << "Maximum peak detected at X:" << maxPeak.first / 1000.0 << "km, Y:" << maxPeak.second << "mV";

    if (std::find(peakPoints.begin(), peakPoints.end(), maxPeak) == peakPoints.end()) {
        peakPoints.push_back(maxPeak);
    }

//    qDebug() << "Peaks detected. Total peaks:" << peakPoints.size();

    for (const auto& peak : peakPoints) {
//        qDebug() << "Peak at X:" << peak.first / 1000.0 << "km, Y:" << peak.second << "mV";
    }

    std::vector<std::pair<float, double>> downsampledPeaks;
    size_t step = std::max<size_t>(1, peakPoints.size() / 50); // Downsample to around 50 points
    for (size_t i = 0; i < peakPoints.size(); i += step) {
        downsampledPeaks.push_back(peakPoints[i]);
    }
    if (peakPoints.back() != downsampledPeaks.back()) {
        downsampledPeaks.push_back(peakPoints.back()); // Ensure the last point is included
    }

    if (std::find(downsampledPeaks.begin(), downsampledPeaks.end(), maxPeak) == downsampledPeaks.end()) {
        downsampledPeaks.push_back(maxPeak);
    }

    std::sort(downsampledPeaks.begin(), downsampledPeaks.end()); // Sort points by X
//    qDebug() << "Downsampling completed. Total downsampled points:" << downsampledPeaks.size();

    std::vector<std::pair<float, double>> smoothCurve;
    for (size_t i = 0; i < downsampledPeaks.size() - 1; ++i) {
        float x1 = downsampledPeaks[i].first;
        float x2 = downsampledPeaks[i + 1].first;
        double y1 = downsampledPeaks[i].second;
        double y2 = downsampledPeaks[i + 1].second;

        // Interpolate between peaks
        for (float x = x1; x <= x2; x += (x2 - x1) / 10.0) { // Add 10 points per segment
            double t = (x - x1) / (x2 - x1); // Normalize x between 0 and 1
            double y = (1 - t) * y1 + t * y2; // Linear interpolation
            smoothCurve.emplace_back(x, y);
        }
    }

    qDebug() << "Smoothing completed. Total points for the curve:" << smoothCurve.size();

    QJsonObject mainObject;
    QJsonArray dist, volt;
    for (const auto& point : smoothCurve) {
        dist.push_back(point.first / 1000.0);  // Convert m to km
        volt.push_back(point.second);         // Voltage in mV
    }
    mainObject.insert("objectName", "dataPlotingB");
    mainObject.insert("distance", dist);
    mainObject.insert("voltage", volt);

    QJsonDocument jsonDoc(mainObject);
    QString raw_data = jsonDoc.toJson(QJsonDocument::Compact);
//    qDebug() << "Generated JSON for smoothed curve:" << raw_data;

    rawdataArrayB = std::move(raw_data);

    // Emit the signal for the curve
    emit plotingDataPhaseB(rawdataArrayB);
}


void mainwindows::reSamplingNormalizationC(const std::vector<std::pair<float, float>>& result) {
    qDebug() << "reSamplingNormalizationC:" << result;
    if (result.size() < 3) {
        qDebug() << "Not enough data points to process.";
        return;
    }

    qDebug() << "Starting peak detection and smoothing...";

    // Step 1: Detect Peaks
    std::vector<std::pair<float, double>> peakPoints;
    std::pair<float, double> startPoint = {0.0, 0.0};

    // Detect the starting point
    for (const auto& point : result) {
        if (point.second > 0.0) { // First non-zero voltage
            startPoint = {point.first, point.second};
            break;
        }
    }
    peakPoints.push_back(startPoint);

    // Detect peaks
    for (size_t i = 1; i < result.size() - 1; ++i) {
        float prevVoltage = result[i - 1].second;
        float currentVoltage = result[i].second;
        float nextVoltage = result[i + 1].second;

        if (prevVoltage < currentVoltage && currentVoltage > nextVoltage) {
            peakPoints.emplace_back(result[i]);
        }
    }

    peakPoints.push_back(result.back());

    auto maxPeakIt = std::max_element(peakPoints.begin(), peakPoints.end(),
                                      [](const std::pair<float, double>& a, const std::pair<float, double>& b) {
                                          return a.second < b.second;
                                      });
    std::pair<float, double> maxPeak = *maxPeakIt;
//    qDebug() << "Maximum peak detected at X:" << maxPeak.first / 1000.0 << "km, Y:" << maxPeak.second << "mV";

    if (std::find(peakPoints.begin(), peakPoints.end(), maxPeak) == peakPoints.end()) {
        peakPoints.push_back(maxPeak);
    }

//    qDebug() << "Peaks detected. Total peaks:" << peakPoints.size();

    // Debug peaks
    for (const auto& peak : peakPoints) {
//        qDebug() << "Peak at X:" << peak.first / 1000.0 << "km, Y:" << peak.second << "mV";
    }

    // Step 2: Downsample Peak Points
    std::vector<std::pair<float, double>> downsampledPeaks;
    size_t step = std::max<size_t>(1, peakPoints.size() / 50); // Downsample to around 50 points
    for (size_t i = 0; i < peakPoints.size(); i += step) {
        downsampledPeaks.push_back(peakPoints[i]);
    }
    if (peakPoints.back() != downsampledPeaks.back()) {
        downsampledPeaks.push_back(peakPoints.back()); // Ensure the last point is included
    }

    // Ensure the maximum peak is included in the downsampled points
    if (std::find(downsampledPeaks.begin(), downsampledPeaks.end(), maxPeak) == downsampledPeaks.end()) {
        downsampledPeaks.push_back(maxPeak);
    }

    std::sort(downsampledPeaks.begin(), downsampledPeaks.end()); // Sort points by X
//    qDebug() << "Downsampling completed. Total downsampled points:" << downsampledPeaks.size();

    // Step 3: Smoothing using Linear Interpolation
    std::vector<std::pair<float, double>> smoothCurve;
    for (size_t i = 0; i < downsampledPeaks.size() - 1; ++i) {
        float x1 = downsampledPeaks[i].first;
        float x2 = downsampledPeaks[i + 1].first;
        double y1 = downsampledPeaks[i].second;
        double y2 = downsampledPeaks[i + 1].second;

        // Interpolate between peaks
        for (float x = x1; x <= x2; x += (x2 - x1) / 10.0) { // Add 10 points per segment
            double t = (x - x1) / (x2 - x1); // Normalize x between 0 and 1
            double y = (1 - t) * y1 + t * y2; // Linear interpolation
            smoothCurve.emplace_back(x, y);
        }
    }

//    qDebug() << "Smoothing completed. Total points for the curve:" << smoothCurve.size();

    // Step 4: Prepare JSON Output
    QJsonObject mainObject;
    QJsonArray dist, volt;
    for (const auto& point : smoothCurve) {
        dist.push_back(point.first / 1000.0);  // Convert m to km
        volt.push_back(point.second);         // Voltage in mV
    }
    mainObject.insert("objectName", "dataPlotingC");
    mainObject.insert("distance", dist);
    mainObject.insert("voltage", volt);

    QJsonDocument jsonDoc(mainObject);
    QString raw_data = jsonDoc.toJson(QJsonDocument::Compact);
//    qDebug() << "Generated JSON for smoothed curve:" << raw_data;

    rawdataArrayC = std::move(raw_data);

    // Emit the signal for the curve
    emit plotingDataPhaseC(rawdataArrayC);
}

void mainwindows::plotPatternA(double sagFactorInit, double samplingRateInit, double distanceToStartInit,
                            double distanceToShowInit, double fulldistance, double thresholdInitA) {
    qDebug() << "Debug plotGraph:" << sagFactorInit << samplingRateInit << distanceToStartInit
             << distanceToShowInit << fulldistance << thresholdInitA;

    QString filePath = "/home/pi/data0.raw";
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "Unable to open file:" << filePath;
        return;
    }
    QByteArray data = file.readAll();
    file.close();

    std::vector<float> normalizedValues;
    const uint8_t* ptr = reinterpret_cast<const uint8_t*>(data.constData());
    const uint8_t* endPtr = ptr + data.size();

    while (ptr + 2 <= endPtr) {
        uint16_t signedValue = static_cast<uint16_t>((static_cast<uint8_t>(ptr[1]) << 8) | static_cast<uint8_t>(ptr[0]));
        float normalizedValue = static_cast<float>(signedValue) / 32768.0f;  // Convert to mV
        normalizedValues.push_back(normalizedValue);
        ptr += 2;
    }

//    qDebug() << "Total samples read: " << normalizedValues.size();

    const float threshold = thresholdInitA / 32768.0f;  // Convert to mV
    auto startIt = std::find_if(normalizedValues.begin(), normalizedValues.end(), [threshold](float val) {
        return val >= threshold;
    });

    if (startIt == normalizedValues.end()) {
        qDebug() << "Threshold value not found in data.";
        return;
    }
    int startIndex = std::distance(normalizedValues.begin(), startIt);
//    qDebug() << "Starting index found at position:" << startIndex;

    int resampling = samplingRateInit / (60 * sagFactorInit); // Resampling rate
//    qDebug() << "Resampling rate:" << resampling;

    float totalDistance = (distanceToShowInit - distanceToStartInit) * 1000;
    int fullpoint = static_cast<int>(totalDistance / (60 * sagFactorInit));
    int trueDistancepoint = fullpoint / resampling; // Points after resampling

//    qDebug() << "Full points:" << fullpoint;
//    qDebug() << "True distance points after resampling:" << trueDistancepoint;

    float pointInterval = totalDistance / trueDistancepoint; // Distance interval per point
//    qDebug() << "Point interval (m):" << pointInterval;

    std::vector<std::pair<float, float>> result;
    float currentDistance = distanceToStartInit * 1000; // Start in meters

    for (int i = 0; i < trueDistancepoint; ++i) {
        float currentValue = (i * resampling + startIndex < normalizedValues.size())
                             ? normalizedValues[i * resampling + startIndex] * 4096/2  // Multiply by 4096 here
                             : 0.0f;
        result.emplace_back(currentDistance, currentValue);
        currentDistance += pointInterval;
    }

    qDebug() << "Final Total Points:" << result.size();
    for (const auto& [distance, voltage] : result) {
//        qDebug() << "X:" << distance / 1000.0 << " km, Y:" << voltage << " mV";
    }

    // JSON Output for Plotting
    QJsonObject mainObject;
    QJsonArray dist, volt;
    for (const auto& [distance, voltage] : result) {
        dist.push_back(distance / 1000);  // Convert m to km
        volt.push_back(voltage);  // Already multiplied by 4096
    }

    mainObject.insert("objectName", "patternA");
    mainObject.insert("distance", dist);
    mainObject.insert("voltage", volt);

    QJsonDocument jsonDoc(mainObject);
    QString raw_data = jsonDoc.toJson(QJsonDocument::Compact);
//    qDebug() << "Generated JSON:" << raw_data;

    rawdataArrayA = raw_data;
    reSamplingNormalizationPatternA(result);

}

void mainwindows::reSamplingNormalizationPatternA(const std::vector<std::pair<float, float>>& result) {
    if (result.size() < 3) {
        qDebug() << "Not enough data points to process.";
        return;
    }
    qDebug() << "Starting peak detection and smoothing...";

    // Step 1: Detect Peaks
    std::vector<std::pair<float, double>> peakPoints;
    std::pair<float, double> startPoint = {0.0, 0.0};

    for (const auto& point : result) {
        if (point.second > 0.0) { // First non-zero voltage
            startPoint = {point.first, point.second};
            break;
        }
    }
    peakPoints.push_back(startPoint);

    for (size_t i = 1; i < result.size() - 1; ++i) {
        float prevVoltage = result[i - 1].second;
        float currentVoltage = result[i].second;
        float nextVoltage = result[i + 1].second;

        if (prevVoltage < currentVoltage && currentVoltage > nextVoltage) {
            peakPoints.emplace_back(result[i]);
        }
    }

    peakPoints.push_back(result.back());

    auto maxPeakIt = std::max_element(peakPoints.begin(), peakPoints.end(),
                                      [](const std::pair<float, double>& a, const std::pair<float, double>& b) {
                                          return a.second < b.second;
                                      });
    std::pair<float, double> maxPeak = *maxPeakIt;

    if (std::find(peakPoints.begin(), peakPoints.end(), maxPeak) == peakPoints.end()) {
        peakPoints.push_back(maxPeak);
    }

    qDebug() << "Peaks detected. Total peaks:" << peakPoints.size();

    // Step 2: Downsample Peak Points
    std::vector<std::pair<float, double>> downsampledPeaks;
    size_t step = std::max<size_t>(1, peakPoints.size() / 50); // Downsample to around 50 points
    for (size_t i = 0; i < peakPoints.size(); i += step) {
        downsampledPeaks.push_back(peakPoints[i]);
    }
    if (peakPoints.back() != downsampledPeaks.back()) {
        downsampledPeaks.push_back(peakPoints.back()); // Ensure the last point is included
    }

    if (std::find(downsampledPeaks.begin(), downsampledPeaks.end(), maxPeak) == downsampledPeaks.end()) {
        downsampledPeaks.push_back(maxPeak);
    }

    std::sort(downsampledPeaks.begin(), downsampledPeaks.end()); // Sort points by X

    std::vector<std::pair<float, double>> smoothCurve;
    for (size_t i = 0; i < downsampledPeaks.size() - 1; ++i) {
        float x1 = downsampledPeaks[i].first;
        float x2 = downsampledPeaks[i + 1].first;
        double y1 = downsampledPeaks[i].second;
        double y2 = downsampledPeaks[i + 1].second;

        for (float x = x1; x <= x2; x += (x2 - x1) / 10.0) { // Add 10 points per segment
            double t = (x - x1) / (x2 - x1); // Normalize x between 0 and 1
            double y = (1 - t) * y1 + t * y2; // Linear interpolation
            smoothCurve.emplace_back(x, y);
        }
    }

    qDebug() << "Smoothing completed. Total points for the curve:" << smoothCurve.size();

    QJsonObject mainObject;
    QJsonArray dist, volt;
    for (const auto& point : smoothCurve) {
        dist.push_back(point.first / 1000.0);  // Convert m to km
        volt.push_back(point.second);         // Voltage in mV
    }
    mainObject.insert("objectName", "patternA");
    mainObject.insert("distance", dist);
    mainObject.insert("voltage", volt);

    QJsonDocument jsonDoc(mainObject);
    QString raw_data = jsonDoc.toJson(QJsonDocument::Compact);

    rawdataArrayA = std::move(raw_data);
    emit plotingDataPhaseA(rawdataArrayA);

    QDir dir("/home/pi/patternData");
    if (!dir.exists()) {
        if (!dir.mkpath(".")) {
            qDebug() << "Failed to create directory:" << dir.absolutePath();
            return;
        }
    }

    QString dateStr = QDate::currentDate().toString("dd_MM_yyyy");
    QString timeStr = QTime::currentTime().toString("hh_mm_ss");
    QString filePath = QString("/home/pi/patternData/patternA_1_%1_%2.csv").arg(dateStr).arg(timeStr);

    QFile file(filePath);

    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qDebug() << "Failed to create CSV file:" << filePath;
        return;
    }

    QTextStream out(&file);
    out << "Distance (km),Voltage (mV)\n";
    for (const auto& point : smoothCurve) {
        double distance = point.first / 1000.0; // Convert to km
        double voltage = point.second;         // Voltage in mV
        out << QString::number(distance, 'f', 6) << "," << QString::number(voltage, 'f', 6) << "\n";
    }

    file.close();

    qDebug() << "CSV file created successfully at:" << filePath;
}


void mainwindows::plotPatternB(double sagFactorInit, double samplingRateInit, double distanceToStartInit,
                            double distanceToShowInit, double fulldistance, double thresholdInitB) {
    qDebug() << "Debug plotPatternB:" << sagFactorInit << samplingRateInit << distanceToStartInit
             << distanceToShowInit << fulldistance << thresholdInitB;

    QString filePath = "/home/pi/data0.raw";
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "Unable to open file:" << filePath;
        return;
    }
    QByteArray data = file.readAll();
    file.close();

    std::vector<float> normalizedValues;
    const uint8_t* ptr = reinterpret_cast<const uint8_t*>(data.constData());
    const uint8_t* endPtr = ptr + data.size();

    while (ptr + 2 <= endPtr) {
        uint16_t signedValue = static_cast<uint16_t>((static_cast<uint8_t>(ptr[1]) << 8) | static_cast<uint8_t>(ptr[0]));
        float normalizedValue = static_cast<float>(signedValue) / 32768.0f;  // Convert to mV
        normalizedValues.push_back(normalizedValue);
        ptr += 2;
    }

//    qDebug() << "Total samples read: " << normalizedValues.size();

    const float threshold = thresholdInitB / 32768.0f;  // Convert to mV
    auto startIt = std::find_if(normalizedValues.begin(), normalizedValues.end(), [threshold](float val) {
        return val >= threshold;
    });

    if (startIt == normalizedValues.end()) {
        qDebug() << "Threshold value not found in data.";
        return;
    }
    int startIndex = std::distance(normalizedValues.begin(), startIt);
//    qDebug() << "Starting index found at position:" << startIndex;

    int resampling = samplingRateInit / (60 * sagFactorInit); // Resampling rate
//    qDebug() << "Resampling rate:" << resampling;

    float totalDistance = (distanceToShowInit - distanceToStartInit) * 1000;
    int fullpoint = static_cast<int>(totalDistance / (60 * sagFactorInit));
    int trueDistancepoint = fullpoint / resampling; // Points after resampling

//    qDebug() << "Full points:" << fullpoint;
//    qDebug() << "True distance points after resampling:" << trueDistancepoint;

    float pointInterval = totalDistance / trueDistancepoint; // Distance interval per point
//    qDebug() << "Point interval (m):" << pointInterval;

    std::vector<std::pair<float, float>> result;
    float currentDistance = distanceToStartInit * 1000; // Start in meters

    for (int i = 0; i < trueDistancepoint; ++i) {
        float currentValue = (i * resampling + startIndex < normalizedValues.size())
                             ? normalizedValues[i * resampling + startIndex] * 4096/2  // Multiply by 4096 here
                             : 0.0f;
        result.emplace_back(currentDistance, currentValue);
        currentDistance += pointInterval;
    }

    qDebug() << "Final Total Points:" << result.size();
    for (const auto& [distance, voltage] : result) {
//        qDebug() << "X:" << distance / 1000.0 << " km, Y:" << voltage << " mV";
    }

    // JSON Output for Plotting
    QJsonObject mainObject;
    QJsonArray dist, volt;
    for (const auto& [distance, voltage] : result) {
        dist.push_back(distance / 1000);  // Convert m to km
        volt.push_back(voltage);  // Already multiplied by 4096
    }

    mainObject.insert("objectName", "patternB");
    mainObject.insert("distance", dist);
    mainObject.insert("voltage", volt);

    QJsonDocument jsonDoc(mainObject);
    QString raw_data = jsonDoc.toJson(QJsonDocument::Compact);
//    qDebug() << "Generated JSON:" << raw_data;

    rawdataArrayB = raw_data;
    reSamplingNormalizationPatternB(result);

}

void mainwindows::reSamplingNormalizationPatternB(const std::vector<std::pair<float, float>>& result) {
    if (result.size() < 3) {
        qDebug() << "Not enough data points to process.";
        return;
    }
    qDebug() << "Starting peak detection and smoothing...";

    // Step 1: Detect Peaks
    std::vector<std::pair<float, double>> peakPoints;
    std::pair<float, double> startPoint = {0.0, 0.0};

    for (const auto& point : result) {
        if (point.second > 0.0) { // First non-zero voltage
            startPoint = {point.first, point.second};
            break;
        }
    }
    peakPoints.push_back(startPoint);

    for (size_t i = 1; i < result.size() - 1; ++i) {
        float prevVoltage = result[i - 1].second;
        float currentVoltage = result[i].second;
        float nextVoltage = result[i + 1].second;

        if (prevVoltage < currentVoltage && currentVoltage > nextVoltage) {
            peakPoints.emplace_back(result[i]);
        }
    }

    peakPoints.push_back(result.back());

    auto maxPeakIt = std::max_element(peakPoints.begin(), peakPoints.end(),
                                      [](const std::pair<float, double>& a, const std::pair<float, double>& b) {
                                          return a.second < b.second;
                                      });
    std::pair<float, double> maxPeak = *maxPeakIt;
//    qDebug() << "Maximum peak detected at X:" << maxPeak.first / 1000.0 << "km, Y:" << maxPeak.second << "mV";

    if (std::find(peakPoints.begin(), peakPoints.end(), maxPeak) == peakPoints.end()) {
        peakPoints.push_back(maxPeak);
    }

    qDebug() << "Peaks detected. Total peaks:" << peakPoints.size();

    for (const auto& peak : peakPoints) {
//        qDebug() << "Peak at X:" << peak.first / 1000.0 << "km, Y:" << peak.second << "mV";
    }

    // Step 2: Downsample Peak Points
    std::vector<std::pair<float, double>> downsampledPeaks;
    size_t step = std::max<size_t>(1, peakPoints.size() / 50); // Downsample to around 50 points
    for (size_t i = 0; i < peakPoints.size(); i += step) {
        downsampledPeaks.push_back(peakPoints[i]);
    }
    if (peakPoints.back() != downsampledPeaks.back()) {
        downsampledPeaks.push_back(peakPoints.back()); // Ensure the last point is included
    }

    if (std::find(downsampledPeaks.begin(), downsampledPeaks.end(), maxPeak) == downsampledPeaks.end()) {
        downsampledPeaks.push_back(maxPeak);
    }

    std::sort(downsampledPeaks.begin(), downsampledPeaks.end()); // Sort points by X
//    qDebug() << "Downsampling completed. Total downsampled points:" << downsampledPeaks.size();

    // Step 3: Generate Smooth Curve
    std::vector<std::pair<float, double>> smoothCurve;
    for (size_t i = 0; i < downsampledPeaks.size() - 1; ++i) {
        float x1 = downsampledPeaks[i].first;
        float x2 = downsampledPeaks[i + 1].first;
        double y1 = downsampledPeaks[i].second;
        double y2 = downsampledPeaks[i + 1].second;

        for (float x = x1; x <= x2; x += (x2 - x1) / 10.0) { // Add 10 points per segment
            double t = (x - x1) / (x2 - x1); // Normalize x between 0 and 1
            double y = (1 - t) * y1 + t * y2; // Linear interpolation
            smoothCurve.emplace_back(x, y);
        }
    }

    qDebug() << "Smoothing completed. Total points for the curve:" << smoothCurve.size();

    // Step 4: Prepare JSON Output
    QJsonObject mainObject;
    QJsonArray dist, volt;
    for (const auto& point : smoothCurve) {
        dist.push_back(point.first / 1000.0);  // Convert m to km
        volt.push_back(point.second);         // Voltage in mV
    }
    mainObject.insert("objectName", "patternB");
    mainObject.insert("distance", dist);
    mainObject.insert("voltage", volt);

    QJsonDocument jsonDoc(mainObject);
    QString raw_data = jsonDoc.toJson(QJsonDocument::Compact);
//    qDebug() << "Generated JSON for smoothed curve:" << raw_data;

    // Emit the signal for the curve
    rawdataArrayB = std::move(raw_data);
    emit plotingDataPhaseB(rawdataArrayB);
}

void mainwindows::plotPatternC(double sagFactorInit, double samplingRateInit, double distanceToStartInit,
                            double distanceToShowInit, double fulldistance, double thresholdInitC) {
    qDebug() << "Debug plotGraph:" << sagFactorInit << samplingRateInit << distanceToStartInit
             << distanceToShowInit << fulldistance << thresholdInitC;

    QString filePath = "/home/pi/data0.raw";
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "Unable to open file:" << filePath;
        return;
    }
    QByteArray data = file.readAll();
    file.close();

    std::vector<float> normalizedValues;
    const uint8_t* ptr = reinterpret_cast<const uint8_t*>(data.constData());
    const uint8_t* endPtr = ptr + data.size();

    while (ptr + 2 <= endPtr) {
        uint16_t signedValue = static_cast<uint16_t>((static_cast<uint8_t>(ptr[1]) << 8) | static_cast<uint8_t>(ptr[0]));
        float normalizedValue = static_cast<float>(signedValue) / 32768.0f;  // Convert to mV
        normalizedValues.push_back(normalizedValue);
        ptr += 2;
    }

//    qDebug() << "Total samples read: " << normalizedValues.size();

    const float threshold = thresholdInitC / 32768.0f;  // Convert to mV
    auto startIt = std::find_if(normalizedValues.begin(), normalizedValues.end(), [threshold](float val) {
        return val >= threshold;
    });

    if (startIt == normalizedValues.end()) {
        qDebug() << "Threshold value not found in data.";
        return;
    }
    int startIndex = std::distance(normalizedValues.begin(), startIt);
//    qDebug() << "Starting index found at position:" << startIndex;

    int resampling = samplingRateInit / (60 * sagFactorInit); // Resampling rate
//    qDebug() << "Resampling rate:" << resampling;

    float totalDistance = (distanceToShowInit - distanceToStartInit) * 1000;
    int fullpoint = static_cast<int>(totalDistance / (60 * sagFactorInit));
    int trueDistancepoint = fullpoint / resampling; // Points after resampling

//    qDebug() << "Full points:" << fullpoint;
//    qDebug() << "True distance points after resampling:" << trueDistancepoint;

    float pointInterval = totalDistance / trueDistancepoint; // Distance interval per point
//    qDebug() << "Point interval (m):" << pointInterval;

    std::vector<std::pair<float, float>> result;
    float currentDistance = distanceToStartInit * 1000; // Start in meters

    for (int i = 0; i < trueDistancepoint; ++i) {
        float currentValue = (i * resampling + startIndex < normalizedValues.size())
                             ? normalizedValues[i * resampling + startIndex] * 4096/2  // Multiply by 4096 here
                             : 0.0f;
        result.emplace_back(currentDistance, currentValue);
        currentDistance += pointInterval;
    }

    qDebug() << "Final Total Points:" << result.size();
    for (const auto& [distance, voltage] : result) {
//        qDebug() << "X:" << distance / 1000.0 << " km, Y:" << voltage << " mV";
    }

    // JSON Output for Plotting
    QJsonObject mainObject;
    QJsonArray dist, volt;
    for (const auto& [distance, voltage] : result) {
        dist.push_back(distance / 1000);  // Convert m to km
        volt.push_back(voltage);  // Already multiplied by 4096
    }

    mainObject.insert("objectName", "patternC");
    mainObject.insert("distance", dist);
    mainObject.insert("voltage", volt);

    QJsonDocument jsonDoc(mainObject);
    QString raw_data = jsonDoc.toJson(QJsonDocument::Compact);
//    qDebug() << "Generated JSON:" << raw_data;

    rawdataArrayC = raw_data;
    reSamplingNormalizationPatternC(result);

}

void mainwindows::reSamplingNormalizationPatternC(const std::vector<std::pair<float, float>>& result) {
    if (result.size() < 3) {
        qDebug() << "Not enough data points to process.";
        return;
    }
    qDebug() << "Starting peak detection and smoothing...";

    // Step 1: Detect Peaks
    std::vector<std::pair<float, double>> peakPoints;
    std::pair<float, double> startPoint = {0.0, 0.0};

    for (const auto& point : result) {
        if (point.second > 0.0) { // First non-zero voltage
            startPoint = {point.first, point.second};
            break;
        }
    }
    peakPoints.push_back(startPoint);

    for (size_t i = 1; i < result.size() - 1; ++i) {
        float prevVoltage = result[i - 1].second;
        float currentVoltage = result[i].second;
        float nextVoltage = result[i + 1].second;

        if (prevVoltage < currentVoltage && currentVoltage > nextVoltage) {
            peakPoints.emplace_back(result[i]);
        }
    }

    peakPoints.push_back(result.back());

    auto maxPeakIt = std::max_element(peakPoints.begin(), peakPoints.end(),
                                      [](const std::pair<float, double>& a, const std::pair<float, double>& b) {
                                          return a.second < b.second;
                                      });
    std::pair<float, double> maxPeak = *maxPeakIt;
//    qDebug() << "Maximum peak detected at X:" << maxPeak.first / 1000.0 << "km, Y:" << maxPeak.second << "mV";

    if (std::find(peakPoints.begin(), peakPoints.end(), maxPeak) == peakPoints.end()) {
        peakPoints.push_back(maxPeak);
    }

    qDebug() << "Peaks detected. Total peaks:" << peakPoints.size();

    for (const auto& peak : peakPoints) {
//        qDebug() << "Peak at X:" << peak.first / 1000.0 << "km, Y:" << peak.second << "mV";
    }

    // Step 2: Downsample Peak Points
    std::vector<std::pair<float, double>> downsampledPeaks;
    size_t step = std::max<size_t>(1, peakPoints.size() / 50); // Downsample to around 50 points
    for (size_t i = 0; i < peakPoints.size(); i += step) {
        downsampledPeaks.push_back(peakPoints[i]);
    }
    if (peakPoints.back() != downsampledPeaks.back()) {
        downsampledPeaks.push_back(peakPoints.back()); // Ensure the last point is included
    }

    if (std::find(downsampledPeaks.begin(), downsampledPeaks.end(), maxPeak) == downsampledPeaks.end()) {
        downsampledPeaks.push_back(maxPeak);
    }

    std::sort(downsampledPeaks.begin(), downsampledPeaks.end()); // Sort points by X
//    qDebug() << "Downsampling completed. Total downsampled points:" << downsampledPeaks.size();

    // Step 3: Generate Smooth Curve
    std::vector<std::pair<float, double>> smoothCurve;
    for (size_t i = 0; i < downsampledPeaks.size() - 1; ++i) {
        float x1 = downsampledPeaks[i].first;
        float x2 = downsampledPeaks[i + 1].first;
        double y1 = downsampledPeaks[i].second;
        double y2 = downsampledPeaks[i + 1].second;

        for (float x = x1; x <= x2; x += (x2 - x1) / 10.0) { // Add 10 points per segment
            double t = (x - x1) / (x2 - x1); // Normalize x between 0 and 1
            double y = (1 - t) * y1 + t * y2; // Linear interpolation
            smoothCurve.emplace_back(x, y);
        }
    }

    qDebug() << "Smoothing completed. Total points for the curve:" << smoothCurve.size();

    // Step 4: Prepare JSON Output
    QJsonObject mainObject;
    QJsonArray dist, volt;
    for (const auto& point : smoothCurve) {
        dist.push_back(point.first / 1000.0);  // Convert m to km
        volt.push_back(point.second);         // Voltage in mV
    }
    mainObject.insert("objectName", "patternC");
    mainObject.insert("distance", dist);
    mainObject.insert("voltage", volt);

    QJsonDocument jsonDoc(mainObject);
    QString raw_data = jsonDoc.toJson(QJsonDocument::Compact);
//    qDebug() << "Generated JSON for smoothed curve:" << raw_data;

    // Emit the signal for the curve
    rawdataArrayC = std::move(raw_data);
    emit plotingDataPhaseC(rawdataArrayC);
}



void* mainwindows::ThreadFuncA(void* pTr) {
    ThreadData* data = static_cast<ThreadData*>(pTr);
    data->instance->plotGraphA(data->sagFactorInit, data->samplingRateInit, data->distanceToStartInit,
                               data->distanceToShowInit, data->fulldistance, data->thresholdInit);
    return NULL;
}
void* mainwindows::ThreadFuncB(void* pTr) {
    ThreadData* data = static_cast<ThreadData*>(pTr);
    data->instance->plotGraphB(data->sagFactorInit, data->samplingRateInit, data->distanceToStartInit,
                               data->distanceToShowInit, data->fulldistance, data->thresholdInit);
    return NULL;
}

void* mainwindows::ThreadFuncC(void* pTr) {
    ThreadData* data = static_cast<ThreadData*>(pTr);
    data->instance->plotGraphC(data->sagFactorInit, data->samplingRateInit, data->distanceToStartInit,
                               data->distanceToShowInit, data->fulldistance, data->thresholdInit);
    return NULL;
}
void mainwindows::startThreads(double sagFactorInit, double samplingRateInit, double distanceToStartInit,
                               double distanceToShowInit, double fulldistance, double thresholdInitA,
                               double thresholdInitB, double thresholdInitC) {
    dataA = {this, sagFactorInit, samplingRateInit, distanceToStartInit, distanceToShowInit, fulldistance, thresholdInitA};
    dataB = {this, sagFactorInit, samplingRateInit, distanceToStartInit, distanceToShowInit, fulldistance, thresholdInitB};
    dataC = {this, sagFactorInit, samplingRateInit, distanceToStartInit, distanceToShowInit, fulldistance, thresholdInitC};

    int ret;
    ret = pthread_create(&idThreadA, NULL, ThreadFuncA, &dataA);
    if (ret == 0) {
        qDebug() << "Thread A created successfully.";
    } else {
        qDebug() << "Thread A not created.";
    }

    ret = pthread_create(&idThreadB, NULL, ThreadFuncB, &dataB);
    if (ret == 0) {
        qDebug() << "Thread B created successfully.";
    } else {
        qDebug() << "Thread B not created.";
    }

    ret = pthread_create(&idThreadC, NULL, ThreadFuncC, &dataC);
    if (ret == 0) {
        qDebug() << "Thread C created successfully.";
    } else {
        qDebug() << "Thread C not created.";
    }
}


void mainwindows::manualtest(QString msg) {
    qDebug() << "manualtest:" << msg;
    if(msg == "ManualTest"){
        QJsonDocument jsonDoc;
        QJsonObject Param;
        Param.insert("objectName","ManualTest");
        jsonDoc.setObject(Param);
        QString raw_data = QJsonDocument(Param).toJson(QJsonDocument::Compact).toStdString().c_str();
        qDebug() << "Test button Manual test:" << raw_data;
        emit sendMessage(raw_data);
    }
}


void mainwindows::patterntest(int msg) {
    qDebug() << "PatternTest:" << msg;
//    if(msg == "PatternTest"){
//        uint8_t n = obj["number"].toInt();
        QJsonDocument jsonDoc;
        QJsonObject Param;
        Param.insert("objectName","PatternTest");
        Param.insert("number",msg);//
        QString raw_data = QJsonDocument(Param).toJson(QJsonDocument::Compact).toStdString().c_str();
        emit sendMessage(raw_data);
//    }
}


void mainwindows::RecalculateWithMargin(QString msg) {
    qDebug() << "RecalculateWithMargin called with data:" << msg;

    QJsonDocument doc = QJsonDocument::fromJson(msg.toUtf8());
    QJsonObject obj = doc.object();
    QJsonObject command = doc.object();
    QString getCommand =  QJsonValue(command["objectName"]).toString();
    if(getCommand.contains("combinedDataPhaseA")){
        int marginA = obj["marginA"].toInt();
        int valueVoltageA = obj["valueVoltageA"].toInt();
        int focusIndex = obj["focusIndex"].toInt();
        QString phase = obj["PHASE"].toString();
        qDebug() << "Processing MarginA:" << marginA << " ValueVoltageA:" << valueVoltageA
                 << " focusIndex:" << focusIndex << " Phase:" << phase;

        QDir directory("/home/pi/patternData/");
        if (!directory.exists()) {
            qDebug() << "Directory does not exist!";
            return;
        }

        QStringList filters;
        filters << "patternA_*.csv";
        directory.setNameFilters(filters);
        directory.setSorting(QDir::Time | QDir::Reversed); // เรียงจากใหม่ไปเก่า
        QFileInfoList fileList = directory.entryInfoList(QDir::Files);

        if (fileList.isEmpty()) {
            qDebug() << "No CSV files found in directory.";
            return;
        }

        QString latestFile = fileList.first().absoluteFilePath();
        qDebug() << "Opening latest CSV file:" << latestFile;

        QFile file(latestFile);
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            qDebug() << "Unable to open file:" << latestFile;
            return;
        }

        QTextStream in(&file);
        QVector<double> distanceArray;
        QVector<double> voltageArray;
        static QVector<double> segmentAdjustments;

        bool firstLine = true;

        while (!in.atEnd()) {
            QString line = in.readLine();
            if (firstLine) { firstLine = false; continue; }

            QStringList values = line.split(",");
            if (values.size() == 2) {
                double distance = values[0].toDouble();
                double voltage = values[1].toDouble();
                distanceArray.append(distance);
                voltageArray.append(voltage);
            }
        }
        file.close();

        qDebug() << "CSV Data Loaded Successfully! Total data points:" << distanceArray.size();

        if (distanceArray.isEmpty()) {
            qDebug() << "No data available for processing!";
            return;
        }

        double maxDistance = distanceArray.last();
        int totalSegments = marginA; // จำนวนช่วง
        double segmentSize = maxDistance / totalSegments;

        qDebug() << "Max Distance:" << maxDistance << " Total Segments:" << totalSegments
                 << " Segment Size:" << segmentSize;

        if (segmentAdjustments.size() != totalSegments) {
            segmentAdjustments.fill(0, totalSegments);
        }

        for (int i = 0; i < distanceArray.size(); ++i) {
            int segmentIndex = static_cast<int>(distanceArray[i] / segmentSize);

            if (segmentIndex >= totalSegments) {
                segmentIndex = totalSegments - 1;
            }

            voltageArray[i] += segmentAdjustments[segmentIndex];

            if (segmentIndex == focusIndex) {
                voltageArray[i] += valueVoltageA;
            }
        }

        segmentAdjustments[focusIndex] += valueVoltageA;

        QJsonObject mainObject;
        QJsonArray dist, volt;

        for (int i = 0; i < distanceArray.size(); ++i) {
            dist.push_back(distanceArray[i]);
            volt.push_back(voltageArray[i]);
        }

        mainObject.insert("objectName", "patternA");
        mainObject.insert("distance", dist);
        mainObject.insert("voltage", volt);

        QJsonDocument jsonDoc(mainObject);
        QString raw_data = jsonDoc.toJson(QJsonDocument::Compact);

        rawdataArrayA = std::move(raw_data);
        emit plotingDataPhaseA(rawdataArrayA);

        qDebug() << "Updated data sent for plotting!";
    }else if (getCommand.contains("autoSetValueMargin")) {
        int marginA = obj["rangeofmargin"].toInt();
        int valueVoltageA = obj["autoValueVoltage"].toInt();
        QString phase = obj["PHASE"].toString();

        qDebug() << "Processing Auto Value Margin. Range:" << marginA
                 << " AutoValueVoltage:" << valueVoltageA << " Phase:" << phase;

        QDir directory("/home/pi/patternData/");
        if (!directory.exists()) {
            qDebug() << "Directory does not exist!";
            return;
        }

        QStringList filters;
        filters << "patternA_*.csv";
        directory.setNameFilters(filters);
        directory.setSorting(QDir::Time | QDir::Reversed);
        QFileInfoList fileList = directory.entryInfoList(QDir::Files);

        if (fileList.isEmpty()) {
            qDebug() << "No CSV files found in directory.";
            return;
        }

        QString latestFile = fileList.first().absoluteFilePath();
        qDebug() << "Opening latest CSV file:" << latestFile;

        QFile file(latestFile);
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            qDebug() << "Unable to open file:" << latestFile;
            return;
        }

        QTextStream in(&file);
        QVector<double> distanceArray;
        QVector<double> voltageArray;

        bool firstLine = true;
        while (!in.atEnd()) {
            QString line = in.readLine();
            if (firstLine) { firstLine = false; continue; }

            QStringList values = line.split(",");
            if (values.size() == 2) {
                double distance = values[0].toDouble();
                double voltage = values[1].toDouble();
                distanceArray.append(distance);
                voltageArray.append(voltage);
            }
        }
        file.close();

        qDebug() << "CSV Data Loaded Successfully! Total data points:" << distanceArray.size();
        if (distanceArray.isEmpty()) {
            qDebug() << "No data available for processing!";
            return;
        }

        for (int i = 0; i < voltageArray.size(); ++i) {
            voltageArray[i] += valueVoltageA; // Apply voltage increase to ALL values
        }

        QJsonObject mainObject;
        QJsonArray dist, volt;

        for (int i = 0; i < distanceArray.size(); ++i) {
            dist.push_back(distanceArray[i]);
            volt.push_back(voltageArray[i]);
        }

        mainObject.insert("objectName", "patternA");
        mainObject.insert("distance", dist);
        mainObject.insert("voltage", volt);

        QJsonDocument jsonDoc(mainObject);
        QString raw_data = jsonDoc.toJson(QJsonDocument::Compact);

        rawdataArrayA = std::move(raw_data);
        emit plotingDataPhaseA(rawdataArrayA);

        qDebug() << "Updated data sent for plotting!";
    }

}

void mainwindows::getSetting()
{
    qDebug() << "getSetting";
    QSettings *settings;
    const QString cfgfile = FILESETTINGMASTER;
    qDebug() << "Loading configuration from:" << cfgfile;
    if(QDir::isAbsolutePath(cfgfile))
    {
        qDebug() << "isAbsolutePath";
        settings = new QSettings(cfgfile,QSettings::IniFormat);
        networks->dhcpmethod = settings->value(QString("%1/DHCP").arg(NETWORK_SERVER),0).toInt();
        networks->ip_address = settings->value(QString("%1/IP_ADDRESS").arg(NETWORK_SERVER),"").toString();
        networks->subnet = settings->value(QString("%1/NETMASK").arg(NETWORK_SERVER),"").toString();
        networks->ip_gateway = settings->value(QString("%1/IP_GATEWAY").arg(NETWORK_SERVER),"").toString();
        networks->pridns = settings->value(QString("%1/PRIDNS").arg(NETWORK_SERVER),"").toString();
        networks->secdns = settings->value(QString("%1/SECDNS").arg(NETWORK_SERVER),"").toString();
        networks->phyName = settings->value(QString("%1/PHYNAME").arg(NETWORK_SERVER),"").toString();

        networks->ip_snmp = settings->value(QString("%1/IP_ADDRESS").arg(SNMP_SERVER),"0.0.0.0").toString();


//        networks->sender_email = settings->value(QString("%1/SENDER_EMAIL").arg(SMTP_SERVER),"").toString();
//        networks->sender_name = settings->value(QString("%1/SENDER_NAME").arg(SMTP_SERVER),"").toString();
//        networks->password = settings->value(QString("%1/PASSWORD").arg(SMTP_SERVER),"").toString();
//        networks->recipient_email = settings->value(QString("%1/RECIPIENT_EMAIL").arg(SMTP_SERVER),"").toString();
//        networks->recipient_name = settings->value(QString("%1/RECIPIENT_NAME").arg(SMTP_SERVER),"").toString();
//        networks->server = settings->value(QString("%1/SERVER").arg(SMTP_SERVER),"").toString();
//        networks->port = settings->value(QString("%1/PORT").arg(SMTP_SERVER),"").toString();

        networks->ip_timeserver = settings->value(QString("%1/IP_ADDRESS").arg(TIME_SERVER),"0.0.0.0").toString();
        networks->location_snmp = settings->value(QString("%1/LOCATION").arg(TIME_SERVER),"").toString();
    }
    else{
        qDebug() << "Loading configuration from:" << cfgfile << " FILE NOT FOUND!";
    }
    qDebug() << "Loading configuration completed" << networks->subnet;
    networks->printinfo();
    delete settings;
}

void mainwindows::updateNetwork()
{
    qDebug() << "updateNetwork";
    QSettings *settings;
    const QString cfgfile = FILESETTINGMASTER;
    qDebug() << "Loading configuration from:" << cfgfile;
    if(QDir::isAbsolutePath(cfgfile))
    {
        settings = new QSettings(cfgfile,QSettings::IniFormat);
        settings->setValue(QString("%1/DHCP").arg(NETWORK_SERVER),networks->dhcpmethod);
        settings->setValue(QString("%1/IP_ADDRESS").arg(NETWORK_SERVER),networks->ip_address);
        settings->setValue(QString("%1/IP_GATEWAY").arg(NETWORK_SERVER),networks->ip_gateway);
        settings->setValue(QString("%1/NETMASK").arg(NETWORK_SERVER),networks->subnet);
        settings->setValue(QString("%1/PRIDNS").arg(NETWORK_SERVER),networks->pridns);
        settings->setValue(QString("%1/SECDNS").arg(NETWORK_SERVER),networks->secdns);
        settings->setValue(QString("%1/PHYNAME").arg(NETWORK_SERVER),networks->phyName);

//        settings->setValue(QString("%1/IP_ADDRESS").arg(SNMP_SERVER),networks->ip_snmp);
//        settings->setValue(QString("%1/EMAIL").arg(SNMP_SERVER),networks->email_snmp);

//        settings->setValue(QString("%1/IP_ADDRESS").arg(TIME_SERVER),networks->ip_timeserver);
    }
    else{
        qDebug() << "Loading configuration from:" << cfgfile << " FILE NOT FOUND!";
    }
    qDebug() << "Loading configuration completed";
    networks->printinfo();
    delete settings;
}

// void mainwindows::sendlinkPictures(QString fileName) {
//     qDebug() << "Received file name from ImageProvider:" << fileName;
// }



//void mainwindows::RecalculateWithMargin(QString msg) {
//    qDebug() << "RecalculateWithMargin called with data:" << msg;

//    // **แปลง JSON String เป็น QJsonObject**
//    QJsonDocument doc = QJsonDocument::fromJson(msg.toUtf8());
//    QJsonObject obj = doc.object();

//    // **ดึงค่าจาก JSON**
//    int marginA = obj["marginA"].toInt();
//    int valueVoltageA = obj["valueVoltageA"].toInt();
//    int focusIndex = obj["focusIndex"].toInt();
//    QString phase = obj["PHASE"].toString();
//    qDebug() << "Processing MarginA:" << marginA << " ValueVoltageA:" << valueVoltageA
//             << " focusIndex:" << focusIndex << " Phase:" << phase;

//    // **Step 1: ค้นหาไฟล์ CSV ล่าสุด**
//    QDir directory("/home/pi/patternData/");
//    if (!directory.exists()) {
//        qDebug() << "Directory does not exist!";
//        return;
//    }

//    QStringList filters;
//    filters << "patternA_*.csv"; // กรองเฉพาะไฟล์ patternA
//    directory.setNameFilters(filters);
//    directory.setSorting(QDir::Time | QDir::Reversed); // เรียงจากใหม่ไปเก่า
//    QFileInfoList fileList = directory.entryInfoList(QDir::Files);

//    if (fileList.isEmpty()) {
//        qDebug() << "No CSV files found in directory.";
//        return;
//    }

//    QString latestFile = fileList.first().absoluteFilePath();
//    qDebug() << "Opening latest CSV file:" << latestFile;

//    // **Step 2: เปิดไฟล์ CSV และอ่านข้อมูล**
//    QFile file(latestFile);
//    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
//        qDebug() << "Unable to open file:" << latestFile;
//        return;
//    }

//    QTextStream in(&file);
//    QVector<double> distanceArray;
//    QVector<double> voltageArray;
//    QMap<int, double> segmentVoltageMap;  // เก็บค่าแรงดันของแต่ละช่วง
//    bool firstLine = true;

//    while (!in.atEnd()) {
//        QString line = in.readLine();
//        if (firstLine) { firstLine = false; continue; } // ข้าม Header

//        QStringList values = line.split(",");
//        if (values.size() == 2) {
//            double distance = values[0].toDouble();
//            double voltage = values[1].toDouble();
//            distanceArray.append(distance);
//            voltageArray.append(voltage);
//        }
//    }
//    file.close();

//    qDebug() << "CSV Data Loaded Successfully! Total data points:" << distanceArray.size();

//    // **Step 3: คำนวณช่วงของ margin**
//    if (distanceArray.isEmpty()) {
//        qDebug() << "No data available for processing!";
//        return;
//    }

//    double maxDistance = distanceArray.last(); // ใช้ค่าระยะทางสุดท้าย
//    int totalSegments = marginA; // จำนวนช่วง
//    double segmentSize = maxDistance / totalSegments; // ขนาดของแต่ละช่วง

//    qDebug() << "Max Distance:" << maxDistance << " Total Segments:" << totalSegments
//             << " Segment Size:" << segmentSize;

//    // **Step 4: ปรับค่าแรงดันไฟฟ้า**
//    for (int i = 0; i < distanceArray.size(); ++i) {
//        int segmentIndex = static_cast<int>(distanceArray[i] / segmentSize);

//        // กำหนดให้ค่าระยะทางสุดท้ายอยู่ในช่วงสุดท้าย
//        if (segmentIndex >= totalSegments) {
//            segmentIndex = totalSegments - 1;
//        }

//        // ถ้าช่วงนี้เป็นช่วงที่เลือก ให้เพิ่มค่าแรงดันไฟฟ้าเข้าไป
//        if (segmentIndex == focusIndex) {
//            voltageArray[i] += valueVoltageA;
//        }
//    }

//    // **Step 5: ส่งค่าที่อัปเดตกลับไป**
//    QJsonObject mainObject;
//    QJsonArray dist, volt;

//    for (int i = 0; i < distanceArray.size(); ++i) {
//        dist.push_back(distanceArray[i]);  // ส่งค่าระยะทางเดิมกลับไป
//        volt.push_back(voltageArray[i]);  // ส่งค่า voltage ที่แก้ไขแล้วกลับไป
//    }

//    mainObject.insert("objectName", "patternA");
//    mainObject.insert("distance", dist);
//    mainObject.insert("voltage", volt);

//    QJsonDocument jsonDoc(mainObject);
//    QString raw_data = jsonDoc.toJson(QJsonDocument::Compact);

//    // **Step 6: ส่งข้อมูลไป Plot**
//    rawdataArrayA = std::move(raw_data);
//    emit plotingDataPhaseA(rawdataArrayA);

//    qDebug() << "Updated data sent for plotting!";
//}

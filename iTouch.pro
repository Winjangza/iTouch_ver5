QT += quick virtualkeyboard
QT += sql
QT += quick websockets qml charts
TEMPLATE = app
CONFIG += c++11
CONFIG += link_pkgconfig
QT += serialbus
QT += virtualkeyboard
QT += charts qml quick
#TARGET = VNCiTouch

static {
    QT += svg
    QTPLUGIN += qtvirtualkeyboardplugin
}
# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0
#DEFINES += QT_NO_DEBUG_OUTPUT
SOURCES += \
        ChatServer.cpp \
        SocketClient.cpp \
        database.cpp \
        main.cpp \
        mainwindows.cpp \
        screencapture.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target



LIBS += -DPJ_AUTOCONF=1 -O2 -DPJ_IS_BIG_ENDIAN=0 -DPJ_IS_LITTLE_ENDIAN=1
LIBS += -lboost_system -lboost_chrono -lboost_thread -ludev
LIBS += -lnetsnmp -lasound
DISTFILES += \
    adc_ch1_voltage.dat

HEADERS += \
    ChatServer.h \
    SocketClient.h \
    database.h \
    mainwindows.h \
    screencapture.h

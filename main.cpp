#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <mainwindows.h>
#include <QQmlContext>
#include <QtWidgets/QApplication>
#include <QtQuick/QQuickView>
#include <QtCore/QDir>
#include <QtQml/QQmlEngine>
#include <QQuickWindow>
#include <QApplication>
#include "screencapture.h"
#include "database.h"
#include <QSurfaceFormat>
//sudo mysql -u root -pOTL324$
//#define QT_NO_DEBUG
//#define VNC
int main(int argc, char *argv[])
{
#ifdef QT_NO_DEBUG
         qputenv("QT_LOGGING_RULES", "qml=false; *.debug=false");
#endif
    QSurfaceFormat format;
    format.setRenderableType(QSurfaceFormat::OpenGL);
    format.setProfile(QSurfaceFormat::CoreProfile);
    format.setVersion(3, 3);
    QSurfaceFormat::setDefaultFormat(format);
    QCoreApplication::setOrganizationName("MyCompany");
    QCoreApplication::setOrganizationDomain("mycompany.com");
#ifdef VNC
    qputenv("QT_QPA_PLATFORM", QByteArray("vnc"));
#endif
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    if (qEnvironmentVariableIsEmpty("QTGLESSTREAM_DISPLAY")) {
        qputenv("QT_QPA_EGLFS_PHYSICAL_WIDTH", QByteArray("213"));
        qputenv("QT_QPA_EGLFS_PHYSICAL_HEIGHT", QByteArray("120"));

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
        QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    }

    QApplication app(argc, argv);
    QGuiApplication::setOverrideCursor(QCursor(Qt::BlankCursor));
    QQuickWindow::setSceneGraphBackend("software");

    QQmlApplicationEngine engine;
    ImageProvider *imageProvider = new ImageProvider();
    engine.addImageProvider(QLatin1String("screenshots"), imageProvider);
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);   }, Qt::QueuedConnection);

    engine.load(url);
    QQuickWindow *view = dynamic_cast<QQuickWindow *>(engine.rootObjects().at(0));

#ifdef VNC    
    mainwindows mainwindows("VNC");
    QObject::connect(&mainwindows, SIGNAL(captureScreenshot()),&mainwindows, SLOT(captureScreenshotseand()));

#else
    mainwindows mainwindows("desktop");
//    QObject::connect(view, SIGNAL(getScreenshot()),imageProvider, SLOT(makeScreenshot()));
    QObject::connect(&mainwindows, SIGNAL(captureScreenshot()),&mainwindows, SLOT(captureScreenshotseand()));

#endif

//    mainwindows mainwindows;
    QObject *topLevel = engine.rootObjects().value(0);
    QQuickWindow *qmlWindow = qobject_cast<QQuickWindow *>(topLevel);
    engine.rootContext()->setContextProperty("mainwindows", &mainwindows);
    QObject::connect(qmlWindow, SIGNAL(qmlCommand(QString)),&mainwindows, SLOT(cppSubmitTextFiled(QString)));
    QObject::connect(&mainwindows,SIGNAL(cppCommand(QVariant)),qmlWindow, SLOT(qmlSubmitTextFiled(QVariant)));


//#ifdef GUI
//    QObject::connect(view, SIGNAL(getScreenshot()),imageProvider, SLOT(makeScreenshot()));
//#endif


    return app.exec();

}


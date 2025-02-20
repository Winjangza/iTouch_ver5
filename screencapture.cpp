#include <QPixmap>
#include <QQuickView>
#include <QString>
#include <QDateTime>
#include <QDir>
#include <QFile>
#include <QDebug>

#include "screencapture.h"

ImageProvider::ImageProvider(QObject *parent, Flags flags)
    : QQuickImageProvider(QQmlImageProviderBase::Image, flags), QObject(parent) {

}

QImage ImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize) {
    bool ok = false;
    QImage img = m_images[id.toInt(&ok)];
    return img;
}

void ImageProvider::makeScreenshot() {
    QString filePart = "/var/www/html/pic/";
    QString fileName = QString::number(QDateTime::currentDateTime().toSecsSinceEpoch()) + ".png";

    QQuickWindow *view = qobject_cast<QQuickWindow *>(sender());
    if (!view) {
        qDebug() << "Failed to get QQuickWindow sender";
        return;
    }

    static int pos = 0;
    QImage img = view->grabWindow();
    m_images.insert(pos, img);

    QVariant returnedValue;
    QMetaObject::invokeMethod(view, "setImage",
                              Q_RETURN_ARG(QVariant, returnedValue),
                              Q_ARG(QVariant, pos++));

    // Construct the full file path
    QString fullPath = QDir::cleanPath(filePart + "/" + fileName);
    QFile file(fullPath);

    if (file.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
        img.save(&file, "PNG");
        // emit sendlinkPicturesToServer(fullPath);
    } else {
        qDebug() << "Can't open file:" << fullPath;
    }

    qDebug() << "Screenshot saved to:" << fullPath;
}


#ifndef SCREENCAPTURE_H
#define SCREENCAPTURE_H

#include <QQuickImageProvider>
#include <QImage>
#include <QMap>
#include <QObject>
#include <QString>
#include <QJsonObject>
#include <QJsonDocument>



class ImageProvider : public QObject, public QQuickImageProvider {
    Q_OBJECT

public:
    explicit ImageProvider(QObject *parent = nullptr, Flags flags = Flags());

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;

public slots:
    void makeScreenshot();

protected:
    QMap<int, QImage> m_images;

};
#endif // SCREENCAPTURE_H

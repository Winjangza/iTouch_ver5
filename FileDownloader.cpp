#include "FileDownloader.h"

FileDownloader::FileDownloader(QObject *parent)
    : QObject(parent)
{
    manager = new QNetworkAccessManager(this);
    connect(manager, &QNetworkAccessManager::finished, this, &FileDownloader::fileDownloaded);
}

void FileDownloader::downloadFile(const QString &url, const QString &outputPath)
{
    OutputPath = outputPath;
    QNetworkRequest request(url);
    QNetworkReply *reply = manager->get(request);

    connect(reply, &QNetworkReply::finished, this, [this, reply, outputPath]() {
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray fileData = reply->readAll();
            QFile file(outputPath);
            if (file.open(QIODevice::WriteOnly)) {
                file.write(fileData);
                file.close();
                qDebug() << "Download complete!";
                emit downloadCompleted(OutputPath);
            } else {
                qDebug() << "Failed to open file for writing!";
            }
        } else {
            qDebug() << "Download error:" << reply->errorString();
        }
        reply->deleteLater();
    });
}

void FileDownloader::fileDownloaded(QNetworkReply *reply) {
    if (reply->error() != QNetworkReply::NoError) {
        qDebug() << "Download error:" << reply->errorString();
    } else {
        qDebug() << "Download complete!";

    }
}

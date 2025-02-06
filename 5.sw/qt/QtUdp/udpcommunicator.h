#ifndef UDPCOMMUNICATOR_H
#define UDPCOMMUNICATOR_H

#include <QObject>
#include <QScopedPointer>
#include <QtNetwork>
#include <QUdpSocket>

#include "opencv2/core/core.hpp"
#include "opencv2/highgui/highgui.hpp"

class UDPCommunicator : public QObject
{
    Q_OBJECT

public:
    explicit UDPCommunicator(QObject *parent = 0);
    ~UDPCommunicator();

private:
    QSharedPointer<QTimer> mDisplayTimer;
    QUdpSocket *socket = nullptr;
    QHostAddress hostAddress;
    QByteArray datagram;
    cv::Mat image;
    qint64 currentTime;
    uint8_t frame, frame_prev;

private slots:
    void processPendingDatagrams();
    void sendData();    


public slots:
    void display();
    void initialize();

};

#endif // UDPCOMMUNICATOR_H

#include "udpcommunicator.h"

UDPCommunicator::UDPCommunicator(QObject *parent) : QObject(parent)
{
}

UDPCommunicator::~UDPCommunicator()
{
    qDebug() << "~UDPCommunicator()";
    mDisplayTimer->stop();
}

void UDPCommunicator::initialize()
{
    bool ipChange = hostAddress.setAddress("192.168.1.20");
    if(ipChange) qInfo() << "IP ADDRESS CHANGED";
    else qInfo() << "IP ADDRESS NOT CHANGED";

    int xdim =1280;
    int ydim =700;
    image = cv::Mat (ydim, xdim, CV_8UC3);
    frame = 0;
    frame_prev = 0;

    socket = new QUdpSocket(this);
    bool result =  socket->bind(hostAddress, 1234);
    qInfo() << result;
    if(result)
    {
        qInfo() << "PASS BINDING";
    }
    else
    {
        qInfo() << "FAIL BINDING";
    }
    connect(socket, SIGNAL(readyRead()), this, SLOT(processPendingDatagrams()), Qt::AutoConnection);

    mDisplayTimer = QSharedPointer<QTimer>(new QTimer());
    mDisplayTimer->setInterval(1);
    mDisplayTimer->setTimerType(Qt::TimerType::PreciseTimer);
    mDisplayTimer->setSingleShot(false);
    connect(mDisplayTimer.data(), &QTimer::timeout, this, &UDPCommunicator::display);
    mDisplayTimer->start();
    currentTime = QDateTime::currentMSecsSinceEpoch();
    /*if(socket->waitForReadyRead()) {
        QThread::wait(100);
    }*/
}

void UDPCommunicator::display()
{
    // show the image on window
    qint32 diffTime = QDateTime::currentMSecsSinceEpoch() - currentTime;
    if(diffTime > 2) {
       // cv::Mat imageBrighness;
        //image.convertTo(imageBrighness, -1, 1, 20); //increase the brightness by 50
/*
        cv::Scalar m;
        m=cv::mean(image);
        image-=m;
        image+=cv::Scalar(0.3,0.31,0.3); // Changing this you can adjust color balance.
*/
  //      cv::normalize(image,image,0,1,cv::NORM_MINMAX);
        cv::imshow("Image", image);
        currentTime = QDateTime::currentMSecsSinceEpoch();
    }
}

void UDPCommunicator::sendData()
{
    QByteArray Data; // Message for send
    Data += "SAMP";
    Data += QString( 93 );
    Data += QString( 119 );
    Data += QString( 26 );
    Data += QString( 214 );
    Data += QString(7777 & 0xFF);
    Data += QString(7777 >> 8 & 0xFF);
    Data.append("i");

    int sebindeo = socket->bind(1234);
    int envio = socket->writeDatagram(Data, hostAddress, 1234);
    qDebug() << "Bind: " << sebindeo << "; Send bytes: " << envio << "; Message send: " << Data;
}

void UDPCommunicator::processPendingDatagrams()
{
    QHostAddress sender;
    uint16_t port;
    uint16_t y, rgb565;
    cv::Vec3b rgb888;

    while (socket->hasPendingDatagrams()) {
        datagram.clear();
        datagram.resize(socket->pendingDatagramSize());
        socket->readDatagram(datagram.data(), datagram.size(), &sender, &port);
        if(datagram.size()  == 1282) {
            y = (uint16_t)((datagram.data()[0]&0x7f)<<8 | (uint8_t)datagram.data()[1]);
            frame = (uint8_t)(datagram.data()[0] >> 7);
            for(int x=2; x<=1282; x=x+2) {
                rgb565 = (uint16_t)datagram.data()[x] << 8 | (uint8_t)datagram.data()[x+1];
                if(frame == 0) {
                    //image.at<cv::Vec3b>(y,x-2) = rgb888;
                    //image.at<cv::Vec3b>(y,x-2)[2] = cv::saturate_cast<uchar>((uint16_t)(rgb565&0xF800 | 0x07) >> 8);
                    //image.at<cv::Vec3b>(y,x-2)[1] = cv::saturate_cast<uchar>((uint16_t)(rgb565&0x07E0 | 0x03) >> 3);
                    //image.at<cv::Vec3b>(y,x-2)[0] = cv::saturate_cast<uchar>((uint16_t)(rgb565&0x001F | 0x07) << 3);
                    image.at<cv::Vec3b>(y,x-2)[2] = (uchar)((uint16_t)(rgb565&0xF800 | 0x07) >> 8);
                    image.at<cv::Vec3b>(y,x-2)[1] = (uchar)((uint16_t)(rgb565&0x07E0 | 0x03) >> 3);
                    image.at<cv::Vec3b>(y,x-2)[0] = (uchar)((uint16_t)(rgb565&0x001F | 0x07) << 3);
                } else {
                    //image.at<cv::Vec3b>(y,x-1) = rgb888;
                    //image.at<cv::Vec3b>(y,x-1)[2] = cv::saturate_cast<uchar>((uint16_t)(rgb565&0xF800 | 0x07) >> 8);
                    //image.at<cv::Vec3b>(y,x-1)[1] = cv::saturate_cast<uchar>((uint16_t)(rgb565&0x07E0 | 0x03) >> 3);
                    //image.at<cv::Vec3b>(y,x-1)[0] = cv::saturate_cast<uchar>((uint16_t)(rgb565&0x001F | 0x07) << 3);
                    image.at<cv::Vec3b>(y,x-1)[2] = (uchar)((uint16_t)(rgb565&0xF800 | 0x07) >> 8);
                    image.at<cv::Vec3b>(y,x-1)[1] = (uchar)((uint16_t)(rgb565&0x07E0 | 0x03) >> 3);
                    image.at<cv::Vec3b>(y,x-1)[0] = (uchar)((uint16_t)(rgb565&0x001F | 0x07) << 3);
                }
            }
            /*if(y > 690) {
                cv::imshow("Image", image);
            }*/
            frame_prev = frame;
            //qInfo() <<"Message :: frame: " << frame << " row:" << y;
        } else {
            qInfo() <<"size " << datagram.size();
        }
        //cv::imshow("Image", image);
    }
}

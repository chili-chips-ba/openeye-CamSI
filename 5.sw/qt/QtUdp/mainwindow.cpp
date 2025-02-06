#include "mainwindow.h"

#include <QtWidgets>
#include <QtNetwork>
#include <QThread>
#include <QDebug>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent)
{
    mUdpCommunicator = new UDPCommunicator();
    mUdpCommunicatorThread = QSharedPointer<QThread>(new QThread());
    connect(mUdpCommunicatorThread.data(), &QThread::finished, mUdpCommunicator, &QObject::deleteLater);
    connect(mUdpCommunicatorThread.data(), &QThread::started, mUdpCommunicator, &UDPCommunicator::initialize);
    mUdpCommunicator->moveToThread(mUdpCommunicatorThread.data());
    mUdpCommunicatorThread->start(QThread::TimeCriticalPriority);



/*
    cv::Mat image = cv::Mat (600, 800, CV_8UC3);
    image.setTo(cv::Scalar(0, 0, 255));
    cv::imshow("Image", image);
*/
}

MainWindow::~MainWindow()
{
    if (!mUdpCommunicatorThread.isNull()) {
        mUdpCommunicatorThread->quit();
        mUdpCommunicatorThread->wait();
    }
}

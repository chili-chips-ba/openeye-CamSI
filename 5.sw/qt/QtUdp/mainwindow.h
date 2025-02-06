#ifndef MAINWINDOW_H
#define MAINWINDOW_H


#include <QMainWindow>
#include <QUdpSocket>
#include <QThread>
#include <QLabel>
#include "udpcommunicator.h"


class MainWindow : public QMainWindow
{
    Q_OBJECT
public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

private:
    QImage *image1 = nullptr;
    UDPCommunicator *mUdpCommunicator;
    QSharedPointer<QThread> mUdpCommunicatorThread;

};

#endif // MAINWINDOW_H

QT += core gui network

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11 console
CONFIG -= app_bundle

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \
    mainwindow.cpp \
    udpcommunicator.cpp

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

FORMS += \
    mainwindow.ui

HEADERS += \
    mainwindow.h \
    udpcommunicator.h

LIBS += -LD:\GitHub\openeye-CSI\5.sw\qt\opencv-build\install\x64\vc14\lib -lopencv_core4100 -lopencv_imgproc4100 -lopencv_highgui4100 -lopencv_imgcodecs4100 -lopencv_videoio4100 -lopencv_video4100 -lopencv_calib3d4100 -lopencv_photo4100 -lopencv_features2d4100
INCLUDEPATH += D:\GitHub\openeye-CSI\5.sw\qt\opencv-build\install\include
DEPENDPATH += D:\GitHub\openeye-CSI\5.sw\qt\opencv-build\install\include

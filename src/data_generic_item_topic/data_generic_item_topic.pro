#-------------------------------------------------
#
# Project created by QtCreator 2017-03-08T09:13:06
#
#-------------------------------------------------

QT      += core
QT      -= gui

TARGET = data_generic_item_topic
TEMPLATE = lib

DEFINES += DATA_GENERIC_ITEM_TOPIC_LIBRARY

QMAKE_CXXFLAGS += -std=c++14
DEFINES += EIGEN_DONT_VECTORIZE
DEFINES += EIGEN_DISABLE_UNALIGNED_ARRAY_ASSERT


# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    data_generic_item_topic_flightmode.cpp \
    data_generic_item_topic_GPS.cpp \
    data_generic_item_topic_param_value.cpp \
    data_generic_item_topic_text.cpp \
    data_generic_item_topic_battery.cpp \
    data_generic_item_topic_heartbeat.cpp \
    data_generic_item_topic_system_arm.cpp \
    data_generic_item_topic_systemtime.cpp

HEADERS +=\
        data_generic_item_topic_global.h \
    data_generic_item_topic_components.h \
    data_generic_item_topic_flightmode.h \
    data_generic_item_topic_GPS.h \
    data_generic_item_topic_param_value.h \
    data_generic_item_topic_text.h \
    data_generic_item_topic_battery.h \
    data_generic_item_topic_heartbeat.h \
    data_generic_item_topic_system_arm.h \
    data_generic_item_topic_systemtime.h

# Unix lib Install
unix:!symbian {
    target.path = $$(MACE_ROOT)/lib
    INSTALLS += target
}

# Windows lib install
lib.path    = $$(MACE_ROOT)/lib
win32:CONFIG(release, debug|release):       lib.files   += release/data_generic_item_topic.lib release/data_generic_item_topic.dll
else:win32:CONFIG(debug, debug|release):    lib.files   += debug/data_generic_item_topic.lib debug/data_generic_item_topic.dll
INSTALLS += lib


#Header file copy
INSTALL_PREFIX = $$(MACE_ROOT)/include/$$TARGET
INSTALL_HEADERS = $$HEADERS
include(../headerinstall.pri)

INCLUDEPATH += $$PWD/../
INCLUDEPATH += $$(MACE_ROOT)/spdlog/

contains(DEFINES, WITH_HERON_MAVLINK_SUPPORT) {
  message("data_generic_item_topic: Compiling with AI support")
  INCLUDEPATH += $$(MACE_ROOT)/tools/mavlink/ardupilot/generated_messages/HeronAI/
}else{
  message("data_generic_item_topic: Using standard mavlink libraries")
  INCLUDEPATH += $$(MACE_ROOT)/tools/mavlink/ardupilot/generated_messages/ardupilotmega/
}

INCLUDEPATH += $$(MACE_ROOT)/Eigen/include/eigen3
# Eigen Warning suppression:
QMAKE_CXXFLAGS += -isystem $$(MACE_ROOT)/Eigen/include/eigen3

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../common/release/ -lcommon
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../common/debug/ -lcommon
else:unix:!macx: LIBS += -L$$OUT_PWD/../common/ -lcommon

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../base/release/ -lbase
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../base/debug/ -lbase
else:unix:!macx: LIBS += -L$$OUT_PWD/../base/ -lbase

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../data/release/ -ldata
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../data/debug/ -ldata
else:unix: LIBS += -L$$OUT_PWD/../data/ -ldata

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../data_generic_item/release/ -ldata_generic_item
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../data_generic_item/debug/ -ldata_generic_item
else:unix:!macx: LIBS += -L$$OUT_PWD/../data_generic_item/ -ldata_generic_item


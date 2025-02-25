#-------------------------------------------------
#
# Project created by QtCreator 2016-12-08T21:09:09
#
#-------------------------------------------------
QT      += core
QT      -= gui

TARGET = data
TEMPLATE = lib

DEFINES += DATA_LIBRARY

QMAKE_CXXFLAGS += -std=c++14
DEFINES += EIGEN_DONT_VECTORIZE
DEFINES += EIGEN_DISABLE_UNALIGNED_ARRAY_ASSERT


CONFIG += object_parallel_to_source

SOURCES += \
    event_tag.cpp \
    system_description.cpp \
    environment_time.cpp \
    timer_lambda.cpp \
    topic_components/topic_component_string.cpp \
    topic_components/topic_component_void.cpp \
    flight_modes/arducopter_component_flight_mode.cpp \
    flight_modes/arduplane_component_flight_mode.cpp

HEADERS += data_global.h \
    dogfight_teams.h \
    event_tag.h \
    i_topic_component_data_object.h \
    mace_hsm_state.h \
    mav_type_definitions.h \
    timer_lambda.h \
    topic_data_object_collection.h \
    coordinate_frame.h \
    vehicle_command_types.h \
    vehicle_types.h \
    timer.h \
    operating_mode.h \
    speed_frame.h \
    autopilot_types.h \
    controller_state.h \
    system_description.h \
    data_get_set_notifier.h \
    comms_protocol.h \
    command_ack_type.h \
    mission_command.h \
    mission_execution_state.h \
    command_validity_type.h \
    controller_comms_state.h \
    environment_time.h \
    topic_components/topic_component_string.h \
    topic_components/topic_component_void.h \
    topic_components/mission_key.h \
    mission_type.h \
    mission_state.h \
    loiter_direction.h \
    flight_modes/arducopter_component_flight_mode.h \
    flight_modes/arduplane_component_flight_mode.h \
    flight_modes/ardupilot_component_operating_mode.h

# Unix lib Install
unix:!symbian {
    target.path = $$(MACE_ROOT)/lib
    INSTALLS += target
}

# Windows lib install
lib.path    = $$(MACE_ROOT)/lib
win32:CONFIG(release, debug|release):       lib.files   += release/data.lib release/data.dll
else:win32:CONFIG(debug, debug|release):    lib.files   += debug/data.lib debug/data.dll
INSTALLS += lib


#Header file copy
INSTALL_PREFIX = $$(MACE_ROOT)/include/$$TARGET
INSTALL_HEADERS = $$HEADERS
include(../headerinstall.pri)


INCLUDEPATH += $$PWD/../
INCLUDEPATH += $$(MACE_ROOT)/spdlog/

contains(DEFINES, WITH_HERON_MAVLINK_SUPPORT) {
  message("base: Compiling with Heron support")
  INCLUDEPATH += $$(MACE_ROOT)/tools/mavlink/ardupilot/generated_messages/HeronAI/
}else{
  message("base: Using standard mavlink libraries")
  INCLUDEPATH += $$(MACE_ROOT)/tools/mavlink/ardupilot/generated_messages/ardupilotmega/
}

INCLUDEPATH += $$(MACE_ROOT)/Eigen/include/eigen3
# Eigen Warning suppression:
QMAKE_CXXFLAGS += -isystem $$(MACE_ROOT)/Eigen/include/eigen3

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../common/release/ -lcommon
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../common/debug/ -lcommon
else:unix:!macx: LIBS += -L$$OUT_PWD/../common/ -lcommon

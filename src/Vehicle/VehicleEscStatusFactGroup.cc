/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "VehicleEscStatusFactGroup.h"
#include "Vehicle.h"

//const char* VehicleEscStatusFactGroup::_indexFactName =                             "index";

const char* VehicleEscStatusFactGroup::_rpmFirstFactName =                          "rpm1";
const char* VehicleEscStatusFactGroup::_rpmSecondFactName =                         "rpm2";
const char* VehicleEscStatusFactGroup::_rpmThirdFactName =                          "rpm3";
const char* VehicleEscStatusFactGroup::_rpmFourthFactName =                         "rpm4";
const char* VehicleEscStatusFactGroup::_rpmFifthFactName =                          "rpm5";
const char* VehicleEscStatusFactGroup::_rpmSixthFactName =                          "rpm6";
const char* VehicleEscStatusFactGroup::_rpmSeventhFactName =                        "rpm7";
const char* VehicleEscStatusFactGroup::_rpmEightFactName =                          "rpm8";

const char* VehicleEscStatusFactGroup::_currentFirstFactName =                      "current1";
const char* VehicleEscStatusFactGroup::_currentSecondFactName =                     "current2";
const char* VehicleEscStatusFactGroup::_currentThirdFactName =                      "current3";
const char* VehicleEscStatusFactGroup::_currentFourthFactName =                     "current4";
const char* VehicleEscStatusFactGroup::_currentFifthFactName =                      "current5";
const char* VehicleEscStatusFactGroup::_currentSixthFactName =                      "current6";
const char* VehicleEscStatusFactGroup::_currentSeventhFactName =                    "current7";
const char* VehicleEscStatusFactGroup::_currentEightFactName =                      "current8";

const char* VehicleEscStatusFactGroup::_voltageFirstFactName =                      "voltage1";
const char* VehicleEscStatusFactGroup::_voltageSecondFactName =                     "voltage2";
const char* VehicleEscStatusFactGroup::_voltageThirdFactName =                      "voltage3";
const char* VehicleEscStatusFactGroup::_voltageFourthFactName =                     "voltage4";
const char* VehicleEscStatusFactGroup::_voltageFifthFactName =                      "voltage5";
const char* VehicleEscStatusFactGroup::_voltageSixthFactName =                      "voltage6";
const char* VehicleEscStatusFactGroup::_voltageSeventhFactName =                    "voltage7";
const char* VehicleEscStatusFactGroup::_voltageEightFactName =                      "voltage8";

const char* VehicleEscStatusFactGroup::_temperatureFirstFactName =                      "temperature1";
const char* VehicleEscStatusFactGroup::_temperatureSecondFactName =                     "temperature2";
const char* VehicleEscStatusFactGroup::_temperatureThirdFactName =                      "temperature3";
const char* VehicleEscStatusFactGroup::_temperatureFourthFactName =                     "temperature4";
const char* VehicleEscStatusFactGroup::_temperatureFifthFactName =                      "temperature5";
const char* VehicleEscStatusFactGroup::_temperatureSixthFactName =                      "temperature6";
const char* VehicleEscStatusFactGroup::_temperatureSeventhFactName =                    "temperature7";
const char* VehicleEscStatusFactGroup::_temperatureEightFactName =                      "temperature8";

VehicleEscStatusFactGroup::VehicleEscStatusFactGroup(QObject* parent)
    : FactGroup                         (1000, ":/json/Vehicle/EscStatusFactGroup.json", parent)
    //, _indexFact                        (0, _indexFactName,                         FactMetaData::valueTypeUint8)

    , _rpmFirstFact                     (0, _rpmFirstFactName,                      FactMetaData::valueTypeFloat)
    , _rpmSecondFact                    (0, _rpmSecondFactName,                     FactMetaData::valueTypeFloat)
    , _rpmThirdFact                     (0, _rpmThirdFactName,                      FactMetaData::valueTypeFloat)
    , _rpmFourthFact                    (0, _rpmFourthFactName,                     FactMetaData::valueTypeFloat)
    , _rpmFifthFact                     (0, _rpmFifthFactName,                      FactMetaData::valueTypeFloat)
    , _rpmSixthFact                     (0, _rpmSixthFactName,                      FactMetaData::valueTypeFloat)
    , _rpmSeventhFact                   (0, _rpmSeventhFactName,                    FactMetaData::valueTypeFloat)
    , _rpmEightFact                     (0, _rpmEightFactName,                      FactMetaData::valueTypeFloat)

    , _currentFirstFact                 (0, _currentFirstFactName,                  FactMetaData::valueTypeFloat)
    , _currentSecondFact                (0, _currentSecondFactName,                 FactMetaData::valueTypeFloat)
    , _currentThirdFact                 (0, _currentThirdFactName,                  FactMetaData::valueTypeFloat)
    , _currentFourthFact                (0, _currentFourthFactName,                 FactMetaData::valueTypeFloat)
    , _currentFifthFact                 (0, _currentFifthFactName,                      FactMetaData::valueTypeFloat)
    , _currentSixthFact                 (0, _currentSixthFactName,                      FactMetaData::valueTypeFloat)
    , _currentSeventhFact               (0, _currentSeventhFactName,                    FactMetaData::valueTypeFloat)
    , _currentEightFact                 (0, _currentEightFactName,                      FactMetaData::valueTypeFloat)

    , _voltageFirstFact                 (0, _voltageFirstFactName,                  FactMetaData::valueTypeFloat)
    , _voltageSecondFact                (0, _voltageSecondFactName,                 FactMetaData::valueTypeFloat)
    , _voltageThirdFact                 (0, _voltageThirdFactName,                  FactMetaData::valueTypeFloat)
    , _voltageFourthFact                (0, _voltageFourthFactName,                 FactMetaData::valueTypeFloat)
    , _voltageFifthFact                 (0, _voltageFifthFactName,                      FactMetaData::valueTypeFloat)
    , _voltageSixthFact                 (0, _voltageSixthFactName,                      FactMetaData::valueTypeFloat)
    , _voltageSeventhFact               (0, _voltageSeventhFactName,                    FactMetaData::valueTypeFloat)
    , _voltageEightFact                 (0, _voltageEightFactName,                      FactMetaData::valueTypeFloat)

    , _temperatureFirstFact             (0, _temperatureFirstFactName,                  FactMetaData::valueTypeFloat)
    , _temperatureSecondFact            (0, _temperatureSecondFactName,                 FactMetaData::valueTypeFloat)
    , _temperatureThirdFact             (0, _temperatureThirdFactName,                  FactMetaData::valueTypeFloat)
    , _temperatureFourthFact            (0, _temperatureFourthFactName,                 FactMetaData::valueTypeFloat)
    , _temperatureFifthFact             (0, _temperatureFifthFactName,                      FactMetaData::valueTypeFloat)
    , _temperatureSixthFact             (0, _temperatureSixthFactName,                      FactMetaData::valueTypeFloat)
    , _temperatureSeventhFact           (0, _temperatureSeventhFactName,                    FactMetaData::valueTypeFloat)
    , _temperatureEightFact             (0, _temperatureEightFactName,                      FactMetaData::valueTypeFloat)
{
    //_addFact(&_indexFact,                       _indexFactName);

    _addFact(&_rpmFirstFact,                    _rpmFirstFactName);
    _addFact(&_rpmSecondFact,                   _rpmSecondFactName);
    _addFact(&_rpmThirdFact,                    _rpmThirdFactName);
    _addFact(&_rpmFourthFact,                   _rpmFourthFactName);
    _addFact(&_rpmFifthFact,                    _rpmFifthFactName);
    _addFact(&_rpmSixthFact,                    _rpmSixthFactName);
    _addFact(&_rpmSeventhFact,                  _rpmSeventhFactName);
    _addFact(&_rpmEightFact,                    _rpmEightFactName);

    _addFact(&_currentFirstFact,                _currentFirstFactName);
    _addFact(&_currentSecondFact,               _currentSecondFactName);
    _addFact(&_currentThirdFact,                _currentThirdFactName);
    _addFact(&_currentFourthFact,               _currentFourthFactName);
    _addFact(&_currentFifthFact,                _currentFifthFactName);
    _addFact(&_currentSixthFact,                _currentSixthFactName);
    _addFact(&_currentSeventhFact,              _currentSeventhFactName);
    _addFact(&_currentEightFact,                _currentEightFactName);

    _addFact(&_voltageFirstFact,                _voltageFirstFactName);
    _addFact(&_voltageSecondFact,               _voltageSecondFactName);
    _addFact(&_voltageThirdFact,                _voltageThirdFactName);
    _addFact(&_voltageFourthFact,               _voltageFourthFactName);
    _addFact(&_voltageFifthFact,                _voltageFifthFactName);
    _addFact(&_voltageSixthFact,                _voltageSixthFactName);
    _addFact(&_voltageSeventhFact,              _voltageSeventhFactName);
    _addFact(&_voltageEightFact,                _voltageEightFactName);

    _addFact(&_temperatureFirstFact,                _temperatureFirstFactName);
    _addFact(&_temperatureSecondFact,               _temperatureSecondFactName);
    _addFact(&_temperatureThirdFact,                _temperatureThirdFactName);
    _addFact(&_temperatureFourthFact,               _temperatureFourthFactName);
    _addFact(&_temperatureFifthFact,                _temperatureFifthFactName);
    _addFact(&_temperatureSixthFact,                _temperatureSixthFactName);
    _addFact(&_temperatureSeventhFact,              _temperatureSeventhFactName);
    _addFact(&_temperatureEightFact,                _temperatureEightFactName);
}

void VehicleEscStatusFactGroup::handleMessage(Vehicle* /* vehicle */, mavlink_message_t& message)
{
    if (message.msgid != MAVLINK_MSG_ID_ESC_TELEMETRY_1_TO_4 && message.msgid != MAVLINK_MSG_ID_ESC_TELEMETRY_5_TO_8) {
        return;
    }

    if (message.msgid == MAVLINK_MSG_ID_ESC_TELEMETRY_1_TO_4) {
        mavlink_esc_telemetry_1_to_4_t content;
        mavlink_msg_esc_telemetry_1_to_4_decode(&message, &content);

        rpmFirst()->setRawValue                     (content.rpm[0]);
        rpmSecond()->setRawValue                    (content.rpm[1]);
        rpmThird()->setRawValue                     (content.rpm[2]);
        rpmFourth()->setRawValue                    (content.rpm[3]);

        currentFirst()->setRawValue                 (content.current[0]);
        currentSecond()->setRawValue                (content.current[1]);
        currentThird()->setRawValue                 (content.current[2]);
        currentFourth()->setRawValue                (content.current[3]);

        voltageFirst()->setRawValue                 (content.voltage[0]);
        voltageSecond()->setRawValue                (content.voltage[1]);
        voltageThird()->setRawValue                 (content.voltage[2]);
        voltageFourth()->setRawValue                (content.voltage[3]);

        temperatureFirst()->setRawValue             (content.temperature[0]);
        temperatureSecond()->setRawValue            (content.temperature[1]);
        temperatureThird()->setRawValue             (content.temperature[2]);
        temperatureFourth()->setRawValue            (content.temperature[3]);
    }

    if (message.msgid == MAVLINK_MSG_ID_ESC_TELEMETRY_5_TO_8) {
        mavlink_esc_telemetry_5_to_8_t content;
        mavlink_msg_esc_telemetry_5_to_8_decode(&message, &content);

        rpmFifth()->setRawValue                     (content.rpm[0]);
        rpmSixth()->setRawValue                     (content.rpm[1]);
        rpmSeventh()->setRawValue                   (content.rpm[2]);
        rpmEight()->setRawValue                     (content.rpm[3]);


        currentFifth()->setRawValue                 (content.current[0]);
        currentSixth()->setRawValue                 (content.current[1]);
        currentSeventh()->setRawValue               (content.current[2]);
        currentEight()->setRawValue                 (content.current[3]);


        voltageFifth()->setRawValue                 (content.voltage[0]);
        voltageSixth()->setRawValue                 (content.voltage[1]);
        voltageSeventh()->setRawValue               (content.voltage[2]);
        voltageEight()->setRawValue                 (content.voltage[3]);


        temperatureFifth()->setRawValue             (content.temperature[0]);
        temperatureSixth()->setRawValue             (content.temperature[1]);
        temperatureSeventh()->setRawValue           (content.temperature[2]);
        temperatureEight()->setRawValue             (content.temperature[3]);
    }
}

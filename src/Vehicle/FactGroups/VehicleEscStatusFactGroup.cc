/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "VehicleEscStatusFactGroup.h"
#include "Vehicle.h"

VehicleEscStatusFactGroup::VehicleEscStatusFactGroup(QObject *parent)
    : FactGroup(1000, QStringLiteral(":/json/Vehicle/EscStatusFactGroup.json"), parent)
{
    //_addFact(&_indexFact);

    _addFact(&_rpm1Fact);
    _addFact(&_rpm2Fact);
    _addFact(&_rpm3Fact);
    _addFact(&_rpm4Fact);
    _addFact(&_rpm5Fact);
    _addFact(&_rpm6Fact);
    _addFact(&_rpm7Fact);
    _addFact(&_rpm8Fact);

    _addFact(&_current1Fact);
    _addFact(&_current2Fact);
    _addFact(&_current3Fact);
    _addFact(&_current4Fact);
    _addFact(&_current5Fact);
    _addFact(&_current6Fact);
    _addFact(&_current7Fact);
    _addFact(&_current8Fact);

    _addFact(&_voltage1Fact);
    _addFact(&_voltage2Fact);
    _addFact(&_voltage3Fact);
    _addFact(&_voltage4Fact);
    _addFact(&_voltage5Fact);
    _addFact(&_voltage6Fact);
    _addFact(&_voltage7Fact);
    _addFact(&_voltage8Fact);

    _addFact(&_temperature1Fact);
    _addFact(&_temperature2Fact);
    _addFact(&_temperature3Fact);
    _addFact(&_temperature4Fact);
    _addFact(&_temperature5Fact);
    _addFact(&_temperature6Fact);
    _addFact(&_temperature7Fact);
    _addFact(&_temperature8Fact);
}

void VehicleEscStatusFactGroup::handleMessage(Vehicle *vehicle, const mavlink_message_t &message)
{
    Q_UNUSED(vehicle);

    if (message.msgid != MAVLINK_MSG_ID_ESC_TELEMETRY_1_TO_4 && message.msgid != MAVLINK_MSG_ID_ESC_TELEMETRY_5_TO_8) {
        return;
    }

    if (message.msgid == MAVLINK_MSG_ID_ESC_TELEMETRY_1_TO_4) {
        mavlink_esc_telemetry_1_to_4_t content;
        mavlink_msg_esc_telemetry_1_to_4_decode(&message, &content);

        rpm1()->setRawValue(content.rpm[0]);
        rpm2()->setRawValue(content.rpm[1]);
        rpm3()->setRawValue(content.rpm[2]);
        rpm4()->setRawValue(content.rpm[3]);
        
        current1()->setRawValue(content.current[0]);
        current2()->setRawValue(content.current[1]);
        current3()->setRawValue(content.current[2]);
        current4()->setRawValue(content.current[3]);

        voltage1()->setRawValue(content.voltage[0]);
        voltage2()->setRawValue(content.voltage[1]);
        voltage3()->setRawValue(content.voltage[2]);
        voltage4()->setRawValue(content.voltage[3]);

        temperature1()->setRawValue(content.temperature[0]);
        temperature2()->setRawValue(content.temperature[1]);
        temperature3()->setRawValue(content.temperature[2]);
        temperature4()->setRawValue(content.temperature[3]);
    }

    if (message.msgid == MAVLINK_MSG_ID_ESC_TELEMETRY_5_TO_8) {
        mavlink_esc_telemetry_5_to_8_t content;
        mavlink_msg_esc_telemetry_5_to_8_decode(&message, &content);

        rpm5()->setRawValue(content.rpm[0]);
        rpm6()->setRawValue(content.rpm[1]);
        rpm7()->setRawValue(content.rpm[2]);
        rpm8()->setRawValue(content.rpm[3]);

        current5()->setRawValue(content.current[0]);
        current6()->setRawValue(content.current[1]);
        current7()->setRawValue(content.current[2]);
        current8()->setRawValue(content.current[3]);

        voltage5()->setRawValue(content.voltage[0]);
        voltage6()->setRawValue(content.voltage[1]);
        voltage7()->setRawValue(content.voltage[2]);
        voltage8()->setRawValue(content.voltage[3]);

        temperature5()->setRawValue(content.temperature[0]);
        temperature6()->setRawValue(content.temperature[1]);
        temperature7()->setRawValue(content.temperature[2]);
        temperature8()->setRawValue(content.temperature[3]);
    }

    _setTelemetryAvailable(true);
}

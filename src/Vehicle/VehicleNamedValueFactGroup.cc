/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "VehicleNamedValueFactGroup.h"
#include "Vehicle.h"
#include "FactMetaData.h"

#include <cstring>

VehicleNamedValueFactGroup::VehicleNamedValueFactGroup(QObject* parent)
    : FactGroup(0 /* updateRateMsecs: immediate */, parent)
{
}

void VehicleNamedValueFactGroup::handleMessage(Vehicle* /* vehicle */, mavlink_message_t& message)
{
    switch (message.msgid) {
    case MAVLINK_MSG_ID_NAMED_VALUE_FLOAT: {
        mavlink_named_value_float_t nvf;
        mavlink_msg_named_value_float_decode(&message, &nvf);
        _updateValue(nvf.name, static_cast<double>(nvf.value), FactMetaData::valueTypeFloat);
        break;
    }
    case MAVLINK_MSG_ID_NAMED_VALUE_INT: {
        mavlink_named_value_int_t nvi;
        mavlink_msg_named_value_int_decode(&message, &nvi);
        _updateValue(nvi.name, static_cast<double>(nvi.value), FactMetaData::valueTypeInt32);
        break;
    }
    default:
        break;
    }
}

void VehicleNamedValueFactGroup::_updateValue(const char* rawName, double value, FactMetaData::ValueType_t type)
{
    // NAMED_VALUE_* name is char[10] and is NOT null terminated when the name uses
    // all 10 characters, so copy into a padded buffer before use.
    char nameBuf[11];
    memcpy(nameBuf, rawName, 10);
    nameBuf[10] = '\0';

    const QString displayName = QString::fromLatin1(nameBuf).trimmed();
    if (displayName.isEmpty()) {
        return;
    }

    // The value picker displays fact names with an upper-cased first letter and then
    // looks them up after lower-casing the first letter (camelCase). So the fact must
    // be stored under a lower-first key for that round-trip to resolve. The original
    // name is kept as the short description shown in the values bar.
    const QString key = displayName.left(1).toLower() + displayName.mid(1);

    // Create a fact for this name the first time we see it.
    if (!_nameToFactMap.contains(key)) {
        FactMetaData* metaData = new FactMetaData(type, key, this);
        metaData->setShortDescription(displayName);
        if (type != FactMetaData::valueTypeInt32) {
            metaData->setDecimalPlaces(3);
        }
        _nameToFactMetaDataMap[key] = metaData;

        Fact* fact = new Fact(0, key, type, this);
        _addFact(fact, key); // applies the metadata registered above

        qCDebug(VehicleLog) << "VehicleNamedValueFactGroup: new custom telemetry value" << displayName;
    }

    _nameToFactMap[key]->setRawValue(value);
    _setTelemetryAvailable(true);
}

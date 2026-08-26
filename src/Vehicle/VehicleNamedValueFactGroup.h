/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once

#include "FactGroup.h"
#include "QGCMAVLink.h"

class Vehicle;

/// Exposes custom NAMED_VALUE_FLOAT / NAMED_VALUE_INT telemetry (e.g. from Lua
/// scripts) as facts. A fact is created dynamically for each unique value name the
/// first time it is received, so it can then be shown in the Fly View telemetry
/// values bar.
class VehicleNamedValueFactGroup : public FactGroup
{
    Q_OBJECT

public:
    VehicleNamedValueFactGroup(QObject* parent = nullptr);

    // Overrides from FactGroup
    void handleMessage(Vehicle* vehicle, mavlink_message_t& message) override;

private:
    void _updateValue(const char* rawName, double value, FactMetaData::ValueType_t type);
};

/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once

#include "FactGroup.h"

class VehicleEscStatusFactGroup : public FactGroup
{
    Q_OBJECT
    //Q_PROPERTY(Fact *index          READ index          CONSTANT)
    Q_PROPERTY(Fact *rpm1       READ rpm1       CONSTANT)
    Q_PROPERTY(Fact *rpm2      READ rpm2      CONSTANT)
    Q_PROPERTY(Fact *rpm3      READ rpm3       CONSTANT)
    Q_PROPERTY(Fact *rpm4      READ rpm4      CONSTANT)
    Q_PROPERTY(Fact *rpm5      READ rpm5       CONSTANT)
    Q_PROPERTY(Fact *rpm6      READ rpm6      CONSTANT)
    Q_PROPERTY(Fact *rpm7      READ rpm7       CONSTANT)
    Q_PROPERTY(Fact *rpm8      READ rpm8      CONSTANT)
    Q_PROPERTY(Fact *current1   READ current1   CONSTANT)
    Q_PROPERTY(Fact *current2  READ current2  CONSTANT)
    Q_PROPERTY(Fact *current3   READ current3   CONSTANT)
    Q_PROPERTY(Fact *current4  READ current4  CONSTANT)
    Q_PROPERTY(Fact *current5   READ current5   CONSTANT)
    Q_PROPERTY(Fact *current6  READ current6  CONSTANT)
    Q_PROPERTY(Fact *current7   READ current7   CONSTANT)
    Q_PROPERTY(Fact *current8  READ current8  CONSTANT)
    Q_PROPERTY(Fact *voltage1   READ voltage1   CONSTANT)
    Q_PROPERTY(Fact *voltage2  READ voltage2  CONSTANT)
    Q_PROPERTY(Fact *voltage3   READ voltage3   CONSTANT)
    Q_PROPERTY(Fact *voltage4  READ voltage4  CONSTANT)
    Q_PROPERTY(Fact *voltage5   READ voltage5   CONSTANT)
    Q_PROPERTY(Fact *voltage6  READ voltage6  CONSTANT)
    Q_PROPERTY(Fact *voltage7   READ voltage7   CONSTANT)
    Q_PROPERTY(Fact *voltage8  READ voltage8  CONSTANT)

public:
    explicit VehicleEscStatusFactGroup(QObject *parent = nullptr);

    //Fact *index() { return &_indexFact; }
    Fact *rpm1() { return &_rpm1Fact; }
    Fact *rpm2() { return &_rpm2Fact; }
    Fact *rpm3() { return &_rpm3Fact; }
    Fact *rpm4() { return &_rpm4Fact; }
    Fact *rpm5() { return &_rpm5Fact; }
    Fact *rpm6() { return &_rpm6Fact; }
    Fact *rpm7() { return &_rpm7Fact; }
    Fact *rpm8() { return &_rpm8Fact; }

    Fact *current1() { return &_current1Fact; }
    Fact *current2() { return &_current2Fact; }
    Fact *current3() { return &_current3Fact; }
    Fact *current4() { return &_current4Fact; }
    Fact *current5() { return &_current5Fact; }
    Fact *current6() { return &_current6Fact; }
    Fact *current7() { return &_current7Fact; }
    Fact *current8() { return &_current8Fact; }

    Fact *voltage1() { return &_voltage1Fact; }
    Fact *voltage2() { return &_voltage2Fact; }
    Fact *voltage3() { return &_voltage3Fact; }
    Fact *voltage4() { return &_voltage4Fact; }
    Fact *voltage5() { return &_voltage5Fact; }
    Fact *voltage6() { return &_voltage6Fact; }
    Fact *voltage7() { return &_voltage7Fact; }
    Fact *voltage8() { return &_voltage8Fact; }

    Fact *temperature1() { return &_temperature1Fact; }
    Fact *temperature2() { return &_temperature2Fact; }
    Fact *temperature3() { return &_temperature3Fact; }
    Fact *temperature4() { return &_temperature4Fact; }
    Fact *temperature5() { return &_temperature5Fact; }
    Fact *temperature6() { return &_temperature6Fact; }
    Fact *temperature7() { return &_temperature7Fact; }
    Fact *temperature8() { return &_temperature8Fact; }

    // Overrides from FactGroup
    void handleMessage(Vehicle *vehicle, const mavlink_message_t &message) final;

private:
    //Fact _indexFact = Fact(0, QStringLiteral("index"), FactMetaData::valueTypeUint8);
    Fact _rpm1Fact = Fact(0, QStringLiteral("rpm1"), FactMetaData::valueTypeFloat);
    Fact _rpm2Fact = Fact(0, QStringLiteral("rpm2"), FactMetaData::valueTypeFloat);
    Fact _rpm3Fact = Fact(0, QStringLiteral("rpm3"), FactMetaData::valueTypeFloat);
    Fact _rpm4Fact = Fact(0, QStringLiteral("rpm4"), FactMetaData::valueTypeFloat);
    Fact _rpm5Fact = Fact(0, QStringLiteral("rpm5"), FactMetaData::valueTypeFloat);
    Fact _rpm6Fact = Fact(0, QStringLiteral("rpm6"), FactMetaData::valueTypeFloat);
    Fact _rpm7Fact = Fact(0, QStringLiteral("rpm7"), FactMetaData::valueTypeFloat);
    Fact _rpm8Fact = Fact(0, QStringLiteral("rpm8"), FactMetaData::valueTypeFloat);

    Fact _current1Fact = Fact(0, QStringLiteral("current1"), FactMetaData::valueTypeFloat);
    Fact _current2Fact = Fact(0, QStringLiteral("current2"), FactMetaData::valueTypeFloat);
    Fact _current3Fact = Fact(0, QStringLiteral("current3"), FactMetaData::valueTypeFloat);
    Fact _current4Fact = Fact(0, QStringLiteral("current4"), FactMetaData::valueTypeFloat);
    Fact _current5Fact = Fact(0, QStringLiteral("current5"), FactMetaData::valueTypeFloat);
    Fact _current6Fact = Fact(0, QStringLiteral("current6"), FactMetaData::valueTypeFloat);
    Fact _current7Fact = Fact(0, QStringLiteral("current7"), FactMetaData::valueTypeFloat);
    Fact _current8Fact = Fact(0, QStringLiteral("current8"), FactMetaData::valueTypeFloat);

    Fact _voltage1Fact = Fact(0, QStringLiteral("voltage1"), FactMetaData::valueTypeFloat);
    Fact _voltage2Fact = Fact(0, QStringLiteral("voltage2"), FactMetaData::valueTypeFloat);
    Fact _voltage3Fact = Fact(0, QStringLiteral("voltage3"), FactMetaData::valueTypeFloat);
    Fact _voltage4Fact = Fact(0, QStringLiteral("voltage4"), FactMetaData::valueTypeFloat);
    Fact _voltage5Fact = Fact(0, QStringLiteral("voltage5"), FactMetaData::valueTypeFloat);
    Fact _voltage6Fact = Fact(0, QStringLiteral("voltage6"), FactMetaData::valueTypeFloat);
    Fact _voltage7Fact = Fact(0, QStringLiteral("voltage7"), FactMetaData::valueTypeFloat);
    Fact _voltage8Fact = Fact(0, QStringLiteral("voltage8"), FactMetaData::valueTypeFloat);

    Fact _temperature1Fact = Fact(0, QStringLiteral("temperature1"), FactMetaData::valueTypeFloat);
    Fact _temperature2Fact = Fact(0, QStringLiteral("temperature2"), FactMetaData::valueTypeFloat);
    Fact _temperature3Fact = Fact(0, QStringLiteral("temperature3"), FactMetaData::valueTypeFloat);
    Fact _temperature4Fact = Fact(0, QStringLiteral("temperature4"), FactMetaData::valueTypeFloat);
    Fact _temperature5Fact = Fact(0, QStringLiteral("temperature5"), FactMetaData::valueTypeFloat);
    Fact _temperature6Fact = Fact(0, QStringLiteral("temperature6"), FactMetaData::valueTypeFloat);
    Fact _temperature7Fact = Fact(0, QStringLiteral("temperature7"), FactMetaData::valueTypeFloat);
    Fact _temperature8Fact = Fact(0, QStringLiteral("temperature8"), FactMetaData::valueTypeFloat);
};

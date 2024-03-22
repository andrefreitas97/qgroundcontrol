/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl 1.0

import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.12


GuidedToolStripAction {
    property var   activeVehicle:           QGroundControl.multiVehicleManager.activeVehicle
    property bool   _vehiclebravo: QGroundControl.settingsManager.appSettings.vehiclebravo.value

    text:       "Position"
    iconSource: "/res/position.svg"
    visible:    activeVehicle && _vehiclebravo
    enabled:    _guidedController.showPosition
    actionID:   _guidedController.actionPosition
}

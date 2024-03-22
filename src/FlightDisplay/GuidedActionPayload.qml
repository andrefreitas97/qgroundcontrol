/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QGroundControl.FlightDisplay 1.0
import QGroundControl 1.0
import QGroundControl.Controls  1.0

import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0

ToolStripAction {
    property var   activeVehicle:           QGroundControl.multiVehicleManager.activeVehicle
    property bool   _vehiclebravo: QGroundControl.settingsManager.appSettings.vehiclebravo.value

    text:       "Payloads"
    iconSource: "/res/payload.svg"
    visible:     activeVehicle && _vehiclebravo
    enabled:    _guidedController.showPayload

    onTriggered: {
        _guidedController.closeAll()

        if (QGroundControl.settingsManager.appSettings.payloadgripper.value === true) {_guidedController.confirmAction(_guidedController.actionGripper)}
        if (QGroundControl.settingsManager.appSettings.payloadgrenades.value === true) {_guidedController.confirmAction(_guidedController.actionGrenades)}
    }
}

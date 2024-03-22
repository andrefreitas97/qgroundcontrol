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
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.Controls              1.0

GuidedToolStripAction {
    property var   activeVehicle:           QGroundControl.multiVehicleManager.activeVehicle
    property bool   _vehiclebravo: QGroundControl.settingsManager.appSettings.vehiclebravo.value
    property bool   _initialConnectComplete:    activeVehicle ? activeVehicle.initialConnectComplete : false
    property bool  _isVehicleArmed:         _initialConnectComplete ? activeVehicle.armed : false

    text:       "Grenades"
    iconSource: "/res/Grenade.svg"
    visible:    activeVehicle && _vehiclebravo && !_isVehicleArmed
    enabled:    _guidedController.showGrenades
    actionID:   _guidedController.actionGrenades
}

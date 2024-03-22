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

    text:       "Config"
    iconSource: "/res/config.svg"
    visible:     activeVehicle
    enabled:    _guidedController.showConfig

    onTriggered: {
        _guidedController.closeAll()
        _widgetLayer._configMenu.createObject(mainWindow).open()
    }
}

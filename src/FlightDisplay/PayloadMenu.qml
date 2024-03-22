import QtQuick                  2.3
import QtQuick.Controls         1.2
import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs          1.2
import QtLocation               5.3
import QtPositioning            5.3
import QtQuick.Layouts          1.2

import QGroundControl                           1.0
import QGroundControl.ScreenTools               1.0
import QGroundControl.Controls                  1.0
import QGroundControl.Palette                   1.0
import QGroundControl.Vehicle                   1.0
import QGroundControl.FlightMap                 1.0

import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0

Component {
    id: messageDialogComponent
    QGCPopupDialog {
        title: "Select payload"
        property var  acceptFunction:     null
        buttons:  StandardButton.Cancel

        property var    _activeVehicle:             QGroundControl.multiVehicleManager.activeVehicle

        onRejected:{
            _guidedController.closeAll()
            close()
        }

        onAccepted: {
            if (acceptFunction) {
                close()
            }
        }

        RowLayout {

            QGCColumnButton {
                id: gripper
                text:                   "Gripper"
                iconSource:             "/res/Gripper.svg"
                pointSize:              ScreenTools.defaultFontPointSize * 1
                backRadius:             width / 40
                heightFactor:           0.75
                Layout.preferredWidth:  ScreenTools.defaultFontPixelWidth * 30
                Layout.preferredHeight: Layout.preferredWidth / 1.20
                visible: _guidedController.showGripper
                onClicked: {
                    _guidedController.confirmAction(_guidedController.actionGripper)
                    close()
                }
            }


            QGCColumnButton {
                id: grenades
                text:                   "Grenades"
                iconSource:             "/res/Grenade.svg"
                pointSize:              ScreenTools.defaultFontPointSize * 1
                backRadius:             width / 40
                heightFactor:           0.75
                Layout.preferredWidth:  ScreenTools.defaultFontPixelWidth * 30
                Layout.preferredHeight: Layout.preferredWidth / 1.20
                visible: _guidedController.showGrenades
                onClicked: {
                    _guidedController.confirmAction(_guidedController.actionGrenades)
                    close()
                }
            }
        }
    }
}

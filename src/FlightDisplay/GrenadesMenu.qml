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

Component {
    id: messageDialogComponent
    QGCPopupDialog {
        title: "Select Grenade action"
        property var  acceptFunction:     null
        buttons:  StandardButton.Cancel

        onRejected:{
        //    //_guidedController._grenadesFunction = 0
            _guidedController.closeAll()
            close()
        }

        onAccepted: {
            if (acceptFunction) {
                //_guidedController._grenadesFunction = 0
                close()
            }
        }

        RowLayout {
            QGCColumnButton {
                id: grenade1Button
                text:                   "Release Grenade 1"
                iconSource:             "/res/Grenade.svg"
                pointSize:              ScreenTools.defaultFontPointSize * 1
                backRadius:             width / 40
                heightFactor:           0.75
                Layout.preferredHeight: grenade2Button.height
                Layout.preferredWidth:  grenade2Button.width

                onClicked: {
                    _guidedController._grenadesFunction = 1
                    close()
                }
            }

            //QGCColumnButton {
            //    id: locked
            //    text:                   "Locked"
            //    iconSource:             "/res/LockClosed.svg"
            //    pointSize:              ScreenTools.defaultFontPointSize * 1
            //    backRadius:             width / 40
            //    heightFactor:           0.75
            //    Layout.preferredHeight: grenade2Button.height
            //    Layout.preferredWidth:  grenade2Button.width

            //    onClicked: {
            //        _guidedController._grenadesFunction = 0
            //        close()
            //    }
            //}

            QGCColumnButton {
                id: grenade2Button
                text:                   "Release Grenade 2"
                iconSource:             "/res/Grenade.svg"
                pointSize:              ScreenTools.defaultFontPointSize * 1
                backRadius:             width / 40
                heightFactor:           0.75
                Layout.preferredWidth:  ScreenTools.defaultFontPixelWidth * 30
                Layout.preferredHeight: Layout.preferredWidth / 1.20

                onClicked: {
                    _guidedController._grenadesFunction = 2
                    close()
                }
            }
        }
    }
}

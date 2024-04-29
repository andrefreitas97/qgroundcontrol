/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                  2.4
import QtPositioning            5.2
import QtQuick.Layouts          1.2
import QtQuick.Controls         1.4
import QtQuick.Dialogs          1.2
import QtGraphicalEffects       1.0

import QGroundControl                   1.0
import QGroundControl.ScreenTools       1.0
import QGroundControl.Controls          1.0
import QGroundControl.Palette           1.0
import QGroundControl.Vehicle           1.0
import QGroundControl.Controllers       1.0
import QGroundControl.FactSystem        1.0
import QGroundControl.FactControls      1.0

import QGroundControl.SettingsManager   1.0

Rectangle {
    height:     mainLayout.height + (_margins * 2)
    color:      Qt.rgba(qgcPal.window.r, qgcPal.window.g, qgcPal.window.b, 0.5)
    radius:     _margins
    visible:    multiVehiclePanelSelector.showSingleVehiclePanel && QGroundControl.settingsManager.appSettings.cameraZio.value && _activeVehicle

    property real   _margins:                                   ScreenTools.defaultFontPixelHeight / 2
    property var    _activeVehicle:                             QGroundControl.multiVehicleManager.activeVehicle

    property var    _videoSettings:             QGroundControl.settingsManager.videoSettings

    property bool   _communicationLost: _activeVehicle ? _activeVehicle.vehicleLinkManager.communicationLost : false
    property bool   _initialConnectComplete:    _activeVehicle ? _activeVehicle.initialConnectComplete : false


    ColumnLayout {
        id:                         mainLayout
        anchors.margins:            _margins
        anchors.top:                parent.top
        anchors.horizontalCenter:   parent.horizontalCenter
        spacing:                    ScreenTools.defaultFontPixelHeight / 2

        RowLayout {
            Layout.alignment:   Qt.AlignHCenter
            spacing:            0
            enabled:            !_communicationLost && _initialConnectComplete

            QGCRadioButton {
                font.pointSize: ScreenTools.smallFontPointSize
                text:           qsTr("FPV Stream")
                checked:        _videoSettings.rtspUrl.value == _videoSettings.rtspUrl1.value ? true : false
                onClicked:      {_videoSettings.rtspUrl.value = _videoSettings.rtspUrl1.value
                                 _activeVehicle.sendSetMount1Action()}
            }

            QGCRadioButton {
                font.pointSize: ScreenTools.smallFontPointSize
                text:           qsTr("Gimbal Stream")
                checked:        _videoSettings.rtspUrl.value == _videoSettings.rtspUrl2.value ? true : false
                onClicked:      {_videoSettings.rtspUrl.value = _videoSettings.rtspUrl2.value
                                 _activeVehicle.sendSetMount2Action()}
            }
        }
    }
}

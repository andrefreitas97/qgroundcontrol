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
import QGroundControl.MultiVehicleManager 1.0

import QGroundControl.SettingsManager   1.0

import SiYi.Object 1.0

Rectangle {
    height:     mainLayout.height + (_margins * 2)
    color:      Qt.rgba(qgcPal.window.r, qgcPal.window.g, qgcPal.window.b, 0.5)
    radius:     _margins
    visible:    multiVehiclePanelSelector.showSingleVehiclePanel && (QGroundControl.settingsManager.appSettings.gimbalCameraA8.value || QGroundControl.settingsManager.appSettings.gimbalCameraZT6.value || QGroundControl.settingsManager.appSettings.gimbalCameraZIO.value) && _activeVehicle

    property real   _margins:                                   ScreenTools.defaultFontPixelHeight / 2
    property var    _activeVehicle:                             QGroundControl.multiVehicleManager.activeVehicle
    property var  gimbalController:             _activeVehicle ? _activeVehicle.gimbalController : undefined
    property var  activeGimbal:                 gimbalController ? gimbalController.activeGimbal : undefined

    property var    _videoSettings:             QGroundControl.settingsManager.videoSettings

    property bool   _communicationLost: _activeVehicle ? _activeVehicle.vehicleLinkManager.communicationLost : false
    property bool   _initialConnectComplete:    _activeVehicle ? _activeVehicle.initialConnectComplete : false


    ColumnLayout {
        id:                         mainLayout
        anchors.margins:            _margins
        anchors.top:                parent.top
        anchors.horizontalCenter:   parent.horizontalCenter
        spacing:                    ScreenTools.defaultFontPixelHeight / 2

        GridLayout {
            columns: 2
            Layout.alignment: Qt.AlignHCenter
            enabled: !_communicationLost && _initialConnectComplete && activeGimbal

            onEnabledChanged:{
                if (enabled) {
                _videoSettings.rtspUrl.value = _videoSettings.rtspUrlFPV.value;
                _activeVehicle.sendSetMountFPVAction();
                SiYi.camera.analyzeIp(_videoSettings.rtspUrl.value);
                //gimbalController.activeGimbal = gimbalController.gimbals.get(0)
                }
            }

            QGCRadioButton {
                font.pointSize: ScreenTools.smallFontPointSize
                text:           qsTr("FPV\nStream")
                font.bold:      _videoSettings.rtspUrl.value == _videoSettings.rtspUrlFPV.value ? true : false
                checked:        _videoSettings.rtspUrl.value == _videoSettings.rtspUrlFPV.value ? true : false
                onClicked:      {_videoSettings.rtspUrl.value = _videoSettings.rtspUrlFPV.value
                                _activeVehicle.sendSetMountFPVAction()
                                SiYi.camera.analyzeIp(_videoSettings.rtspUrl.value)
                                //gimbalController.activeGimbal = gimbalController.gimbals.get(0)
                                }
            }

            QGCRadioButton {
                font.pointSize: ScreenTools.smallFontPointSize
                text:           qsTr("A8\nStream")
                font.bold:      _videoSettings.rtspUrl.value == _videoSettings.rtspUrlA8.value ? true : false
                checked:        _videoSettings.rtspUrl.value == _videoSettings.rtspUrlA8.value ? true : false
                onClicked:      {_videoSettings.rtspUrl.value = _videoSettings.rtspUrlA8.value
                                _activeVehicle.sendSetMountA8Action()
                                SiYi.camera.analyzeIp(_videoSettings.rtspUrl.value)
                                gimbalController.activeGimbal = gimbalController.gimbals.get(0)
                                }
                visible:        QGroundControl.settingsManager.appSettings.gimbalCameraA8.value
            }

            QGCRadioButton {
                font.pointSize: ScreenTools.smallFontPointSize
                text:           qsTr("ZT6 Main\nStream")
                font.bold:      _videoSettings.rtspUrl.value == _videoSettings.rtspUrlZT6Main.value ? true : false
                checked:        _videoSettings.rtspUrl.value == _videoSettings.rtspUrlZT6Main.value ? true : false
                onClicked:      {_videoSettings.rtspUrl.value = _videoSettings.rtspUrlZT6Main.value
                                _activeVehicle.sendSetMountZT6Action()
                                SiYi.camera.analyzeIp(_videoSettings.rtspUrl.value)
                                gimbalController.activeGimbal = gimbalController.gimbals.get(0)
                                }
                visible:        QGroundControl.settingsManager.appSettings.gimbalCameraZT6.value
            }

            QGCRadioButton {
                font.pointSize: ScreenTools.smallFontPointSize
                text:           qsTr("ZT6 Sub\nStream")
                font.bold:      _videoSettings.rtspUrl.value == _videoSettings.rtspUrlZT6Sub.value ? true : false
                checked:        _videoSettings.rtspUrl.value == _videoSettings.rtspUrlZT6Sub.value ? true : false
                onClicked:      {_videoSettings.rtspUrl.value = _videoSettings.rtspUrlZT6Sub.value
                                _activeVehicle.sendSetMountZT6Action()
                                SiYi.camera.analyzeIp(_videoSettings.rtspUrl.value)
                                gimbalController.activeGimbal = gimbalController.gimbals.get(0)
                                }
                visible:        QGroundControl.settingsManager.appSettings.gimbalCameraZT6.value
            }

            QGCRadioButton {
                font.pointSize: ScreenTools.smallFontPointSize
                text:           qsTr("ZIO\nStream")
                font.bold:      _videoSettings.rtspUrl.value == _videoSettings.rtspUrlZIO.value ? true : false
                checked:        _videoSettings.rtspUrl.value == _videoSettings.rtspUrlZIO.value ? true : false
                onClicked:      {_videoSettings.rtspUrl.value = _videoSettings.rtspUrlZIO.value
                                //_activeVehicle.sendSetMountZIOAction()
                                SiYi.camera.analyzeIp(_videoSettings.rtspUrl.value)
                                //gimbalController.activeGimbal = gimbalController.gimbals.get(1)
                                }
                visible:        QGroundControl.settingsManager.appSettings.gimbalCameraZIO.value
            }
        }
    }
}

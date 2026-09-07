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
    id:         videoStreamSourceSelector
    height:     mainLayout.height + (_margins * 2)
    color:      Qt.rgba(qgcPal.window.r, qgcPal.window.g, qgcPal.window.b, 0.5)
    radius:     _margins
    visible:    multiVehiclePanelSelector.showSingleVehiclePanel && (QGroundControl.settingsManager.appSettings.gimbalCameraA8.value || QGroundControl.settingsManager.appSettings.gimbalCameraZT6.value || QGroundControl.settingsManager.appSettings.gimbalCameraZIO.value || QGroundControl.settingsManager.appSettings.celeraCamera.value) && _activeVehicle

    property real   _margins:                                   ScreenTools.defaultFontPixelHeight / 2
    property var    _activeVehicle:                             QGroundControl.multiVehicleManager.activeVehicle
    property var  gimbalController:             _activeVehicle ? _activeVehicle.gimbalController : undefined
    property var  activeGimbal:                 gimbalController ? gimbalController.activeGimbal : undefined

    property var    _videoSettings:             QGroundControl.settingsManager.videoSettings

    property bool   _communicationLost: _activeVehicle ? _activeVehicle.vehicleLinkManager.communicationLost : false
    property bool   _initialConnectComplete:    _activeVehicle ? _activeVehicle.initialConnectComplete : false

    property var siyi: SiYi
    property SiYiCamera camera: siyi.camera

    // The following properties relate to a simple camera
    property var    _flyViewSettings:                           QGroundControl.settingsManager.flyViewSettings
    property bool   _simpleCameraAvailable:                     !_mavlinkCamera && _activeVehicle && _flyViewSettings.showSimpleCameraControl.rawValue
    property bool   _onlySimpleCameraAvailable:                 !_anyVideoStreamAvailable && _simpleCameraAvailable
    property bool   _simpleCameraIsShootingInCurrentMode:       _onlySimpleCameraAvailable && !_simplePhotoCaptureIsIdle

    // The following properties relate to a simple video stream
    property bool   _videoStreamAvailable:                      _videoStreamManager.hasVideo
    property var    _videoStreamSettings:                       QGroundControl.settingsManager.videoSettings
    property var    _videoStreamManager:                        QGroundControl.videoManager
    property bool   _videoStreamAllowsPhotoWhileRecording:      true
    property bool   _videoStreamIsStreaming:                    _videoStreamManager.streaming
    property bool   _simplePhotoCaptureIsIdle:             true
    property bool   _videoStreamRecording:                      _videoStreamManager.recording
    property bool   _videoStreamCanShoot:                       _videoStreamIsStreaming
    property bool   _videoStreamIsShootingInCurrentMode:        _videoStreamInPhotoMode ? !_simplePhotoCaptureIsIdle : _videoStreamRecording
    property bool   _videoStreamInPhotoMode:                    false

    // The following properties relate to a mavlink protocol camera
    property var    _mavlinkCameraManager:                      _activeVehicle ? _activeVehicle.cameraManager : null
    property int    _mavlinkCameraManagerCurCameraIndex:        _mavlinkCameraManager ? _mavlinkCameraManager.currentCamera : -1
    property bool   _noMavlinkCameras:                          _mavlinkCameraManager ? _mavlinkCameraManager.cameras.count === 0 : true
    property var    _mavlinkCamera:                             !_noMavlinkCameras ? (_mavlinkCameraManager.cameras.get(_mavlinkCameraManagerCurCameraIndex) && _mavlinkCameraManager.cameras.get(_mavlinkCameraManagerCurCameraIndex).paramComplete ? _mavlinkCameraManager.cameras.get(_mavlinkCameraManagerCurCameraIndex) : null) : null
    property bool   _multipleMavlinkCameras:                    _mavlinkCameraManager ? _mavlinkCameraManager.cameras.count > 1 : false
    property string _mavlinkCameraName:                         _mavlinkCamera && _multipleMavlinkCameras ? _mavlinkCamera.modelName : ""
    property bool   _noMavlinkCameraStreams:                    _mavlinkCamera ? _mavlinkCamera.streamLabels.length : true
    property bool   _multipleMavlinkCameraStreams:              _mavlinkCamera ? _mavlinkCamera.streamLabels.length > 1 : false
    property int    _mavlinCameraCurStreamIndex:                _mavlinkCamera ? _mavlinkCamera.currentStream : -1
    property bool   _mavlinkCameraHasThermalVideoStream:        _mavlinkCamera ? _mavlinkCamera.thermalStreamInstance : false
    property bool   _mavlinkCameraModeUndefined:                _mavlinkCamera ? _mavlinkCamera.cameraMode === QGCCameraControl.CAM_MODE_UNDEFINED : true
    property bool   _mavlinkCameraInVideoMode:                  _mavlinkCamera ? _mavlinkCamera.cameraMode === QGCCameraControl.CAM_MODE_VIDEO : false
    property bool   _mavlinkCameraInPhotoMode:                  _mavlinkCamera ? _mavlinkCamera.cameraMode === QGCCameraControl.CAM_MODE_PHOTO : false
    property bool   _mavlinkCameraElapsedMode:                  _mavlinkCamera && _mavlinkCamera.cameraMode === QGCCameraControl.CAM_MODE_PHOTO && _mavlinkCamera.photoMode === QGCCameraControl.PHOTO_CAPTURE_TIMELAPSE
    property bool   _mavlinkCameraHasModes:                     _mavlinkCamera && _mavlinkCamera.hasModes
    property bool   _mavlinkCameraVideoIsRecording:             _mavlinkCamera && _mavlinkCamera.videoStatus === QGCCameraControl.VIDEO_CAPTURE_STATUS_RUNNING
    property bool   _mavlinkCameraPhotoCaptureIsIdle:           _mavlinkCamera && (_mavlinkCamera.photoStatus === QGCCameraControl.PHOTO_CAPTURE_IDLE || _mavlinkCamera.photoStatus >= QGCCameraControl.PHOTO_CAPTURE_LAST)
    property bool   _mavlinkCameraStorageReady:                 _mavlinkCamera && _mavlinkCamera.storageStatus === QGCCameraControl.STORAGE_READY
    property bool   _mavlinkCameraBatteryReady:                 _mavlinkCamera && _mavlinkCamera.batteryRemaining >= 0
    property bool   _mavlinkCameraStorageSupported:             _mavlinkCamera && _mavlinkCamera.storageStatus !== QGCCameraControl.STORAGE_NOT_SUPPORTED
    property bool   _mavlinkCameraAllowsPhotoWhileRecording:    false
    property bool   _mavlinkCameraCanShoot:                     (!_mavlinkCameraModeUndefined && ((_mavlinkCameraStorageReady && _mavlinkCamera.storageFree > 0) || !_mavlinkCameraStorageSupported)) || _videoStreamManager.streaming
    property bool   _mavlinkCameraIsShooting:                   ((_mavlinkCameraInVideoMode && _mavlinkCameraVideoIsRecording) || (_mavlinkCameraInPhotoMode && !_mavlinkCameraPhotoCaptureIsIdle)) || _videoStreamManager.recording

    // The following settings and functions unify between a mavlink camera and a simple video stream for simple access

    property bool   _anyVideoStreamAvailable:                   _videoStreamManager.hasVideo
    property string _cameraName:                                _mavlinkCamera ? _mavlinkCameraName : ""
    property bool   _showModeIndicator:                         _mavlinkCamera ? _mavlinkCameraHasModes : _videoStreamManager.hasVideo
    property bool   _modeIndicatorPhotoMode:                    _mavlinkCamera ? _mavlinkCameraInPhotoMode : _videoStreamInPhotoMode || _onlySimpleCameraAvailable
    property bool   _allowsPhotoWhileRecording:                  _mavlinkCamera ? _mavlinkCameraAllowsPhotoWhileRecording : _videoStreamAllowsPhotoWhileRecording
    property bool   _switchToPhotoModeAllowed:                  !_modeIndicatorPhotoMode && (_mavlinkCamera ? !_mavlinkCameraIsShooting : true)
    property bool   _switchToVideoModeAllowed:                  _modeIndicatorPhotoMode && (_mavlinkCamera ? !_mavlinkCameraIsShooting : true)
    property bool   _videoIsRecording:                          _mavlinkCamera ? _mavlinkCameraIsShooting : _videoStreamRecording
    property bool   _canShootInCurrentMode:                     _mavlinkCamera ? _mavlinkCameraCanShoot : _videoStreamCanShoot || _simpleCameraAvailable
    property bool   _isShootingInCurrentMode:                   _mavlinkCamera ? _mavlinkCameraIsShooting : _videoStreamIsShootingInCurrentMode || _simpleCameraIsShootingInCurrentMode

    property var  vehicleLinkManager:             _activeVehicle ? _activeVehicle.vehicleLinkManager : undefined

    // ---- Celera custom vehicle parameters -----------------------------------
    // Created by the ArduPilot Lua script (tools/celera/celera_params.lua).
    //
    //   CELERA_MODE     image mode      written here
    //   CELERA_POL      polarization    written here
    //   CELERA_TRIGGER  photos asked    written here, once per shutter press
    //   CELERA_SHOTS    photos taken    written by the companion computer only
    //
    // NOTE: MAVLink limits a parameter name to 16 characters, which is why the
    //       polarization parameter is CELERA_POL and not CELERA_POLARIZATION
    //       (19 chars). Keep these names in sync with the Lua script.
    property string _celeraModeParam:       "CELERA_MODE"
    property string _celeraPolParam:        "CELERA_POL"
    property string _celeraTriggerParam:    "CELERA_TRIGGER"
    property string _celeraShotsParam:      "CELERA_SHOTS"

    property int    _celeraTriggerMax:      65535

    // CELERA_MODE only accepts 0 or 2 -> combo index 0/1 maps through this
    property var    _celeraModeValues:      [ 0, 2 ]

    // The polarization values the camera accepts depend on the image mode, so
    // the polarization combo is rebuilt whenever the mode changes. Index is no
    // longer the value - both combos map through their values array.
    property var    _celeraPolByMode:       ({ 0: [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 13 ],
                                               2: [ 10, 11, 12 ] })

    property int    _celeraMode:            _celeraModeFact ? Math.round(_celeraModeFact.rawValue) : -1
    property int    _celeraPol:             _celeraPolFact  ? Math.round(_celeraPolFact.rawValue)  : -1
    property var    _celeraPolValues:       _celeraPolByMode[_celeraMode] !== undefined ? _celeraPolByMode[_celeraMode] : []
    property var    _celeraPolLabels:       _celeraPolValues.map(function(value) { return value.toString() })

    property bool   _celeraSelected:        _videoSettings.rtspUrl.value == _videoSettings.rtspUrlCelera.value

    // Row conditions for the settings dialog. Named once here so the label, the
    // control next to it and the row count below can never drift apart.
    property bool   _zt6MainSelected:       _anyVideoStreamAvailable && _videoSettings.rtspUrl.value == _videoSettings.rtspUrlZT6Main.value
    property bool   _zt6ThermalActive:      _zt6MainSelected && _videoStreamSettings.zt6ImageMode.rawValue != 1
    property bool   _celeraParamsReady:     _activeVehicle && _activeVehicle.parameterManager ? _activeVehicle.parameterManager.parametersReady : false

    property var    _celeraModeFact:        _celeraParamsReady ? _lookupCeleraFact(_celeraModeParam)    : null
    property var    _celeraPolFact:         _celeraParamsReady ? _lookupCeleraFact(_celeraPolParam)     : null
    property var    _celeraTriggerFact:     _celeraParamsReady ? _lookupCeleraFact(_celeraTriggerParam) : null
    property var    _celeraShotsFact:       _celeraParamsReady ? _lookupCeleraFact(_celeraShotsParam)   : null

    property int    _celeraRequested:       _celeraTriggerFact ? Math.round(_celeraTriggerFact.rawValue) : 0
    property int    _celeraConfirmed:       _celeraShotsFact   ? Math.round(_celeraShotsFact.rawValue)   : 0

    // A photo legitimately takes a moment to be reported. Only call it a failure
    // once the grace period has elapsed with the counts still apart.
    property bool   _celeraCaptureLate:     !celeraCaptureGrace.running && _celeraConfirmed < _celeraRequested

    Timer {
        id:         celeraCaptureGrace
        interval:   6000
    }

    // FactPanelController binds to the active vehicle when it is *constructed*,
    // and this panel is built at app startup - before any vehicle connects. So a
    // controller is created on demand, once the parameters are actually there.
    Component {
        id: celeraParamControllerComponent

        FactPanelController { }
    }

    function _lookupCeleraFact(paramName) {
        var ctrl = celeraParamControllerComponent.createObject(videoStreamSourceSelector)
        if (!ctrl) {
            return null
        }
        var fact = ctrl.parameterExists(-1, paramName)
                    ? ctrl.getParameterFact(-1, paramName, false)
                    : null
        ctrl.destroy()
        return fact
    }

    // Writing the mode can invalidate the polarization, so the two are changed
    // together here rather than leaving the vehicle holding a combination the
    // camera cannot use.
    function setCeleraMode(mode) {
        if (!_celeraModeFact) {
            return
        }
        _celeraModeFact.rawValue = mode

        if (_celeraPolFact) {
            var allowed = _celeraPolByMode[mode] !== undefined ? _celeraPolByMode[mode] : []
            if (allowed.length > 0 && allowed.indexOf(Math.round(_celeraPolFact.rawValue)) === -1) {
                _celeraPolFact.rawValue = allowed[0]
            }
        }
    }

    function triggerCeleraPhoto() {
        if (!_celeraTriggerFact) {
            mainWindow.showMessageDialog(qsTr("Celera"),
                                         qsTr("The vehicle has no %1 parameter. Is the Celera Lua script running on the autopilot?").arg(_celeraTriggerParam))
            return
        }

        // Wrap rather than growing without bound. A wrap makes the value go
        // down, which the companion computer treats as a resync - it costs at
        // most the one press that wraps.
        var current = _celeraRequested
        if (!(current >= 0) || current >= _celeraTriggerMax) {
            current = 0
        }
        _celeraTriggerFact.rawValue = current + 1
        celeraCaptureGrace.restart()
    }


    ColumnLayout {
        id:                         mainLayout
        anchors.margins:            _margins
        anchors.top:                parent.top
        anchors.left:   parent.left
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
                text:           qsTr("ZT6\nStream")
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
                visible:        false //QGroundControl.settingsManager.appSettings.gimbalCameraZT6.value
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

            QGCRadioButton {
                font.pointSize: ScreenTools.smallFontPointSize
                text:           qsTr("Celera\nStream")
                font.bold:      _videoSettings.rtspUrl.value == _videoSettings.rtspUrlCelera.value ? true : false
                checked:        _videoSettings.rtspUrl.value == _videoSettings.rtspUrlCelera.value ? true : false
                onClicked:      {_videoSettings.rtspUrl.value = _videoSettings.rtspUrlCelera.value
                                SiYi.camera.analyzeIp(_videoSettings.rtspUrl.value)
                                }
                visible:        QGroundControl.settingsManager.appSettings.celeraCamera.value
            }
        }

        // Celera photo trigger. The Celera has no MAVLink camera, so a press
        // increments CELERA_TRIGGER and the companion computer answers by
        // incrementing CELERA_SHOTS once the photo has actually been taken.
        ColumnLayout {
            Layout.alignment:   Qt.AlignHCenter
            spacing:            ScreenTools.defaultFontPixelHeight / 4
            visible:            _celeraSelected && _celeraTriggerFact

            QGCButton {
                Layout.alignment:   Qt.AlignHCenter
                text:               qsTr("Take Photo")
                enabled:            !_communicationLost && _initialConnectComplete
                onClicked:          triggerCeleraPhoto()
            }

            // "taken / asked". Turns amber when a request has gone unanswered
            // for longer than the grace period.
            QGCLabel {
                Layout.alignment:   Qt.AlignHCenter
                font.pointSize:     ScreenTools.smallFontPointSize
                visible:            _celeraShotsFact
                text:               qsTr("%1 / %2").arg(_celeraConfirmed).arg(_celeraRequested)
                color:              _celeraCaptureLate ? qgcPal.colorOrange : qgcPal.text
            }
        }
    }

    QGCPalette { id: qgcPal; colorGroupEnabled: enabled }

        QGCColoredImage {
            anchors.margins:    _margins
            anchors.bottom:        parent.bottom
            anchors.right:      parent.right
            source:             "/res/gear-black.svg"
            mipmap:             true
            height:             ScreenTools.defaultFontPixelHeight
            width:              height
            sourceSize.height:  height
            color:              qgcPal.text
            fillMode:           Image.PreserveAspectFit
            enabled: !_communicationLost && _initialConnectComplete && activeGimbal
            opacity:  enabled ? 1 : 0.5


            QGCMouseArea {
                fillItem:   parent
                onClicked:  {
                            if(_videoSettings.rtspUrl.value == _videoSettings.rtspUrlZT6Main.value){
                                console.log("Requesting pseudoColor...")
                                camera.requestPalette()
                                console.log("Requesting irGain...")
                                camera.requestThermalGain()
                                console.log("Requesting mainStreamSplitMode...")
                                camera.getSplitMode()  
                            } 

                            settingsDialogComponent.createObject(mainWindow).open()
                }
            }

            Connections {
                target: camera
                onPseudoColorChanged: {
                    console.log("pseudoColor updated:", camera.pseudoColor)
                    console.log("_videoStreamSettings.colorPalette.value (before):", _videoStreamSettings.colorPalette.value)
                    _videoStreamSettings.colorPalette.rawValue = camera.pseudoColor
                    console.log("_videoStreamSettings.colorPalette.value (after):", _videoStreamSettings.colorPalette.value)  
                }
            }

            Connections {
                target: camera
                onIrGainChanged: {
                    console.log("irGain updated:", camera.irGain)
                    console.log("_videoStreamSettings.thermalGain.value (before):", _videoStreamSettings.thermalGain.value)
                    _videoStreamSettings.thermalGain.rawValue = camera.irGain
                    console.log("_videoStreamSettings.thermalGain.value (after):", _videoStreamSettings.thermalGain.value)  
                }
            }

            Connections {
                target: camera
                onMainStreamSplitModeChanged: {
                    console.log("MainStreamSplit updated:", camera.mainStreamSplitMode)
                    console.log("_videoStreamSettings.zt6ImageMode.rawValue (before):", _videoStreamSettings.zt6ImageMode.rawValue)
                    if(camera.mainStreamSplitMode == 3){_videoStreamSettings.zt6ImageMode.rawValue = 0}
                    if(camera.mainStreamSplitMode == 0){_videoStreamSettings.zt6ImageMode.rawValue = 1}
                    if(camera.mainStreamSplitMode == 2){_videoStreamSettings.zt6ImageMode.rawValue = 2}
                    console.log("_videoStreamSettings.zt6ImageMode.rawValue (after):", _videoStreamSettings.zt6ImageMode.rawValue)  
                }
            }       
        }      

    Component {
        id: settingsDialogComponent

        QGCPopupDialog {
            id:         settingsDialog
            title:      qsTr("Settings")
            buttons:    StandardButton.Close

            // The Celera parameter facts live on the panel root - see the
            // block at the top of this file.
            property bool   showCeleraMode:     _anyVideoStreamAvailable && _celeraSelected && _celeraModeFact !== null
            property bool   showCeleraPol:      _anyVideoStreamAvailable && _celeraSelected && _celeraPolFact  !== null

            ColumnLayout {
                spacing: _margins

                GridLayout {
                    id:     gridLayout
                    flow:   GridLayout.TopToBottom
                    // GridLayout fills column by column here (flow: TopToBottom),
                    // so `rows` MUST equal the number of *visible* items in the
                    // first column. One too many and the whole second column
                    // slides up a row against its labels.
                    //
                    // This was an accumulator that every label adjusted from
                    // onVisibleChanged. That only works if each label emits
                    // exactly one change signal at exactly the right moment,
                    // which is not true: Item.visible also reflects ancestor
                    // visibility, and QGCPopupDialog reparents its content after
                    // construction, so labels can report a change that is really
                    // the dialog appearing. A label whose visibility is a
                    // constant (Reset Camera Defaults) never fires at all.
                    // Counting the conditions directly is order-independent.
                    rows:   dynamicRows + (_mavlinkCamera ? _mavlinkCamera.activeSettings.length : 0)

                    property int dynamicRows:
                          (_multipleMavlinkCameras ? 1 : 0)                                                                             // Camera
                        + (_multipleMavlinkCameraStreams ? 1 : 0)                                                                       // Video Stream
                        + (_mavlinkCameraHasThermalVideoStream ? 1 : 0)                                                                 // Thermal View Mode
                        + (_mavlinkCameraHasThermalVideoStream && _mavlinkCamera.thermalMode === QGCCameraControl.THERMAL_BLEND ? 1 : 0) // Blend Opacity
                        + (_mavlinkCameraHasModes ? 1 : 0)                                                                              // Photo Mode
                        + (_mavlinkCameraInPhotoMode && _mavlinkCamera.photoMode === QGCCameraControl.PHOTO_CAPTURE_TIMELAPSE ? 1 : 0)   // Photo Interval
                        + (_anyVideoStreamAvailable ? 1 : 0)                                                                            // Video Grid Lines
                        + (_anyVideoStreamAvailable ? 1 : 0)                                                                            // Video Flip
                        + (_zt6MainSelected ? 1 : 0)                                                                                    // Image Mode
                        + (_zt6ThermalActive ? 4 : 0)                                                                                   // Thermal Palette, Thermal Gain, Max/Min Temperature Points, Point Temperature
                        + (settingsDialog.showCeleraMode ? 1 : 0)                                                                       // Celera Image Mode
                        + (settingsDialog.showCeleraPol ? 1 : 0)                                                                        // Celera Polarization
                        + (_mavlinkCameraStorageSupported ? 1 : 0)                                                                      // Storage
                        // "Reset Camera Defaults" is hard-coded invisible, so it is not counted.

                    // First column
                    QGCLabel {
                        text:               qsTr("Camera")
                        visible:            _multipleMavlinkCameras
                    }

                    QGCLabel {
                        text:               qsTr("Video Stream")
                        visible:            _multipleMavlinkCameraStreams
                    }

                    QGCLabel {
                        text:               qsTr("Thermal View Mode")
                        visible:            _mavlinkCameraHasThermalVideoStream
                    }

                    QGCLabel {
                        text:               qsTr("Blend Opacity")
                        visible:            _mavlinkCameraHasThermalVideoStream && _mavlinkCamera.thermalMode === QGCCameraControl.THERMAL_BLEND
                    }

                    // Mavlink Camera Protocol active settings
                    Repeater {
                        model: _mavlinkCamera ? _mavlinkCamera.activeSettings : []

                        QGCLabel {
                            text: _mavlinkCamera.getFact(modelData).shortDescription
                        }
                    }

                    QGCLabel {
                        text:               qsTr("Photo Mode")
                        visible:            _mavlinkCameraHasModes
                    }

                    QGCLabel {
                        text:               qsTr("Photo Interval (seconds)")
                        visible:            _mavlinkCameraInPhotoMode && _mavlinkCamera.photoMode === QGCCameraControl.PHOTO_CAPTURE_TIMELAPSE
                    }

                    QGCLabel {
                        text:               qsTr("Video Grid Lines")
                        visible:            _anyVideoStreamAvailable
                    }

                    QGCLabel {
                        text:               qsTr("Video Flip")
                        visible:            _anyVideoStreamAvailable
                    }

                    //QGCLabel {
                    //    text:               qsTr("Video Screen Fit")
                    //    visible:            _anyVideoStreamAvailable
                    //    onVisibleChanged:   gridLayout.dynamicRows += visible ? 1 : -1
                    //}

                    QGCLabel {
                        text:               qsTr("Image Mode")
                        visible:            _zt6MainSelected
                    }

                    QGCLabel {
                        text:               qsTr("Thermal Palette")
                        visible:            _zt6ThermalActive
                    }

                    QGCLabel {
                        text:               qsTr("Thermal Gain")
                        visible:            _zt6ThermalActive
                    }

                    //QGCLabel {
                    //    text:               qsTr("Gimbal Mode")
                    //    visible:            _zt6ThermalActive
                    //    onVisibleChanged:   gridLayout.dynamicRows += visible ? 1 : -1
                    //}

                    QGCLabel {
                        text:               qsTr("Max/Min Temperature Points")
                        visible:            _zt6ThermalActive
                    }

                    QGCLabel {
                        text:               qsTr("Point Temperature")
                        visible:            _zt6ThermalActive
                    }

                    QGCLabel {
                        text:               qsTr("Celera Image Mode")
                        visible:            settingsDialog.showCeleraMode
                    }

                    QGCLabel {
                        text:               qsTr("Celera Polarization")
                        visible:            settingsDialog.showCeleraPol
                    }


                    QGCLabel {
                        text:               qsTr("Reset Camera Defaults")
                        visible:            false //_mavlinkCamera
                    }

                    QGCLabel {
                        text:               qsTr("Storage")
                        visible:            _mavlinkCameraStorageSupported
                    }

                    // Second column
                    QGCComboBox {
                        Layout.fillWidth:   true
                        sizeToContents:     true
                        model:              _mavlinkCameraManager ? _mavlinkCameraManager.cameraLabels : []
                        currentIndex:       _mavlinkCameraManagerCurCameraIndex
                        visible:            _multipleMavlinkCameras
                        onActivated:        _mavlinkCameraManager.currentCamera = index
                    }

                    QGCComboBox {
                        Layout.fillWidth:   true
                        sizeToContents:     true
                        model:              _mavlinkCamera ? _mavlinkCamera.streamLabels : []
                        currentIndex:       _mavlinCameraCurStreamIndex
                        visible:            _multipleMavlinkCameraStreams
                        onActivated:        _mavlinkCamera.currentStream = index
                    }

                    QGCComboBox {
                        Layout.fillWidth:   true
                        sizeToContents:     true
                        model:              [ qsTr("Off"), qsTr("Blend"), qsTr("Full"), qsTr("Picture In Picture") ]
                        currentIndex:       _mavlinkCamera ? _mavlinkCamera.thermalMode : -1
                        visible:            _mavlinkCameraHasThermalVideoStream
                        onActivated:        _mavlinkCamera.thermalMode = index
                    }

                    QGCSlider {
                        Layout.fillWidth:           true
                        maximumValue:               100
                        minimumValue:               0
                        value:                      _mavlinkCamera ? _mavlinkCamera.thermalOpacity : 0
                        updateValueWhileDragging:   true
                        visible:                    _mavlinkCameraHasThermalVideoStream && _mavlinkCamera.thermalMode === QGCCameraControl.THERMAL_BLEND
                        onValueChanged:             _mavlinkCamera.thermalOpacity = value
                    }

                    // Mavlink Camera Protocol active settings
                    Repeater {
                        model: _mavlinkCamera ? _mavlinkCamera.activeSettings : []

                        RowLayout {
                            Layout.fillWidth:   true
                            spacing:            ScreenTools.defaultFontPixelWidth

                            property var    _fact:      _mavlinkCamera.getFact(modelData)
                            property bool   _isBool:    _fact.typeIsBool
                            property bool   _isCombo:   !_isBool && _fact.enumStrings.length > 0
                            property bool   _isSlider:  _fact && !isNaN(_fact.increment)
                            property bool   _isEdit:    !_isBool && !_isSlider && _fact.enumStrings.length < 1

                            FactComboBox {
                                Layout.fillWidth:   true
                                sizeToContents:     true
                                fact:               parent._fact
                                indexModel:         false
                                visible:            parent._isCombo
                            }
                            FactTextField {
                                Layout.fillWidth:   true
                                fact:               parent._fact
                                visible:            parent._isEdit
                            }
                            QGCSlider {
                                Layout.fillWidth:           true
                                maximumValue:               parent._fact.max
                                minimumValue:               parent._fact.min
                                stepSize:                   parent._fact.increment
                                visible:                    parent._isSlider
                                updateValueWhileDragging:   false
                                property bool initialized:  false

                                onValueChanged: {
                                    if (!initialized) {
                                        return
                                    }
                                    parent._fact.value = value
                                }

                                Component.onCompleted: {
                                    value = parent._fact.value
                                    initialized = true
                                }
                            }
                            QGCSwitch {
                                checked:        parent._fact ? parent._fact.value : false
                                visible:        parent._isBool
                                onClicked:      parent._fact.value = checked ? 1 : 0
                            }
                        }
                    }

                    QGCComboBox {
                        Layout.fillWidth:   true
                        sizeToContents:     true
                        model:              [ qsTr("Single"), qsTr("Time Lapse") ]
                        currentIndex:       _mavlinkCamera ? _mavlinkCamera.photoMode : 0
                        visible:            _mavlinkCameraHasModes
                        onActivated:        _mavlinkCamera.photoMode = index
                    }

                    QGCSlider {
                        Layout.fillWidth:           true
                        maximumValue:               60
                        minimumValue:               1
                        stepSize:                   1
                        value:                      _mavlinkCamera ? _mavlinkCamera.photoLapse : 5
                        displayValue:               true
                        updateValueWhileDragging:   true
                        visible:                    _mavlinkCameraInPhotoMode && _mavlinkCamera.photoMode === QGCCameraControl.PHOTO_CAPTURE_TIMELAPSE
                        onValueChanged: {
                            if (_mavlinkCamera) {
                                _mavlinkCamera.photoLapse = value
                            }
                        }
                    }

                    QGCSwitch {
                        checked:            _videoStreamSettings.gridLines.rawValue
                        visible:            _anyVideoStreamAvailable
                        onClicked:          _videoStreamSettings.gridLines.rawValue = checked ? 1 : 0
                    }

                    QGCSwitch {
                        checked:            _videoStreamSettings.videoFlip_FPV.rawValue
                        visible:            _anyVideoStreamAvailable && _videoSettings.rtspUrl.value == _videoSettings.rtspUrlFPV.value
                        onClicked:          _videoStreamSettings.videoFlip_FPV.rawValue = checked ? true : false
                    }

                    QGCSwitch {
                        checked:            _videoStreamSettings.videoFlip_GimbalA8.rawValue
                        visible:            _anyVideoStreamAvailable && _videoSettings.rtspUrl.value == _videoSettings.rtspUrlA8.value
                        onClicked:          _videoStreamSettings.videoFlip_GimbalA8.rawValue = checked ? true : false
                    }

                    QGCSwitch {
                        checked:            _videoStreamSettings.videoFlip_GimbalZT6Main.rawValue
                        visible:            _zt6MainSelected
                        onClicked:          _videoStreamSettings.videoFlip_GimbalZT6Main.rawValue = checked ? true : false
                    }

                    QGCSwitch {
                        checked:            _videoStreamSettings.videoFlip_GimbalZT6Sub.rawValue
                        visible:            _anyVideoStreamAvailable && _videoSettings.rtspUrl.value == _videoSettings.rtspUrlZT6Sub.value
                        onClicked:          _videoStreamSettings.videoFlip_GimbalZT6Sub.rawValue = checked ? true : false
                    }

                    QGCSwitch {
                        checked:            _videoStreamSettings.videoFlip_GimbalZIO.rawValue
                        visible:            _anyVideoStreamAvailable && _videoSettings.rtspUrl.value == _videoSettings.rtspUrlZIO.value
                        onClicked:          _videoStreamSettings.videoFlip_GimbalZIO.rawValue = checked ? true : false
                    }

                    QGCSwitch {
                        checked:            _videoStreamSettings.videoFlip_Celera.rawValue
                        visible:            _anyVideoStreamAvailable && _videoSettings.rtspUrl.value == _videoSettings.rtspUrlCelera.value
                        onClicked:          _videoStreamSettings.videoFlip_Celera.rawValue = checked ? true : false
                    }

                    //FactComboBox {
                    //    Layout.fillWidth:   true
                    //    sizeToContents:     true
                    //    fact:               _videoStreamSettings.videoFit
                    //    indexModel:         false
                    //    visible:            _anyVideoStreamAvailable
                    //}

                    FactComboBox {
                        Layout.fillWidth:   true
                        sizeToContents:     true
                        fact:               _videoStreamSettings.zt6ImageMode
                        indexModel:         false
                        visible:            _zt6MainSelected
                        onActivated: {
                                      camera.setZT6ImageMode(_videoStreamSettings.zt6ImageMode.rawValue)
                                                    }
                    }

                    FactComboBox {
                        Layout.fillWidth:   true
                        sizeToContents:     true
                        fact:               _videoStreamSettings.colorPalette
                        indexModel:         false
                        visible:            _zt6ThermalActive
                        onActivated: {
                                      camera.setPalette(_videoStreamSettings.colorPalette.rawValue)
                                                    }
                    }

                    FactComboBox {
                        Layout.fillWidth:   true
                        sizeToContents:     true
                        fact:               _videoStreamSettings.thermalGain
                        indexModel:         false
                        visible:            _zt6ThermalActive
                        onActivated: {
                                      camera.setThermalGain(_videoStreamSettings.thermalGain.rawValue)
                                                    }
                    }

                    //FactComboBox {
                    //    Layout.fillWidth:   true
                    //    sizeToContents:     true
                    //    fact:               _videoStreamSettings.gimbalMode
                    //    indexModel:         false
                    //    visible:            _zt6ThermalActive
                    //    onActivated: {
                    //                  camera.setGimbalMode(_videoStreamSettings.gimbalMode.rawValue)
                    //                                }
                    //}

                    FactComboBox {
                        Layout.fillWidth:   true
                        sizeToContents:     true
                        fact:               _videoStreamSettings.tempFullImage
                        indexModel:         false
                        visible:            _zt6ThermalActive
                        onActivated: {
                                      camera.requestTempFullImage(_videoStreamSettings.tempFullImage.rawValue)
                                                    }
                    }

                    FactComboBox {
                        Layout.fillWidth:   true
                        sizeToContents:     true
                        fact:               _videoStreamSettings.pointTemp
                        indexModel:         false
                        visible:            _zt6ThermalActive
                        onActivated: {
                                      //camera.requestPointTemp( 1920*(3/4), 1080/2, _videoStreamSettings.pointTemp.rawValue)
                                                    }
                    }

                    QGCComboBox {
                        Layout.fillWidth:   true
                        sizeToContents:     true
                        model:              [ qsTr("Mode 0"), qsTr("Mode 2") ]
                        visible:            settingsDialog.showCeleraMode
                        currentIndex:       videoStreamSourceSelector._celeraModeValues.indexOf(videoStreamSourceSelector._celeraMode)
                        onActivated:        videoStreamSourceSelector.setCeleraMode(videoStreamSourceSelector._celeraModeValues[index])
                    }

                    QGCComboBox {
                        Layout.fillWidth:   true
                        sizeToContents:     true
                        model:              videoStreamSourceSelector._celeraPolLabels
                        visible:            settingsDialog.showCeleraPol
                        // -1 when the vehicle holds a value the current mode does
                        // not allow: shows nothing rather than a wrong selection.
                        currentIndex:       videoStreamSourceSelector._celeraPolValues.indexOf(videoStreamSourceSelector._celeraPol)
                        onActivated: {
                            if (videoStreamSourceSelector._celeraPolFact) {
                                videoStreamSourceSelector._celeraPolFact.rawValue = videoStreamSourceSelector._celeraPolValues[index]
                            }
                        }
                    }


                    QGCButton {
                        Layout.fillWidth:   true
                        text:               qsTr("Reset")
                        visible:            false //_mavlinkCamera
                        onClicked:          resetPrompt.open()
                        MessageDialog {
                            id:                 resetPrompt
                            title:              qsTr("Reset Camera to Factory Settings")
                            text:               qsTr("Confirm resetting all settings?")
                            standardButtons:    StandardButton.Yes | StandardButton.No
                            onNo: resetPrompt.close()
                            onYes: {
                                _mavlinkCamera.resetSettings()
                                resetPrompt.close()
                            }
                        }
                    }

                    QGCButton {
                        Layout.fillWidth:   true
                        text:               qsTr("Format")
                        visible:            _mavlinkCameraStorageSupported
                        onClicked:          formatPrompt.open()
                        MessageDialog {
                            id:                 formatPrompt
                            title:              qsTr("Format Camera Storage")
                            text:               qsTr("Confirm erasing all files?")
                            standardButtons:    StandardButton.Yes | StandardButton.No
                            onNo: formatPrompt.close()
                            onYes: {
                                _mavlinkCamera.formatCard()
                                formatPrompt.close()
                            }
                        }
                    }
                }
            }
        }
    }
}

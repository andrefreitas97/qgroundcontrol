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

import QGroundControl.NTRIP          1.0

Component {
    id: messageDialogComponent
    QGCPopupDialog {
        title: "Configure vehicle"
        property var  acceptFunction:     null
        buttons:  StandardButton.Close

        property var    _activeVehicle:             QGroundControl.multiVehicleManager.activeVehicle

        property bool  _initialConnectComplete: _activeVehicle ? _activeVehicle.initialConnectComplete : false
        property bool  _isVehicleArmed:         _initialConnectComplete ? _activeVehicle.armed : false

        property real  _iconSize:               ScreenTools.defaultFontPixelHeight * 1.5
        property real  _labelColWidth:          ScreenTools.defaultFontPixelWidth * 20
        property real  _statusColWidth:         ScreenTools.defaultFontPixelWidth * 14

        FactPanelController { id: controller }
        property Fact param1: controller.getParameterFact(-1, "SRCSEL_MODE")
        property bool showOpflow: param1.value == 1
        property bool showGPSposition: param1.value == 2
        property bool showAutoposition: param1.value == 3

        property Fact param5: controller.getParameterFact(-1, "EK3_SRC1_POSZ")
        property bool showGPSheight: param5.value == 3

        property Fact param6: controller.getParameterFact(-1, "EK3_SRC1_POSZ")
        property bool showBaro: param6.value == 1

        property Fact param7: controller.getParameterFact(-1, "LANDING_ASSIST")
        property bool showLandingAssistON: param7.value == 1
        property bool showLandingAssistOFF: param7.value == 0

        property Fact param8: controller.getParameterFact(-1, "AVOID_ENABLE")
        property bool showProximityAvoidance: param8.value == 2 || param8.value == 3 || param8.value == 6 || param8.value == 7 ? true : false

        property Fact param9: controller.getParameterFact(-1, "SCR_USER3")
        property bool showSlow: param9.value == 1
        property bool showNormal: param9.value == 2
        property bool showFast: param9.value == 3

        property Fact param10: controller.getParameterFact(-1, "RNGFND1_TYPE")
        property Fact param11: controller.getParameterFact(-1, "RNGFND1_ORIENT")
        property bool showSurfaceTracking: param10.value != 0 && param11.value == 25

        property bool landingLightAvailable: controller.parameterExists(-1, "STROBE_LIGHTS")

        property Fact param13: controller.getParameterFact(-1, "STROBE_LIGHTS", false /* reportMissing */)
        property bool showLandingLightOFF: param13.value == 0
        property bool showLandingLightON: param13.value == 1

        // Rangefinder availability from the SYS_STATUS laser sensor bits (present + healthy).
        // This stays valid while the drone is stationary and correctly goes false on
        // disconnect. Note: ArduPilot latches these bits at boot, so a hot-reconnect of
        // the sensor requires a reboot before it reads as available again.
        property bool _rangefinderPresent: _activeVehicle ? ((_activeVehicle.sensorsPresentBits & Vehicle.SysStatusSensorLaserPosition) !== 0) : false
        property bool _rangefinderHealthy: _activeVehicle ? ((_activeVehicle.sensorsHealthBits  & Vehicle.SysStatusSensorLaserPosition) !== 0) : false
        property bool _rangefinderOk:      _rangefinderPresent && _rangefinderHealthy

        property Fact ntripEnabledFact: QGroundControl.settingsManager.ntripSettings.ntripServerConnectEnabled
        property bool showNtripON:  ntripEnabledFact.rawValue
        property bool showNtripOFF: !ntripEnabledFact.rawValue

        // Live NTRIP connection status (independent of the enable flag)
        property string ntripStatusText: {
            try {
                return NTRIPManager ? (NTRIPManager.ntripStatus || qsTr("Disconnected")) : qsTr("N/A")
            } catch (e) {
                return qsTr("Disconnected")
            }
        }
        property color ntripStatusColor: {
            try {
                if (!ntripEnabledFact.rawValue) return qgcPal.colorGrey
                if (!NTRIPManager) return qgcPal.text
                var lower = (NTRIPManager.ntripStatus || "").toLowerCase()
                if (lower.indexOf("error") !== -1 || lower.indexOf("failed") !== -1) return qgcPal.colorRed
                if (lower.indexOf("disconnected") !== -1) return qgcPal.colorOrange
                if (lower.indexOf("connecting")   !== -1) return qgcPal.colorOrange
                if (lower.indexOf("connected")    !== -1) return qgcPal.colorGreen
                return qgcPal.text
            } catch (e) {
                return qgcPal.text
            }
        }


        onRejected:{
            _guidedController.closeAll()
            close()
        }

        onAccepted: {
            if (acceptFunction) {
                close()
            }
        }

        GridLayout {
            id:                         configGrid
            anchors.margins:            _margins
            anchors.top:                parent.top
            anchors.horizontalCenter:   parent.horizontalCenter
            columns:                    4
            columnSpacing:              ScreenTools.defaultFontPixelWidth * 1.5
            rowSpacing:                 ScreenTools.defaultFontPixelHeight * 0.5

            // ---------------- Positioning ----------------
            QGCLabel {
                text:               qsTr("Positioning")
                font.bold:          true
                font.pointSize:     ScreenTools.smallFontPointSize
                color:              qgcPal.colorGrey
                Layout.columnSpan:  4
                Layout.topMargin:   ScreenTools.defaultFontPixelHeight * 0.25
            }

            // Position Source (segmented)
            QGCColoredImage {
                Layout.preferredWidth:  _iconSize
                Layout.preferredHeight: _iconSize
                Layout.alignment:       Qt.AlignVCenter
                sourceSize.width:       _iconSize
                fillMode:               Image.PreserveAspectFit
                source:                 "/res/position.svg"
                color:                  qgcPal.buttonText
            }
            QGCLabel {
                text:                   qsTr("Position source")
                font.bold:              true
                Layout.minimumWidth:    _labelColWidth
                Layout.alignment:       Qt.AlignVCenter
            }
            RowLayout {
                Layout.columnSpan:  2
                spacing:            ScreenTools.defaultFontPixelWidth
                QGCRadioButton {
                    text:           qsTr("GPS + Baro")
                    checked:        showOpflow
                    onClicked:      _activeVehicle.sendPositionAction(1)
                }
                QGCRadioButton {
                    text:           qsTr("Opflow + Baro")
                    checked:        showGPSposition
                    onClicked:      _activeVehicle.sendPositionAction(2)
                }
                QGCRadioButton {
                    text:           qsTr("Full GPS")
                    checked:        showAutoposition
                    onClicked:      _activeVehicle.sendPositionAction(3)
                }
            }

            // NTRIP (RTK) (toggle + live status)
            QGCColoredImage {
                Layout.preferredWidth:  _iconSize
                Layout.preferredHeight: _iconSize
                Layout.alignment:       Qt.AlignVCenter
                sourceSize.width:       _iconSize
                fillMode:               Image.PreserveAspectFit
                source:                 "/res/location.svg"
                color:                  ntripStatusColor
            }
            QGCLabel {
                text:                   qsTr("NTRIP (RTK)")
                font.bold:              true
                Layout.minimumWidth:    _labelColWidth
                Layout.alignment:       Qt.AlignVCenter
            }
            QGCSwitch {
                Layout.alignment:   Qt.AlignVCenter
                checked:            showNtripON
                onClicked:          ntripEnabledFact.rawValue = checked
            }
            QGCLabel {
                Layout.alignment:   Qt.AlignVCenter
                Layout.minimumWidth: _statusColWidth
                text:               ntripEnabledFact.rawValue ? ntripStatusText : qsTr("Off")
                color:              ntripStatusColor
            }

            // Surface Tracking (toggle)
            QGCColoredImage {
                Layout.preferredWidth:  _iconSize
                Layout.preferredHeight: _iconSize
                Layout.alignment:       Qt.AlignVCenter
                sourceSize.width:       _iconSize
                fillMode:               Image.PreserveAspectFit
                source:                 "/res/surface.svg"
                color:                  (!showSurfaceTracking || !_rangefinderOk) ? qgcPal.colorGrey :
                                        (QGroundControl.settingsManager.appSettings.surfaceTracking.value ? qgcPal.colorGreen : qgcPal.colorRed)
            }
            QGCLabel {
                text:                   qsTr("Surface tracking")
                font.bold:              true
                Layout.minimumWidth:    _labelColWidth
                Layout.alignment:       Qt.AlignVCenter
            }
            QGCSwitch {
                Layout.alignment:   Qt.AlignVCenter
                enabled:            showSurfaceTracking && _rangefinderOk
                checked:            QGroundControl.settingsManager.appSettings.surfaceTracking.value
                onClicked: {
                    QGroundControl.settingsManager.appSettings.surfaceTracking.value = checked
                    _activeVehicle.setSurfaceTracking(checked ? 1 : 0)
                }
            }
            QGCLabel {
                Layout.alignment:   Qt.AlignVCenter
                Layout.minimumWidth: _statusColWidth
                text:               !showSurfaceTracking ? qsTr("Not configured") :
                                    !_rangefinderPresent ? qsTr("No rangefinder") :
                                    !_rangefinderHealthy ? qsTr("Rangefinder fault") :
                                    (QGroundControl.settingsManager.appSettings.surfaceTracking.value ? qsTr("On") : qsTr("Off"))
                color:              (!showSurfaceTracking)                       ? qgcPal.colorGrey :
                                    (!_rangefinderOk)                            ? qgcPal.colorRed  :
                                    (QGroundControl.settingsManager.appSettings.surfaceTracking.value ? qgcPal.colorGreen : qgcPal.colorGrey)
            }

            // ---------------- Safety ----------------
            QGCLabel {
                text:               qsTr("Safety")
                font.bold:          true
                font.pointSize:     ScreenTools.smallFontPointSize
                color:              qgcPal.colorGrey
                Layout.columnSpan:  4
                Layout.topMargin:   ScreenTools.defaultFontPixelHeight * 0.4
            }

            // Landing Assistance (toggle)
            QGCColoredImage {
                Layout.preferredWidth:  _iconSize
                Layout.preferredHeight: _iconSize
                Layout.alignment:       Qt.AlignVCenter
                sourceSize.width:       _iconSize
                fillMode:               Image.PreserveAspectFit
                source:                 "/res/landing_assist.svg"
                color:                  !_rangefinderOk ? qgcPal.colorGrey :
                                        (showLandingAssistON ? qgcPal.colorGreen : qgcPal.colorRed)
            }
            QGCLabel {
                text:                   qsTr("Landing assistance")
                font.bold:              true
                Layout.minimumWidth:    _labelColWidth
                Layout.alignment:       Qt.AlignVCenter
            }
            QGCSwitch {
                Layout.alignment:   Qt.AlignVCenter
                enabled:            _rangefinderOk
                checked:            showLandingAssistON
                onClicked:          _activeVehicle.sendLandingAssistAction(checked ? 1 : 0)
            }
            QGCLabel {
                Layout.alignment:   Qt.AlignVCenter
                Layout.minimumWidth: _statusColWidth
                text:               !_rangefinderPresent ? qsTr("No rangefinder") :
                                    !_rangefinderHealthy ? qsTr("Rangefinder fault") :
                                    (showLandingAssistON ? qsTr("On") : qsTr("Off"))
                color:              !_rangefinderOk ? qgcPal.colorRed :
                                    (showLandingAssistON ? qgcPal.colorGreen : qgcPal.colorGrey)
            }

            // Obstacle Avoidance (toggle)
            QGCColoredImage {
                Layout.preferredWidth:  _iconSize
                Layout.preferredHeight: _iconSize
                Layout.alignment:       Qt.AlignVCenter
                sourceSize.width:       _iconSize
                fillMode:               Image.PreserveAspectFit
                source:                 "/res/avoidance.svg"
                color:                  !showProximityAvoidance ? qgcPal.colorGrey :
                                        (QGroundControl.settingsManager.appSettings.proximityAvoidance.value ? qgcPal.colorGreen : qgcPal.colorRed)
            }
            QGCLabel {
                text:                   qsTr("Obstacle avoidance")
                font.bold:              true
                Layout.minimumWidth:    _labelColWidth
                Layout.alignment:       Qt.AlignVCenter
            }
            QGCSwitch {
                Layout.alignment:   Qt.AlignVCenter
                enabled:            showProximityAvoidance
                checked:            QGroundControl.settingsManager.appSettings.proximityAvoidance.value
                onClicked: {
                    QGroundControl.settingsManager.appSettings.proximityAvoidance.value = checked
                    _activeVehicle.setProximityAvoidance(checked ? 1 : 0)
                }
            }
            QGCLabel {
                Layout.alignment:   Qt.AlignVCenter
                Layout.minimumWidth: _statusColWidth
                text:               !showProximityAvoidance ? qsTr("Not available") :
                                    (QGroundControl.settingsManager.appSettings.proximityAvoidance.value ? qsTr("On") : qsTr("Off"))
                color:              !showProximityAvoidance ? qgcPal.colorGrey :
                                    (QGroundControl.settingsManager.appSettings.proximityAvoidance.value ? qgcPal.colorGreen : qgcPal.colorGrey)
            }

            // ---------------- Lights · Home · Correction ----------------
            QGCLabel {
                text:               qsTr("Lights · Home")
                font.bold:          true
                font.pointSize:     ScreenTools.smallFontPointSize
                color:              qgcPal.colorGrey
                Layout.columnSpan:  4
                Layout.topMargin:   ScreenTools.defaultFontPixelHeight * 0.4
            }

            // Strobe Lights (toggle)
            QGCColoredImage {
                Layout.preferredWidth:  _iconSize
                Layout.preferredHeight: _iconSize
                Layout.alignment:       Qt.AlignVCenter
                sourceSize.width:       _iconSize
                fillMode:               Image.PreserveAspectFit
                source:                 "/res/illumination.svg"
                color:                  !landingLightAvailable ? qgcPal.colorGrey :
                                        (showLandingLightON ? qgcPal.colorGreen : qgcPal.colorRed)
            }
            QGCLabel {
                text:                   qsTr("Strobe lights")
                font.bold:              true
                Layout.minimumWidth:    _labelColWidth
                Layout.alignment:       Qt.AlignVCenter
            }
            QGCSwitch {
                Layout.alignment:   Qt.AlignVCenter
                enabled:            landingLightAvailable
                checked:            showLandingLightON
                onClicked:          _activeVehicle.setStrobeLight(checked ? 1 : 0)
            }
            QGCLabel {
                Layout.alignment:   Qt.AlignVCenter
                Layout.minimumWidth: _statusColWidth
                text:               !landingLightAvailable ? qsTr("Not available") :
                                    (showLandingLightON ? qsTr("On") : qsTr("Off"))
                color:              !landingLightAvailable ? qgcPal.colorGrey :
                                    (showLandingLightON ? qgcPal.colorGreen : qgcPal.colorGrey)
            }

            // Home Position (segmented)
            QGCColoredImage {
                Layout.preferredWidth:  _iconSize
                Layout.preferredHeight: _iconSize
                Layout.alignment:       Qt.AlignVCenter
                sourceSize.width:       _iconSize
                fillMode:               Image.PreserveAspectFit
                source:                 "/res/home.svg"
                color:                  qgcPal.buttonText
            }
            QGCLabel {
                text:                   qsTr("Home position")
                font.bold:              true
                Layout.minimumWidth:    _labelColWidth
                Layout.alignment:       Qt.AlignVCenter
            }
            RowLayout {
                Layout.columnSpan:  2
                spacing:            ScreenTools.defaultFontPixelWidth
                QGCRadioButton {
                    text:           qsTr("Default")
                    checked:        !QGroundControl.settingsManager.flyViewSettings.updateHomePosition.value
                    onClicked:      QGroundControl.settingsManager.flyViewSettings.updateHomePosition.value = false
                }
                QGCRadioButton {
                    text:           qsTr("Follow GCS")
                    checked:        QGroundControl.settingsManager.flyViewSettings.updateHomePosition.value
                    onClicked:      QGroundControl.settingsManager.flyViewSettings.updateHomePosition.value = true
                }
            }
        }
    }
}

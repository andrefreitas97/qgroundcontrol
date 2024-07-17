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
        title: "Configure vehicle:"
        property var  acceptFunction:     null
        buttons:  StandardButton.Close

        property var    _activeVehicle:             QGroundControl.multiVehicleManager.activeVehicle

        property bool  _initialConnectComplete: _activeVehicle ? _activeVehicle.initialConnectComplete : false
        property bool  _isVehicleArmed:         _initialConnectComplete ? _activeVehicle.armed : false

        FactPanelController { id: controller }
        property Fact param1: controller.getParameterFact(-1, "EK3_SRC_OPTIONS")
        property Fact param2: controller.getParameterFact(-1, "EK3_SRC2_VELXY")
        property bool showGPSposition: param1.value == 0 && param2.value == 0

        property Fact param3: controller.getParameterFact(-1, "EK3_SRC_OPTIONS")
        property Fact param4: controller.getParameterFact(-1, "EK3_SRC2_VELXY")
        property bool showOpflow: param3.value == 1 && param4.value == 5

        property Fact param5: controller.getParameterFact(-1, "EK3_SRC1_POSZ")
        property bool showGPSheight: param5.value == 3

        property Fact param6: controller.getParameterFact(-1, "EK3_SRC1_POSZ")
        property bool showBaro: param6.value == 1

        property Fact param7: controller.getParameterFact(-1, "SCR_USER1")
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


        onRejected:{
            _guidedController.closeAll()
            close()
        }

        onAccepted: {
            if (acceptFunction) {
                close()
            }
        }

        ColumnLayout{
        id:                         colLayout
        anchors.margins:            _margins
        anchors.top:                parent.top
        anchors.horizontalCenter:   parent.horizontalCenter
        spacing:                    ScreenTools.defaultFontPixelHeight / 2

            Row {
                Layout.alignment:   Qt.AlignLeft
                spacing:            ScreenTools.defaultFontPixelWidth

                QGCColoredImage {
                    anchors.top:        parent.top
                    anchors.bottom:     parent.bottom
                    width:              height
                    sourceSize.width:   width
                    source:             "/res/position.svg"
                    color:              qgcPal.buttonText
                }

                QGCLabel {
                    text:       qsTr("Speed Mode:")
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold:              true
                }

                QGCRadioButton {
                    font.pointSize: ScreenTools.defaultFontPointSize
                    text:           qsTr("Cine")
                    enabled:        QGroundControl.settingsManager.appSettings.vehiclebravo.value && _activeVehicle.flightMode == "Loiter"
                    checked:        showSlow
                    onClicked:      _activeVehicle.setSpeedMode(1)
                }

                QGCRadioButton {
                    font.pointSize: ScreenTools.defaultFontPointSize
                    text:           qsTr("Normal")
                    enabled:        QGroundControl.settingsManager.appSettings.vehiclebravo.value && _activeVehicle.flightMode == "Loiter"
                    checked:        showNormal
                    onClicked:      _activeVehicle.setSpeedMode(2)
                }

                QGCRadioButton {
                    font.pointSize: ScreenTools.defaultFontPointSize
                    text:           qsTr("Sport")
                    enabled:        QGroundControl.settingsManager.appSettings.vehiclebravo.value && _activeVehicle.flightMode == "Loiter"
                    checked:        showFast
                    onClicked:      _activeVehicle.setSpeedMode(3)
                }

            }

            Row {
                Layout.alignment:   Qt.AlignLeft
                spacing:            ScreenTools.defaultFontPixelWidth

                QGCColoredImage {
                    anchors.top:        parent.top
                    anchors.bottom:     parent.bottom
                    width:              height
                    sourceSize.width:   width
                    source:             "/res/position.svg"
                    color:              qgcPal.buttonText
                }

                QGCLabel {
                    text:       qsTr("Horizontal Position Source:")
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold:              true
                }

                QGCRadioButton {
                    font.pointSize: ScreenTools.defaultFontPointSize
                    text:           qsTr("Opflow + GPS")
                    enabled:        QGroundControl.settingsManager.appSettings.vehiclebravo.value && !QGroundControl.settingsManager.appSettings.payloadgripper.value
                    checked:        showOpflow
                    onClicked:      _activeVehicle.sendPositionAction(0)
                }

                QGCRadioButton {
                    font.pointSize: ScreenTools.defaultFontPointSize
                    text:           qsTr("GPS")
                    enabled:        QGroundControl.settingsManager.appSettings.vehiclebravo.value && !QGroundControl.settingsManager.appSettings.payloadgripper.value
                    checked:        showGPSposition
                    onClicked:      _activeVehicle.sendPositionAction(1)
                }

            }

            Row {
                Layout.alignment:   Qt.AlignLeft
                spacing:            ScreenTools.defaultFontPixelWidth

                QGCColoredImage {
                    anchors.top:        parent.top
                    anchors.bottom:     parent.bottom
                    width:              height
                    sourceSize.width:   width
                    source:             "/res/Height.svg"
                    color:              qgcPal.buttonText
                }

                QGCLabel {
                    text:       qsTr("Vertical Position Source:")
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold:              true
                }

                QGCRadioButton {
                    font.pointSize: ScreenTools.defaultFontPointSize
                    text:           qsTr("Baro")
                    enabled:        QGroundControl.settingsManager.appSettings.vehiclebravo.value
                    checked:        showBaro
                    onClicked:      _activeVehicle.sendHeightAction(0)

                }

                QGCRadioButton {
                    font.pointSize: ScreenTools.defaultFontPointSize
                    text:           qsTr("GPS")
                    enabled:        QGroundControl.settingsManager.appSettings.vehiclebravo.value
                    checked:        showGPSheight
                    onClicked:      _activeVehicle.sendHeightAction(1)
                }

            }

            Row {
                Layout.alignment:   Qt.AlignLeft
                spacing:            ScreenTools.defaultFontPixelWidth

                QGCColoredImage {
                    anchors.top:        parent.top
                    anchors.bottom:     parent.bottom
                    width:              height
                    sourceSize.width:   width
                    source:             "/res/landing_assist.svg"
                    color:              showLandingAssistON ? qgcPal.colorGreen : qgcPal.colorRed
                }

                QGCLabel {
                    text:       qsTr("Landing Assistance:")
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold:              true
                }

                QGCRadioButton {
                    font.pointSize: ScreenTools.defaultFontPointSize
                    text:           qsTr("ON")
                    enabled:        QGroundControl.settingsManager.appSettings.vehiclebravo.value
                    checked:        showLandingAssistON
                    onClicked:      _activeVehicle.sendLandingAssistAction(1)

                }

                QGCRadioButton {
                    font.pointSize: ScreenTools.defaultFontPointSize
                    text:           qsTr("OFF")
                    enabled:        QGroundControl.settingsManager.appSettings.vehiclebravo.value
                    checked:        showLandingAssistOFF
                    onClicked:      _activeVehicle.sendLandingAssistAction(0)
                }

            }

            Row {
                Layout.alignment:   Qt.AlignLeft
                spacing:            ScreenTools.defaultFontPixelWidth

                QGCColoredImage {
                    anchors.top:        parent.top
                    anchors.bottom:     parent.bottom
                    width:              height
                    sourceSize.width:   width
                    source:             "/res/surface.svg"
                    color:              QGroundControl.settingsManager.appSettings.surfaceTracking.value ? qgcPal.colorGreen : qgcPal.colorRed
                }

                QGCLabel {
                    text:       qsTr("Surface Tracking:")
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold:              true
                }

                QGCRadioButton {
                    font.pointSize: ScreenTools.defaultFontPointSize
                    text:           qsTr("ON")
                    enabled: showSurfaceTracking
                    checked:        QGroundControl.settingsManager.appSettings.surfaceTracking.value
                    onClicked:{
                        QGroundControl.settingsManager.appSettings.surfaceTracking.value = true
                        _activeVehicle.setSurfaceTracking(1)
                    }
                }

                QGCRadioButton {
                    font.pointSize: ScreenTools.defaultFontPointSize
                    text:           qsTr("OFF")
                    enabled: showSurfaceTracking
                    checked:        !QGroundControl.settingsManager.appSettings.surfaceTracking.value
                    onClicked:{
                        QGroundControl.settingsManager.appSettings.surfaceTracking.value = false
                        _activeVehicle.setSurfaceTracking(0)
                    }
                }
            }

            Row {
                Layout.alignment:   Qt.AlignLeft
                spacing:            ScreenTools.defaultFontPixelWidth

                QGCColoredImage {
                    anchors.top:        parent.top
                    anchors.bottom:     parent.bottom
                    width:              height
                    sourceSize.width:   width
                    source:             "/res/home.svg"
                    color:              qgcPal.buttonText
                }

                QGCLabel {
                    text:       qsTr("Home Position Behaviour:")
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold:              true
                }

                QGCRadioButton {
                    font.pointSize: ScreenTools.defaultFontPointSize
                    text:           qsTr("Default")
                    checked:        !QGroundControl.settingsManager.flyViewSettings.updateHomePosition.value
                    onClicked:      QGroundControl.settingsManager.flyViewSettings.updateHomePosition.value = false

                }

                QGCRadioButton {
                    font.pointSize: ScreenTools.defaultFontPointSize
                    text:           qsTr("Follow GCS")
                    checked:        QGroundControl.settingsManager.flyViewSettings.updateHomePosition.value
                    onClicked:      QGroundControl.settingsManager.flyViewSettings.updateHomePosition.value = true
                }

            }

            Row {
                Layout.alignment:   Qt.AlignLeft
                spacing:            ScreenTools.defaultFontPixelWidth

                QGCColoredImage {
                    anchors.top:        parent.top
                    anchors.bottom:     parent.bottom
                    width:              height
                    sourceSize.width:   width
                    source:             "/res/avoidance.svg"
                    color:              QGroundControl.settingsManager.appSettings.proximityAvoidance.value ? qgcPal.colorGreen : qgcPal.colorRed
                }

                QGCLabel {
                    text:       qsTr("Obstacle Avoidance:")
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold:              true
                }

                QGCRadioButton {
                    font.pointSize: ScreenTools.defaultFontPointSize
                    text:           qsTr("ON")
                    enabled: showProximityAvoidance
                    checked:        QGroundControl.settingsManager.appSettings.proximityAvoidance.value
                    onClicked:{
                        QGroundControl.settingsManager.appSettings.proximityAvoidance.value = true
                        _activeVehicle.setProximityAvoidance(1)
                    }
                }

                QGCRadioButton {
                    font.pointSize: ScreenTools.defaultFontPointSize
                    text:           qsTr("OFF")
                    enabled: showProximityAvoidance
                    checked:        !QGroundControl.settingsManager.appSettings.proximityAvoidance.value
                    onClicked:{
                        QGroundControl.settingsManager.appSettings.proximityAvoidance.value = false
                        _activeVehicle.setProximityAvoidance(0)
                    }
                }
            }

        }
    }
}

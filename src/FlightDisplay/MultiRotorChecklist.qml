/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                      2.11
import QtQuick.Controls             2.4
import QtQml.Models                 2.1

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controls      1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.Vehicle       1.0

Item {
    property var model: listModel
    PreFlightCheckModel {
        id:     listModel
        PreFlightCheckGroup {
            name: qsTr("Airframe")

            PreFlightCheckButton {
                name:           qsTr("Aircraft Integrity")
                manualText:     qsTr("No cracks, loose screws, or missing fasteners?")
            }

            PreFlightCheckButton {
                name:           qsTr("Propellers")
                manualText:     qsTr("Open and not loose?")
            }

            PreFlightCheckButton {
                name:           qsTr("Motors")
                manualText:     qsTr("Spin freely, no unusual play, no dirt or resistance?")
            }

            PreFlightCheckButton {
                name:           qsTr("Arms")
                manualText:     qsTr("Open and Locked?")
            }

            PreFlightCheckButton {
                name:           qsTr("Landing Gear")
                manualText:     qsTr("Locked and Secured?")
            }

            PreFlightCheckButton {
                name:           qsTr("Antennas")
                manualText:     qsTr("Firmly attached and oriented correctly?")
            }

            PreFlightCheckButton {
                name:           qsTr("Connectors")
                manualText:     qsTr("No visible loose connectors?")
            }
            
        }

        PreFlightCheckGroup {
            name: qsTr("Environment")

            PreFlightCheckButton {
                name:           qsTr("Weather")
                manualText:     qsTr("Wind under limits? No precipitation? Good visibility? Temperature within specs?")
            }

            PreFlightCheckButton {
                name:           qsTr("Launch area")
                manualText:     qsTr("Free of obstacles/people?")
            }

            PreFlightCheckButton {
                name:           qsTr("Flight area")
                manualText:     qsTr("Aware of flight path obstacles?")
            }
        }

        PreFlightCheckGroup {
            name: qsTr("RC controller")
            

            PreFlightRCCheck {
            }

            PreFlightCheckButton {
                name:           qsTr("Controller Battery Level")
                manualText:     qsTr("Enough for operation?")
            }

            PreFlightCheckButton {
                name:           qsTr("Sticks and switches")
                manualText:     qsTr("Operational?")
            }

            PreFlightSoundCheck {
                allowOverrideSound:    true
            }
        }

        PreFlightCheckGroup {
            name: qsTr("Power")

            PreFlightBatteryCheck {
                failurePercent:                 40
                allowFailurePercentOverride:    true
            }

            PreFlightCheckButton {
                name:           qsTr("Battery Integrity")
                manualText:     qsTr("No swelling or damage?")
            }

            PreFlightCheckButton {
                name:           qsTr("Battery latch")
                manualText:     qsTr("Properly seated and locked?")
            }


        }

        PreFlightCheckGroup {
            name: qsTr("Electronics")

            PreFlightSensorsHealthCheck {
            }

            PreFlightGPSCheck {
                failureSatCount:        9
                allowOverrideSatCount:  true
            }

            PreFlightCheckButton {
                name:           qsTr("FPV Camera")
                manualText:     qsTr("Video available and no lag?")
            }

            PreFlightCheckButton {
                name:           qsTr("Compass interference")
                manualText:     qsTr("No large metalic object/structure within 5-10m?")
            }
            
        }

        PreFlightCheckGroup {
            name: qsTr("Emergency Plan")

            PreFlightCheckButton {
                name:           qsTr("RTL")
                manualText:     qsTr("Altitude appropriate for terrain and path clear?")
            }

            PreFlightCheckButton {
                name:           qsTr("Failsafe")
                manualText:     qsTr("Failsafe actions checked?")
            }

            PreFlightCheckButton {
                name:           qsTr("Alternative landing area")
                manualText:     qsTr("Defined and planned?")
            }

        }

        PreFlightCheckGroup {
            name: qsTr("Camera Payload")
            visible: QGroundControl.settingsManager.appSettings.gimbalCameraA8.value || QGroundControl.settingsManager.appSettings.gimbalCameraZT6.value

            PreFlightCheckButton {
                name:           qsTr("Mount")
                manualText:     qsTr("Mounted securely?")
            }

            PreFlightCheckButton {
                name:           qsTr("Connection")
                manualText:     qsTr("Controls working properly?")
            }

            PreFlightCheckButton {
                name:           qsTr("Video")
                manualText:     qsTr("Available with no lag?")
            }
            
        }

        PreFlightCheckGroup {
            name: qsTr("Tactical Payload")
            visible: QGroundControl.settingsManager.appSettings.payloadgripper.value || QGroundControl.settingsManager.appSettings.payloadgrenades.value || QGroundControl.settingsManager.appSettings.gimbalCameraZIO.value

            PreFlightCheckButton {
                name:           qsTr("Mount")
                manualText:     qsTr("Mounted securely?")
            }

            PreFlightCheckButton {
                name:           qsTr("Connection")
                manualText:     qsTr("Controls working properly?")
            }

            PreFlightCheckButton {
                name:           qsTr("Collision")
                manualText:     qsTr("Payload clear from propeller contact?")
            }
            
        }
    }
}


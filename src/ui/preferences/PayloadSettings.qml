/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick                  2.3
import QtQuick.Controls         2.4
import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs          1.2
import QtQuick.Layouts          1.2

import QGroundControl                       1.0
import QGroundControl.FactSystem            1.0
import QGroundControl.FactControls          1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.Palette               1.0
import QGroundControl.Controllers           1.0
import QGroundControl.SettingsManager       1.0

Rectangle {
    id:                 _root
    color:              qgcPal.window
    anchors.fill:       parent
    anchors.margins:    ScreenTools.defaultFontPixelWidth

    property real   _labelWidth:                ScreenTools.defaultFontPixelWidth * 20
    property real   _comboFieldWidth:           ScreenTools.defaultFontPixelWidth * 30
    property real   _valueFieldWidth:           ScreenTools.defaultFontPixelWidth * 10
    property real   _panelWidth:                _root.width * _internalWidthRatio
    property real   _margins:                   ScreenTools.defaultFontPixelWidth

    property var    _activeVehicle:             QGroundControl.multiVehicleManager.activeVehicle
    property bool   _vehicleArmed:              _activeVehicle ? _activeVehicle.armed : false

    readonly property real _internalWidthRatio: 0.8

    QGCPalette { id: qgcPal }

    QGCFlickable {
        clip:               true
        anchors.fill:       parent
        contentHeight:      outerItem.height
        contentWidth:       outerItem.width

        Item {
            id:     outerItem
            width:  Math.max(_root.width, settingsColumn.width)
            height: settingsColumn.height

            ColumnLayout {
                id:                         settingsColumn
                anchors.horizontalCenter:   parent.horizontalCenter

                Item { width: 1; height: _margins; visible: payloadSectionLabel.visible }
                QGCLabel {
                    id:         payloadSectionLabel
                    text:       qsTr("Payload")
                    visible:    QGroundControl.settingsManager.flyViewSettings.visible
                }
                Rectangle {
                    Layout.preferredHeight: payloadGrid.height + (_margins * 2)
                    Layout.preferredWidth:  payloadGrid.width + (_margins * 2)
                    color:                  qgcPal.windowShade
                    visible:                payloadSectionLabel.visible
                    Layout.fillWidth:       true

                     GridLayout {
                        id:                         payloadGrid
                        anchors.topMargin:          _margins
                        anchors.top:                parent.top
                        Layout.fillWidth:           true
                        anchors.horizontalCenter:   parent.horizontalCenter
                        columns:                    3

                         QGCLabel {
                            text:               qsTr("No vehicle connected.")
                            Layout.columnSpan:  3
                            Layout.alignment:   Qt.AlignHCenter
                            visible: !_activeVehicle
                        }

                         QGCLabel {
                            text:               qsTr("No payloads available for Alfa.")
                            Layout.columnSpan:  3
                            Layout.alignment:   Qt.AlignHCenter
                            visible: QGroundControl.settingsManager.appSettings.vehiclealfa.value && _activeVehicle
                        }


                          QGCLabel {
                            text:               qsTr("Front Payload")
                            Layout.columnSpan:  3
                            Layout.alignment:   Qt.AlignHCenter
                            visible:            QGroundControl.settingsManager.appSettings.vehiclebravo.value && _activeVehicle
                        }


                          ButtonGroup {
                            id: frontPayloadGroup
                            exclusive: true  // Ensures only one button is selected at a time
                        }

                         QGCRadioButton {
                            text:               qsTr("Gimbal Camera A8")
                            visible:            QGroundControl.settingsManager.appSettings.vehiclebravo.value && _activeVehicle
                            enabled:            !_vehicleArmed
                            checked:            QGroundControl.settingsManager.appSettings.gimbalCameraA8.value
                            onClicked:{
                                if(QGroundControl.settingsManager.appSettings.gimbalCameraA8.value){
                                    QGroundControl.settingsManager.appSettings.gimbalCameraA8.value = false
                                    QGroundControl.settingsManager.videoSettings.rtspUrl.value = QGroundControl.settingsManager.videoSettings.rtspUrlFPV.value
                                    QGroundControl.multiVehicleManager.activeVehicle.sendSetMountFPVAction()
                                    QGroundControl.multiVehicleManager.activeVehicle.sendDisableMountA8Action()
                                }else {
                                    QGroundControl.settingsManager.appSettings.gimbalCameraA8.value = true
                                    QGroundControl.settingsManager.appSettings.gimbalCameraZT6.value = false
                                    QGroundControl.multiVehicleManager.activeVehicle.sendEnableMountA8Action()
                                }
                            }
                            Layout.columnSpan:  3
                            ButtonGroup.group: frontPayloadGroup  // Assign to the ButtonGroup
                        }

                         QGCRadioButton {
                            text:               qsTr("Gimbal Camera ZT6")
                            visible:            QGroundControl.settingsManager.appSettings.vehiclebravo.value && _activeVehicle
                            enabled:            !_vehicleArmed
                            checked:            QGroundControl.settingsManager.appSettings.gimbalCameraZT6.value
                            onClicked:{
                                if(QGroundControl.settingsManager.appSettings.gimbalCameraZT6.value){
                                    QGroundControl.settingsManager.appSettings.gimbalCameraZT6.value = false
                                    QGroundControl.settingsManager.videoSettings.rtspUrl.value = QGroundControl.settingsManager.videoSettings.rtspUrlFPV.value
                                    QGroundControl.multiVehicleManager.activeVehicle.sendSetMountFPVAction()
                                    QGroundControl.multiVehicleManager.activeVehicle.sendDisableMountZT6Action()
                                }else {
                                    QGroundControl.settingsManager.appSettings.gimbalCameraZT6.value = true
                                    QGroundControl.settingsManager.appSettings.gimbalCameraA8.value = false
                                    QGroundControl.multiVehicleManager.activeVehicle.sendEnableMountZT6Action()
                                }
                            }
                            Layout.columnSpan:  3
                            ButtonGroup.group: frontPayloadGroup  // Assign to the ButtonGroup
                        }


                          QGCLabel {
                            text:               qsTr("Rear Payload")
                            Layout.columnSpan:  3
                            Layout.alignment:   Qt.AlignHCenter
                            visible:            QGroundControl.settingsManager.appSettings.vehiclebravo.value && _activeVehicle
                        }

                         ButtonGroup {
                            id: rearPayloadGroup
                            exclusive: true  // Ensures only one button is selected at a time
                        }


                          QGCRadioButton {
                            text:               qsTr("Gripper")
                            visible:            QGroundControl.settingsManager.appSettings.vehiclebravo.value && _activeVehicle
                            enabled:            !_vehicleArmed
                            checked:            QGroundControl.settingsManager.appSettings.payloadgripper.value === true
                            onClicked:{
                                if(QGroundControl.settingsManager.appSettings.payloadgripper.value){
                                    QGroundControl.settingsManager.appSettings.payloadgripper.value = false
                                }else {
                                    QGroundControl.settingsManager.appSettings.payloadgripper.value = true
                                    QGroundControl.settingsManager.appSettings.payloadgrenades.value = false
                                    QGroundControl.multiVehicleManager.activeVehicle.setPayloadType(0)

                                     QGroundControl.multiVehicleManager.activeVehicle.sendPositionAction(1)

                                     QGroundControl.settingsManager.appSettings.gimbalCameraZIO.value = false
                                    QGroundControl.settingsManager.videoSettings.rtspUrl.value = QGroundControl.settingsManager.videoSettings.rtspUrlFPV.value
                                    QGroundControl.multiVehicleManager.activeVehicle.sendSetMountFPVAction()
                                    //QGroundControl.multiVehicleManager.activeVehicle.sendDisableMountZIOAction()
                                }

                             }
                            Layout.columnSpan:  3
                            ButtonGroup.group: rearPayloadGroup  // Assign to the ButtonGroup
                        }

                         QGCRadioButton {
                            text:               qsTr("Grenade Dropper")
                            visible:            QGroundControl.settingsManager.appSettings.vehiclebravo.value && _activeVehicle
                            enabled:            !_vehicleArmed
                            checked:            QGroundControl.settingsManager.appSettings.payloadgrenades.value === true
                            onClicked:{
                                if(QGroundControl.settingsManager.appSettings.payloadgrenades.value){
                                    QGroundControl.settingsManager.appSettings.payloadgrenades.value = false
                                }else {
                                    QGroundControl.settingsManager.appSettings.payloadgrenades.value = true
                                    QGroundControl.settingsManager.appSettings.payloadgripper.value = false
                                    QGroundControl.multiVehicleManager.activeVehicle.setPayloadType(1)

                                     QGroundControl.settingsManager.appSettings.gimbalCameraZIO.value = false
                                    QGroundControl.settingsManager.videoSettings.rtspUrl.value = QGroundControl.settingsManager.videoSettings.rtspUrlFPV.value
                                    QGroundControl.multiVehicleManager.activeVehicle.sendSetMountFPVAction()
                                    //QGroundControl.multiVehicleManager.activeVehicle.sendDisableMountZIOAction()
                                }
                            }
                            Layout.columnSpan:  3
                            ButtonGroup.group: rearPayloadGroup  // Assign to the ButtonGroup
                        }

                         QGCRadioButton {
                            text:               qsTr("Gimbal Camera ZIO")
                            visible:            QGroundControl.settingsManager.appSettings.vehiclebravo.value && _activeVehicle
                            enabled:            !_vehicleArmed
                            checked:            QGroundControl.settingsManager.appSettings.gimbalCameraZIO.value
                            onClicked:{
                                if(QGroundControl.settingsManager.appSettings.gimbalCameraZIO.value){
                                    QGroundControl.settingsManager.appSettings.gimbalCameraZIO.value = false
                                    QGroundControl.settingsManager.videoSettings.rtspUrl.value = QGroundControl.settingsManager.videoSettings.rtspUrlFPV.value
                                    QGroundControl.multiVehicleManager.activeVehicle.sendSetMountFPVAction()
                                    //QGroundControl.multiVehicleManager.activeVehicle.sendDisableMountZIOAction()
                                }else {
                                    QGroundControl.settingsManager.appSettings.gimbalCameraZIO.value = true
                                    //QGroundControl.multiVehicleManager.activeVehicle.sendEnableMountZIOAction()

                                     QGroundControl.settingsManager.appSettings.payloadgripper.value = false
                                    QGroundControl.settingsManager.appSettings.payloadgrenades.value = false
                                }
                            }
                            Layout.columnSpan:  3
                            ButtonGroup.group: rearPayloadGroup  // Assign to the ButtonGroup
                        }

                         QGCLabel {
                            text:               qsTr("Note: Reboot vehicle after change of payload.")
                            Layout.columnSpan:  3
                            Layout.alignment:   Qt.AlignHCenter
                            font.pointSize:     ScreenTools.smallFontPointSize
                            visible: QGroundControl.settingsManager.appSettings.vehiclebravo.value && _activeVehicle
                        }

                         QGCButton {
                            text:       qsTr("Reboot Vehicle")
                            enabled: _activeVehicle && !_vehicleArmed
                            Layout.columnSpan:  3
                            Layout.alignment: Qt.AlignHCenter
                            onClicked: {
                                mainWindow.showMessageDialog(qsTr("Reboot Vehicle"),
                                                             qsTr("Select Ok to reboot vehicle."),
                                                             Dialog.Cancel | Dialog.Ok,
                                                             function() { _activeVehicle.rebootVehicle() })
                            }
                        }
                    }
                }
            } // settingsColumn
        }
    }
}

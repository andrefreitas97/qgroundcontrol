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

                Item { width: 1; height: _margins; visible: rtkSectionLabel.visible }
                QGCLabel {
                    id:         rtkSectionLabel
                    text:       qsTr("RTK (Fixed Base)")
                    visible:    QGroundControl.settingsManager.rtkSettings.visible
                }
                Rectangle {
                    Layout.preferredHeight: rtkGrid.height + (_margins * 2)
                    Layout.preferredWidth:  rtkGrid.width + (_margins * 2)
                    color:                  qgcPal.windowShade
                    visible:                rtkSectionLabel.visible
                    Layout.fillWidth:       true

                    GridLayout {
                        id:                         rtkGrid
                        anchors.topMargin:          _margins
                        anchors.top:                parent.top
                        Layout.fillWidth:           true
                        anchors.horizontalCenter:   parent.horizontalCenter
                        columns:                    3

                        property var  rtkSettings:      QGroundControl.settingsManager.rtkSettings
                        property bool useFixedPosition: rtkSettings.useFixedBasePosition.rawValue
                        property real firstColWidth:    ScreenTools.defaultFontPixelWidth * 3

                        QGCRadioButton {
                            text:               qsTr("Perform Survey-In")
                            visible:            rtkGrid.rtkSettings.useFixedBasePosition.visible
                            checked:            rtkGrid.rtkSettings.useFixedBasePosition.value === false
                            Layout.columnSpan:  3
                            onClicked:          rtkGrid.rtkSettings.useFixedBasePosition.value = false
                        }

                        Item { width: rtkGrid.firstColWidth; height: 1 }
                        QGCLabel {
                            text:               rtkGrid.rtkSettings.surveyInAccuracyLimit.shortDescription
                            visible:            rtkGrid.rtkSettings.surveyInAccuracyLimit.visible
                            enabled:            !rtkGrid.useFixedPosition
                        }
                        FactTextField {
                            fact:               rtkGrid.rtkSettings.surveyInAccuracyLimit
                            visible:            rtkGrid.rtkSettings.surveyInAccuracyLimit.visible
                            enabled:            !rtkGrid.useFixedPosition
                            Layout.preferredWidth:  _valueFieldWidth
                        }

                        Item { width: rtkGrid.firstColWidth; height: 1 }
                        QGCLabel {
                            text:               rtkGrid.rtkSettings.surveyInMinObservationDuration.shortDescription
                            visible:            rtkGrid.rtkSettings.surveyInMinObservationDuration.visible
                            enabled:            !rtkGrid.useFixedPosition
                        }
                        FactTextField {
                            fact:               rtkGrid.rtkSettings.surveyInMinObservationDuration
                            visible:            rtkGrid.rtkSettings.surveyInMinObservationDuration.visible
                            enabled:            !rtkGrid.useFixedPosition
                            Layout.preferredWidth:  _valueFieldWidth
                        }

                        QGCRadioButton {
                            text:               qsTr("Use Specified Base Position")
                            visible:            rtkGrid.rtkSettings.useFixedBasePosition.visible
                            checked:            rtkGrid.rtkSettings.useFixedBasePosition.value === true
                            onClicked:          rtkGrid.rtkSettings.useFixedBasePosition.value = true
                            Layout.columnSpan:  3
                        }

                        Item { width: rtkGrid.firstColWidth; height: 1 }
                        QGCLabel {
                            text:               rtkGrid.rtkSettings.fixedBasePositionLatitude.shortDescription
                            visible:            rtkGrid.rtkSettings.fixedBasePositionLatitude.visible
                            enabled:            rtkGrid.useFixedPosition
                        }
                        FactTextField {
                            fact:               rtkGrid.rtkSettings.fixedBasePositionLatitude
                            visible:            rtkGrid.rtkSettings.fixedBasePositionLatitude.visible
                            enabled:            rtkGrid.useFixedPosition
                            Layout.fillWidth:   true
                        }

                        Item { width: rtkGrid.firstColWidth; height: 1 }
                        QGCLabel {
                            text:               rtkGrid.rtkSettings.fixedBasePositionLongitude.shortDescription
                            visible:            rtkGrid.rtkSettings.fixedBasePositionLongitude.visible
                            enabled:            rtkGrid.useFixedPosition
                        }
                        FactTextField {
                            fact:               rtkGrid.rtkSettings.fixedBasePositionLongitude
                            visible:            rtkGrid.rtkSettings.fixedBasePositionLongitude.visible
                            enabled:            rtkGrid.useFixedPosition
                            Layout.fillWidth:   true
                        }

                        Item { width: rtkGrid.firstColWidth; height: 1 }
                        QGCLabel {
                            text:           rtkGrid.rtkSettings.fixedBasePositionAltitude.shortDescription
                            visible:        rtkGrid.rtkSettings.fixedBasePositionAltitude.visible
                            enabled:        rtkGrid.useFixedPosition
                        }
                        FactTextField {
                            fact:               rtkGrid.rtkSettings.fixedBasePositionAltitude
                            visible:            rtkGrid.rtkSettings.fixedBasePositionAltitude.visible
                            enabled:            rtkGrid.useFixedPosition
                            Layout.fillWidth:   true
                        }

                        Item { width: rtkGrid.firstColWidth; height: 1 }
                        QGCLabel {
                            text:           rtkGrid.rtkSettings.fixedBasePositionAccuracy.shortDescription
                            visible:        rtkGrid.rtkSettings.fixedBasePositionAccuracy.visible
                            enabled:        rtkGrid.useFixedPosition
                        }
                        FactTextField {
                            fact:               rtkGrid.rtkSettings.fixedBasePositionAccuracy
                            visible:            rtkGrid.rtkSettings.fixedBasePositionAccuracy.visible
                            enabled:            rtkGrid.useFixedPosition
                            Layout.fillWidth:   true
                        }

                        Item { width: rtkGrid.firstColWidth; height: 1 }
                        QGCButton {
                            text:               qsTr("Save Current Base Position")
                            enabled:            QGroundControl.gpsRtk && QGroundControl.gpsRtk.valid.value
                            Layout.columnSpan:  2
                            onClicked: {
                                rtkGrid.rtkSettings.fixedBasePositionLatitude.rawValue =    QGroundControl.gpsRtk.currentLatitude.rawValue
                                rtkGrid.rtkSettings.fixedBasePositionLongitude.rawValue =   QGroundControl.gpsRtk.currentLongitude.rawValue
                                rtkGrid.rtkSettings.fixedBasePositionAltitude.rawValue =    QGroundControl.gpsRtk.currentAltitude.rawValue
                                rtkGrid.rtkSettings.fixedBasePositionAccuracy.rawValue =    QGroundControl.gpsRtk.currentAccuracy.rawValue
                            }
                        }
                    }
                }
            } // settingsColumn
        }
    }
}
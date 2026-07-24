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

import QGroundControl.NTRIP                 1.0

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

                // --- NTRIP / Network RTK section ---
                Item { width: 1; height: _margins; visible: ntripSectionLabel.visible }
                QGCLabel {
                    id:         ntripSectionLabel
                    text:       qsTr("RTK (NTRIP Server)")
                    visible:    QGroundControl.settingsManager.ntripSettings.visible
                }
                Rectangle {
                    Layout.preferredHeight: ntripGrid.y + ntripGrid.height + _margins
                    Layout.preferredWidth:  ntripGrid.width + (_margins * 2)
                    color:                  qgcPal.windowShade
                    visible:                ntripSectionLabel.visible
                    Layout.fillWidth:       true

                    QGCLabel {
                        id:                 rebootLabel
                        anchors.margins:    _margins
                        anchors.top:        parent.top
                        anchors.left:       parent.left
                        anchors.right:      parent.right
                        font.pointSize:     ScreenTools.smallFontPointSize
                        wrapMode:           Text.WordWrap
                        text:               qsTr("Note: Reboot NTRIP connection everytime any paramater is changed.")
                    }

                    GridLayout {
                        id:                         ntripGrid
                        anchors.topMargin:          _margins
                        anchors.top:                rebootLabel.bottom
                        Layout.fillWidth:           true
                        anchors.horizontalCenter:   parent.horizontalCenter
                        columns:                    2

                        property var  ntrip:      QGroundControl.settingsManager.ntripSettings
                        property Fact enabled:    ntrip.ntripServerConnectEnabled

                        // Enable/disable NTRIP
                        FactCheckBox {
                            Layout.fillWidth:   true
                            text:               ntripGrid.enabled.shortDescription
                            fact:               ntripGrid.enabled
                            visible:            ntripGrid.enabled.visible
                        }

                        // Status line
                        QGCLabel {
                            Layout.fillWidth:     true
                            Layout.minimumHeight: 30
                            visible:              true
                            wrapMode:             Text.WordWrap
                            text: {
                                try {
                                    return NTRIPManager ? (NTRIPManager.ntripStatus || qsTr("Disconnected")) : qsTr("NTRIP Manager not available")
                                } catch (e) {
                                    return qsTr("Disconnected")
                                }
                            }
                            color: {
                                try {
                                    if (!NTRIPManager) return qgcPal.text
                                    var status = NTRIPManager.ntripStatus || ""
                                    var lower  = status.toLowerCase()
                                    if (lower.indexOf("disconnected") !== -1) return qgcPal.text
                                    if (lower.indexOf("connected")  !== -1) return qgcPal.colorGreen
                                    if (lower.indexOf("connecting") !== -1) return qgcPal.colorOrange
                                    if (lower.indexOf("error") !== -1 || lower.indexOf("failed") !== -1 ) return qgcPal.colorRed
                                    return qgcPal.text
                                } catch (e) {
                                    return qgcPal.text
                                }
                            }
                        }

                        // Host
                        QGCLabel {
                            text:                       ntripGrid.ntrip.ntripServerHostAddress.shortDescription
                            visible:                    ntripGrid.ntrip.ntripServerHostAddress.visible
                        }
                        FactTextField {
                            Layout.fillWidth:           true
                            fact:                       ntripGrid.ntrip.ntripServerHostAddress
                            visible:                    ntripGrid.ntrip.ntripServerHostAddress.visible
                        }

                        // Port
                        QGCLabel {
                            text:                       ntripGrid.ntrip.ntripServerPort.shortDescription
                            visible:                    ntripGrid.ntrip.ntripServerPort.visible
                        }
                        FactTextField {
                            Layout.fillWidth:           true
                            fact:                       ntripGrid.ntrip.ntripServerPort
                            visible:                    ntripGrid.ntrip.ntripServerPort.visible
                        }

                        // Username
                        QGCLabel {
                            text:                       ntripGrid.ntrip.ntripUsername.shortDescription
                            visible:                    ntripGrid.ntrip.ntripUsername.visible
                        }
                        FactTextField {
                            Layout.fillWidth:           true
                            fact:                       ntripGrid.ntrip.ntripUsername
                            visible:                    ntripGrid.ntrip.ntripUsername.visible
                        }

                        // Password
                        QGCLabel {
                            text:                       ntripGrid.ntrip.ntripPassword.shortDescription
                            visible:                    ntripGrid.ntrip.ntripPassword.visible
                        }
                        FactTextField {
                            Layout.fillWidth:           true
                            fact:                       ntripGrid.ntrip.ntripPassword
                            visible:                    ntripGrid.ntrip.ntripPassword.visible
                        }

                        // Mountpoint
                        QGCLabel {
                            text:                       ntripGrid.ntrip.ntripMountpoint.shortDescription
                            visible:                    ntripGrid.ntrip.ntripMountpoint.visible
                        }
                        FactTextField {
                            Layout.fillWidth:           true
                            fact:                       ntripGrid.ntrip.ntripMountpoint
                            visible:                    ntripGrid.ntrip.ntripMountpoint.visible
                        }

                        // Whitelist
                        QGCLabel {
                            text:                       ntripGrid.ntrip.ntripWhitelist.shortDescription
                            visible:                    false //ntripGrid.ntrip.ntripWhitelist.visible
                        }
                        FactTextField {
                            Layout.fillWidth:           true
                            fact:                       ntripGrid.ntrip.ntripWhitelist
                            visible:                    false //ntripGrid.ntrip.ntripWhitelist.visible
                        }

                        // SPARTN (currently disabled like in original file)
                        FactCheckBox {
                            Layout.fillWidth:   true
                            text:               ntripGrid.ntrip.ntripUseSpartn.shortDescription
                            fact:               ntripGrid.ntrip.ntripUseSpartn
                            visible:            false//_ntrip.ntripUseSpartn.visible
                            enabled:            false
                        }
                    }
                }
            } // settingsColumn
        }
    }
}

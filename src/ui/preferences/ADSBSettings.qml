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

                Item { width: 1; height: _margins; visible: adsbSectionLabel.visible }
                QGCLabel {
                    id:         adsbSectionLabel
                    text:       qsTr("ADSB Server")
                    visible:    QGroundControl.settingsManager.adsbVehicleManagerSettings.visible
                }
                Rectangle {
                    Layout.preferredHeight: adsbGrid.y + adsbGrid.height + _margins
                    Layout.preferredWidth:  adsbGrid.width + (_margins * 2)
                    color:                  qgcPal.windowShade
                    visible:                adsbSectionLabel.visible
                    Layout.fillWidth:       true

                    QGCLabel {
                        id:                 warningLabel
                        anchors.margins:    _margins
                        anchors.top:        parent.top
                        anchors.left:       parent.left
                        anchors.right:      parent.right
                        font.pointSize:     ScreenTools.smallFontPointSize
                        wrapMode:           Text.WordWrap
                        text:               qsTr("Note: These setting are not meant for use with an ADSB transponder which is situated on the vehicle.")
                    }

                    GridLayout {
                        id:                         adsbGrid
                        anchors.topMargin:          _margins
                        anchors.top:                warningLabel.bottom
                        Layout.fillWidth:           true
                        anchors.horizontalCenter:   parent.horizontalCenter
                        columns:                    2

                        property var  adsbSettings:    QGroundControl.settingsManager.adsbVehicleManagerSettings

                        FactCheckBox {
                            text:                   adsbGrid.adsbSettings.adsbServerConnectEnabled.shortDescription
                            fact:                   adsbGrid.adsbSettings.adsbServerConnectEnabled
                            visible:                adsbGrid.adsbSettings.adsbServerConnectEnabled.visible
                            Layout.columnSpan:      2
                        }

                        QGCLabel {
                            text:               adsbGrid.adsbSettings.adsbServerHostAddress.shortDescription
                            visible:            adsbGrid.adsbSettings.adsbServerHostAddress.visible
                        }
                        FactTextField {
                            fact:                   adsbGrid.adsbSettings.adsbServerHostAddress
                            visible:                adsbGrid.adsbSettings.adsbServerHostAddress.visible
                            Layout.fillWidth:       true
                        }

                        QGCLabel {
                            text:               adsbGrid.adsbSettings.adsbServerPort.shortDescription
                            visible:            adsbGrid.adsbSettings.adsbServerPort.visible
                        }
                        FactTextField {
                            fact:                   adsbGrid.adsbSettings.adsbServerPort
                            visible:                adsbGrid.adsbSettings.adsbServerPort.visible
                            Layout.preferredWidth:  _valueFieldWidth
                        }
                    }
                }
            } // settingsColumn
        }
    }
}
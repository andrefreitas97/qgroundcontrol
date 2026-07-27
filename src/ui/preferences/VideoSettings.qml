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

    property var    _videoSettings:             QGroundControl.settingsManager.videoSettings
    property string _videoSource:               _videoSettings.videoSource.rawValue
    property bool   _isGst:                     QGroundControl.videoManager.isGStreamer
    property bool   _isUDP264:                  _isGst && _videoSource === _videoSettings.udp264VideoSource
    property bool   _isUDP265:                  _isGst && _videoSource === _videoSettings.udp265VideoSource
    property bool   _isRTSP:                    _isGst && _videoSource === _videoSettings.rtspVideoSource
    property bool   _isTCP:                     _isGst && _videoSource === _videoSettings.tcpVideoSource
    property bool   _isMPEGTS:                  _isGst && _videoSource === _videoSettings.mpegtsVideoSource
    property bool   _videoAutoStreamConfig:     QGroundControl.videoManager.autoStreamConfigured
    property bool   _showSaveVideoSettings:     _isGst || _videoAutoStreamConfig

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

                Item { width: 1; height: _margins; visible: videoSectionLabel.visible }
                QGCLabel {
                    id:         videoSectionLabel
                    text:       qsTr("Video Settings")
                    visible:    _videoSettings.visible
                }
                Rectangle {
                    Layout.preferredHeight: videoGrid.height + (_margins * 2)
                    Layout.preferredWidth:  videoGrid.width + (_margins * 2)
                    color:                  qgcPal.windowShade
                    visible:                videoSectionLabel.visible
                    Layout.fillWidth:       true

                    GridLayout {
                        id:                         videoGrid
                        anchors.margins:            _margins
                        anchors.top:                parent.top
                        anchors.horizontalCenter:   parent.horizontalCenter
                        columns:                    2
                        visible:                    _videoSettings.visible

                        QGCLabel {
                            id:         videoSourceLabel
                            text:       qsTr("Source")
                            visible:    !_videoAutoStreamConfig && _videoSettings.videoSource.visible
                        }
                        FactComboBox {
                            id:                     videoSource
                            Layout.preferredWidth:  _comboFieldWidth
                            indexModel:             false
                            fact:                   _videoSettings.videoSource
                            visible:                videoSourceLabel.visible
                        }

                        QGCLabel {
                            id:         udpPortLabel
                            text:       qsTr("UDP Port")
                            visible:    !_videoAutoStreamConfig && (_isUDP264 || _isUDP265 || _isMPEGTS) && _videoSettings.udpPort.visible
                        }
                        FactTextField {
                            Layout.preferredWidth:  _comboFieldWidth
                            fact:                   _videoSettings.udpPort
                            visible:                udpPortLabel.visible
                        }

                        QGCLabel {
                            id:         a2rtspUrlLabel
                            text:       qsTr("Gimbal A2 RTSP URL")
                            visible:    !_videoAutoStreamConfig && _isRTSP && _videoSettings.rtspUrl.visible
                        }
                        FactTextField {
                            Layout.preferredWidth:  _comboFieldWidth
                            fact:                   _videoSettings.rtspUrlA2
                            visible:                a2rtspUrlLabel.visible
                            //text: "rtsp://192.168.144.25:8554/main.264"
                            //onTextChanged: {
                            //    SiYi.camera.analyzeIp(text)
                            //}
                        }

                        QGCLabel {
                            id:         gimbalA8rtspUrlLabel
                            text:       qsTr("Gimbal A8 RTSP URL")
                            visible:    !_videoAutoStreamConfig && _isRTSP && _videoSettings.rtspUrl.visible
                        }
                        FactTextField {
                            Layout.preferredWidth:  _comboFieldWidth
                            fact:                   _videoSettings.rtspUrlA8
                            visible:                gimbalA8rtspUrlLabel.visible
                        }

                        QGCLabel {
                            id:         gimbalZT6MainrtspUrlLabel
                            text:       qsTr("Gimbal ZT6 Main RTSP URL")
                            visible:    !_videoAutoStreamConfig && _isRTSP && _videoSettings.rtspUrl.visible
                        }
                        FactTextField {
                            Layout.preferredWidth:  _comboFieldWidth
                            fact:                   _videoSettings.rtspUrlZT6Main
                            visible:                gimbalZT6MainrtspUrlLabel.visible
                        }

                        QGCLabel {
                            id:         gimbalZT6SubrtspUrlLabel
                            text:       qsTr("Gimbal ZT6 Sub RTSP URL")
                            visible:    false //!_videoAutoStreamConfig && _isRTSP && _videoSettings.rtspUrl.visible
                        }
                        FactTextField {
                            Layout.preferredWidth:  _comboFieldWidth
                            fact:                   _videoSettings.rtspUrlZT6Sub
                            visible:               false //gimbalZT6SubrtspUrlLabel.visible
                        }

                        QGCLabel {
                            id:         gimbalZIOrtspUrlLabel
                            text:       qsTr("Gimbal ZIO RTSP URL")
                            visible:    !_videoAutoStreamConfig && _isRTSP && _videoSettings.rtspUrl.visible
                            enabled:               false
                        }
                        FactTextField {
                            Layout.preferredWidth:  _comboFieldWidth
                            fact:                   _videoSettings.rtspUrlZIO
                            visible:                gimbalZIOrtspUrlLabel.visible
                            enabled:               false
                        }

                        QGCLabel {
                            id:         tcpUrlLabel
                            text:       qsTr("TCP URL")
                            visible:    !_videoAutoStreamConfig && _isTCP && _videoSettings.tcpUrl.visible
                        }
                        FactTextField {
                            Layout.preferredWidth:  _comboFieldWidth
                            fact:                   _videoSettings.tcpUrl
                            visible:                tcpUrlLabel.visible
                        }

                        QGCLabel {
                            text:                   qsTr("Aspect Ratio")
                            visible:                !_videoAutoStreamConfig && _isGst && _videoSettings.aspectRatio.visible
                        }
                        FactTextField {
                            Layout.preferredWidth:  _comboFieldWidth
                            fact:                   _videoSettings.aspectRatio
                            visible:                !_videoAutoStreamConfig && _isGst && _videoSettings.aspectRatio.visible
                        }

                        QGCLabel {
                            id:         videoFileFormatLabel
                            text:       qsTr("Record File Format")
                            visible:    _showSaveVideoSettings && _videoSettings.recordingFormat.visible
                        }
                        FactComboBox {
                            Layout.preferredWidth:  _comboFieldWidth
                            fact:                   _videoSettings.recordingFormat
                            visible:                videoFileFormatLabel.visible
                        }

                        QGCLabel {
                            id:         maxSavedVideoStorageLabel
                            text:       qsTr("Max Storage Usage")
                            visible:    _showSaveVideoSettings && _videoSettings.maxVideoSize.visible && _videoSettings.enableStorageLimit.value
                        }
                        FactTextField {
                            Layout.preferredWidth:  _comboFieldWidth
                            fact:                   _videoSettings.maxVideoSize
                            visible:                _showSaveVideoSettings && _videoSettings.enableStorageLimit.value && maxSavedVideoStorageLabel.visible
                        }

                        QGCLabel {
                            id:         videoDecodeLabel
                            text:       qsTr("Video decode priority")
                            visible:    forceVideoDecoderComboBox.visible
                        }
                        FactComboBox {
                            id:                     forceVideoDecoderComboBox
                            Layout.preferredWidth:  _comboFieldWidth
                            fact:                   _videoSettings.forceVideoDecoder
                            visible:                fact.visible
                            indexModel:             false
                        }

                        Item { width: 1; height: 1}
                        FactCheckBox {
                            text:       qsTr("Disable When Disarmed")
                            fact:       _videoSettings.disableWhenDisarmed
                            visible:    !_videoAutoStreamConfig && _isGst && fact.visible
                        }

                        Item { width: 1; height: 1}
                        FactCheckBox {
                            text:       qsTr("Low Latency Mode")
                            fact:       _videoSettings.lowLatencyMode
                            visible:    !_videoAutoStreamConfig && _isGst && fact.visible
                        }

                        Item { width: 1; height: 1}
                        FactCheckBox {
                            text:       qsTr("Auto-Delete Saved Recordings")
                            fact:       _videoSettings.enableStorageLimit
                            visible:    _showSaveVideoSettings && fact.visible
                        }

                        Item { width: 1; height: 1}
                        FactCheckBox {
                            text:       qsTr("Enable Camera Menu")
                            fact:       _videoSettings.enableCameraMenu
                            visible:    _showSaveVideoSettings && fact.visible
                        }
                    }
                }
            } // settingsColumn
        }
    }
}

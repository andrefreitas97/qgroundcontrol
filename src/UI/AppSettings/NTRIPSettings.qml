/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QGroundControl
import QGroundControl.FactControls
import QGroundControl.Controls
import QGroundControl.ScreenTools
import QGroundControl.NTRIP 1.0

SettingsPage {
    property var _settingsManager:   QGroundControl.settingsManager
    property var _ntrip:             _settingsManager.ntripSettings
    property var _enabled:          _ntrip.ntripServerConnectEnabled
    
    SettingsGroupLayout {
        Layout.fillWidth:   true
        heading:            qsTr("NTRIP / RTK")
        visible:            _ntrip.visible
        
        FactCheckBoxSlider {
            Layout.fillWidth:   true
            text:               _enabled.shortDescription
            fact:               _enabled
            visible:            _enabled.visible
        }
    }
    
    SettingsGroupLayout {
        Layout.fillWidth:   true
        visible:            _ntrip.ntripServerHostAddress.visible || _ntrip.ntripServerPort.visible ||
                            _ntrip.ntripUsername.visible || _ntrip.ntripPassword.visible ||
                            _ntrip.ntripMountpoint.visible || _ntrip.ntripWhitelist.visible ||
                            _ntrip.ntripUseSpartn.visible
        
        // Status line
        QGCLabel {
            Layout.fillWidth:   true
            Layout.minimumHeight: 30
            text: {
                if (typeof NTRIPManager === "undefined" || !NTRIPManager)
                    return "NTRIP Manager not available"
                return NTRIPManager.ntripStatus || "Disconnected"
            }
            wrapMode: Text.WordWrap
            color: {
                if (typeof NTRIPManager === "undefined" || !NTRIPManager)
                    return qgcPal.text
            
                var status = (NTRIPManager.ntripStatus || "").toLowerCase()
                if (status.includes("disconnected")) return qgcPal.text
                if (status.includes("connected")) return qgcPal.colorGreen
                if (status.includes("connecting")) return qgcPal.colorOrange
                if (status.includes("error") || status.includes("failed")) return qgcPal.colorRed
                return qgcPal.text
            }
        }
        
        LabelledFactTextField {
            Layout.fillWidth:   true
            label:              _ntrip.ntripServerHostAddress.shortDescription
            fact:               _ntrip.ntripServerHostAddress
            visible:            _ntrip.ntripServerHostAddress.visible
            textFieldPreferredWidth: ScreenTools.defaultFontPixelWidth * 30
            enabled:            !_enabled.rawValue
        }
        
        LabelledFactTextField {
            Layout.fillWidth:   true
            label:              _ntrip.ntripServerPort.shortDescription
            fact:               _ntrip.ntripServerPort
            visible:            _ntrip.ntripServerPort.visible
            textFieldPreferredWidth: ScreenTools.defaultFontPixelWidth * 10
            enabled:            !_enabled.rawValue
        }
        
        LabelledFactTextField {
            Layout.fillWidth:   true
            label:              _ntrip.ntripUsername.shortDescription
            fact:               _ntrip.ntripUsername
            visible:            _ntrip.ntripUsername.visible
            textFieldPreferredWidth: ScreenTools.defaultFontPixelWidth * 30
            enabled:            !_enabled.rawValue
        }
        
        LabelledFactTextField {
            Layout.fillWidth:   true
            label:              _ntrip.ntripPassword.shortDescription
            fact:               _ntrip.ntripPassword
            visible:            _ntrip.ntripPassword.visible
            textField.echoMode: TextInput.Password
            textFieldPreferredWidth: ScreenTools.defaultFontPixelWidth * 30
            enabled:            !_enabled.rawValue
        }
        
        LabelledFactTextField {
            Layout.fillWidth:   true
            label:              _ntrip.ntripMountpoint.shortDescription
            fact:               _ntrip.ntripMountpoint
            visible:            _ntrip.ntripMountpoint.visible
            textFieldPreferredWidth: ScreenTools.defaultFontPixelWidth * 10
            enabled:            !_enabled.rawValue
        }
        
        LabelledFactTextField {
            Layout.fillWidth:   true
            label:              _ntrip.ntripWhitelist.shortDescription
            fact:               _ntrip.ntripWhitelist
            visible:            false //_ntrip.ntripWhitelist.visible
            textFieldPreferredWidth: ScreenTools.defaultFontPixelWidth * 40
            enabled:            !_enabled.rawValue
        }
        
        FactCheckBoxSlider {
            Layout.fillWidth:   true
            text:               _ntrip.ntripUseSpartn.shortDescription
            fact:               _ntrip.ntripUseSpartn
            visible:            false //_ntrip.ntripUseSpartn.visible
            enabled:            !_enabled.rawValue //false
        }
    }
}
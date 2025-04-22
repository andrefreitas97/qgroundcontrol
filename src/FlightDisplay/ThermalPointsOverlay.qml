import QtQuick 2.12
import QGroundControl 1.0

import SiYi.Object 1.0

import QtQuick.Window 2.15

Item {
    id: overlayRoot

    property var    _videoStreamSettings:                       QGroundControl.settingsManager.videoSettings
    property double _ar:                QGroundControl.videoManager.aspectRatio
    property var siyi: SiYi
    property SiYiCamera camera: siyi.camera

    property int marker_temp_x: 0
    property int marker_temp_y: 0

    // Properties from FlyViewWidgetLayer.qml
    property real rootWidth
    property real rootHeight

    function getHeight() {
        return _ar != 0.0 ? rootWidth * (1 / _ar) : rootHeight
    }

    on_ArChanged: {
        getHeight()
    }

    // Red thermal point
    Rectangle {
        id: redPoint
        width: 20
        height: width
        radius: width / 2
        color: "red"
        visible: _videoStreamSettings.tempFullImage.rawValue == 1 && 
                 _videoStreamSettings.rtspUrl.value == _videoStreamSettings.rtspUrlZT6Main.value && 
                 _videoStreamSettings.zt6ImageMode.rawValue != 1
        x: _videoStreamSettings.zt6ImageMode.rawValue == 0 
            ? camera.temp_max_x - (width / 2) 
            : 1920 / 2 - (1080 * (640 / 512)) / 2 + camera.temp_max_x * (1920 / (_ar * 512)) - (width / 2)
        y: _videoStreamSettings.zt6ImageMode.rawValue == 0 
            ? rootHeight / 2 - getHeight() / 2 + camera.temp_max_y - (width / 2) 
            : rootHeight / 2 - getHeight() / 2 + camera.temp_max_y * (1080 / 512) - (width / 2)

        Text {
            anchors.top: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: camera.temp_max / 100 + " °C"
            color: "red"
            font.pixelSize: 30
            visible: parent.visible
        }
    }

    // Blue thermal point
    Rectangle {
        id: bluePoint
        width: 20
        height: width
        radius: width / 2
        color: "blue"
        visible: _videoStreamSettings.tempFullImage.rawValue == 1 && 
                 _videoStreamSettings.rtspUrl.value == _videoStreamSettings.rtspUrlZT6Main.value && 
                 _videoStreamSettings.zt6ImageMode.rawValue != 1
        x: _videoStreamSettings.zt6ImageMode.rawValue == 0 
            ? camera.temp_min_x - (width / 2) 
            : 1920 / 2 - (1080 * (640 / 512)) / 2 + camera.temp_min_x * (1920 / (_ar * 512)) - (width / 2)
        y: _videoStreamSettings.zt6ImageMode.rawValue == 0 
            ? rootHeight / 2 - getHeight() / 2 + camera.temp_min_y - (width / 2) 
            : rootHeight / 2 - getHeight() / 2 + camera.temp_min_y * (1080 / 512) - (width / 2)

        Text {
            anchors.top: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: camera.temp_min / 100 + " °C"
            color: "blue"
            font.pixelSize: 30
            visible: parent.visible
        }
    }

    Rectangle {
        id: tempPoint_touchArea
        width: _videoStreamSettings.zt6ImageMode.rawValue == 0
                ? rootWidth / 2
                : getHeight() * (640 / 512)
        height: rootHeight
        color: "transparent"
        //opacity: 0.5  // 50% opacity
        border.color: "green"  // Set the border color to green
        border.width: 5        // Set the width of the border
        visible: _videoStreamSettings.pointTemp.rawValue == 1 && 
                 _videoStreamSettings.rtspUrl.value == _videoStreamSettings.rtspUrlZT6Main.value && 
                 _videoStreamSettings.zt6ImageMode.rawValue != 1
        x: _videoStreamSettings.zt6ImageMode.rawValue == 0
            ? rootWidth / 2 
            : rootWidth / 2 - (getHeight() * (640 / 512)) / 2
        y: _videoStreamSettings.zt6ImageMode.rawValue == 0
            ? 0 
            : 0
        
        

        Rectangle {
            id: pointMarker
            width: 20
            height: width
            radius: width / 2
            color: "green"
            visible: false
            anchors.centerIn: undefined // disable automatic anchoring
            
            Text {
                anchors.top: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text: camera.point_temp / 100 + " °C"
                color: "green"
                font.pixelSize: 30
                visible: parent.visible
            }           
        }
        
        
        MouseArea {
            id: thermal_mouseArea
            anchors.fill: parent
            visible: parent.visible

            onClicked: {
                // Update point marker position
                pointMarker.x = mouse.x - pointMarker.width / 2
                pointMarker.y = mouse.y - pointMarker.height / 2
                pointMarker.visible = true
                
                if (_videoStreamSettings.zt6ImageMode.rawValue == 0) {
                    marker_temp_x = tempPoint_touchArea.x + mouse.x
                    marker_temp_y = (tempPoint_touchArea.y + mouse.y) - rootHeight / 2 +  getHeight() / 2
                }else {
                    marker_temp_x = ((tempPoint_touchArea.x + mouse.x) - rootWidth / 2 + (getHeight() * (640 / 512)) / 2) / (rootWidth / (_ar * 512))
                    marker_temp_y = ((tempPoint_touchArea.y + mouse.y) - rootHeight / 2 +  getHeight() / 2) / (getHeight() / 512)
                }

                camera.requestPointTemp( marker_temp_x, marker_temp_y, _videoStreamSettings.pointTemp.rawValue)

            }
        }            
    }
//
    //property int center_point_split_x: rootWidth *(3/4)
    //property int center_point_split_y: getHeight()/2
    //property int center_point_thermal_x: 640/2
    //property int center_point_thermal_y: 512/2

    //Rectangle {
    //    id: centerPoint
    //    width: 20
    //    height: width
    //    radius: width / 2
    //    color: "green"
    //    visible: _videoStreamSettings.pointTemp.rawValue == 1 && 
    //             _videoStreamSettings.rtspUrl.value == _videoStreamSettings.rtspUrlZT6Main.value && 
    //             _videoStreamSettings.zt6ImageMode.rawValue != 1
    //    x: _videoStreamSettings.zt6ImageMode.rawValue == 0 
    //        ? center_point_split_x - (width / 2) 
    //        : 1920 / 2 - (1080 * (640 / 512)) / 2 + center_point_thermal_x * (1920 / (_ar * 512)) - (width / 2)
    //    y: _videoStreamSettings.zt6ImageMode.rawValue == 0 
    //        ? rootHeight / 2 - getHeight() / 2 + center_point_split_y - (width / 2) 
    //        : rootHeight / 2 - getHeight() / 2 + center_point_thermal_y * (1080 / 512) - (width / 2)
//
    //    Text {
    //        anchors.top: parent.bottom
    //        anchors.horizontalCenter: parent.horizontalCenter
    //        text: camera.point_temp / 100 + " °C"
    //        color: "green"
    //        font.pixelSize: 30
    //        visible: parent.visible
    //    }
    //}
}

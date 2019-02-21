import QtQuick 2.11
import QtGraphicalEffects 1.12

Item {
    id: jam_color_bg
    readonly property string color_host: "#424242"
    readonly property string color_blue: "#5DC0D6"
    readonly property string color_red: "#E36256"
    property string color: color_host

    width: 1080
    height: 480

    RadialGradient {
        anchors.fill: parent
        horizontalRadius: width * 0.8
        verticalRadius: horizontalRadius
        gradient: Gradient {
            GradientStop {
                position: -0.3
                color: "white"
            }
            GradientStop {
                position: 0.5
                color: jam_color_bg.color
            }
        }
    }

    RadialGradient {
        id: jam_color_bg_2nd_gradient
        anchors.fill: parent
        horizontalRadius: width * 0.8
        verticalRadius: horizontalRadius
        gradient: Gradient {
            GradientStop {
                position: -0.7
                color: "white"
            }
            GradientStop {
                position: 0.5
                color: color_host
            }
        }
        opacity: 0.2
    }
    onColorChanged: {
        jam_color_bg_2nd_gradient.visible = !color === '#ffffff'
    }
}

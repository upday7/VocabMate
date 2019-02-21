import QtQuick 2.0
import QtQuick.Controls 2.5

Item {

    property double pctg: 0
    width: 32
    height: width

    Rectangle {
        id: outter_circle
        width: parent.width * 0.8
        height: width
        radius: 360
        color: "#00000000"
        anchors.centerIn: parent
        border {
            color: "white"
            width: width / 10
        }
    }

    Text {
        id: pctg_text
        text: Number(pctg * 100).toString().split(".")[0]
        color: "#fff"
        font {
            family: 'open sans'
            pixelSize: parent.width * 0.4
            bold: true
        }
        Component.onCompleted: {
            if (pctg === 0) {
                this.anchors.centerIn = parent
            } else {
                this.anchors.centerIn = null
                if (pctg > 0.1) {
                    x = parent.width * (7 / 20)
                    y = parent.height * (8 / 20)
                } else {
                    x = parent.width * (12 / 20)
                    y = parent.height * (8 / 20)
                }
            }
        }
        z: 3
    }

    Canvas {
        id: pie
        width: parent.width * 0.8
        height: width
        rotation: -90

        anchors {
            centerIn: parent
        }

        onPaint: {

            console.log("Word Progress is ", pctg, " drawing progress pie")
            var ctx = getContext("2d")
            var x = width / 2
            var y = height / 2

            ctx.reset()
            ctx.beginPath()

            ctx.moveTo(x, y)
            ctx.arc(x, y, x - parent.width / 10, Math.PI * (0 / 180),
                    Math.PI * pctg * 360 / 180, false)
            ctx.lineTo(x, y)
            ctx.globalAlpha = 0.8
            ctx.fillStyle = "#A7C98B"

            ctx.fill()

            ctx.closePath()
        }
    }
    onPctgChanged: {
        pie.requestPaint()
    }
}

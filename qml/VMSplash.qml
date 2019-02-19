import QtQuick 2.0

Rectangle {
    id: splash

    property string left_bg_color: '#87BB72'
    property string right_bg_color: '#7BB563'

    width: 540
    height: 225

    Canvas {
        id: left_bg
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            var x = 0
            var y = 0
            ctx.reset()

            // left bg
            ctx.beginPath()
            ctx.moveTo(x, y)
            x = x + width / 20
            ctx.lineTo(x, y)
            y = height
            x = width * 19 / 20
            ctx.lineTo(x, y)
            x = 0
            ctx.lineTo(x, y)
            y = 0
            ctx.lineTo(x, y)
            ctx.fillStyle = left_bg_color

            ctx.fill()

            // right bg
            x = width * 1 / 20
            y = 0
            ctx.moveTo(x, y)
            y = height
            x = width * 19 / 20
            ctx.lineTo(x, y)
            x = width
            ctx.lineTo(x, y)
            y = 0
            ctx.lineTo(x, y)
            x = width / 20
            ctx.lineTo(x, y)
            ctx.fillStyle = right_bg_color
            ctx.fill()

            // draw text
            ctx.drawTet()

            ctx.closePath()
        }
    }
}

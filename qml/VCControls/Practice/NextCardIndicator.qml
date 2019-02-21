import QtQuick 2.9

Item {
    id: indicator
    height: 70
    width: 30

    signal clicked
    MouseArea {
        anchors.fill: parent
        onClicked: parent.clicked()
    }

    Canvas {
        id: canvas
        height: parent.height
        width: parent.width - 2
        onPaint: {
            var ctx = canvas.getContext('2d')
            ctx.strokeStyle = '#BDC0BD'
            ctx.lineWidth = 10

            ctx.beginPath()
            ctx.moveTo(10, 10) //start point
            ctx.lineTo(width - 5, height / 2)
            ctx.lineTo(10, height - 10)
            ctx.stroke()
            ctx.closePath()
        }

        XAnimator {
            target: canvas
            from: 0
            to: 3
            duration: 600
            running: true
            loops: Animation.Infinite
        }
    }
}

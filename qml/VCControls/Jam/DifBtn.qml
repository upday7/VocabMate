import QtQuick 2.0
import QtQuick.Controls 2.4

Button {

    id: jam_dif_btn

    property string face_color: "#cccccc"
    readonly property var dif_level_data: [["../../res/img/jam-dif0.svg", "#4DB538"], ["../../res/img/jam-dif1.svg", "#BDCB31"], ["../../res/img/jam-dif2.svg", "#FFCD05"], ["../../res/img/jam-dif3.svg", "#F26922"], ["../../res/img/jam-dif4.svg", "#EE2F26"]]
    property int dif_lvl: 0

    width: 78
    height: width

    background: Canvas {
        id: bg
        anchors.fill: parent
        property string svg_url: dif_level_data[dif_lvl][0]
        onPaint: {
            if (isImageLoaded(bg.svg_url)) {
                var ctx = getContext('2d')

                ctx.drawImage(bg.svg_url, 0, 0, jam_dif_btn.width,
                              jam_dif_btn.height)

                ctx.globalCompositeOperation = "source-in"

                // draw color
                ctx.fillStyle = face_color
                ctx.fillRect(0, 0, bg.width, bg.height)

                ctx.strokeStyle = ctx.fillStyle
                ctx.strokeRect(0, 0, bg.width, bg.height)
            }
        }
        onImageLoaded: {
            requestPaint()
        }

        Component.onCompleted: {
            loadImage(bg.svg_url)
        }
    }
    MouseArea {
        id: ma2
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            parent.state = 'Hovering'
        }
        onExited: {
            parent.state = ''
        }
        onClicked: {
            ma2.entered()
            parent.clicked()
        }
    }
    state: ""
    states: [
        State {
            name: ""
            PropertyChanges {
                target: ma2
                cursorShape: Qt.ArrowCursor
            }
        },
        State {
            name: "Hovering"
            PropertyChanges {
                target: ma2
                cursorShape: Qt.PointingHandCursor
            }
        }
    ]
    hoverEnabled: true
    onClicked: {
        set_active()
    }
    function set_color(_color) {
        face_color = _color
        bg.requestPaint()
    }
    function set_active() {
        set_color(dif_level_data[dif_lvl][1].toLowerCase())
    }
    function set_inactive() {
        set_color("#cccccc")
    }
}

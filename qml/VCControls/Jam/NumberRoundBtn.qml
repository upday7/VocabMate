import QtQuick 2.9
import QtQuick.Controls 2.4

RoundButton {
    property int cur_number: 10

    id: q_count_btn
    width: 48
    height: width

    background: Rectangle {
        id: bg
        anchors.fill: parent
        radius: parent.width
        color: "#cccccc"
        Text {
            text: cur_number.toString()
            anchors.centerIn: parent
            font {
                family: "open sans"
                bold: true
                pixelSize: q_count_btn.width * 0.4
            }
            color: "white"
        }
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            q_count_btn.state = 'Hovering'
        }
        onExited: {
            q_count_btn.state = ''
        }
        onClicked: {
            ma.entered()
            parent.clicked()
        }
    }

    state: ""
    states: [
        State {
            name: ""
            PropertyChanges {
                target: ma
                cursorShape: Qt.ArrowCursor
            }
        },
        State {
            name: "Hovering"
            PropertyChanges {
                target: ma
                cursorShape: Qt.PointingHandCursor
            }
        }
    ]

    onClicked: {
        set_active()
    }
    function set_color(_color) {
        bg.color = _color
    }
    function set_active() {
        set_color("#6AB14B")
    }
    function set_inactive() {
        set_color("#cccccc")
    }
}

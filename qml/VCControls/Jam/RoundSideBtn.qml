import QtQuick 2.9
import QtQuick.Controls 2.9

Button {

    property string cur_text: "Test"
    property alias font_size: round_side_btn_text.font.pixelSize
    id: round_side_btn

    background: Rectangle {
        id: round_side_btn_bg
        anchors.fill: parent
        radius: round_side_btn.height
        color: "#cccccc"

        width: round_side_btn_text.paintedWidth
        height: round_side_btn_text.paintedHeight

        Text {
            id: round_side_btn_text
            text: cur_text
            fontSizeMode: Text.Fit
            anchors {
                centerIn: parent
            }

            font {
                pixelSize: 32
                family: "open sans"
                weight: Font.Black
            }
            color: "white"
        }

        Component.onCompleted: {
            round_side_btn.width = round_side_btn_text.paintedWidth
                    + round_side_btn_text.font.pixelSize * 1.8
            round_side_btn.height = round_side_btn_text.paintedHeight
                    + round_side_btn_text.paintedHeight * 0.4
        }
    }

    MouseArea {
        id: round_side_btn_ma
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            parent.state = 'Hovering'
        }
        onExited: {
            parent.state = ''
        }
        onClicked: {
            entered()
            parent.clicked()
        }
        z: 2
    }

    state: ""
    states: [
        State {
            name: ""
            PropertyChanges {
                target: round_side_btn_ma
                cursorShape: Qt.ArrowCursor
            }
        },
        State {
            name: "Hovering"
            PropertyChanges {
                target: round_side_btn_ma
                cursorShape: Qt.PointingHandCursor
            }
        }
    ]

    onClicked: {
        set_active()
    }
    function set_color(_color) {
        round_side_btn_bg.color = _color
    }
    function set_active() {
        set_color("#6AB14B")
    }
    function set_inactive() {
        set_color("#cccccc")
    }
}

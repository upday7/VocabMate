import QtQuick 2.9

Rectangle {

    signal clicked

    id: bg_rect
    radius: 5
    z: 10

    function invalidOption() {
        bg_rect.enabled = false
    }

    Image {
        id: option_img
        anchors.fill: parent
        source: modelData.option
        property var nonce: modelData.nonce
        fillMode: Image.PreserveAspectCrop
        z: 15
    }

    Rectangle {
        id: checking
        width: 48
        height: 48
        visible: true
        z: 20
        opacity: 0.8
        color: "black"
        anchors.centerIn: parent
        radius: 10
        AnimatedImage {
            width: 32
            height: 32
            source: "../../res/img/loading.svg"
            anchors.centerIn: parent
            RotationAnimator on rotation {
                loops: Animation.Infinite
                from: 0
                to: 360
                running: true
                duration: 3000
            }
        }
    }

    Rectangle {
        id: correct
        width: 32
        height: 32
        anchors.centerIn: parent
        border {
            color: "#78A752"
            width: 32 / 0.9 * (1 / 7)
        }
        radius: 360
        z: 20
        color: "#00ffffff"
        Text {
            text: $favar.fa_check
            anchors {
                centerIn: parent
            }
            font {
                family: $awesome.name
                pixelSize: parent.height
            }
            scale: 0.5
            color: "#78A752"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Rectangle {
        id: incorrect
        width: 32
        height: 32
        anchors.centerIn: parent
        border {
            color: "#BB3330"
            width: 32 / 0.9 * (1 / 7)
        }
        radius: 360
        z: 20
        color: "#00ffffff"
        Text {
            text: $favar.fa_times
            anchors {
                centerIn: parent
            }
            font {
                family: $awesome.name
                pixelSize: parent.height
            }
            scale: 0.5
            color: "#BB3330"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if ("normal, pressing".search(this.state) === -1) {
                return
            }
            bg_rect.clicked()
        }
    }

    state: "normal"
    states: [
        State {
            name: "normal"

            PropertyChanges {
                target: option_img
                scale: 1
            }
            PropertyChanges {
                target: checking
                visible: false
            }
            PropertyChanges {
                target: correct
                visible: false
            }
            PropertyChanges {
                target: incorrect
                visible: false
            }
        },
        State {
            name: "checking"

            PropertyChanges {
                target: option_img
                scale: 1
            }
            PropertyChanges {
                target: correct
                visible: false
            }
            PropertyChanges {
                target: checking
                visible: true
            }
            PropertyChanges {
                target: incorrect
                visible: false
            }
        },
        State {
            name: "correct"

            PropertyChanges {
                target: option_img
                scale: 0.97
            }
            PropertyChanges {
                target: bg_rect
                color: "#78A752"
            }
            PropertyChanges {
                target: checking
                visible: false
            }
            PropertyChanges {
                target: correct
                visible: true
            }
            PropertyChanges {
                target: incorrect
                visible: false
            }
        },
        State {
            name: "incorrect"

            PropertyChanges {
                target: option_img
                scale: 0.97
            }
            PropertyChanges {
                target: bg_rect
                color: "#BB3330"
            }
            PropertyChanges {
                target: checking
                visible: false
            }
            PropertyChanges {
                target: correct
                visible: false
            }
            PropertyChanges {
                target: incorrect
                visible: true
            }
        }
    ]
}

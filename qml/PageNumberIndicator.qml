import QtQuick 2.0

Item {
    id: pager
    width: 128
    height: width

    property alias page_number: inner_number.text

    Rectangle {
        id: outter_circle
        radius: width * 0.5
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        color: "#00000000"
        border {
            color: "#BDC0BD"
            width: height * (1 / 15)
        }
    }

    Rectangle {
        id: inner_pie
        radius: width * 0.5
        anchors.centerIn: parent
        width: outter_circle.width - outter_circle.border.width * 2
        height: outter_circle.height - outter_circle.border.width * 2
    }

    Text {
        id: inner_number
        anchors.centerIn: parent
        text: "10"
        z: 1
        opacity: inner_pie.opacity
        fontSizeMode: Text.Fit
        font {
            family: "open sans"
            bold: true
            pixelSize: parent.width * 0.6
        }
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        id: correct
        text: $favar.fa_check
        anchors.centerIn: parent
        font {
            family: $awesome.name
            pixelSize: parent.height
        }
        scale: 0.5
        color: "white"
        visible: false
    }

    Text {
        id: incorrect
        text: $favar.fa_times
        anchors.centerIn: parent
        font {
            family: $awesome.name
            pixelSize: parent.height
        }
        scale: 0.5
        color: "white"
        visible: false
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onHoveredChanged: {
            if (parent.state === "normal") {
                parent.state = "hovering"
            } else {
                if ("correct,incorrect,current".search(parent.state) === -1) {
                    parent.state = "normal"
                }
            }
        }
    }

    state: "normal"
    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: inner_pie
                color: "#00000000"
            }

            PropertyChanges {
                target: inner_number
                visible: true
            }
        },
        State {
            name: "current"
            PropertyChanges {
                target: inner_pie
                opacity: 0.8
                color: "white"
                visible: true
            }

            PropertyChanges {
                target: inner_number
                visible: true
            }
        },
        State {
            name: "hovering"
            PropertyChanges {
                target: inner_pie
                opacity: 0.4
                color: "white"
                visible: true
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
            name: "correct"
            PropertyChanges {
                target: correct
                visible: true
            }

            PropertyChanges {
                target: inner_pie
                opacity: 0.4
                color: "white"
                visible: true
            }

            PropertyChanges {
                target: inner_number
                visible: false
            }
        },

        State {
            name: "incorrect"
            PropertyChanges {
                target: incorrect
                visible: true
            }

            PropertyChanges {
                target: inner_pie
                opacity: 0.4
                color: "white"
                visible: true
            }
            PropertyChanges {
                target: inner_number
                visible: false
            }
        }
    ]
}

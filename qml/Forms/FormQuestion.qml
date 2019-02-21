import QtQuick 2.9
import "../VCControls/Practice"

Item {
    id: question_win

    Question {
        id: question
        anchors.fill: parent
        visible: false
    }

    RoundSummary {
        id: round_summary
        anchors {
            centerIn: parent
            verticalCenterOffset: 20
        }
        height: parent.height - 40
        visible: !question.visible
    }

    NextCardIndicator {
        id: new_round
        anchors {
            left: round_summary.right
            leftMargin: 20
            verticalCenter: round_summary.verticalCenter
        }
        onClicked: {
            $api.start()
        }
        visible: round_summary.visible
    }

    MenuButton {
        id: menButton
        width: parent.width / 36
        height: width
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        z: 0
        onClicked: menu.state = 'on'
        onCancelled: menu.state = 'off'
        visible: false
    }

    Rectangle {

        id: menu
        visible: false
        height: parent.height - y
        width: parent.width
        color: "black"
        opacity: 0
        y: parent.height
        z: 99

        state: "off"
        states: [
            State {
                name: "on"
                PropertyChanges {
                    target: menu
                    y: menButton.height + 10 + 10
                }
            },
            State {
                name: "off"
                PropertyChanges {
                    target: menu
                    y: parent.height
                }
            }
        ]

        transitions: [
            Transition {
                from: "off"
                to: "on"
                ParallelAnimation {
                    PropertyAnimation {
                        target: menu
                        property: "y"
                        from: window.height
                        to: menButton.height + 10 + 10
                        duration: 200
                    }
                    PropertyAnimation {
                        target: menu
                        property: "opacity"
                        from: 0
                        to: .9
                        duration: 200
                    }
                }
            },
            Transition {
                from: "on"
                to: "off"
                ParallelAnimation {
                    PropertyAnimation {
                        target: menu
                        property: "y"
                        from: menButton.height + 10 + 10
                        to: window.height
                        duration: 200
                    }
                    PropertyAnimation {
                        target: menu
                        property: "opacity"
                        from: .9
                        to: 0
                        duration: 200
                    }
                }
            }
        ]
    }

    Connections {
        target: $api
        onLoading: {
            question.visible = true
        }
        onRoundSummary: function (round_prg_data) {
            question.visible = false
            for (var i = 0; i < round_prg_data.length; i++) {
                console.log(round_prg_data[i]['wrd'], round_prg_data[i]['prg'],
                            round_prg_data[i]['def_'])
            }
            round_summary.round_prg_data = round_prg_data
        }
    }

    SequentialAnimation {
        id: showUp
        PropertyAnimation {
            property: 'width'
            from: 100
            duration: 1000
        }
        PropertyAnimation {
            property: "height"
            from: 20
            duration: 1000
        }
    }

    Component.onCompleted: {
        $api.start()
    }
}

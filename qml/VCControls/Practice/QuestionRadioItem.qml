import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

Item {
    id: ratio_item

    height: 32
//    width: childrenRect.width

    property alias label: label_metrics.text
    property var nonce
    property alias btn_lookup: btn_lookup
    signal clicked
    signal lookupClicked

    TextMetrics {
        id: label_metrics
        text: qsTr("I'm a labe")
        font {
            bold: true
        }
    }

    TextMetrics {
        id: short_def_metrics
        elide: Qt.ElideRight
        text: qsTr("I'm a short_def")
    }

    RowLayout {
        id: item_wrapper

        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        Item {
            id: radio_item_conrrol

            width: 32
            height: 32

            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true

            Rectangle {
                id: outter_circle
                radius: width * 0.5
                border {
                    color: "#78A752"
                    width: parent.height * (1 / 7)
                }

                anchors.fill: parent

                Rectangle {
                    id: inner_pie
                    anchors {
                        centerIn: parent
                    }
                    width: parent.width * 0.5
                    height: parent.height * 0.5
                    radius: width * 0.5
                    border.color: "#00000000"
                    opacity: 0.5
                    color: "#78A752"
                }
            }

            AnimatedImage {
                id: loading
                width: parent.height * 0.9
                height: parent.height * 0.9
                source: "../../res/img/loading.svg"

                anchors.fill: parent

                visible: false
                RotationAnimator on rotation {
                    loops: Animation.Infinite
                    from: 0
                    to: 360
                    running: true
                    duration: 3000
                }
            }

            Rectangle {
                id: correct
                width: parent.height * 0.9
                height: parent.height * 0.9
                radius: width * 0.5

                anchors.fill: parent


                border {
                    color: "#78A752"
                    width: parent.height * (1 / 7)
                }

                Text {
                    id: element
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
                id: wrong
                width: parent.height * 0.9
                height: parent.height * 0.9
                radius: width * 0.5
                anchors.fill: parent
                border {
                    color: "#BB3330"
                    width: parent.height * (1 / 7)
                }
                Text {
                    text: $favar.fa_times
                    anchors {
                        centerIn: parent
                    }

                    font {
                        family: $awesome.name
                        pixelSize: parent.height
                    }
                    scale: 0.6
                    color: "#BB3330"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            MouseArea {
                id: ratio_item_ma
                anchors.fill: parent
                hoverEnabled: true
                onHoveredChanged: function () {
                    if ("incorrect, correc,checking ".search(
                                ratio_item.state) >= 0) {
                        return
                    }

                    if (ratio_item.state === "hovered") {
                        ratio_item.state = "normal"
                    } else {
                        if (ratio_item.state === "normal") {
                            ratio_item.state = "hovered"
                        }
                    }
                }

                onClicked: {
                    if ("normal,pressing,hovered".search(ratio_item.state) === -1) {
                        return
                    }
                    ratio_item.clicked()
                }
            }
        }

        Column{
            Text {
                id: label
                text: label_metrics.elidedText
                textFormat: Text.PlainText
                color: "#3D588A"
                font {
                    bold: true
                }

            }

            Text {
                id: short_def
                visible: false
                text: "short_def_metrics.elidedText"
                textFormat: Text.PlainText
                color: "#000000"
                font {
                    italic: true
                    bold: false
                }
            }
        }
    }

    RoundButton {
        id: btn_lookup
        height: 28
        width: 28
        text: "<font color='#ffffff'>" + $favar.fa_search + "</font>"
        font.family: $awesome.name
        x:item_wrapper.x+item_wrapper.width+20
        anchors.verticalCenter: item_wrapper.verticalCenter
        visible: false
        onClicked: {
            lookupClicked()
        }
    }


    function invalidOption() {
        item_wrapper.enabled = false
        outter_circle.visible = false
    }

    function show_def(def) {
//        short_def_metrics.text = def
//        short_def_metrics.elideWidth = this.width
        short_def.text = def
        short_def.visible = true
        short_def.opacity = 1
        btn_lookup.visible = false
    }

    function show_btn_lookup() {
        btn_lookup.visible = !short_def.visible
    }

    state: "normal"
    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: inner_pie
                visible: false
            }
            PropertyChanges {
                target: loading
                visible: false
            }
            PropertyChanges {
                target: correct
                visible: false
            }
            PropertyChanges {
                target: wrong
                visible: false
            }
        },

        State {
            name: "hovered"
            PropertyChanges {
                target: inner_pie
                visible: true
            }
            PropertyChanges {
                target: loading
                visible: false
            }
            PropertyChanges {
                target: correct
                visible: false
            }
            PropertyChanges {
                target: wrong
                visible: false
            }
        },

        State {
            name: "checking"
            PropertyChanges {
                target: outter_circle
                visible: false
            }
            PropertyChanges {
                target: inner_pie
                visible: false
            }
            PropertyChanges {
                target: loading
                visible: true
            }
            PropertyChanges {
                target: correct
                visible: false
            }
            PropertyChanges {
                target: wrong
                visible: false
            }
        },
        State {
            name: "correct"
            PropertyChanges {
                target: outter_circle
                visible: false
            }

            PropertyChanges {
                target: inner_pie
                visible: false
            }
            PropertyChanges {
                target: loading
                visible: false
            }
            PropertyChanges {
                target: correct
                visible: true
            }
            PropertyChanges {
                target: wrong
                visible: false
            }
            PropertyChanges {
                target: label
                color: "#78A752"
            }

            PropertyChanges {
                target: element
                verticalAlignment: Text.AlignBottom
            }
        },
        State {
            name: "incorrect"
            PropertyChanges {
                target: outter_circle
                visible: false
            }
            PropertyChanges {
                target: inner_pie
                visible: false
            }
            PropertyChanges {
                target: loading
                visible: false
            }
            PropertyChanges {
                target: correct
                visible: false
            }
            PropertyChanges {
                target: wrong
                visible: true
            }

            PropertyChanges {
                target: label
                color: "#BB3330"
            }
        }
    ]
}

















































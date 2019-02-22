import QtQuick 2.9
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

//A section contains
Item {
    property alias title: wordlist_section_title.text
    property alias description: wordlist_section_des.text
    property alias word_count_txt: wordlist_section_more.text

    id: wordlist_section
    signal clicked
    signal createGame(string game_type)

    width: 400
    height: childrenRect.height
    scale: 1
    Rectangle {
        id: wordlist_section_bg
        anchors.fill: parent
        color: "#333333"
        radius: 8
        z: -1
    }

    Text {
        id: wordlist_section_title
        width: parent.width - 10
        anchors.left: wordlist_section_des.left
        color: "#2E5586"
        text: '100 SAT Words Beginning with "A"'
        font {
            pixelSize: 18
            family: "open sans"
            bold: true
        }
        wrapMode: Text.WrapAnywhere
    }

    Text {
        id: wordlist_section_des
        width: parent.width - 10
        anchors.top: wordlist_section_title.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#666666"
        text: 'Learn these words derived from the Latin roots pater and patris, meaning "father."'
        font {
            pixelSize: 12
            family: "open sans"
        }
        wrapMode: Text.WrapAnywhere
    }

    Text {

        anchors {
            top: wordlist_section_des.bottom
            topMargin: 10
            verticalCenter: wordlist_section_des.verticalCenter
            left: parent.left
            leftMargin: 10
        }

        id: wordlist_section_more
        Layout.fillWidth: true
        width: parent.width - 10
        color: "#2E5586"
        text: '45 words'
        font {
            pixelSize: 12
            family: "open sans"
            bold: true
        }
        wrapMode: Text.WrapAnywhere
    }

    ButtonGroup {

        buttons: create_game_buttons.children
    }

    Row {
        spacing: 5
        id: create_game_buttons

        anchors {
            top: wordlist_section_des.bottom
            topMargin: 10
            bottomMargin: 5
            right: parent.right
            rightMargin: 10
        }

        Button {

            property string game_type: "p"
            text: "<font color='#ffffff'>Practice</font>"
            font {
                pixelSize: 12
                family: "open sans"
                bold: true
            }

            background: Rectangle {
                anchors.fill: parent
                color: "#6AB14B"
                radius: 8
            }

            MouseArea {

                anchors {
                    fill: parent
                }
                hoverEnabled: true
                onEntered: {
                    wordlist_section.state = "hovering"
                }
                onExited: {
                    wordlist_section.state = "normal"
                }
                onClicked: {
                    wordlist_section.createGame(parent.game_type)
                }
                onPressedChanged: {
                    parent.scale = parent.scale === 0.98 ? 1 : 0.98
                }
                z: 99
            }
        }
        Button {
            property string game_type: "j"
            text: "<font color='#ffffff'>Jam</font>"
            font {
                pixelSize: 12
                family: "open sans"
                bold: true
            }

            background: Rectangle {
                anchors.fill: parent
                color: "#73C5DB"
                radius: 8
            }

            MouseArea {

                anchors {
                    fill: parent
                }
                hoverEnabled: true
                onEntered: {
                    wordlist_section.state = "hovering"
                }
                onExited: {
                    wordlist_section.state = "normal"
                }
                onClicked: {
                    wordlist_section.createGame(parent.game_type)
                }
                onPressedChanged: {
                    parent.scale = parent.scale === 0.98 ? 1 : 0.98
                }
                z: 99
            }
        }
    }

    MouseArea {
        id: wordlist_section_ma
        anchors {
            fill: parent
        }
        hoverEnabled: true
        onEntered: {
            wordlist_section.state = "hovering"
        }
        onExited: {
            wordlist_section.state = "normal"
        }

        onClicked: {
            parent.clicked()
        }
        onPressedChanged: {
            parent.scale = parent.scale === 0.98 ? 1 : 0.98
        }
        z: -1
    }
    state: "normal"
    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: wordlist_section_bg
                opacity: 0
            }
        },
        State {
            name: "hovering"
            PropertyChanges {
                target: wordlist_section_bg
                opacity: 0.05
            }
        }
    ]

    Component.onCompleted: {
        height += 10
    }
}

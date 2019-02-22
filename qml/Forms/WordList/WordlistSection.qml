import QtQuick 2.9

//A section contains
Item {
    property alias title: wordlist_section_title.text
    property alias description: wordlist_section_des.text
    property alias word_count_txt: wordlist_section_more.text

    id: wordlist_section
    signal clicked

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
        id: wordlist_section_more
        anchors.top: wordlist_section_des.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
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

    MouseArea {
        id: wordlist_section_ma
        anchors {
            fill: parent
        }
        hoverEnabled: true
        onEntered: {
            parent.state = "hovering"
            cursorShape = Qt.PointingHandCursor
        }
        onExited: {
            parent.state = "normal"
            cursorShape = Qt.ArrowCursor
        }
        onPressedChanged: {
            parent.scale = parent.scale == 0.98 ? 1 : 0.98
        }
        onClicked: {
            parent.clicked()
        }
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
}

import QtQuick 2.9
import QtQuick.Layouts 1.3

Item {
    id: wordlist_category_list
    readonly property var menu_icon_txt: ["⋆", "✎", "", "📖", "🔎", "💡", "🎤", "♥", "📰"]
    readonly property var colors: ['#cccccc', "#2E5586", "#6AB14B"]
    property string cur_color: colors[0]

    signal menu_activated(string category_cd)

    height: childrenRect.height
    width: childrenRect.width + 10
    Repeater {
        id: fonts_rpt
        model: ["../../res/fonts/ss-symbolicons-block.woff", "../../res/fonts/ss-standard.woff"]
        delegate: Item {
            FontLoader {
                source: modelData

                onStatusChanged: {
                    if ((status === FontLoader.Ready)) {
                        console.log(name, " loaded.")
                    }
                }
            }
        }
    }
    ColumnLayout {
        spacing: 10
        Repeater {
            id: word_list_menu_rpt
            model: [['*', 'Featured List'], ["TST", "Test Prep"], ["ROOTS", "Morphology & Roots"], ["LIT", "Literature"], ["NON", 'Non-Fiction'], ["HIS", "Historical Documents"], ["SPH", "Speeches"], ["FUN", 'Just for Fun'], ["NWS", 'News']]
            property int last_activated_index: -1
            delegate: Item {
                id: word_list_menu_item
                height: wordlist_category_name.paintedHeight + word_list_menu_line.height + 10
                width: childrenRect.width
                Layout.fillWidth: true
                Layout.margins: 5
                property bool activated: false

                Text {
                    id: word_list_menu_icon
                    text: menu_icon_txt[index]
                    color: colors[1]
                    anchors {
                        left: parent.left
                        leftMargin: 5
                    }
                    font {
                        family: "SS Standard"
                        pixelSize: 18
                    }
                }

                Text {
                    id: wordlist_category_name
                    text: modelData[1]

                    font {
                        family: "open sans"
                        pixelSize: 18
                    }
                    color: colors[1]
                    anchors {
                        left: word_list_menu_icon.right
                        leftMargin: 10
                    }
                }

                Rectangle {
                    id: word_list_menu_line
                    height: 2
                    width: parent.width
                    color: colors[0]
                    anchors {
                        top: wordlist_category_name.bottom
                        topMargin: 5
                    }
                    opacity: 0.5
                }

                MouseArea {
                    id: wordlist_category_ma
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        if (activated) {
                            return
                        }
                        parent.state = "hovering"
                    }
                    onExited: {
                        if (activated) {
                            return
                        }
                        parent.state = "normal"
                    }
                    onClicked: {
                        parent.state = "clicked"
                    }
                }
                function set_active() {
                    this.state = "clicked"
                }

                state: "normal"
                states: [
                    State {
                        name: "normal"
                        PropertyChanges {
                            target: word_list_menu_icon
                            color: colors[1]
                        }
                        PropertyChanges {
                            target: wordlist_category_name
                            font.bold: false
                        }
                        PropertyChanges {
                            target: word_list_menu_line
                            opacity: 0.5
                        }
                    },
                    State {
                        name: "hovering"
                        PropertyChanges {
                            target: word_list_menu_icon
                            color: colors[2]
                        }

                        PropertyChanges {
                            target: word_list_menu_line
                            opacity: 1
                        }
                    },
                    State {
                        name: "clicked"
                        PropertyChanges {
                            target: word_list_menu_item
                            activated: true
                        }
                        PropertyChanges {
                            target: word_list_menu_icon
                            color: colors[2]
                        }
                        PropertyChanges {
                            target: wordlist_category_name
                            font.bold: true
                        }
                        PropertyChanges {
                            target: word_list_menu_line
                            opacity: 1
                        }
                    }
                ]

                onActivatedChanged: {
                    if (word_list_menu_rpt.last_activated_index !== -1) {
                        word_list_menu_rpt.itemAt(
                                    word_list_menu_rpt.last_activated_index).state = 'normal'
                    }
                    console.log(index, " menu item activated:", modelData)
                    word_list_menu_rpt.last_activated_index = index
                    wordlist_category_list.menu_activated(modelData[0])
                }
            }
        }
    }

    Component.onCompleted: {
        word_list_menu_rpt.itemAt(0).set_active()
    }
}

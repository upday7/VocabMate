import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import QtQml.Models 2.3
import pyAPIBridge 1.0
import "../../JsonModel"
import "../../VCControls/Generic"

Rectangle {
    id: form_wordlist
    width: 1080
    height: 480
    color: "#ffffff"

    signal word_list_selected(int list_id)
    signal create_game(int list_id, string game_type)
    readonly property var api: VCWordListAPI {
    }

    property var form_wordlist_sections_obj: null

    JSONListModel {
        id: wordlist_sections_model
    }

    Connections {
        target: api
        onWordListLoaded: function (json_string) {
            wordlist_sections_model.json = json_string
            form_wordlist.state = 'normal'
        }
    }

    RowLayout {
        id: form_wordlist_row
        anchors {
            fill: parent
            margins: 20
        }
        spacing: 10

        CategoryMenu {
            id: form_wordlist_category
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            onMenu_activated: function (category_id) {
                form_wordlist.state = 'loading'
                wordlist_sections_model.model.clear()
                api.get_wordlist_sections(category_id)
            }
        }

        Item {

            Loading {
                id: form_wordlist_loading
                anchors {
                    centerIn: parent
                }

                visible: !wordlist_sections_scroll.visible
                running: visible
            }

            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.fillHeight: true

            ScrollView {
                id: wordlist_sections_scroll
                visible: true
                property var list_data: []

                anchors.fill: parent

                ListView {
                    anchors.fill: parent
                    spacing: 20

                    add: Transition {
                        NumberAnimation {
                            property: "opacity"
                            from: 0
                            to: 1.0
                            duration: 400
                        }
                        NumberAnimation {
                            property: "scale"
                            from: 0
                            to: 1.0
                            duration: 400
                        }
                    }

                    displaced: Transition {
                        NumberAnimation {
                            properties: "x,y"
                            duration: 400
                            easing.type: Easing.OutBounce
                        }
                    }

                    model: wordlist_sections_model.model

                    property string cur_category

                    delegate: Item {
                        height: childrenRect.height
                        Text {
                            id: form_wordlist_section_title
                            color: "#333333"
                            text: category
                            font {
                                pixelSize: 24
                                family: "open sans"
                            }
                            wrapMode: Text.WrapAnywhere
                        }

                        Rectangle {
                            id: form_wordlist_section_seperator
                            anchors {
                                top: form_wordlist_section_title.bottom
                                topMargin: 3
                            }
                            width: wordlist_sections_scroll.width
                            height: 1
                            color: "#cccccc"
                        }

                        GridLayout {
                            anchors {
                                top: form_wordlist_section_seperator.bottom
                                topMargin: 7
                            }
                            columnSpacing: 10
                            columns: 2
                            rowSpacing: 10

                            Repeater {
                                model: lists
                                delegate: WordlistSection {
                                    title: name
                                    description: description
                                    word_count_txt: total_words
                                    onClicked: {
                                        word_list_selected(id_)
                                    }
                                    onCreateGame: function (game_type) {
                                        create_game(id_, game_type)
                                    }
                                }
                            }
                        }
                    }
                }

                onList_dataChanged: {

                }
            }
        }
    }

    state: "normal"
    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: wordlist_sections_scroll
                visible: true
            }
            PropertyChanges {
                target: form_wordlist_category
                opacity: 1
                enabled: true
            }
        },
        State {
            name: "loading"
            PropertyChanges {
                target: wordlist_sections_scroll
                visible: false
            }
            PropertyChanges {
                target: form_wordlist_category
                opacity: 0.3
                enabled: false
            }
        }
    ]

    onWord_list_selected: function (list_id) {
        console.log("Selected list: ", list_id)
    }
    onCreate_game: function (list_id, game_type) {
        console.log("Selected list: ", list_id, "for game: ", game_type)
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/


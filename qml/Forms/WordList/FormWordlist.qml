import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import QtQml.Models 2.2
import pyAPIBridge 1.0

Rectangle {
    id: form_wordlist
    width: 1080
    height: 480
    color: "#ffffff"

    signal word_list_selected(int list_id)
    readonly property var api: VCWordListAPI {
    }

    property var form_wordlist_sections_obj: null

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
                console.log("Category menu activated, id: ", category_id)
                if (form_wordlist_sections_obj) {
                    form_wordlist_sections_obj.destroy()
                }
                form_wordlist_sections_obj = form_wordlist_sections.createObject(
                            form_wordlist_row, {
                                "list_data": api.get_wordlist_sections(
                                                 category_id)
                            })
            }
        }
    }

    onWord_list_selected: function (list_id) {
        console.log("Selected list: ", list_id)
    }

    Component {
        id: form_wordlist_sections

        ScrollView {
            id: wordlist_sections_scroll

            property var list_data: []

            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                spacing: 20
                anchors.fill: parent

                Repeater {
                    model: list_data
                    property string cur_category
                    delegate: Item {
                        height: childrenRect.height
                        Text {
                            id: form_wordlist_section_title
                            color: "#333333"
                            text: modelData['category']
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

                            columns: 2
                            columnSpacing: 10
                            rowSpacing: 10
                            Repeater {
                                id: wordlist_sections
                                model: modelData['lists']
                                delegate: WordlistSection {
                                    title: modelData['name']
                                    description: modelData['description']
                                    word_count_txt: modelData['total_words']
                                    onClicked: {
                                        word_list_selected(modelData['id_'])
                                    }
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

import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

ColumnLayout {
    property alias options: rpt.model
    property alias question_text: question.text
    //    property string question_text
    signal correctAnswerSelected(var correct, var answer)
    property int radio_lookup_clicked_index

    id: main_layout
    spacing: 20
    Layout.margins: 20

    Text {
        id: question
        text: qsTr("Question Text")
        color: "#444444"
        textFormat: Text.RichText
        Layout.fillWidth: true
        wrapMode: Text.Wrap
        font {
        }
    }

    ColumnLayout {

        spacing: 10
        //        Layout.fillWidth: true
        //        Layout.fillHeight: true
        Repeater {
            id: rpt
            QuestionRadioItem {
                id: radio_item

                anchors {
                    leftMargin: 20
                }

                width: main_layout.width
                label: modelData.option
                nonce: modelData.nonce
                onClicked: {
                    this.state = 'checking'
                    $api.verify_answer(index, modelData.nonce)
                }
                onLookupClicked: {
                    radio_lookup_clicked_index = index
                    $api.get_simple_def(modelData.option)
                }
            }
        }

        Connections {
            target: $api
            onSimpleDefGot: function (def) {
                var item = rpt.itemAt(main_layout.radio_lookup_clicked_index)
                item.show_def(def)
            }

            onAnswerBingo: function (idx, answer) {
                var correct = idx === answer.correct_choice
                var cur_item = rpt.itemAt(idx)

                cur_item.state = correct ? 'correct' : "incorrect"
                correctAnswerSelected(correct, answer)
                if (correct) {
                    var item
                    for (var iidx = 0; iidx < rpt.count; iidx++) {
                        item = rpt.itemAt(iidx)
                        item.invalidOption()
                        if ('F,S,H,P'.search(answer.question_type) > -1) {
                            item.show_btn_lookup()
                        }
                    }
                }

                // trigger to short def
                if ('F,S,H,P'.search(answer.question_type) > -1) {
                    radio_lookup_clicked_index = idx
                    $api.get_simple_def(cur_item.label)
                }
            }
        }

        Component.onCompleted: {
            console.log("QuestionRadioGroup load completed, options: ", options)
        }
    }

    function _click_option_item(option_item) {
        if (option_item.enabled) {
            option_item.clicked()
        }
    }

    focus: true
    Keys.onDigit1Pressed: {
        _click_option_item((rpt.itemAt(0)))
    }
    Keys.onDigit2Pressed: {
        _click_option_item((rpt.itemAt(1)))
    }

    Keys.onDigit3Pressed: {
        _click_option_item((rpt.itemAt(2)))
    }

    Keys.onDigit4Pressed: {
        _click_option_item((rpt.itemAt(3)))
    }
}
